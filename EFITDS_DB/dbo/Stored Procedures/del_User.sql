USE TDSLive;
GO

Create OR Alter Procedure [dbo].[del_User]
	@loginId INT
	,@Status NVARCHAR(1)
--***********************************************************
--*** Purpse: - Enable/disable the Users.
--***
--*** Created On 31 Oct 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)


	DECLARE @login_Id INT
	
	--[1]. Check the status IsNew or IsModify
	SELECT @login_Id=login_Id FROM [dbo].[TDS_t_UserLogin] Where login_Id=@LoginId

	--[2]. Insert / Update office Details
	IF @login_Id<>0
	BEGIN
		--Update the Office status
		UPDATE u
		SET [Status]=@Status
		FROM [dbo].[TDS_t_UserLogin] u
		WHERE u.login_Id=@LoginId

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error enabling / disabling User.'
			GOTO spError
		END
	END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='del_User: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END