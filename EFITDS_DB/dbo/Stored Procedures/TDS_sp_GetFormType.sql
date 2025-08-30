
Create   Procedure [dbo].[TDS_sp_GetFormType]

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
	
	--Get Quarter Information	
	Select
		f.FType_Id,
		f.FormType			
	FROM [dbo].[TDS_t_FormType] f with(nolock)
	WHERE f.Status='Y'
	ORDER BY f.OrderSeq
	  
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END