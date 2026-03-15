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

	DECLARE @ErrMsg		NVARCHAR(255),
			@rc			SMALLINT
			
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
				EXEC [dbo].[TDS_sp_ins_updEmpTransferHistoryBySevaarthId] @DDO_Code=@DDO_Code,@Sevaarth_Id=@Sevaarth_Id,@VDate=@MinDate,@Result=@rc OUTPUT

				EXEC [dbo].[TDS_sp_ins_updEmpTransferHistoryBySevaarthId] @DDO_Code=@DDO_Code,@Sevaarth_Id=@Sevaarth_Id,@VDate=@MaxDate,@Result=@rc OUTPUT
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