USE TDSLive
GO

CREATE   Procedure [dbo].[TDS_sp_ins_updEmpTransferHistoryBySevaarthId]
	@DDO_Code NVARCHAR(10)
	,@Sevaarth_Id NVARCHAR(15)
	,@VDate	 DATETIME
	,@Result INT  OUTPUT
--***********************************************************
--***
--*** Created On 25 Jan 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)			
			
	--[1].  Update Employee transfer History
	DECLARE @GetDate	DATETIME
			,@Status NVARCHAR(1)
			,@SystemEndDate DATETIME			
			,@RowCnt INT

	SET @GetDate=GETDATE();
	SET @SystemEndDate=(Select [dbo].[fn_GetSystemEndDate]());

	--[1.] Check emp entry not present then Insert new entry and Return	
	IF NOT EXISTS (SELECT * FROM [dbo].[TDS_t_EmpTransfer_History] WHERE Sevaarth_Id=@Sevaarth_Id)
	BEGIN
	   /* Insert new record */
		INSERT INTO [dbo].[TDS_t_EmpTransfer_History]
		(
		    Sevaarth_Id,
		    CurDDO_Code,
		    ExtDDO_Code,
		    ValidFrom,
		    ValidTo,
		    Transfer_Date,
		    Status
		)
		VALUES
		(
		    @Sevaarth_Id,
		    @DDO_Code,
		    NULL,
		    @VDate,
		    @SystemEndDate,
		    NULL,
		    'Y'
		);

		IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error while inserting new transfer record.'
			GOTO spError
		END

		SET @Result=1;

		RETURN(0)	
	END	

	--[2.]  Updating record based on Voucher Date	   
	IF OBJECT_ID('tempdb..#ExistingHistory') IS NOT NULL
		DROP TABLE #ExistingHistory

	CREATE TABLE #ExistingHistory(
			Transfer_Id			int,
			Sevaarth_Id			nvarchar(15) NOT NULL,
			DDO_Code			nvarchar(11) NULL,
			PreValidFrom		date		 NULL,
			PreValidTo			date		 NULL,
			ValidFrom			date		 NULL,
			ValidTo				date         NULL,
			NextValidFrom		date		 NULL,
			NextValidTo			date         NULL)
	
	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	INSERT INTO #ExistingHistory(Transfer_Id,
								 Sevaarth_Id,		
								 DDO_Code,			
								 PreValidFrom,	
								 PreValidTo,		
								 ValidFrom,		
								 ValidTo,			
								 NextValidFrom,	
								 NextValidTo)
						SELECT  Transfer_Id,
								Sevaarth_Id,
							    CurDDO_Code,
								LAG(ValidFrom) OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS PreviousRecordStartDate,
								LAG(ValidTo) OVER (PARTITION BY Sevaarth_Id ORDER BY ValidTo ASC) AS PreviousRecordEndDate,
								ValidFrom,
								ValidTo,
								LEAD(ValidFrom) OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS NextRecordStartDate,
								LEAD(ValidTo) OVER (PARTITION BY Sevaarth_Id ORDER BY ValidTo ASC) AS NextRecordEndDate
						FROM  [dbo].[TDS_t_EmpTransfer_History]
						Where Sevaarth_Id=@Sevaarth_Id
						ORDER BY ValidTo ASC;

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while getting employee extsing history.'
		GOTO spError
	END
	
	DECLARE @Transfer_Id			INT,
			@tmpSevaarth_Id			nvarchar(15),
			@tmpDDO_Code			nvarchar(11),			
			@tmpPreValidTo			date,	
			@tmpValidFrom			date,	
			@tmpValidTo				date ,  
			@tmpNextValidFrom		date

	Select @Transfer_Id=Transfer_Id,
		   @tmpDDO_Code=DDO_Code,
		   @tmpPreValidTo=PreValidTo,
		   @tmpValidFrom=ValidFrom,
		   @tmpValidTo=ValidTo,
		   @tmpNextValidFrom=NextValidFrom
	FROM #ExistingHistory WHERE DDO_Code=@DDO_Code AND ((@VDate BETWEEN ValidFrom AND ValidTo) 
							 OR (ValidFrom>@VDate AND (PreValidTo<@VDate OR PreValidTo IS NUll)))

	IF @Transfer_Id=0 OR @Transfer_Id IS NULL
	BEGIN
		Select @Transfer_Id=Transfer_Id,
		   @tmpDDO_Code=DDO_Code,
		   @tmpPreValidTo=PreValidTo,
		   @tmpValidFrom=ValidFrom,
		   @tmpValidTo=ValidTo,
		   @tmpNextValidFrom=NextValidFrom
		FROM #ExistingHistory WHERE DDO_Code=@DDO_Code AND ((@VDate BETWEEN ValidFrom AND ValidTo) 
							 OR (ValidTo < @VDate AND (NextValidFrom>@VDate OR NextValidFrom IS NUll)))
	END
	
	IF @Transfer_Id=0 OR @Transfer_Id IS NULL
	BEGIN
		Select @Transfer_Id=Transfer_Id,
			   @tmpDDO_Code=DDO_Code,
			   @tmpPreValidTo=PreValidTo,
			   @tmpValidFrom=ValidFrom,
			   @tmpValidTo=ValidTo,
			   @tmpNextValidFrom=NextValidFrom
		FROM #ExistingHistory WHERE ((@VDate BETWEEN ValidFrom AND ValidTo) 
								 OR (ValidFrom>@VDate AND (PreValidTo<@VDate OR PreValidTo IS NUll)) 
								 OR (ValidTo < @VDate AND (NextValidFrom>@VDate OR NextValidFrom IS NUll)))
	END
		
	IF @Transfer_Id<>0 AND @Transfer_Id IS NOT NULL
	BEGIN
		IF (@tmpDDO_Code=@DDO_Code)
		BEGIN
			UPDATE [dbo].[TDS_t_EmpTransfer_History] 
			SET ValidFrom=CASE WHEN ValidFrom>@VDate THEN @VDate ELSE ValidFrom END,
				ValidTo=CASE WHEN ValidTo<@VDate THEN @VDate ELSE ValidTo END
			WHERE Transfer_Id=@Transfer_Id AND CurDDO_Code=@DDO_Code

			IF  @tmpPreValidTo IS NOT NULL
			BEGIN
				UPDATE [dbo].[TDS_t_EmpTransfer_History] 
				SET ValidTo=CASE WHEN ValidTo>@VDate THEN @VDate ELSE ValidTo END
				WHERE ValidTo=@tmpPreValidTo AND Sevaarth_Id=@Sevaarth_Id
			END

			IF  @tmpNextValidFrom IS NOT NULL
			BEGIN
				UPDATE [dbo].[TDS_t_EmpTransfer_History] 
				SET ValidFrom=CASE WHEN ValidFrom<@VDate THEN @VDate ELSE ValidFrom END
				WHERE ValidFrom=@tmpNextValidFrom AND Sevaarth_Id=@Sevaarth_Id
			END

			IF(@@ERROR <> 0)
			BEGIN
				Select @ErrMsg='Error while updating employee history.'
				GOTO spError
			END
		END
		ELSE
		BEGIN
			UPDATE [dbo].[TDS_t_EmpTransfer_History] 
			SET ValidFrom=CASE WHEN ValidFrom>@VDate THEN @VDate ELSE ValidFrom END,
				ValidTo=CASE WHEN ValidTo<@VDate THEN @VDate ELSE ValidTo END
			WHERE Transfer_Id=@Transfer_Id AND CurDDO_Code=@tmpDDO_Code

			IF EXISTS (SELECT * FROM [dbo].[TDS_t_EmpTransfer_History] WHERE @DDO_Code=@DDO_Code  and ValidTo=@tmpPreValidTo)
			BEGIN
			     Update [dbo].[TDS_t_EmpTransfer_History]
				 SET ValidFrom=CASE WHEN ValidFrom>@VDate THEN @VDate ELSE ValidFrom END,
					 ValidTo=CASE WHEN @VDate > @tmpValidFrom THEN (DATEADD(DAY, -1, @tmpValidFrom)) ELSE @VDate END--CASE WHEN ValidTo>@VDate THEN @VDate ELSE ValidTo END
				 WHERE @DDO_Code=@DDO_Code  and ValidTo=@tmpPreValidTo	
			END
			ELSE
			BEGIN
				/* Insert new record */
				INSERT INTO [dbo].[TDS_t_EmpTransfer_History]
				(
				    Sevaarth_Id,
				    CurDDO_Code,
				    ExtDDO_Code,
				    ValidFrom,
				    ValidTo,
				    Transfer_Date,
				    Status
				)
				VALUES
				(
				    @Sevaarth_Id,
				    @DDO_Code,
				    NULL,
				    --@VDate,
					CASE WHEN (@VDate >= @tmpValidFrom AND @tmpValidTo<>@SystemEndDate) THEN (DATEADD(DAY, -2, @tmpValidFrom)) ELSE @VDate END,
				    CASE WHEN (Select Max(ValidFrom) From [dbo].[TDS_t_EmpTransfer_History] where Sevaarth_Id=@Sevaarth_Id)>@VDate 
						 THEN  CASE WHEN (DATEADD(MONTH, 1, @VDate)) > @tmpValidFrom THEN (DATEADD(DAY, -1, @tmpValidFrom)) ELSE (DATEADD(MONTH, 1, @VDate)) END
						 ELSE @SystemEndDate END,
				    NULL,
				    'Y'
				);
			END

			IF(@@ERROR <> 0)
			BEGIN
				Select @ErrMsg='Error while updating/inserting existing transfer history.'
				GOTO spError
			END
		END
	END

	SET @Status=1;

	RETURN(0)
spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_ins_updEmpTransferHistoryBySevaarthId: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Result=0;

	RETURN(-1)
END