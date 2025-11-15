
Create   Procedure [dbo].[TDS_sp_insupdKoshData]
	@loginId INT
	,@DDOCode NVARCHAR(10)
	,@FinYear NVARCHAR(11)
	,@Koshxml TEXT
	,@Status INT  OUTPUT
--***********************************************************
--***
--*** Created On 06 July 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@XMLDocumentHandle  INT,
			@XMLPrepared	INT,
			@ErrMsg		NVARCHAR(255),			
			@rc			SMALLINT,
			@Exists		INT
			
			
	SET @GetDate=GETDATE();

	--open & prepare the XML document for reading into temporary tables.
	EXEC @XMLPrepared=sp_XML_preparedocument @XMLDocumentHandle OUTPUT,@Koshxml

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading XML.'
		GOTO spError
	END

	IF OBJECT_ID('tempdb..#KoshDetails') IS NOT NULL
		DROP TABLE #KoshDetails

	CREATE TABLE #KoshDetails(
				[Quarter]		nvarchar(3)		 NOT NULL,
				Form_Type		nvarchar(3)		 NOT NULL,
				SubForm_Type	nvarchar(MAX)	 NULL,
				Vourcher_Date	date			 NOT NULL,
				Voucher_No		int				 NOT NULL,
				Voucher_Amount	decimal(18, 0)	 NOT NULL
		)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	INSERT INTO #KoshDetails(
					[Quarter],
					Form_Type,
					SubForm_Type,
					Vourcher_Date,
					Voucher_No,
					Voucher_Amount)
		SELECT		[Quarter],
					Form_Type,
					SubForm_Type,
					Vourcher_Date=CASE WHEN Vourcher_Date=CAST('0001-01-01' as date) THEN NULL ELSE Vourcher_Date END,
					Voucher_No,
					Voucher_Amount
			FROM OPENXML(@XMLDocumentHandle ,'/KoshVouchers/KoshwahiniVoucher', 2) WITH
						   ([Quarter]			nvarchar(3) 'Quarter',
							Form_Type			nvarchar(3) 'FormType',
							SubForm_Type		nvarchar(Max) 'SubFormType',
							Vourcher_Date		date 'VoucherDate',
							Voucher_No			Int 'VoucherNo' ,
							Voucher_Amount		Decimal 'VoucherAmount')

    IF(@@ERROR <> 0)
	 BEGIN
	 	Select @ErrMsg='Error while loading office details from XML.'
	 	GOTO spError
	 END	
	 	
	DECLARE	@Voucher_Id	INT,
			@SourceId INT

    DECLARE @Quarter				NVARCHAR(3),
			@Form_Type				NVARCHAR(3),
			@SubForm_Type			NVARCHAR(MAX),
			@VoucherNo				Int,
			@VoucherDate			Datetime,
			@VoucherAmount			Decimal 

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT [Quarter],Form_Type,SubForm_Type,Vourcher_Date,Voucher_No,Voucher_Amount FROM #KoshDetails 
	OPEN K
		FETCH NEXT FROM K INTO @Quarter,@Form_Type,@SubForm_Type,@VoucherDate,@VoucherNo,@VoucherAmount	
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				--[1]. Checking  voucher Exist or Not
				SET @Voucher_Id=(SELECT Voucher_Id FROM [dbo].[TDS_t_Voucher_Details] WHERE DDO_Code=@DDOCode and Voucher_No=@VoucherNo and Vourcher_Date=@VoucherDate
												and Voucher_Amount=@VoucherAmount and [Quarter]=@Quarter and SourceId in(1,2) and ([Status]='Y' OR [Status]='N'))

				SET @SourceId=(SELECT SourceId FROM [dbo].[TDS_t_Voucher_Details] WHERE DDO_Code=@DDOCode and Voucher_No=@VoucherNo and Vourcher_Date=@VoucherDate
												and Voucher_Amount=@VoucherAmount and [Quarter]=@Quarter and SourceId in(1,2) and ([Status]='Y' OR [Status]='N'))
				IF(@Voucher_Id>0)
				BEGIN
				UPDATE [dbo].[TDS_t_Voucher_Details] SET Form_Type=CASE WHEN @SourceId=1 THEN Form_Type ELSE @Form_Type END,
																SubForm_Type=@SubForm_Type,IsKoshwahini='Y',IsOltas='N',
								UpdatedOn=@GetDate,updatedBy=@loginId
					WHERE Voucher_Id=@Voucher_Id					
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].[TDS_t_Voucher_Details](DDO_Code,Fin_Year,[Quarter],Form_Type,SubForm_Type,Vourcher_Date,Voucher_No,Voucher_Amount,IsKoshwahini,IsOltas,SourceId,
															InsertedOn,InsertedBy,[Status]) 
						   VALUES(@DDOCode,@FinYear,@Quarter,@Form_Type,@SubForm_Type,@VoucherDate,@VoucherNo,@VoucherAmount,'Y','N',2,@GetDate,@loginId,'N')
				
				SET @Voucher_Id=@@IDENTITY;	
				END
			END
			FETCH NEXT FROM K INTO @Quarter,@Form_Type,@SubForm_Type,@VoucherDate,@VoucherNo,@VoucherAmount
		END
	CLOSE K
	DEALLOCATE K

	SET @Status=1;

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_insupdKoshData: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Status=0;

	RETURN(-1)
END