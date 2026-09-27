USE TDSLive;
GO

Create OR Alter Procedure [dbo].[TDS_sp_updVoucherFormType]
	@VoucherId INT
	,@Form_Type NVARCHAR(3)
	,@loginId INT
--***********************************************************
--*** Purpse: - Change the voucher form type.
--***
--*** Created On 22 Sep 2026 By A.R.Gawande
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

	--[1]. Change the voucher form type
	IF @VoucherId<>0
	BEGIN		
		UPDATE vd
		SET [Form_Type]=@Form_Type,
		    [UpdatedOn]=@GetDate,
			updatedBy=@loginId
		FROM [dbo].[TDS_t_Voucher_Details] vd
		WHERE vd.Voucher_Id=@VoucherId

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error changing voucher for type.'
			GOTO spError
		END
	END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_updVoucherFormType: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END