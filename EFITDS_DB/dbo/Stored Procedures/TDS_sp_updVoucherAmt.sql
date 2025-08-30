
Create   Procedure [dbo].[TDS_sp_updVoucherAmt]
	@Voucher_Id INT,
	@VoucherAmount  Decimal,
	@UserId Int,
	@Status NVARCHAR(1),
	@updStatus INT OUTPUT

--***********************************************************
--***
--*** Created On 29 Jun 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),
			@GetDate	DATETIME

	  IF(@Voucher_Id = 0)
	      BEGIN
	      	Select @ErrMsg='Voucher Id Should be greater than 0'
	      	GOTO spError
	      END
	  
	  SET @GetDate=GETDATE();
	  
	  UPDATE [dbo].[TDS_t_Voucher_Details]
	  SET Voucher_Amount=@VoucherAmount,UpdatedOn=@GetDate,updatedBy=@UserId,[Status]=@Status
	  WHERE Voucher_Id=@Voucher_Id
	  
	  IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error updating Voucher Amt details'
			GOTO spError
		END

	SET NOCOUNT OFF
	
	SET @updStatus=1

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_updVoucherAmt: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	SET @updStatus=0

	RETURN(-1)
END