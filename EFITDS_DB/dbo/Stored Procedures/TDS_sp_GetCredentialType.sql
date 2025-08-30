
Create   Procedure [dbo].[TDS_sp_GetCredentialType]

--***********************************************************
--***
--*** Created On 23 Dec 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)
	
	--Get Credential Types	
	Select
		c.Credential_Id,
		c.Credential_Type		
	FROM [dbo].[TDS_t_CrendetialTypes] c with(nolock)
	WHERE c.Status='Y'
	ORDER BY c.Credential_Id
	  
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END