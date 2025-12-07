
Create   Procedure [dbo].[TDS_sp_insupdBinData]
	@loginId INT
	,@DDOCode NVARCHAR(10)
	,@FinYear NVARCHAR(11)
	,@Binxml TEXT
	,@Status INT  OUTPUT
--***********************************************************
--***
--*** Created On 27 July 2025 By A.R.Gawande
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
	EXEC @XMLPrepared=sp_XML_preparedocument @XMLDocumentHandle OUTPUT,@Binxml

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading XML.'
		GOTO spError
	END

	IF OBJECT_ID('tempdb..#BinDetails') IS NOT NULL
		DROP TABLE #BinDetails

	CREATE TABLE #BinDetails(
				Voucher_Ids		nvarchar(Max)	 NOT NULL,
				Receipt_No		nvarchar(10)	 NOT NULL,
				Serial_No		nvarchar(10)	 NOT NULL,
				Bin_Date		date			 NOT NULL,
				Ded_Amount		decimal(18, 0)	 NOT NULL
		)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	INSERT INTO #BinDetails(
					Voucher_Ids,
					Receipt_No,					Serial_No,					Bin_Date,					Ded_Amount)
		SELECT		Voucher_Ids,
					Receipt_No,					Serial_No,					Bin_Date=CASE WHEN Bin_Date=CAST('0001-01-01' as date) THEN NULL ELSE Bin_Date END,					Ded_Amount
			FROM OPENXML(@XMLDocumentHandle ,'/BinviewVouchers/BinViewVoucher', 2) WITH
						   (Voucher_Ids			nvarchar(Max) 'VoucherIds',
							Receipt_No			nvarchar(10) 'ReceiptNo',
							Serial_No			nvarchar(10) 'SerialNo',	
							Bin_Date			date 'BinDate',
							Ded_Amount			Decimal 'VoucherAmount')

    IF(@@ERROR <> 0)
	 BEGIN
	 	Select @ErrMsg='Error while loading bin details from XML.'
	 	GOTO spError
	 END	
	 	
	DECLARE	@Bin_Id	INT

    DECLARE @Voucher_Ids			NVARCHAR(Max),
			@Receipt_No				NVARCHAR(10),
			@Serial_No				NVARCHAR(10),
			@Bin_Date				Datetime,
			@Ded_Amount				Decimal 

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT Voucher_Ids,Receipt_No,Serial_No,Bin_Date,Ded_Amount FROM #BinDetails 
	OPEN K
		FETCH NEXT FROM K INTO @Voucher_Ids,@Receipt_No,@Serial_No,@Bin_Date,@Ded_Amount	
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				--[1]. Checking  voucher Exist or Not
				SET @Bin_Id=(SELECT Bin_Id FROM [dbo].[TDS_t_Bin_Details] WHERE DDO_Code=@DDOCode and Receipt_No=@Receipt_No and Bin_Date=@Bin_Date
												and Ded_Amount=@Ded_Amount and Serial_No=@Serial_No  and [Status]='Y')
				
				IF(@Bin_Id<>0)
				BEGIN
					UPDATE [dbo].[TDS_t_Bin_Details] SET Voucher_Ids=@Voucher_Ids
					WHERE Bin_Id=@Bin_Id	
					
					IF(@@ERROR <> 0)
					BEGIN
						Select @ErrMsg='Error while updating bin details.'
						GOTO spError
					END

					UPDATE [dbo].[TDS_t_Voucher_Details] SET IsBinview='Y' 
					WHERE Voucher_Id IN (SELECT * FROM [dbo].[SplitString](@Voucher_Ids, ','))  AND DDO_Code=@DDOCode--(SELECT value FROM STRING_SPLIT(@Voucher_Ids, ',')) AND DDO_Code=@DDOCode

					IF(@@ERROR <> 0)
					BEGIN
						Select @ErrMsg='Error while updating voucher details.'
						GOTO spError
					END
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].[TDS_t_Bin_Details](DDO_Code,Voucher_Ids,Receipt_No,Serial_No,Bin_Date,Ded_Amount,[Status]) 
						   VALUES(@DDOCode,@Voucher_Ids,@Receipt_No,@Serial_No,@Bin_Date,@Ded_Amount,'Y')

					IF(@@ERROR <> 0)
					BEGIN
						Select @ErrMsg='Error while inserting bin details.'
						GOTO spError
					END

					UPDATE [dbo].[TDS_t_Voucher_Details] SET IsBinview='Y' 
					WHERE Voucher_Id IN (SELECT * FROM [dbo].[SplitString](@Voucher_Ids, ',')) AND DDO_Code=@DDOCode

					IF(@@ERROR <> 0)
					BEGIN
						Select @ErrMsg='Error while updating voucher details.'
						GOTO spError
					END

					SET @Bin_Id=@@IDENTITY;
				END
			END
			FETCH NEXT FROM K INTO @Voucher_Ids,@Receipt_No,@Serial_No,@Bin_Date,@Ded_Amount
		END
	CLOSE K
	DEALLOCATE K

	SET @Status=1;

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_insupdBinData: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Status=0;

	RETURN(-1)
END