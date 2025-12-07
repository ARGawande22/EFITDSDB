USE TDSLive;
GO

Create OR Alter Procedure [dbo].[TDS_sp_GetClientCredential]
	@OfficeId int

--***********************************************************
--***
--*** Created On 04 Dec 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)

    IF OBJECT_ID('tempdb..#SevaarthCredential') IS NOT NULL
		DROP TABLE #SevaarthCredential

	CREATE TABLE #SevaarthCredential(
				Id				INT				NOT NULL,
				Office_Id		INT				NULL,
				Credential_Id	INT				NULL,
				[User_Id]		nvarchar(50)	NULL,
				[Password]		nvarchar(255)	NULL,
				[Status]		nvarchar(1)		NULL)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END


	INSERT INTO #SevaarthCredential(Id				
									,Office_Id		
									,Credential_Id	
									,[User_Id]		
									,[Password]		
									,[Status])
							SELECT	oc.Id
									,oc.Office_Id
									,oc.Credential_Id
									,oc.[User_Id]
									,oc.[Password]
									,oc.[Status]
							FROM dbo.TDS_t_Office_Credentials oc
							WHERE oc.Office_Id=@OfficeId

	--Get Client Credentials Information	
	SELECT ct.Credential_Id
		   ,ct.Credential_Type
		   ,c.Id
		   ,c.[User_Id]
		   ,c.[Password]
		   ,c.[Status]
	FROM dbo.TDS_t_CrendetialTypes ct with(nolock)
		LEFT JOIN #SevaarthCredential c with(nolock) ON ct.Credential_Id=c.Credential_Id
	WHERE ct.[Status]='Y'

	IF(@@ROWCOUNT=0)
	BEGIN
	  Select @ErrMsg='TDS_sp_GetClientCredential: Error Getting Office Credentials.'
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