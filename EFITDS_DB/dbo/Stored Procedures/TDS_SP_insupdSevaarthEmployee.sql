USE TDSLive;
GO

Create OR Alter  Procedure [dbo].[TDS_SP_insupdSevaarthEmployee]
	@xml TEXT
	,@loginId INT
	,@DDOCode NVARCHAR(10)
	,@Status INT  OUTPUT
--***********************************************************
--***
--*** Created On 27 Sep 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@XMLDocumentHandle  INT,
			@XMLPrepared	INT,
			@ErrMsg		NVARCHAR(255),			
			@rc			SMALLINT,
			@Exists		INT,
			@affectedRow INT

	SET @GetDate=GETDATE();

	IF OBJECT_ID('tempdb..#EmployeeDetails') IS NOT NULL
		DROP TABLE #EmployeeDetails

	CREATE TABLE #EmployeeDetails(
		Sevaarth_Id			VARCHAR(15)		NOT NULL
		,DDO_Code			VARCHAR(11)		NOT NULL
		,EMP_PANNo			VARCHAR(10)		NULL
		,PAN_Status			VARCHAR(1)		NULL
		,UID_No				VARCHAR(12)		NULL
		,EID_No				VARCHAR(50)		NULL
		,Name_AsPerSevaarth	VARCHAR(50)		NULL
		,DOB_AsPerSevaarth	Date			Null
		,Name_AsPerIT		VARCHAR(50)		NULL
		,DOB_AsPerIT		Date			Null
		,Designation_Id		INT				NULL
		,Designation		VARCHAR(500)
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


	--load XMl Into EmployeeDetails temp table.
	INSERT INTO #EmployeeDetails(
					Sevaarth_Id			
					,DDO_Code			
					,EMP_PANNo			
					,PAN_Status			
					,UID_No				
					,EID_No				
					,Name_AsPerSevaarth
					,DOB_AsPerSevaarth	
					,Name_AsPerIT		
					,DOB_AsPerIT		
					,Designation_Id
					,Designation
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
				 ,DBO_AsPerSevaarth= CASE WHEN  DBO_AsPerSevaarth!=CAST('0001-01-01' As DATE) THEN DBO_AsPerSevaarth ELSE NULL END
				 ,Name_AsPerIT=NULLIF(Name_AsPerIT,'')	
				 ,DBO_AsPerIT= CASE WHEN  DBO_AsPerIT!=CAST('0001-01-01' As DATE) THEN DBO_AsPerIT ELSE NULL END	
				 ,Designation_Id=DesignationId
				 ,Designation=Designation
				 ,DOJ= CASE WHEN  DOJ!=CAST('0001-01-01' As DATE) THEN DOJ ELSE NULL END	
				 ,DOR= CASE WHEN  DOR!=CAST('0001-01-01' As DATE) THEN DOR ELSE NULL END			
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
		FROM OPENXML(@XMLDocumentHandle ,'/Emps/Employee', 2) WITH
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
						,Designation		VARCHAR(500)
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

	DECLARE @Sevaarth_Id			nvarchar(15),
			@DDO_Code				nvarchar(11),
			@EMP_PANNo				nvarchar(10),
			@PAN_Status				nvarchar(1) ,
			@UID_No					nvarchar(12),
			@EID_No					nvarchar(50),
			@Name_AsPerSevaarth		nvarchar(50),
			@DOB_AsPerSevaarth		date		,
			@Name_AsPerIT			nvarchar(50),
			@DOB_AsPerIT			date		,
			@Designation_Id			int			,
			@Designation			nvarchar(500),
			@DOJ					date		,
			@DOR					date		,
			@Contact_No				nvarchar(13),
			@Email_Id				nvarchar(50),
			@Gender_Id				int			,
			@Address				nvarchar(255),
			@IsManual				nvarchar(1) ,
			@IsSeniorCitizen		nvarchar(1) ,
			@IsDCPS					nvarchar(1) ,
			@Account_No				nvarchar(50),
			@Bank_Name				nvarchar(50),
			@IFSC_Code				nvarchar(11),
			@GPF_DCPS_AccountNo		nvarchar(50)

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT Sevaarth_Id,DDO_Code,EMP_PANNo,PAN_Status,UID_No,EID_No,Name_AsPerSevaarth,DOB_AsPerSevaarth,Name_AsPerIT,DOB_AsPerIT,Designation_Id,Designation,
	DOJ,DOR,Contact_No,Email_Id,Gender_Id,Address,IsManual,IsSeniorCitizen,IsDCPS,Account_No,Bank_Name,IFSC_Code,GPF_DCPS_AccountNo
	FROM #EmployeeDetails
	OPEN K
		FETCH NEXT FROM K INTO @Sevaarth_Id,@DDO_Code,@EMP_PANNo,@PAN_Status,@UID_No,@EID_No,@Name_AsPerSevaarth,@DOB_AsPerSevaarth,@Name_AsPerIT,@DOB_AsPerIT,@Designation_Id		
		,@Designation,@DOJ,@DOR,@Contact_No,@Email_Id,@Gender_Id,@Address,@IsManual,@IsSeniorCitizen,@IsDCPS,@Account_No,@Bank_Name,@IFSC_Code,@GPF_DCPS_AccountNo
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
			--[1]. Insert Desinatin if not Exist
				SELECT @Designation_Id=Designation_Id FROM [dbo].[TDS_t_Designations] WHERE Designation=@Designation and [Status]='Y'
				IF(@Designation_Id=0 OR @Designation_Id IS NULL)
				BEGIN
					INSERT INTO [dbo].[TDS_t_Designations](Designation,[Status]) VALUES(@Designation,'Y')
					SET @Designation_Id=@@IDENTITY;
				END


			--[2]. Insert / Update Employee Details
				IF EXISTS(SELECT Sevaarth_Id FROM [dbo].[TDS_t_Emp_Details] Where Sevaarth_Id=@Sevaarth_Id)
				BEGIN
					--Update the Employee Details
					UPDATE e
					SET EMP_PANNo=CASE WHEN @EMP_PANNo IS NOT NULL THEN @EMP_PANNo ELSE e.EMP_PANNo END,
						PAN_Status=CASE WHEN e.PAN_Status='Y' AND e.EMP_PANNo = @EMP_PANNo THEN e.PAN_Status ELSE 'N'END,
						UID_No=CASE WHEN @UID_No IS NOT NULL THEN @UID_No ELSE e.UID_No END,
						EID_No=CASE WHEN @EID_No IS NOT NULL THEN @EID_No ELSE e.EID_No END,
						Name_AsPerSevaarth=@Name_AsPerSevaarth,
						DBO_AsPerSevaarth=CASE WHEN @DOB_AsPerSevaarth IS NOT NULL THEN @DOB_AsPerSevaarth ELSE e.DBO_AsPerSevaarth END,
						Name_AsPerIT=CASE WHEN @Name_AsPerIT IS NOT NULL THEN @Name_AsPerIT ELSE e.Name_AsPerIT END,
						DBO_AsPerIT=CASE WHEN @DOB_AsPerIT IS NOT NULL THEN @DOB_AsPerIT ELSE e.DBO_AsPerIT END,
						Designation_Id=@Designation_Id,
						DOJ=CASE WHEN @DOJ IS NOT NULL THEN @DOJ ELSE e.DOJ END,
						DOR=CASE WHEN @DOR IS NOT NULL THEN @DOR ELSE e.DOR END,
						Contact_No=CASE WHEN @Contact_No IS NOT NULL THEN @Contact_No ELSE e.Contact_No END,
						Email_Id=CASE WHEN @Email_Id IS NOT NULL THEN @Email_Id ELSE e.Email_Id END,
						--Gender_Id=CASE WHEN @Gender_Id IS NOT NULL THEN @Gender_Id ELSE e.Gender_Id END,
						[Address]=CASE WHEN @Address IS NOT NULL THEN @Address ELSE e.[Address] END,
						IsManual=CASE WHEN @IsManual IS NOT NULL THEN @IsManual ELSE e.IsManual END,
						IsSeniorCitizen=CASE WHEN @IsSeniorCitizen IS NOT NULL THEN @IsSeniorCitizen ELSE e.IsSeniorCitizen END,
						IsDCPS=CASE WHEN @IsDCPS IS NOT NULL THEN @IsDCPS ELSE e.IsDCPS END,
						UpdatedOn=@GetDate,
						UpdatedBy=@loginId
					FROM [dbo].[TDS_t_Emp_Details] e
					WHERE e.Sevaarth_Id=@Sevaarth_Id

					IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
					BEGIN
						Select @ErrMsg='Error updating Employee details.'
						GOTO spError
					END
				END
				ELSE
				BEGIN
					--Insert New Eployee Details
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
						VALUES (@Sevaarth_Id,
								@DDO_Code,
								@EMP_PANNo,
								@PAN_Status,
								@UID_No,
								@EID_No,
								@Name_AsPerSevaarth,
								@DOB_AsPerSevaarth,
								@Name_AsPerIT,
								@DOB_AsPerIT,
								@Designation_Id,
								@DOJ,
								@DOR,
								@Contact_No,
								@Email_Id,
								@Gender_Id,
								@Address,
								@IsManual,
								@IsSeniorCitizen,
								@IsDCPS,								
								@GetDate,
								@loginId,
								'Y')

					IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
					BEGIN
						Select @ErrMsg='Error inserting Employee details.'
						GOTO spError
					END							
				END	

				--[3]. Insert / Update EMP Bank Details.
				IF EXISTS (SELECT * FROM [dbo].[TDS_t_EmpBank_Details] WHERE Sevaarth_Id=@Sevaarth_Id)
				BEGIN
					UPDATE b
					SET b.Account_No=CASE WHEN @Account_No IS NOT NULL THEN @Account_No ELSE b.Account_No END,
						b.Bank_Name=CASE WHEN @Bank_Name IS NOT NULL THEN @Bank_Name ELSE b.Bank_Name END,
						b.IFSC_Code=CASE WHEN @IFSC_Code IS NOT NULL THEN @IFSC_Code ELSE b.IFSC_Code END,
						b.GPF_DCPS_AccountNo=CASE WHEN @GPF_DCPS_AccountNo IS NOT NULL THEN @GPF_DCPS_AccountNo ELSE b.GPF_DCPS_AccountNo END
					FROM [dbo].[TDS_t_EmpBank_Details] b
					WHERE b.Sevaarth_Id=@Sevaarth_Id
					
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
					Values(@Sevaarth_Id,
							@Account_No,
							@Bank_Name,
							@IFSC_Code,
							@GPF_DCPS_AccountNo,
							'Y')

					IF(@@ERROR <> 0 OR @@IDENTITY=0)
					BEGIN
						Select @ErrMsg='Error inserting Bank details.'
						GOTO spError
					END
				END

			END
		FETCH NEXT FROM K INTO @Sevaarth_Id,@DDO_Code,@EMP_PANNo,@PAN_Status,@UID_No,@EID_No,@Name_AsPerSevaarth,@DOB_AsPerSevaarth,@Name_AsPerIT,@DOB_AsPerIT,@Designation_Id		
		,@Designation,@DOJ,@DOR,@Contact_No,@Email_Id,@Gender_Id,@Address,@IsManual,@IsSeniorCitizen,@IsDCPS,@Account_No,@Bank_Name,@IFSC_Code,@GPF_DCPS_AccountNo
		END
	CLOSE K
	DEALLOCATE K

	SET @Status=1;

	RETURN(0)
	
spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_SP_insupdSevaarthEmployee: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Status=0;

	RETURN(-1)
END