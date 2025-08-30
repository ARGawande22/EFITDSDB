
Create   Procedure [dbo].[TDS_sp_GetRolerTypes]
--***********************************************************
--***
--*** Created On 23 Dec 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)

	--Get Role Information	
	Select 
		r.[Role_Id],
	   	r.[Role]
	   FROM [dbo].[TDS_t_UserRole] r with(nolock)
	Where r.[Status]='Y' --and r.[Role] in('Admin','Subadmin','FieldOfficer')

	IF(@@ROWCOUNT=0)
	BEGIN
	  Select @ErrMsg='TDS_sp_GetRolerTypes: Error Getting Roles.'
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