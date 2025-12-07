
Create   Procedure [dbo].[TDS_sp_insupd26QVoucherDetails]
	@Yearly_Id INT=0,
	@FinYear NVARCHAR(11),
	@Quarter NVARCHAR(3),
	@Form_Type NVARCHAR(3),
	@DDOCode NVARCHAR(10)=NULL,
	@VoucherId INT,
	@VoucherNo INT,
	@VoucherDate Datetime=NULL,
	@PanNo NVARCHAR(10)=NULL,
	@Pan_Status NVARCHAR(1),
	@SupplierName NVARCHAR(MAX),
	@GrossAmt  Decimal,
	@IncomeTax  Decimal,
	@Section_Id	INT,
	@DeductinRate  Decimal,
	@Status NVARCHAR(1),
	@UserId Int, 
	@StatusId INT OUTPUT

--***********************************************************
--***
--*** Created On 02 Dec 2025 By A.R.Gawande
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

	IF(@Yearly_Id<=0 OR @Yearly_Id Is Null)
	BEGIN
		INSERT INTO [dbo].[TDS_t_26QSub_Details](
						[Supplier_Name],
						[PAN_No],
						[Pan_Status],
						[DDO_Code],
						[Voucher_Id],
						[Fin_Year],
						[Vourcher_Date],
						[Voucher_No],
						[Income_Tax],
						[Gross_Amt],
						[Section_Id],
						[InterestRate],
						[InsertedOn],
						[InsertedBy],
						[Status])
			     VALUES(@SupplierName,
						@PanNo,
						@Pan_Status,
						@DDOCode,
						@VoucherId,
						@FinYear,						
						CONVERT(DATE, @VoucherDate),
						@VoucherNo,
						@IncomeTax,
						@GrossAmt,
						@Section_Id,
						@DeductinRate,
						@GetDate,
						@UserId,
						@Status)

			IF(@@ERROR <> 0 OR @@IDENTITY=0)
			BEGIN
				Select @ErrMsg='Error checking Voucher details'
				GOTO spError
			END

			SET @Yearly_Id=@@IDENTITY;
			SET @StatusId=@Yearly_Id;
	END
	ELSE
	BEGIN
		UPDATE [dbo].[TDS_t_26QSub_Details]
		SET [Supplier_Name]=@SupplierName,
		    [PAN_No]=@PanNo,
			[Pan_Status]=@Pan_Status,
			[Income_Tax]=@IncomeTax,
			[Gross_Amt]=@GrossAmt,
			[Section_Id]=@Section_Id,
			[InterestRate]=@IncomeTax,
			[UpdatedOn]=@GetDate,
			[updatedBy]=@UserId,
			[Status]=@Status
			WHERE Yealy_Id=@Yearly_Id

			SET @StatusId=@Yearly_Id;
	END

	SET NOCOUNT OFF

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_insupd26QVoucherDetails: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	SET @StatusId=-1;

	RETURN(-1)
END