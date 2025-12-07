USE TDSLive;
GO

Create OR Alter Procedure [dbo].[del_Client]
	@OfficeId INT
	,@Status NVARCHAR(1)
--***********************************************************
--*** Purpse: - Enable/disable the Office.
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


	DECLARE @office_Id INT
	
	--[1]. Check the status IsNew or IsModify
	SELECT @office_Id=Office_Id FROM [dbo].[TDS_t_Office_Details] Where Office_Id=@OfficeId

	--[2]. Insert / Update office Details
	IF @office_Id<>0
	BEGIN
		--Update the Office status
		UPDATE o
		SET [Status]=@Status
		FROM [dbo].[TDS_t_Office_Details] o
		WHERE o.Office_Id=@office_Id

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error enabling / disabling client.'
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