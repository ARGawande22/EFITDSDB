
Create   Procedure [dbo].[TDS_sp_GetConfigParam]

--***********************************************************
--***
--*** Created On 07 May 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)
	
	--Get Configuration Parameter Information	
	Select
		cp.[Config_Id],
		cp.[KeyName],
		cp.[Value]			
	FROM [dbo].[TDS_t_ConfigurationParameter] cp with(nolock)
	WHERE cp.Status='Y'
	ORDER BY cp.Config_Id
	  
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END