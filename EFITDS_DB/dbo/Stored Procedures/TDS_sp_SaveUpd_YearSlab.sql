USE TDSLive;
GO

Create  Procedure [dbo].[TDS_sp_SaveUpd_YearSlab]
	@YearId INT
	,@Yearxml TEXT
	,@loginId INT
	,@Result INT  OUTPUT
--***********************************************************
--***
--*** Created On 14 Feb 2026 By A.R.Gawande
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
			@ErrMsg		NVARCHAR(255)

DECLARE @Slab_Id			INT		
		,@xmlYear_Id		INT		
		,@StandardDeduction	VARCHAR(10)
		,@Rebate			VARCHAR(20)
		,@EducationalCess	INT		
		,@Surcharge			VARCHAR(20)
		,@IsNewRegime		VARCHAR(1)
		,@IsSeniorCitizen	VARCHAR(1)
		,@SlabStatus		VARCHAR(1)

	SET @GetDate=GETDATE();
	
	IF OBJECT_ID('tempdb..#YearSlabDetails') IS NOT NULL
		DROP TABLE #YearSlabDetails

	CREATE TABLE #YearSlabDetails(		
		Slab_DetailId		INT				NULL
		,Slab_Id			INT				NULL
		,Slab_Description	VARCHAR(20)		NULL
		,[Value]			VARCHAR(20)		NULL
		,[Status]			VARCHAR(1)		NULL
		)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	--open & prepare the XML document for reading into temporary tables.
	EXEC @XMLPrepared=sp_XML_preparedocument @XMLDocumentHandle OUTPUT,@Yearxml

	--load XMl Into #YearSlab Variables.
	SELECT TOP 1 @Slab_Id=SlabId	
				,@xmlYear_Id=YearId
				 ,@StandardDeduction= StandardDeduction
				 ,@Rebate= Rebate	
				 ,@EducationalCess=EducationalCess		
				 ,@Surcharge=Surcharge			
				 ,@IsNewRegime=IsNewRegime		
				 ,@IsSeniorCitizen=IsSeniorCitizen
				 ,@SlabStatus=IsActive
		FROM OPENXML(@XMLDocumentHandle ,'/FinYearSlabs', 2) WITH
					(	SlabId				INT
						,YearId				INT
						,StandardDeduction	VARCHAR(10)	
						,Rebate				VARCHAR(20)			
						,EducationalCess	INT							
						,Surcharge			VARCHAR(20)
						,IsNewRegime		VARCHAR(1)
						,IsSeniorCitizen	VARCHAR(1)
						,IsActive			VARCHAR(1))

	--load XMl Into ###YearSlabDetails temp table.
	INSERT INTO #YearSlabDetails(
					Slab_Id			
					,Slab_DetailId			
					,Slab_Description	
					,[Value]	
					,[Status])
		SELECT   Slab_Id=SlabId	
				,Slab_DetailId=SlabDetailsId
				,Slab_Description= SlabDescription
				 ,[Value]= [Value]
				 ,[Status]=[Status]
		FROM OPENXML(@XMLDocumentHandle ,'/FinYearSlabs/FinYearSlabDetails/FinYearSlabDetails', 2) WITH
					(	SlabId				INT
						,SlabDetailsId		INT
						,SlabDescription	VARCHAR(20)	
						,[Value]			VARCHAR(20)
						,[Status]			VARCHAR(1))


	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading year slab details from XML.'
		GOTO spError
	END	

	--Clean up & remove the XML reader handle.
	Exec sp_XML_removedocument @XMLDocumentHandle

	IF(@xmlYear_Id<=0 OR @xmlYear_Id Is Null)
	BEGIN
		SET @xmlYear_Id=@YearId
	END

	--Find the Slab based on Other parameter
	IF(@Slab_Id<=0 OR @Slab_Id Is Null)
	BEGIN
		SELECT @Slab_Id=Slab_Id
		FROM [dbo].[TDS_t_YearSlab] 
		WHERE Year_Id=@xmlYear_Id AND IsNewRegime=@IsNewRegime AND IsSeniorCitizen=@IsSeniorCitizen
	END

	IF(@Slab_Id<=0 OR @Slab_Id Is Null)
	BEGIN
		INSERT INTO [dbo].[TDS_t_YearSlab](Year_Id
										  ,StandardDeduction
										  ,Rebate
										  ,EducationalCess
										  ,Surcharge
										  ,IsNewRegime
										  ,IsSeniorCitizen
										  ,[Status])
								   VALUES(@xmlYear_Id
								          ,@StandardDeduction
										  ,@Rebate
										  ,@EducationalCess
										  ,@Surcharge
										  ,@IsNewRegime
										  ,@IsSeniorCitizen
										  ,@SlabStatus)

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error inserting year slab'
			GOTO spError
		END

		SET @Slab_Id=@@IDENTITY;
	END
	ELSE
	BEGIN
		UPDATE [dbo].[TDS_t_YearSlab]
		SET StandardDeduction=CASE WHEN StandardDeduction <>@StandardDeduction THEN @StandardDeduction ELSE StandardDeduction END
		    ,Rebate=CASE WHEN Rebate <>@Rebate THEN @Rebate ELSE Rebate END
		    ,EducationalCess=CASE WHEN EducationalCess <>@EducationalCess THEN @EducationalCess ELSE EducationalCess END
		    ,Surcharge=CASE WHEN Surcharge <>@Surcharge THEN @Surcharge ELSE Surcharge END
		    ,IsNewRegime=CASE WHEN IsNewRegime <>@IsNewRegime THEN @IsNewRegime ELSE IsNewRegime END
		    ,IsSeniorCitizen=CASE WHEN IsSeniorCitizen <>@IsSeniorCitizen THEN @IsSeniorCitizen ELSE IsSeniorCitizen END
		WHERE Slab_Id=@Slab_Id AND Year_Id=@xmlYear_Id
		
		IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='Error updating year slab'
			GOTO spError
		END
	END


	--Inserting / Updating Slab Details
	DECLARE @Slab_DetailId		INT			
			,@xmlSlab_Id		INT			
			,@Slab_Description	VARCHAR(20)	
			,@Value				VARCHAR(20)	
			,@SlabDetailStatus	VARCHAR(1)	

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT Slab_DetailId,Slab_Id,Slab_Description,[Value],[Status]FROM #YearSlabDetails 
	OPEN K
		FETCH NEXT FROM K INTO @Slab_DetailId,@xmlSlab_Id,@Slab_Description,@Value,@SlabDetailStatus	
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				IF(@xmlSlab_Id<=0 OR @xmlSlab_Id Is Null)
				BEGIN
					SET @xmlSlab_Id=@Slab_Id
				END

				--Find the @Slab_DetailId based on Slab Description
				IF(@Slab_DetailId<=0 OR @Slab_DetailId Is Null)
				BEGIN
					SELECT @Slab_DetailId=Slab_DetailId
					FROM [dbo].[TDS_t_YearSlabDetails] 
					WHERE Slab_Id=@xmlSlab_Id AND Slab_Description=@Slab_Description
				END

				IF(@Slab_DetailId<=0 OR @Slab_DetailId Is Null)
				BEGIN
					INSERT INTO [dbo].[TDS_t_YearSlabDetails](Slab_Id
															  ,Slab_Description
															  ,[Value]
														  	  ,[Status])
													   VALUES(@xmlSlab_Id
														      ,@Slab_Description
															  ,@Value
															  ,@SlabDetailStatus)
					
					IF(@@ERROR <> 0 OR @@IDENTITY=0)
					BEGIN
						Select @ErrMsg='Error inserting slab details'
						GOTO spError
					END

					SET @Slab_DetailId=@@IDENTITY;
				END
				ELSE IF(@SlabDetailStatus<>'N')
				BEGIN
					UPDATE [dbo].[TDS_t_YearSlabDetails]
					SET Slab_Description=CASE WHEN Slab_Description<>@Slab_Description THEN @Slab_Description ELSE Slab_Description END
						,[Value]=CASE WHEN [Value]<>@Value THEN @Value ELSE [Value] END
						,[Status] =CASE WHEN [Status]<>@SlabDetailStatus THEN @SlabDetailStatus ELSE [Status] END
					WHERE Slab_Id=@xmlSlab_Id AND Slab_DetailId=@Slab_DetailId

					IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
					BEGIN
						Select @ErrMsg='Error updating year slab details'
						GOTO spError
					END
				END
				ELSE
				BEGIN
					DELETE FROM [dbo].[TDS_t_YearSlabDetails] WHERE Slab_Id=@xmlSlab_Id AND Slab_DetailId=@Slab_DetailId

					IF(@@ERROR <> 0 OR @@ROWCOUNT=0)
					BEGIN
						Select @ErrMsg='Error deleting year slab details'
						GOTO spError
					END
				END
			END
			FETCH NEXT FROM K INTO @Slab_DetailId,@xmlSlab_Id,@Slab_Description,@Value,@SlabDetailStatus
		END
	CLOSE K
	DEALLOCATE K

	SET @Result=1
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_SaveUpd_YearSlab: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Result=0
	RETURN(-1)
END