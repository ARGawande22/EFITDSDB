Use TDSLive
GO

Create   Procedure [dbo].[TDS_sp_SaveUpd_Year]
	@YearId			INT,
	@Fin_Year		VARCHAR(10),
	@ITR_DueDate	Datetime=NULL,
	@Lock_Date		Datetime=NULL,
	@RPUPath		VARCHAR(255)=NULL,
	@RPUName		VARCHAR(255)=NULL,
	@RPUWinName		VARCHAR(255)=NULL,
	@Status			VARCHAR(1)='Y',
	@loginId		INT,
	@Result			INT OUTPUT

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

	DECLARE @ErrMsg		NVARCHAR(255),
			@GetDate	Datetime,
			@OrderSeq	INT

	SET @GetDate=GETDATE()

	--Check if any inserted from Kshwahini
	  IF(@YearId=0 OR @YearId Is NULL)
	  BEGIN
	     SELECT @YearId=Year_Id
		 FROM [dbo].[TDS_t_Year]
		 WHERE Fin_Year=@Fin_Year
	   END


	IF(@YearId<=0 OR @YearId Is Null)
	BEGIN
	SET @OrderSeq= (SELECT MAX(OrderSeq) FROM [dbo].[TDS_t_Year])+1

		INSERT INTO [dbo].[TDS_t_Year](
						[OrderSeq],
						[Fin_Year],
						[ITR_DueDate],
						[Lock_Date],
						[RPUPath],
						[RPUName],
						[RPUWinName],
						[Status])
			     VALUES(@OrderSeq,
						@Fin_Year,
						@ITR_DueDate,
						@Lock_Date,
						@RPUPath,
						@RPUName,
						@RPUWinName,
						'N')

			IF(@@ERROR <> 0 OR @@IDENTITY=0)
			BEGIN
				Select @ErrMsg='Error inserting year details'
				GOTO spError
			END

			SET @YearId=@@IDENTITY;
	END
	ELSE
	BEGIN
		UPDATE [dbo].[TDS_t_Year]
		SET [Fin_Year]=@Fin_Year,
			[ITR_DueDate]=@ITR_DueDate,
			[Lock_Date]=@Lock_Date,			
			[RPUPath]=@RPUPath,
			[RPUName]=@RPUName,
			[RPUWinName]=@RPUWinName
		WHERE Year_Id=@YearId
	END

	SET NOCOUNT OFF

	SET @Result=1
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_SaveUpd_Year: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	SET @Result=0
	RETURN(-1)
END