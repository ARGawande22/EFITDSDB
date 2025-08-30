
Create   Procedure [dbo].[TDS_sp_GetCountry]
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

	--Get country Information	
	Select 
		c.Country_Id,
	   	c.CountryCode,
		c.CountryName
	   FROM [dbo].[TDS_t_Country] c with(nolock)
	Where c.[Status]='Y'

	IF(@@ROWCOUNT=0)
	BEGIN
	  Select @ErrMsg='TDS_sp_GetCountry: Error Getting Cities.'
	  GOTO spError
	END    

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END