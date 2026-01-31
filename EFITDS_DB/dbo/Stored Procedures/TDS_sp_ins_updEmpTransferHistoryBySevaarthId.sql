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
			,@Transfer_Id INT
			,@SystemEndDate DATETIME
			,@ValidFrom  DATETIME
			,@ValidTo    DATETIME
			,@RowCnt INT

	SET @GetDate=GETDATE();
	SET @SystemEndDate=(Select [dbo].[fn_GetSystemEndDate]());
	
	/*  Find matching effective row */
    SET @Transfer_Id=(SELECT dbo.fn_GetTransferId(@Sevaarth_Id, @VDate,@DDO_Code));			
    
	/*  If matching record exists → UPDATE */
    IF @Transfer_Id IS NOT NULL
    BEGIN
		SELECT 
			 @ValidFrom=ValidFrom,
			 @ValidTo=ValidTo
		FROM TDS_t_EmpTransfer_History 
		WHERE Transfer_Id=@Transfer_Id

        IF @VDate <= @ValidFrom
        BEGIN
            -- Scenario 2, 4, 6, 8
            UPDATE TDS_t_EmpTransfer_History
            SET ValidFrom = CASE WHEN ValidFrom < @VDate THEN ValidFrom ELSE @VDate END
            WHERE Transfer_Id = @Transfer_Id;
        END
        ELSE
        BEGIN
            -- Scenario 3, 5, 7
            UPDATE TDS_t_EmpTransfer_History
            SET ValidTo = CASE WHEN ValidTo > @VDate THEN ValidTo ELSE @VDate END
            WHERE Transfer_Id = @Transfer_Id;
        END

		IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error while updating the Transfer details.'
			GOTO spError
		END

		SET @Result=1;

        RETURN(0)
    END

	/*  No matching row → close active row */
    UPDATE TDS_t_EmpTransfer_History
    SET ValidTo = DATEADD(DAY, -1, @VDate)
    WHERE Sevaarth_Id = @Sevaarth_Id
	  AND ValidFrom < @VDate
      AND ValidTo = @SystemEndDate;

	  SET @RowCnt=@@ROWCOUNT;

    /* Insert new record */
    INSERT INTO TDS_t_EmpTransfer_History
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
        CASE WHEN @RowCnt>0 THEN @SystemEndDate ELSE DATEADD(MONTH, 1, @VDate) END,
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
spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_ins_updEmpTransferHistoryBySevaarthId: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Result=0;

	RETURN(-1)
END