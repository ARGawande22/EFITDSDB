
Create   Procedure [dbo].[TDS_sp_GetQuarter]

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
		q.Quarter_Id,
		q.[Quarter]			
	FROM [dbo].[TDS_t_Quarter] q with(nolock)
	WHERE q.Status='Y'
	ORDER BY q.OrderSeq
	  
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END