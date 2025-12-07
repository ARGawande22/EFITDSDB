
Create   Procedure [dbo].[save_Client]
	@xml TEXT
	,@loginId INT
	,@Oid INT  OUTPUT
--***********************************************************
--***
--*** Created On 01 Mar 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@ErrMsg		NVARCHAR(255),			
			@rc			SMALLINT,
			@Exists		INT


	DECLARE @office_Id INT
			

	SET @GetDate=GETDATE();

	IF OBJECT_ID('tempdb..#ClientDetails') IS NOT NULL
		DROP TABLE #ClientDetails

	CREATE TABLE #ClientDetails(
		Office_Id		INT				NOT NULL
		,TAN_No			VARCHAR(10)		NOT NULL
		,Office_Name	VARCHAR(255)	NOT NULL
		,Office_PanNo	VARCHAR(10)		NULL
		,GSTIN			VARCHAR(50)		NULL
		,AIN_No			VARCHAR(7)		NOT NULL
		,Address		VARCHAR(255)	NOT NULL
		,City_Id		INT				NOT NULL
		,PinCode		INT				NOT NULL
		,Contact_No		VARCHAR(13)		NULL
		,Email_Id		VARCHAR(50)		NULL
		,[Type_Id]		INT				NULL
		,Profile_Status	INT				NULL
		,Status			VARCHAR(1)		NOT NULL
		)

	IF OBJECT_ID('tempdb..#DDODetails') IS NOT NULL
		DROP TABLE #DDODetails

	CREATE TABLE #DDODetails(
		DDO_Code		VARCHAR(11)		NOT NULL
		,Office_Id		INT				NOT NULL
		,DDO_Name		VARCHAR(50)		NOT NULL
		,Desination_Id	INT				NULL
		,DDO_PanNo		VARCHAR(10)		NULL
		,DOB			Date			NULL
		,Gender_Id		INT				NULL
		,Address		VARCHAR(255)	NOT NULL
		,City_Id		INT				NOT NULL
		,PinCode		INT				NOT NULL
		,Contact_No		VARCHAR(13)		NULL
		,Email_Id		VARCHAR(50)		NULL
		,Status			VARCHAR(1)		NOT NULL
		)

	IF OBJECT_ID('tempdb..#Credential') IS NOT NULL
		DROP TABLE #Credential

	CREATE TABLE #Credential(
		ID				INT
		,Office_Id		INT				NOT NULL
		,Credential_Id	INT				NOT NULL
		,[User_Id]		VARCHAR(50)		NULL
		,[Password]		VARCHAR(50)		NULL
		,[Status]		VARCHAR(1)		NOT NULL
		)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	--open & prepare the XML document for reading into temporary tables.
	EXEC @rc=dbo.save_Client_Load_XML @xml

	IF(@rc<>0 OR @@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error executing save_Client_Load_XML.'
		GOTO spError
	END

	--[1]. Check the status IsNew or IsModify
	--SELECT @office_Id=Office_Id FROM #ClientDetails 
	SELECT @office_Id=Office_Id FROM [dbo].[TDS_t_Office_Details] Where TAN_No=(SELECT TAN_No FROM #ClientDetails )

	--[2]. Insert / Update office Details
	IF @office_Id<>0
	BEGIN
		--Update the Office Details
		UPDATE o
		SET GSTIN=c.GSTIN,
			AIN_No=c.AIN_No,
			[Address]=c.[Address],
			City_Id=c.City_Id,
			Office_PANNo=c.Office_PanNo,
			PinCode=c.PinCode,
			Contact_No=c.Contact_No,
			Email_Id=c.Email_Id,
			[Type_Id]=c.[Type_Id],
			UpdatedOn=@GetDate,
			UpdatedBy=@loginId
		FROM [dbo].[TDS_t_Office_Details] o
		     JOIN #ClientDetails c on o.Office_Id=c.Office_Id
		WHERE o.Office_Id=@office_Id

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error updating client details.'
			GOTO spError
		END
	END
	ELSE
	BEGIN
		--Insert New Office Details
		INSERT INTO [dbo].[TDS_t_Office_Details](
					TAN_No,
					Office_Name,
					Office_PanNo,
					GSTIN,
					AIN_No,
					[Address],
					City_Id,
					PinCode,
					Contact_No,
					Email_Id,
					[Type_Id],
					Profile_Status,
					CreatedOn,
					CreatedBy,
					[Status])
			SELECT	TAN_No,
					Office_Name,
					Office_PanNo,
					GSTIN,
					AIN_No,
					[Address],
					City_Id,
					PinCode,
					Contact_No,
					Email_Id,
					[Type_Id],
					Profile_Status,
					@GetDate,
					@loginId,
					[Status]
			FROM #ClientDetails

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error inserting client details.'
			GOTO spError
		END
			
			SET @office_Id=@@IDENTITY;
	END


	--[3]. Insert / Update DDO Details.
	IF EXISTS (SELECT * FROM [dbo].[TDS_t_Office_DDODetails] WHERE DDO_Code=(SELECT DDO_Code From #DDODetails))
	BEGIN
		UPDATE d
		SET d.Office_Id=@office_Id,
			d.DDO_PanNo=ddo.DDO_PanNo,
			d.DOB=DDO.DOB,
			d.Gender_Id=ddo.Gender_Id,
			d.Address=ddo.Address,
			d.City_Id=ddo.City_Id,
			d.PinCode=ddo.PinCode,
			d.Contact_No=ddo.Contact_No,
			d.Email_Id=ddo.Email_Id,
			d.Status=ddo.status
		FROM [dbo].[TDS_t_Office_DDODetails] d
		JOIN #DDODetails ddo ON d.DDO_Code=ddo.DDO_Code --AND d.Office_Id=@office_Id
		
		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error updating DDO details.'
			GOTO spError
		END
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[TDS_t_Office_DDODetails](
				DDO_Code,
				Office_Id,
				DDO_Name,
				DDO_PanNo,
				DOB,
				Gender_Id,
				Address,
				City_Id,
				PinCode,
				Contact_No,
				Email_Id,
				Status)
		SELECT  DDO_Code,
				@office_Id,
				DDO_Name,
				DDO_PanNo,
				DOB,
				Gender_Id,
				Address,
				City_Id,
				PinCode,
				Contact_No,
				Email_Id,
				Status
			FROM #DDODetails

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error inserting DDO details.'
			GOTO spError
		END
	END

	--[3] Insert / Update Office credentials
	DECLARE @Cred_Id   INT,
			@CredentialId INT,
			@UserID VARCHAR(50),
			@Password VARCHAR(255),
			@Status	CHAR(1)

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT Credential_Id,User_Id,Password,Status FROM #Credential 
	OPEN K
		FETCH NEXT FROM K INTO @CredentialId,@UserID,@Password,@Status
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				SELECT @Cred_Id=Id FROM [dbo].[TDS_t_Office_Credentials] WHERE Credential_Id=@CredentialId AND Office_Id=@office_Id
				IF (@Cred_Id>0)
				BEGIN
					UPDATE [dbo].[TDS_t_Office_Credentials]
					SET [User_Id]=@UserID,
						[Password]=@Password,
						Status=@Status
					WHERE  Credential_Id=@CredentialId AND Office_Id=@office_Id AND ID=@Cred_Id
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].[TDS_t_Office_Credentials](
									Office_Id,
									Credential_Id,
									[User_Id],
									[Password],
									Status)
							VALUES(	@office_Id,
									@CredentialId,
									@UserID,
									@Password,
									@Status)
				END
			END
			FETCH NEXT FROM K INTO @CredentialId,@UserID,@Password,@Status
		END
	CLOSE K
	DEALLOCATE K

	SET @Oid=@office_Id

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='save_Client: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END