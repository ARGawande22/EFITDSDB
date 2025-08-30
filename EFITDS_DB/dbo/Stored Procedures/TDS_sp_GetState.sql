
Create   Procedure [dbo].[TDS_sp_GetState]
      @CountryId int=Null
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

	--Get State Information
	IF @CountryId <> 0
	BEGIN
	    Select 
	    	s.State_Id,
	    	s.Country_Id,
			s.StateCode,
			s.StateCode_AsperGST,
	    	s.StateName
	    FROM [dbo].[TDS_t_States] s with(nolock)
	    Where s.Country_Id=@CountryId and s.[Status]='Y'

		IF(@@ROWCOUNT=0)
	      BEGIN
		    Select @ErrMsg='TDS_sp_GetState: State not available for Country ID :'+ Convert(nvarchar,@CountryId)
		  GOTO spError
	    END
    END
	ELSE
	BEGIN
		Select 
			s.State_Id,
	    	s.Country_Id,
			s.StateCode,
			s.StateCode_AsperGST,
	    	s.StateName
	    FROM [dbo].[TDS_t_States] s with(nolock)
		Where s.[Status]='Y'

		IF(@@ROWCOUNT=0)
	      BEGIN
		    Select @ErrMsg='TDS_sp_GetCity: Error Getting States.'
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