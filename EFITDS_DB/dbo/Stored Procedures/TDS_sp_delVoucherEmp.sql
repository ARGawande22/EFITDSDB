USE TDSLive;
GO

Create Procedure [dbo].[TDS_sp_delVoucherEmp]
	@EmpId NVARCHAR(15)=NULL
	,@VoucherId INT
	,@YearlyId INT
	,@SourceId INT
	,@FormType NVARCHAR(5)
	,@loginId INT
--***********************************************************
--*** Purpse: - Delete Voucher Emp/Supplier details.
--***
--*** Created On 06 Dec 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)

	IF @FormType='24Q'
	BEGIN
	  IF EXISTS (SELECT * FROM [dbo].[TDS_t_EmpYearly_Details] WHERE Yealy_Id=@YearlyId AND  Voucher_Id=@VoucherId AND Sevaarth_Id=@EmpId)
		BEGIN
			If @SourceId=1
				BEGIN
					UPDATE ey SET ey.[Status]=CASE WHEN ey.[Status]='Y' THEN 'N' ELSE 'Y' END 
					FROM [dbo].[TDS_t_EmpYearly_Details] ey
					WHERE ey.Yealy_Id=@YearlyId AND  ey.Voucher_Id=@VoucherId AND ey.Sevaarth_Id=@EmpId
				END
			ELSE
				BEGIN
					DELETE  FROM [dbo].[TDS_t_EmpYearly_Details] WHERE Yealy_Id=@YearlyId AND  Voucher_Id=@VoucherId AND Sevaarth_Id=@EmpId 
				END
		END
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT * FROM [dbo].[TDS_t_26QSub_Details] WHERE Yealy_Id=@YearlyId AND  Voucher_Id=@VoucherId)
		BEGIN
			DELETE  FROM [dbo].[TDS_t_26QSub_Details] WHERE Yealy_Id=@YearlyId AND  Voucher_Id=@VoucherId
		END
	END

	IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error deleting Voucher details'
			GOTO spError
		END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_delVoucherEmp: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END