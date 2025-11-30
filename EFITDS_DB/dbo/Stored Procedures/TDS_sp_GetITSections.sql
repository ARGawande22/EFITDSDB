
Create   Procedure [dbo].[TDS_sp_GetITSections]

--***********************************************************
--***
--*** Created On 30 Nov 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)
	
	--Get IT Sections
	Select
		s.Section_Id,
		s.Section,
		s.Status
	FROM [dbo].[TDS_t_ITSection] s with(nolock)
	ORDER BY s.Section_Id
	  
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END