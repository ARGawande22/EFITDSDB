


CREATE      Procedure [dbo].[upd_UserPassword]
	@UpdatedBy int,
	@UserId Nvarchar(20),
	@Newpassword Nvarchar(255)

--***********************************************************
--***
--*** Created On 14 Dec 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@GetDate Datetime

	--Get Current Date
	Select @GetDate=Getdate()

	--Update the User password
	UPDATE [dbo].[TDS_t_UserLogin]
	SET Password=@Newpassword,
		Updated_By=@UpdatedBy,
	    Updated_Date=@GetDate
	WHERE [User_Id]=@UserId

	IF(@@ROWCOUNT=0)
	BEGIN
		Select @ErrMsg='Error updating password for user with Id '+CAST(@UserId as VARCHAR)
		GOTO spError
	END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
