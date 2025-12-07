USE TDSLive;
GO

Create OR Alter Procedure [dbo].[save_Employee]
	@xml TEXT
	,@loginId INT
	,@DDOCode NVARCHAR(10)
	,@affectedCnt INT  OUTPUT
--***********************************************************
--***
--*** Created On 26 Oct 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@Sevaarth_Id VARCHAR(15),
			@XMLDocumentHandle  INT,
			@XMLPrepared	INT,
			@ErrMsg		NVARCHAR(255),			
			@rc			SMALLINT,
			@Exists		INT,
			@affectedRow INT

	SET @GetDate=GETDATE();

	IF OBJECT_ID('tempdb..#EmployeeDetailss') IS NOT NULL
		DROP TABLE #EmployeeDetails

	CREATE TABLE #EmployeeDetails(
		Sevaarth_Id			VARCHAR(15)		NOT NULL
		,DDO_Code			VARCHAR(11)		NOT NULL
		,EMP_PANNo			VARCHAR(10)		NULL
		,PAN_Status			VARCHAR(1)		NULL
		,UID_No				VARCHAR(12)		NULL
		,EID_No				VARCHAR(50)		NULL
		,Name_AsPerSevaarth	VARCHAR(50)		NULL
		,DBO_AsPerSevaarth	Date			Null
		,Name_AsPerIT		VARCHAR(50)		NULL
		,DBO_AsPerIT		Date			Null
		,Designation_Id		INT				NULL
		,DOJ				Date			Null
		,DOR				Date			Null
		,Contact_No			VARCHAR(13)		NULL
		,Email_Id			VARCHAR(50)		NULL
		,Gender_Id			INT				NULL
		,Address			VARCHAR(255)	NULL
		,IsManual			VARCHAR(1)		NULL
		,IsSeniorCitizen	VARCHAR(1)		NULL
		,IsDCPS				VARCHAR(1)		NULL
		,Account_No			VARCHAR(50)		NULL
		,Bank_Name			VARCHAR(50)		NULL
		,IFSC_Code			VARCHAR(11)		NULL
		,GPF_DCPS_AccountNo	VARCHAR(50)		NULL
		)	

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	--open & prepare the XML document for reading into temporary tables.
	EXEC @XMLPrepared=sp_XML_preparedocument @XMLDocumentHandle OUTPUT,@xml


	--load XMl Into ClientDetails temp table.
	INSERT INTO #EmployeeDetails(
					Sevaarth_Id			
					,DDO_Code			
					,EMP_PANNo			
					,PAN_Status			
					,UID_No				
					,EID_No				
					,Name_AsPerSevaarth
					,DBO_AsPerSevaarth	
					,Name_AsPerIT		
					,DBO_AsPerIT		
					,Designation_Id		
					,DOJ				
					,DOR				
					,Contact_No			
					,Email_Id			
					,Gender_Id			
					,Address			
					,IsManual			
					,IsSeniorCitizen	
					,IsDCPS				
					,Account_No			
					,Bank_Name			
					,IFSC_Code			
					,GPF_DCPS_AccountNo)
		SELECT Sevaarth_Id=Sevaarth_Id
				,DDO_Code=DDO_Code			
				 ,EMP_PANNo=NULLIF(EMP_PANNo,'')		
				 ,PAN_Status=PAN_Status			
				 ,UID_No=UID_No				
				 ,EID_No=EID_No				
				 ,Name_AsPerSevaarth=NULLIF(Name_AsPerSevaarth,'')
				 ,DBO_AsPerSevaarth= CASE WHEN  DBO_AsPerSevaarth!=CAST('1900-01-01' As DATE) THEN DBO_AsPerSevaarth ELSE NULL END
				 ,Name_AsPerIT=NULLIF(Name_AsPerIT,'')	
				 ,DBO_AsPerIT= CASE WHEN  DBO_AsPerIT!=CAST('1900-01-01' As DATE) THEN DBO_AsPerIT ELSE NULL END	
				 ,Designation_Id=DesignationId		
				 ,DOJ= CASE WHEN  DOJ!=CAST('1900-01-01' As DATE) THEN DOJ ELSE NULL END	
				 ,DOR= CASE WHEN  DOR!=CAST('1900-01-01' As DATE) THEN DOR ELSE NULL END			
				 ,Contact_No=Contact_No			
				 ,Email_Id	=Email_Id		
				 ,Gender_Id	=GenderId		
				 ,Address=NULLIF(EmpAddress,'')			
				 ,IsManual	=IsManual		
				 ,IsSeniorCitizen=	IsSeniorCitizen
				 ,IsDCPS	=IsDCPS			
				 ,Account_No	=Account_No		
				 ,Bank_Name	=	Bank_Name	
				 ,IFSC_Code	=	IFSC_Code	
				 ,GPF_DCPS_AccountNo=GPF_DCPS_AccountNo
		FROM OPENXML(@XMLDocumentHandle ,'/Employee', 2) WITH
					(	Sevaarth_Id			VARCHAR(15)	
						,DDO_Code			VARCHAR(11)	
						,EMP_PANNo			VARCHAR(10)
						,PAN_Status			VARCHAR(1)	
						,UID_No				VARCHAR(12)	
						,EID_No				VARCHAR(50)	
						,Name_AsPerSevaarth	VARCHAR(50)
						,DBO_AsPerSevaarth	DATE			
						,Name_AsPerIT		VARCHAR(50)			
						,DBO_AsPerIT		DATE	
						,DesignationId		INT
						,DOJ				DATE
						,DOR				DATE
						,Contact_No			VARCHAR(13)	
						,Email_Id			VARCHAR(50)
						,GenderId			INT
						,EmpAddress			VARCHAR(255) 'Address'
						,IsManual			VARCHAR(1)
						,IsSeniorCitizen	VARCHAR(1)
						,IsDCPS				VARCHAR(1)
						,Account_No			VARCHAR(50)
						,Bank_Name			VARCHAR(50)
						,IFSC_Code			VARCHAR(11)
						,GPF_DCPS_AccountNo	VARCHAR(50))

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading Employee details from XML.'
		GOTO spError
	END	

	--Clean up & remove the XML reader handle.
	Exec sp_XML_removedocument @XMLDocumentHandle


	SET @Sevaarth_Id=(SELECT TOP 1 Sevaarth_Id FROM #EmployeeDetails)

	--[1]. Insert / Update Employee Details
	IF EXISTS(SELECT Sevaarth_Id FROM [dbo].[TDS_t_Emp_Details] Where Sevaarth_Id=@Sevaarth_Id)
	BEGIN
		--Update the Office Details
		UPDATE e
		SET EMP_PANNo=emp.EMP_PANNo,
			PAN_Status=CASE WHEN emp.PAN_Status='Y' THEN emp.PAN_Status ELSE 'N'END,
			UID_No=emp.UID_No,
			EID_No=emp.EID_No,
			Name_AsPerSevaarth=emp.Name_AsPerSevaarth,
			DBO_AsPerSevaarth=emp.DBO_AsPerSevaarth,
			Name_AsPerIT=emp.Name_AsPerIT,
			DBO_AsPerIT=emp.DBO_AsPerIT,
			Designation_Id=emp.Designation_Id,
			DOJ=emp.DOJ,
			DOR=emp.DOR,
			Contact_No=emp.Contact_No,
			Email_Id=emp.Email_Id,
			Gender_Id=emp.Gender_Id,
			[Address]=emp.[Address],
			IsManual=emp.IsManual,
			IsSeniorCitizen=emp.IsSeniorCitizen,
			IsDCPS=emp.IsDCPS,
			UpdatedOn=@GetDate,
			UpdatedBy=@loginId
		FROM [dbo].[TDS_t_Emp_Details] e
		     JOIN #EmployeeDetails emp on e.Sevaarth_Id=emp.Sevaarth_Id
		WHERE e.Sevaarth_Id=@Sevaarth_Id

		IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='Error updating Employee details.'
			GOTO spError
		END

		SET @affectedRow=@@ROWCOUNT;

	END
	ELSE
	BEGIN
		--Insert New Office Details
		INSERT INTO [dbo].[TDS_t_Emp_Details](
					Sevaarth_Id			
					,DDO_Code			
					,EMP_PANNo			
					,PAN_Status			
					,UID_No				
					,EID_No				
					,Name_AsPerSevaarth
					,DBO_AsPerSevaarth	
					,Name_AsPerIT		
					,DBO_AsPerIT		
					,Designation_Id		
					,DOJ				
					,DOR				
					,Contact_No			
					,Email_Id			
					,Gender_Id			
					,Address			
					,IsManual			
					,IsSeniorCitizen	
					,IsDCPS
					,InsertedOn
					,InsertedBy
					,[Status])
			SELECT	Sevaarth_Id,
					@DDOCode,
					EMP_PANNo,
					PAN_Status,
					UID_No,
					EID_No,
					Name_AsPerSevaarth,
					DBO_AsPerSevaarth,
					Name_AsPerIT,
					DBO_AsPerIT,
					Designation_Id,
					DOJ,
					DOR,
					Contact_No,
					Email_Id,
					Gender_Id,			
					Address,
					IsManual,
					IsSeniorCitizen,
					IsDCPS,
					@GetDate,
					@loginId,
					'Y'
			FROM #EmployeeDetails
			WHERE Sevaarth_Id=@Sevaarth_Id

		IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='Error inserting Employee details.'
			GOTO spError
		END
			
			SET @affectedRow=@@ROWCOUNT;
	END	

	--[3]. Insert / Update EMP Bank Details.
	IF EXISTS (SELECT * FROM [dbo].[TDS_t_EmpBank_Details] WHERE Sevaarth_Id=@Sevaarth_Id)
	BEGIN
		UPDATE b
		SET b.Account_No=emp.Account_No,
			b.Bank_Name=emp.Bank_Name,
			b.IFSC_Code=emp.IFSC_Code,
			b.GPF_DCPS_AccountNo=emp.GPF_DCPS_AccountNo
		FROM [dbo].[TDS_t_EmpBank_Details] b
		JOIN #EmployeeDetails emp ON b.Sevaarth_Id=emp.Sevaarth_Id
		
		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error updating Bank details.'
			GOTO spError
		END
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[TDS_t_EmpBank_Details](
				Sevaarth_Id,
				Account_No,
				Bank_Name,
				IFSC_Code,
				GPF_DCPS_AccountNo,
				Status)
		SELECT  Sevaarth_Id,
				Account_No,
				Bank_Name,
				IFSC_Code,
				GPF_DCPS_AccountNo,
				'Y'
			FROM #EmployeeDetails
			WHERE Sevaarth_Id=@Sevaarth_Id

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error inserting Bank details.'
			GOTO spError
		END
	END

	SET @affectedCnt=@affectedRow

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='save_Client: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END