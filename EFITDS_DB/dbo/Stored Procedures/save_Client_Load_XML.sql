
Create   Procedure [dbo].[save_Client_Load_XML]
	@xml TEXT
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

	DECLARE @ErrMsg Nvarchar(255),
			@Status Char(1),
			@XMLDocumentHandle  INT,
			@XMLPrepared	INT

	--open & prepare the XML document for reading into temporary tables.
	EXEC @XMLPrepared=sp_XML_preparedocument @XMLDocumentHandle OUTPUT,@xml

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading XML.'
		GOTO spError
	END

	--load XMl Into ClientDetails temp table.
	INSERT INTO #ClientDetails(
					Office_Id	
					,TAN_No		
					,Office_Name
					,Office_PanNo
					,GSTIN		
					,AIN_No		
					,Address	
					,City_Id	
					,PinCode	
					,Contact_No	
					,Email_Id	
					,[Type_Id]	
					,Profile_Status
					,Status)
		SELECT Office_Id=OfficeId
				,TAN_No=TanNo
				,Office_Name=NULLIF(OfficeName,'')
				,Office_PanNo= NULLIF(OfficePanNo,'')
				,GSTIN=NULLIF(GSTIN,'')
				,AIN_No=OfficeAINNo
				,Address=NULLIF(OfficeAddress,'')
				,City_Id=CityId
				,PinCode=PinCode
				,Contact_No=ContactNo
				,Email_Id=EmailId
				,[Type_Id]=TypeId
				,Profile_Status=1
				,[Status]='Y'
		FROM OPENXML(@XMLDocumentHandle ,'/ClientModel', 2) WITH
					(	OfficeId		INT				--'OfficeId'
						,TanNo			VARCHAR(10)		--'TanNo'
						,OfficeName		VARCHAR(255)	--'OfficeName'
						,OfficePanNo	VARCHAR(10)		--'OfficePanNo'
						,GSTIN			VARCHAR(50)		--'GSTIN'
						,OfficeAINNo	VARCHAR(7)		--'OfficeAINNo'
						,OfficeAddress	VARCHAR(255)	--'OfficeAddress'
						,CityId			INT				--'CityId'
						,PinCode		INT				--'PinCode'
						,ContactNo		VARCHAR(13)		--'ContactNo'
						,EmailId		VARCHAR(50)		--'EmailId'
						,TypeId			INT				--'TypeId'					
					)

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading office details from XML.'
		GOTO spError
	END	

	--load XMl Into DDDetails temp table
	INSERT INTO #DDODetails(
					DDO_Code	
					,Office_Id		
					,DDO_Name
					,DDO_PanNo
					,DOB		
					,Gender_Id		
					,Address	
					,City_Id	
					,PinCode	
					,Contact_No	
					,Email_Id
					,Status)
		SELECT DDO_Code=DDOCode
				,Office_Id=0
				,DDO_Name=NULLIF(DDOName,'')
				,DDO_PanNo= NULLIF(DDOPanNo,'')
				,DOB=Case when DDODateOfBirth  IS NOT NULL THEN CONVERT(Date,DDODateOfBirth,23) ELSE NULL END
				,Gender_Id=DDOGenderId
				,Address=NULLIF(DDOAddress,'')
				,City_Id=DDOCityId
				,PinCode=DDOPinCode
				,Contact_No=DDOContactNo
				,Email_Id=''
				,[Status]='Y'
		FROM OPENXML(@XMLDocumentHandle ,'/ClientModel/DDO', 2) WITH
					(	DDOCode			VARCHAR(11)		--'DDOCode'
						,DDOName		VARCHAR(50)		--'DDOName'
						,DDOPanNo		VARCHAR(10)		--'DDOPanNo'
						,DDODateOfBirth	Date			--'DDODateOfBirth'
						,DDOGenderId	INT				--'DDOGenderId'
						,DDOAddress		VARCHAR(255)	--'DDOAddress'
						,DDOCityId		INT				--'DDOCityId'
						,DDOPinCode		INT				--'DDOPinCode'
						,DDOContactNo	VARCHAR(13)		--'DDOContactNo'					
					)

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading DDO details from XML.'
		GOTO spError
	END

	--load XMl Into Credential temp table
	INSERT INTO #Credential(
					ID	
					,Office_Id		
					,Credential_Id
					,[User_Id]
					,[Password]
					,Status)
		SELECT	Id=Id
				,Office_Id=0
				,CredentialId=CredentialId
				,UserId= NULLIF(UserId,'')
				,Password=NULLIF(Password,'')
				,[Status]=CredentialStatus
		FROM OPENXML(@XMLDocumentHandle ,'/ClientModel/ClientCredentials/ClientCredential', 2) WITH
					(	Id				INT				'Id'
						,CredentialId	INT				'CredentialId'
						,UserId			VARCHAR(50)		'UserId'
						,Password		VARCHAR(50)		'Password'
						,CredentialStatus	VARCHAR(1)	'CredentialStatus'					
					)
	
	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading Credential details from XML.'
		GOTO spError
	END
	
	--Clean up & remove the XML reader handle.
	Exec sp_XML_removedocument @XMLDocumentHandle

	RETURN(0)

spError:
	IF  @XMLPrepared=0 --XML document handle created, clean it up.
		Exec sp_XML_removedocument @XMLDocumentHandle

	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='save_Client_Load_XML: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END