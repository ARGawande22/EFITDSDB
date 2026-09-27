USE TDSLive;
GO

Create OR Alter Procedure [dbo].[TDS_sp_DelVoucher]
	@VoucherId INT
	,@loginId INT
--***********************************************************
--*** Purpse: - Remove voucher.
--***
--*** Created On 22 Sep 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)

	--[1]. Remove voucher and it employee Details
	IF @VoucherId<>0
	BEGIN
		DELETE vd
		FROM [dbo].[TDS_t_Voucher_Details] vd
		WHERE vd.Voucher_Id=@VoucherId

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error removing voucher details.'
			GOTO spError
		END
	END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_DelVoucher: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END