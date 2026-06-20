
Create   Procedure [dbo].[TDS_sp_GetYearlyChartRefHeaders]
	@Header_Id int=0

--***********************************************************
--***
--*** Created On 18 Apr 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status Char(1)

	IF @Header_Id is null
	BEGIN
	   Select @ErrMsg='TDS_sp_GetYearlyChartRefHeaders: Header id parameter is required.'
	   GOTO spError
	END

	--Get Sevaarth Sub Header Information
	    Select
			ych.Header_Id,			
			ycrh.Ref_Id,			
			ycrh.Ref_HeaderId,
			ycrh.Ref_EstimateHeaderId,
			ycrh.Ref_MainHeader_Name,
			ycrh.IsIncludeCalSheet,
			ycrh.Status
		FROM [dbo].[TDS_t_YearlyChart_Headers] ych with(nolock)
			RIGHT JOIN [dbo].[TDS_t_YearlyChart_RefHeaders] ycrh with(nolock) ON ych.Header_Id=ycrh.Header_Id
		WHERE (@Header_Id=0 OR ych.Header_Id=@Header_Id)
		ORDER BY ycrh.Ref_Id

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END