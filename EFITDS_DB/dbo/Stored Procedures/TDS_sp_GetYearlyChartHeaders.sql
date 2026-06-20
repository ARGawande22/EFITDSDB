
Create   Procedure [dbo].[TDS_sp_GetYearlyChartHeaders]
	@Regards Nvarchar(20)=null

--***********************************************************
--***
--*** Created On 20 Jun 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status Char(1)

	--Get Yearly Chart Headers Information
	Select
			ych.Header_Id,
			ych.OrderSeq,
			ych.Regards,
			ych.Header_Name,
			ych.Display_Name,
			ych.IsYearlyHeader,
			ych.[Status]
		FROM [dbo].[TDS_t_YearlyChart_Headers] ych with(nolock)
		WHERE (@Regards IS NULL OR ych.Regards=@Regards)
		ORDER BY ych.OrderSeq

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END