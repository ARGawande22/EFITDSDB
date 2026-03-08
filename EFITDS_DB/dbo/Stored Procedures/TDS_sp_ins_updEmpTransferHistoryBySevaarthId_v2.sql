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
/*PURPOSE:
       Inserts or updates an employee's DDO transfer history
       so that the record for @DDO_Code correctly covers @VDate,
       without creating overlaps or gaps between history rows.

     PARAMETERS:
       @DDO_Code    - The DDO office code being processed
       @Sevaarth_Id - Employee unique ID
       @VDate       - Voucher / transaction date
       @Result      - OUTPUT: 1=success, 0=no matching record, -1=error

     CHANGE LOG:
       v2.0  - Rewrote with TRY/CATCH, transaction safety,
               fixed WHERE clause bug, removed arbitrary date offsets,
               added overlap/gap prevention.
 */
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg         NVARCHAR(500)
           ,@SystemEndDate  DATETIME
           ,@GetDate        DATETIME

           -- Matched record fields
           ,@Transfer_Id        INT
		   ,@tmpSevaarth_Id		nvarchar(15)
           ,@tmpDDO_Code        NVARCHAR(11)
		   ,@tmpPreTransfer_Id  INT
		   ,@tmpPreDDO_Code     NVARCHAR(11)
           ,@tmpPreValidTo      DATE
           ,@tmpValidFrom       DATE
           ,@tmpValidTo         DATE
		   ,@tmpNextTransfer_Id INT
		   ,@tmpNextDDO_Code    NVARCHAR(11)
           ,@tmpNextValidFrom   DATE

    SET @GetDate       = GETDATE();
    SET @SystemEndDate = (SELECT [dbo].[fn_GetSystemEndDate]());
    SET @Result        = 0;

	BEGIN TRY
		BEGIN TRANSACTION;

	-- [1] No history at all for this employee → Insert fresh row
		 IF NOT EXISTS (SELECT 1
            FROM [dbo].[TDS_t_EmpTransfer_History]
            WHERE Sevaarth_Id = @Sevaarth_Id)
		 BEGIN
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

            SET @Result = 1;
            COMMIT TRANSACTION;
            RETURN;   -- Nothing more to do for a brand-new employee
         END

	-- [2] Build sliding window temp table using LAG / LEAD.So, we can see Previous / Current / Next rows together
		IF OBJECT_ID('tempdb..#ExistingHistory') IS NOT NULL
            DROP TABLE #ExistingHistory;

        CREATE TABLE #ExistingHistory
        (
            Transfer_Id     INT,
            Sevaarth_Id     NVARCHAR(15)    NOT NULL,
            DDO_Code        NVARCHAR(11)    NULL,
            PreTransferId   INT            NULL,	-- previous row TransferId
			PreDDO_Code     NVARCHAR(11)    NULL,	-- previous row DDOCode
            PreValidTo      DATE            NULL,   -- previous row ValidTo
            ValidFrom       DATE            NULL,   -- this row ValidFrom
            ValidTo         DATE            NULL,   -- this row ValidTo
			NextTransferId   INT            NULL,	-- Next row TransferId
			NextDDO_Code     NVARCHAR(11)    NULL,	-- Next row DDOCode
            NextValidFrom   DATE            NULL   -- next row ValidFrom            
        );

        INSERT INTO #ExistingHistory
        (	Transfer_Id,
			Sevaarth_Id,
			DDO_Code,
            PreTransferId,
			PreDDO_Code,
			PreValidTo,
            ValidFrom,
			ValidTo,
			NextTransferId,
			NextDDO_Code,
            NextValidFrom			
        )
        SELECT
            Transfer_Id,
            Sevaarth_Id,
            CurDDO_Code,
            LAG(Transfer_Id)   OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS PreTransfer_Id,
			LAG(CurDDO_Code)   OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS PreDDO_Code,    
            LAG(ValidTo)    OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS PreValidTo,
            ValidFrom,
            ValidTo,
			LEAD(Transfer_Id)  OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS NextTransfer_Id,
			LEAD(CurDDO_Code)  OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS NextDDO_Code,    
            LEAD(ValidFrom) OVER (PARTITION BY Sevaarth_Id ORDER BY ValidFrom ASC) AS NextValidFrom            
        FROM  [dbo].[TDS_t_EmpTransfer_History]
        WHERE Sevaarth_Id = @Sevaarth_Id
        ORDER BY ValidFrom ASC;


	-- ******************************************************************
    -- [3] Locate the best matching row for @VDate
	--
    --   Priority order:
    --     P1 → Same DDO, @VDate falls inside this row's range
	--     P2 → Same DDO, @VDate is before this row but after previous row
	--     P3 → Same DDO, @VDate is after this row but before next row
	--     P4 → Any DDO  (broadest fallback, same date logic as P1-P3)
	-- ******************************************************************

	-- P1: @VDate inside the row
        SELECT TOP 1
            @Transfer_Id      = Transfer_Id,
            @tmpDDO_Code      = DDO_Code,
			@tmpPreTransfer_Id= PreTransferId,
			@tmpPreDDO_Code=PreDDO_Code,
            @tmpPreValidTo    = PreValidTo,
            @tmpValidFrom     = ValidFrom,
            @tmpValidTo       = ValidTo,
			@tmpNextTransfer_Id= NextTransferId,
			@tmpNextDDO_Code=NextDDO_Code,
            @tmpNextValidFrom = NextValidFrom
        FROM #ExistingHistory
        WHERE DDO_Code = @DDO_Code
          AND @VDate BETWEEN ValidFrom AND ValidTo;
 
		 IF @Transfer_Id>0 AND @Transfer_Id IS Not NULL
		 BEGIN
			SET @Result = 1;
            COMMIT TRANSACTION;
            RETURN;
		 END


	-- P2: Same DDO, @VDate is before ValidFrom but after previous row ended
        SELECT TOP 1
               @Transfer_Id      = Transfer_Id,
			@tmpDDO_Code      = DDO_Code,
			@tmpPreTransfer_Id= PreTransferId,
			@tmpPreDDO_Code=PreDDO_Code,
			@tmpPreValidTo    = PreValidTo,
			@tmpValidFrom     = ValidFrom,
			@tmpValidTo       = ValidTo,
			@tmpNextTransfer_Id= NextTransferId,
			@tmpNextDDO_Code=NextDDO_Code,
			@tmpNextValidFrom = NextValidFrom
        FROM #ExistingHistory
        WHERE DDO_Code = @DDO_Code
          AND ValidFrom > @VDate
          AND (PreValidTo < @VDate OR PreValidTo IS NULL)
        ORDER BY ValidFrom ASC;  -- take the closest future row       

		 IF @Transfer_Id>0 AND @Transfer_Id IS Not NULL
		 BEGIN			 
			  UPDATE [dbo].[TDS_t_EmpTransfer_History]
              SET
                  ValidFrom = CASE WHEN ValidFrom > @VDate THEN @VDate ELSE ValidFrom END                  
              WHERE Transfer_Id  = @Transfer_Id
              AND CurDDO_Code  = @DDO_Code;

			   IF @tmpPreValidTo IS NOT NULL AND @tmpPreValidTo=@VDate  
			   BEGIN
					UPDATE [dbo].[TDS_t_EmpTransfer_History]
					SET ValidTo = DATEADD(DAY, -1, @VDate)                                  
					WHERE Sevaarth_Id = @Sevaarth_Id
							AND ValidTo     = @tmpPreValidTo
							AND Transfer_Id=@tmpPreTransfer_Id
			   END

			SET @Result = 1;
            COMMIT TRANSACTION;
            RETURN;
		 END

	-- P3: Same DDO, @VDate is after ValidTo but before next row starts
        SELECT TOP 1
            @Transfer_Id      = Transfer_Id,
			@tmpDDO_Code      = DDO_Code,
			@tmpPreTransfer_Id= PreTransferId,
			@tmpPreDDO_Code=PreDDO_Code,
			@tmpPreValidTo    = PreValidTo,
			@tmpValidFrom     = ValidFrom,
			@tmpValidTo       = ValidTo,
			@tmpNextTransfer_Id= NextTransferId,
			@tmpNextDDO_Code=NextDDO_Code,
			@tmpNextValidFrom = NextValidFrom
         FROM #ExistingHistory
         WHERE DDO_Code = @DDO_Code
           AND ValidTo < @VDate
           AND (NextValidFrom > @VDate OR NextValidFrom IS NULL)
         ORDER BY ValidTo DESC;  -- take the most recent past row
       
	   IF @Transfer_Id>0 AND @Transfer_Id IS Not NULL
		 BEGIN			 
			  UPDATE [dbo].[TDS_t_EmpTransfer_History]
              SET
                  ValidTo   = CASE WHEN ValidTo   < @VDate THEN @VDate ELSE ValidTo   END                 
              WHERE Transfer_Id  = @Transfer_Id
              AND CurDDO_Code  = @DDO_Code;

			   IF @tmpNextValidFrom IS NOT NULL AND @tmpNextValidFrom=@VDate  
			   BEGIN
					UPDATE [dbo].[TDS_t_EmpTransfer_History]
					SET ValidFrom = DATEADD(DAY, 1, @VDate)                                  
					WHERE Sevaarth_Id = @Sevaarth_Id
							AND ValidFrom     = @tmpNextValidFrom
							AND Transfer_Id=@tmpNextTransfer_Id
			   END

			SET @Result = 1;
            COMMIT TRANSACTION;
            RETURN;
		 END


		 -- P4: Fallback – any DDO, best date match        
         SELECT TOP 1
            @Transfer_Id      = Transfer_Id,
			@tmpDDO_Code      = DDO_Code,
			@tmpPreTransfer_Id= PreTransferId,
			@tmpPreDDO_Code=PreDDO_Code,
			@tmpPreValidTo    = PreValidTo,
			@tmpValidFrom     = ValidFrom,
			@tmpValidTo       = ValidTo,
			@tmpNextTransfer_Id= NextTransferId,
			@tmpNextDDO_Code=NextDDO_Code,
			@tmpNextValidFrom = NextValidFrom
         FROM #ExistingHistory
         WHERE @VDate BETWEEN ValidFrom AND ValidTo
            OR (ValidFrom > @VDate AND (PreValidTo < @VDate OR PreValidTo IS NULL))
            OR (ValidTo   < @VDate AND (NextValidFrom > @VDate OR NextValidFrom IS NULL))
         ORDER BY
             -- Prefer the row whose range is closest to @VDate
             ABS(DATEDIFF(DAY, ValidFrom, @VDate)) ASC;      
	  
		IF @Transfer_Id>0 AND @Transfer_Id IS Not NULL
		BEGIN	
			IF @tmpDDO_Code<>@DDO_Code AND @VDate BETWEEN @tmpValidFrom AND @tmpValidTo
			BEGIN
				UPDATE [dbo].[TDS_t_EmpTransfer_History]
				SET
					--ValidFrom = CASE WHEN ValidFrom > @VDate THEN @VDate ELSE ValidFrom END,   
				    ValidTo   = CASE WHEN ValidTo   > @VDate THEN DATEADD(DAY, -1, @VDate)    ELSE ValidTo   END                 
				WHERE Transfer_Id  = @Transfer_Id
				AND CurDDO_Code  = @tmpDDO_Code;


				IF @tmpNextDDO_Code<>@DDO_Code
				BEGIN
					INSERT INTO [dbo].[TDS_t_EmpTransfer_History]
					(
					    Sevaarth_Id, CurDDO_Code, ExtDDO_Code,
					    ValidFrom, ValidTo, Transfer_Date, Status
					)
					VALUES
					(
					    @Sevaarth_Id,
					    @DDO_Code,
					    NULL,
					    @VDate,
					    DATEADD(DAY, -1, @tmpNextValidFrom),
					    NULL,
					    'Y'
					);
				END				
			END

			ELSE IF @tmpDDO_Code<>@DDO_Code AND @tmpValidFrom > @VDate AND (@tmpPreValidTo < @VDate OR @tmpPreValidTo IS NULL)
			BEGIN
				IF(@tmpPreDDO_Code=@DDO_Code)
				BEGIN
					UPDATE [dbo].[TDS_t_EmpTransfer_History]
					SET
						ValidTo   = CASE WHEN ValidTo   > @VDate THEN DATEADD(DAY, -1, @VDate)   ELSE ValidTo   END                 
					WHERE Transfer_Id  = @tmpPreTransfer_Id
					AND CurDDO_Code  = @tmpPreDDO_Code;
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].[TDS_t_EmpTransfer_History]
					(
					    Sevaarth_Id, CurDDO_Code, ExtDDO_Code,
					    ValidFrom, ValidTo, Transfer_Date, Status
					)
					VALUES
					(
					    @Sevaarth_Id,
					    @DDO_Code,
					    NULL,
					    CASE WHEN @tmpPreValidTo Is NULL THEN @VDate ELSE DATEADD(DAY, 1, @tmpPreValidTo) END,
					    DATEADD(DAY, -1, @tmpValidFrom),
					    NULL,
					    'Y'
					);
				END
			END

			ELSE IF @tmpDDO_Code<>@DDO_Code AND @tmpValidTo < @VDate AND (@tmpNextValidFrom > @VDate OR @tmpNextValidFrom IS NULL)
			BEGIN
				IF(@tmpNextDDO_Code=@DDO_Code)
				BEGIN
					UPDATE [dbo].[TDS_t_EmpTransfer_History]
					SET
						ValidFrom   = CASE WHEN ValidFrom   > @VDate THEN @VDate   ELSE ValidFrom   END                    
					WHERE Transfer_Id  = @tmpNextTransfer_Id
					AND CurDDO_Code  = @tmpNextDDO_Code;
				END
				ELSE
				BEGIN
					IF @tmpNextDDO_Code IS NULL AND @tmpValidTo=@SystemEndDate
					BEGIN 
						UPDATE [dbo].[TDS_t_EmpTransfer_History]
						SET
							ValidTo   =   DATEADD(DAY, -1, @VDate)                    
						WHERE Transfer_Id  = @Transfer_Id
						AND CurDDO_Code  = @tmpDDO_Code;
					END

					INSERT INTO [dbo].[TDS_t_EmpTransfer_History]
					(
					    Sevaarth_Id, CurDDO_Code, ExtDDO_Code,
					    ValidFrom, ValidTo, Transfer_Date, Status
					)
					VALUES
					(
					    @Sevaarth_Id,
					    @DDO_Code,
					    NULL,
					    CASE WHEN @tmpValidTo=@SystemEndDate THEN @VDate ELSE DATEADD(DAY, 1, @tmpValidTo) END,
					   CASE WHEN @tmpNextValidFrom IS NULL THEN @SystemEndDate ELSE DATEADD(DAY, -1, @tmpNextValidFrom) END,
					    NULL,
					    'Y'
					);
				END
			END

			SET @Result = 1;
			COMMIT TRANSACTION;
			RETURN;
		END

		IF @Transfer_Id=0 OR @Transfer_Id IS NULL 
        BEGIN
            INSERT INTO [dbo].[TDS_t_EmpTransfer_History]
            (
                Sevaarth_Id, CurDDO_Code, ExtDDO_Code,
                ValidFrom, ValidTo, Transfer_Date, Status
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

            SET @Result = 1;            
        END

		COMMIT TRANSACTION;
        RETURN;

	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @Result = -1;

        -- Re-raise error with full detail
        DECLARE @ErrNum     INT            = ERROR_NUMBER()
               ,@ErrSev     INT            = ERROR_SEVERITY()
               ,@ErrState   INT            = ERROR_STATE()
               ,@ErrProc    NVARCHAR(200)  = ERROR_PROCEDURE()
               ,@ErrLine    INT            = ERROR_LINE()
               ,@ErrMessage NVARCHAR(2048) = ERROR_MESSAGE();

        RAISERROR(
            N'Error in %s (Line %d): [%d] %s',
            @ErrSev,
            @ErrState,
            @ErrProc,
            @ErrLine,
            @ErrNum,
            @ErrMessage
        );
    END CATCH

END