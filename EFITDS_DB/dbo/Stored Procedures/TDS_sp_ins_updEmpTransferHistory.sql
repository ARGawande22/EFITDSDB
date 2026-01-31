USE TDSLive
GO

Create   Procedure [dbo].[TDS_sp_ins_updEmpTransferHistory]
	@EmpHistory [dbo].[EmpTransfer] READONLY
	,@Status INT  OUTPUT
--***********************************************************
--***
--*** Created On 18 Jan 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)			
			
--[1].  Update Employee transfer History
	DECLARE @DDO_Code	 NVARCHAR(10)
			,@Sevaarth_Id  NVARCHAR(15)
			,@MinDate	 DATETIME
			,@MaxDate	 DATETIME			
			,@Transfer_Id INT
			,@ValidFrom DATETIME
			,@ValidTo DATETIME
			,@Transfer_Date DATETIME

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT Sevaarth_Id,DDO_Code,MinDate,MaxDate FROM @EmpHistory ORDER BY MinDate ASC
	OPEN K
		FETCH NEXT FROM K INTO @Sevaarth_Id,@DDO_Code,@MinDate,@MaxDate	
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				SELECT @Transfer_Id=Transfer_Id --,@ValidFrom=ValidFrom,@ValidTo=ValidTo,@Transfer_Date=Transfer_Date
				FROM [dbo].[TDS_t_EmpTransfer_History]
				WHERE Sevaarth_Id=@Sevaarth_Id AND CurDDO_Code=@DDO_Code

				IF(@Transfer_Id IS NULL OR @Transfer_Id <=0)
				BEGIN
					INSERT INTO [dbo].[TDS_t_EmpTransfer_History](Sevaarth_Id,CurDDO_Code,ExtDDO_Code,ValidFrom,ValidTo,Transfer_Date,Status)
					VALUES(@Sevaarth_Id,@DDO_Code,NULL,@MinDate,@MaxDate,@MaxDate,'Y')
				END
				ELSE
				BEGIN
					UPDATE e
					SET e.ValidFrom=CASE WHEN e.ValidFrom<@MinDate THEN e.ValidFrom ELSE @MinDate END
						,e.ValidTo=CASE WHEN e.ValidTo> @MaxDate THEN e.ValidTo ELSE @MaxDate END
						,e.Transfer_Date=CASE WHEN e.Transfer_Date> @MaxDate THEN e.Transfer_Date ELSE @MaxDate  END
						,e.[Status]='Y'
					FROM [dbo].[TDS_t_EmpTransfer_History] e
					WHERE Transfer_Id=@Transfer_Id
				END
			END
			FETCH NEXT FROM K INTO @Sevaarth_Id,@DDO_Code,@MinDate,@MaxDate
		END
	CLOSE K
	DEALLOCATE K

	SET @Status=1;

	RETURN(0)	   	 
spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_ins_updEmpTransferHistory: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Status=0;

	RETURN(-1)
END