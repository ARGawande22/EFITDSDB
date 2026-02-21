Use TDSLive
GO

Create   Procedure [dbo].[TDS_sp_SaveUpd_ConfigParam]
	@Config_Id			INT,
	@KeyName		VARCHAR(50),
	@KeyValue		VARCHAR(max),
	@Encript		INT,
	@Status			VARCHAR(1)='Y',
	@Id				INT OUTPUT

--***********************************************************
--***
--*** Created On 21 Feb 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),
			@GetDate	Datetime

	SET @GetDate=GETDATE()

	--Check if any inserted from Kshwahini
	  IF(@Config_Id=0 OR @Config_Id Is NULL)
	  BEGIN
	     SELECT @Config_Id=Config_Id
		 FROM [dbo].[TDS_t_ConfigurationParameter]
		 WHERE KeyName=@KeyName
	   END


	IF(@Config_Id<=0 OR @Config_Id Is Null)
	BEGIN	
		INSERT INTO [dbo].[TDS_t_ConfigurationParameter](
						[KeyName],
						[Value],
						[Encript],
						[Status])
			     VALUES(@KeyName,
						@KeyValue,
						@Encript,
						@Status)

			IF(@@ERROR <> 0 OR @@IDENTITY=0)
			BEGIN
				Select @ErrMsg='Error inserting config details'
				GOTO spError
			END

			SET @Config_Id=@@IDENTITY;
	END
	ELSE
	BEGIN
		UPDATE [dbo].[TDS_t_ConfigurationParameter]
		SET [Value]=@KeyValue,
			[Encript]=@Encript,
			[Status]=@Status
		WHERE Config_Id=@Config_Id
	END

	SET NOCOUNT OFF

	SET @Id=@Config_Id
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_SaveUpd_ConfigParam: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	SET @Id=0
	RETURN(-1)
END