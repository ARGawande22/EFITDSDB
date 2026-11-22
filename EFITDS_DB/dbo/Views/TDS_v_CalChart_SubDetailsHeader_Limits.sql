USE TDSLive;
GO

Create   View [dbo].[TDS_v_CalChart_SubDetailsHeader_Limits]
--***********************************************************
--***
--*** Created On 13 Nov 2026 By A.R.Gawande
--***
--***********************************************************
AS

	--Get Sub Header Limits Information
	Select
		y.Year_Id,
		y.Fin_Year,
		detsub.SubDetailHeader_Id,
		detsub.SubHeader_Id,
		detsub.OrderSeq,
		detsub.SubDetailHeader_Name,
		detsub.Display_Name,
		detsub.Ref_Id,
		detsub.IsChk,
		detsub.isEditable,
		detsub.Created_Date,
		detsub.Status as HeaderStatus,
		subdetlimit.Limit_id,
		subdetlimit.OldRegimeLimit,
		subdetlimit.NewRegimeLimit,
		subdetlimit.Status as SubLimitStatus
	FROM TDS_t_CalChart_SubDetailHeaders detsub with(nolock)
		LEFT JOIN TDS_t_CalChart_SubDetailsHeader_Limits subdetlimit with(nolock) on detsub.SubDetailHeader_Id=subdetlimit.SubDetailHeader_Id
		JOIN TDS_t_Year y with(nolock) on subdetlimit.Year_Id=y.Year_Id