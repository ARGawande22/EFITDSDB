USE TDSLive;
GO

Create OR Alter Procedure [dbo].[del_Employee]
	@SevaarthId NVARCHAR(15)
	,@Status NVARCHAR(1)
--***********************************************************
--*** Purpse: - Enable/disable the Employee.
--***
--*** Created On 30 Oct 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)


	DECLARE @sevaarth_Id VARCHAR(15)
	
	--[1]. Check the status IsNew or IsModify
	SELECT @sevaarth_Id=Sevaarth_Id FROM [dbo].[TDS_t_Emp_Details] Where Sevaarth_Id=@SevaarthId

	--[2]. Insert / Update Employee Details
	IF @sevaarth_Id IS NOT NULL AND @sevaarth_Id<>''
	BEGIN
		--Update the Office status
		UPDATE o
		SET [Status]=@Status
		FROM [dbo].[TDS_t_Emp_Details] o
		WHERE o.Sevaarth_Id=@sevaarth_Id

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error enabling / disabling Employee.'
			GOTO spError
		END
	END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='del_Client: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END