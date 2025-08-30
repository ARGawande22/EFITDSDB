
Create   Procedure [dbo].[TDS_sp_GetCity]
      @StateId int=Null
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

	--Get City Information
	IF @StateId <> 0
	BEGIN
	    Select 
	    	c.City_Id,
	    	c.State_Id,
	    	c.CityName
	    FROM [dbo].[TDS_t_City] c with(nolock)
	    Where c.State_Id=@StateId and c.[Status]='Y'

		IF(@@ROWCOUNT=0)
	      BEGIN
		    Select @ErrMsg='TDS_sp_GetCity: Cities not available for state ID :'+ Convert(nvarchar,@StateId)
		  GOTO spError
	    END
    END
	ELSE
	BEGIN
		Select 
			c.City_Id,
	    	c.State_Id,
	    	c.CityName
	    FROM [dbo].[TDS_t_City] c with(nolock)
		Where c.[Status]='Y'

		IF(@@ROWCOUNT=0)
	      BEGIN
		    Select @ErrMsg='TDS_sp_GetCity: Error Getting Cities.'
		  GOTO spError
	    END
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