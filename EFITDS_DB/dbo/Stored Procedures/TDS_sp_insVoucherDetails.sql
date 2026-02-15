Use TDSLive
GO

Create   Procedure [dbo].[TDS_sp_insVoucherDetails]
	@DDOCode NVARCHAR(10)=NULL,
	@BillHead NVARCHAR(50)=NULL,
	@FinYear NVARCHAR(11),
	@Quarter NVARCHAR(3),
	@Bill_Month NVARCHAR(10),
	@Bill_Year Int,
	@PayBill_Type NVARCHAR(255),
	@Form_Type NVARCHAR(3),
	@VoucherNo Int=-1,
	@VoucherDate Datetime=NULL,
	@VoucherAmount  Decimal,
	@isKoshwahini NVARCHAR(1),
	@isBinView NVARCHAR(1),
	@isOltas NVARCHAR(1),
	@IsLPC NVARCHAR(1)='N',
	@SourceId NVARCHAR(1),
	@Status NVARCHAR(1),
	@UserId Int, 
	@VoucherId INT OUTPUT

--***********************************************************
--***
--*** Created On 19 May 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),
			@GetDate	Datetime

	SET @GetDate=GETDATE()

	SELECT @VoucherId=Voucher_Id
	FROM [dbo].[TDS_t_Voucher_Details]
	WHERE ((@DDOCode IS NULL) OR (DDO_Code=@DDOCode))
	  AND ((@BillHead IS NULL) OR (BillHead=@BillHead))
	  AND ((@VoucherNo =-1) OR (Voucher_No=@VoucherNo))
	  AND ((@VoucherDate IS NULL) OR (Vourcher_Date=CONVERT(DATE, @VoucherDate)))	

	IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error checking Voucher details...'
			GOTO spError
		END

	--Check if any inserted from Kshwahini
	  IF(@VoucherId=0 OR @VoucherId Is NULL)
	  BEGIN
	     SELECT @VoucherId=Voucher_Id
		 FROM [dbo].[TDS_t_Voucher_Details]
		 WHERE DDO_Code=@DDOCode 
			  AND Voucher_No=@VoucherNo  
			  AND Vourcher_Date=CONVERT(DATE, @VoucherDate) 
			  AND Form_Type=@Form_Type
			  AND [Quarter]=@Quarter
			  AND SourceId=2
	   END


	IF(@VoucherId<=0 OR @VoucherId Is Null)
	BEGIN
		INSERT INTO [dbo].[TDS_t_Voucher_Details](
						[DDO_Code],
						[BillHead],
						[Fin_Year],
						[Quarter],
						[Bill_Month],
						[Bill_Year],
						[PayBill_Type],
						[Form_Type],
						[Voucher_No],
						[Vourcher_Date],
						[Voucher_Amount],
						[IsKoshwahini],
						[IsBinview],
						[IsOltas],
						[IsLPC],
						[SourceId],
						[InsertedOn],
						[InsertedBy],
						[Status])
			     VALUES(@DDOCode,
						@BillHead,
						@FinYear,
						@Quarter,
						@Bill_Month,
						@Bill_Year,
						@PayBill_Type,
						@Form_Type,
						@VoucherNo,
						CONVERT(DATE, @VoucherDate),
						@VoucherAmount,
						@isKoshwahini,
						@isBinView,
						@isOltas,
						@IsLPC,
						@SourceId,
						@GetDate,
						@UserId,
						@Status)

			IF(@@ERROR <> 0 OR @@IDENTITY=0)
			BEGIN
				Select @ErrMsg='Error checking Voucher details'
				GOTO spError
			END

			SET @VoucherId=@@IDENTITY;
	END
	ELSE
	BEGIN
		UPDATE [dbo].[TDS_t_Voucher_Details]
		SET [BillHead]=@BillHead,
			[Bill_Month]=@Bill_Month,
			[Bill_Year]=@Bill_Year,
			[PayBill_Type]=@PayBill_Type,			
			[IsBinview]=CASE WHEN (SourceId=2 AND IsBinview='Y') THEN IsBinview ELSE isBinView END,--@isBinView,
			[IsOltas]=@isOltas,
			[IsLPC]=@IsLPC,
			[SourceId]=@SourceId,
			[UpdatedOn]=@GetDate,
			[updatedBy]=@UserId,
			[Status]=@Status
			WHERE Voucher_Id=@VoucherId
	END

	SET NOCOUNT OFF

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_insVoucherDetails: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	RETURN(-1)
END