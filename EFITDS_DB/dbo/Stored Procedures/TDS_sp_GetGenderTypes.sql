
Create   Procedure [dbo].[TDS_sp_GetGenderTypes]
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

	--Get Gender Information	
	Select 
		g.[Gender_Id],
	   	g.[Gender]
	   FROM [dbo].[TDS_t_Gender] g with(nolock)
	Where g.[Status]='Y'

	IF(@@ROWCOUNT=0)
	BEGIN
	  Select @ErrMsg='TDS_sp_GetGenderTypes: Error Getting Genders.'
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