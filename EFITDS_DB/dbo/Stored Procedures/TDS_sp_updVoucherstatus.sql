
Create   Procedure [dbo].[TDS_sp_updVoucherstatus]
	@VoucherId INT,
	@loginId INT,
	@status CHAR(1)

--***********************************************************
--***
--*** Created On 05 Dec 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@ErrMsg		NVARCHAR(255)


	SET @GetDate=GETDATE();

	--[1]. Insert / Update Login Details	
	UPDATE vd
	SET vd.UpdatedOn=@GetDate,
		vd.updatedBy=@loginId,
		vd.[Status]=@status
	FROM [dbo].[TDS_t_Voucher_Details] vd
	WHERE vd.Voucher_Id=@VoucherId
	
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_updVoucherstatus: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END