
Create   Procedure [dbo].[TDS_sp_GetDeductorTypes]
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

	--Get Deductor Type Information	
	Select 
		d.[Type_Id],
	   	d.[Type]
	   FROM [dbo].[TDS_t_DeductorTypes] d with(nolock)
	Where d.[Status]='Y'

	IF(@@ROWCOUNT=0)
	BEGIN
	  Select @ErrMsg='TDS_sp_GetDeductorTypes: Error Getting Deductor Type.'
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