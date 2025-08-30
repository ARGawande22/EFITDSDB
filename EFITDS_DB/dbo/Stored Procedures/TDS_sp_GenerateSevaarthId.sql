
Create   Procedure [dbo].[TDS_sp_GenerateSevaarthId]
	@TAN_No NVARCHAR(10),
	@SevaarthID NVARCHAR(15) OUTPUT

--***********************************************************
--***
--*** Created On 05 Apr 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),
			@Prefix CHAR(3)='EFI',
			@TANPrefix CHAR(4),
			@RandNo INT

	SELECT @TANPrefix=SUBSTRING(@TAN_No,1,4)

	ReGenerate:
		SELECT @RandNo=floor(1000 + RAND() * 8999)
	
	SET @SevaarthID=CONCAT(@Prefix,@TANPrefix,CONVERT(VARCHAR,@RandNo))

	IF EXISTS (SELECT * FROM [dbo].[TDS_t_Emp_Details] WHERE Sevaarth_Id=@SevaarthID)
	BEGIN
		GOTO ReGenerate
	END

	IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error generating sevaarth Id'
			GOTO spError
		END

	SET NOCOUNT OFF

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_GenerateSevaarthId: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	RETURN(-1)
END