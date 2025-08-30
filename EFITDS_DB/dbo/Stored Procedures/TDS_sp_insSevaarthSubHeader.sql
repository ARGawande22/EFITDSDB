
Create   Procedure [dbo].[TDS_sp_insSevaarthSubHeader]
	@HeaderId INT
	,@Headername NVARCHAR(255)
	,@DetailId INT  OUTPUT
--***********************************************************
--***
--*** Created On 18 Apr 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),			
			@rc			SMALLINT,
		    @Did INT

	--[1]. Check the Is sevaarth Sub head is present or not 
	SELECT @Did=Details_Id FROM [dbo].[TDS_t_HeadersDetails] Where DetailHeader_Name=@Headername

	--[2]. Insert New Sevaarth Sub Head
	IF @Did=0 OR @Did Is NULL
	BEGIN
		INSERT INTO [dbo].[TDS_t_HeadersDetails](
					Header_Id,
					DetailHeader_Name,
					[Status])
			Values(	@HeaderId,
					@Headername,
					'Y')

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error inserting New Sevaarth sub Head.'
			GOTO spError
		END
			
			SET @Did=@@IDENTITY;
	END

	SET @DetailId=@Did

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='save_Client: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END