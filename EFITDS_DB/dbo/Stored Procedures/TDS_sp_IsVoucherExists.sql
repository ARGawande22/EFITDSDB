
Create   Procedure [dbo].[TDS_sp_IsVoucherExists]
	@DDOCode NVARCHAR(10)=NULL,
	@BillHead NVARCHAR(50)=NULL,
	@VoucherNo Int=-1,
	@VoucherDate Datetime=NULL,
	@VoucherId INT OUTPUT

--***********************************************************
--***
--*** Created On 11 May 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)

	SELECT @VoucherId=Voucher_Id
	FROM [dbo].[TDS_t_Voucher_Details]
	WHERE ((@DDOCode IS NULL) OR (DDO_Code=@DDOCode))
	  AND ((@BillHead IS NULL) OR (BillHead=@BillHead))
	  AND ((@VoucherNo =-1) OR (Voucher_No=@VoucherNo))
	  AND ((@VoucherDate IS NULL) OR (Vourcher_Date=CONVERT(DATE, @VoucherDate)))
	  AND [Status]='Y'

	IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error checking Voucher details'
			GOTO spError
		END

	SET NOCOUNT OFF

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_IsVoucherExists: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	RETURN(-1)
END