USE TDSLive;
GO

Create   View [dbo].[TDS_v_CalChart_SubHeader_Limits]
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
		sub.SubHeader_Id,
		sub.Header_Id,
		sub.OrderSeq,
		sub.SubHeader_Name,
		sub.Display_Name,
		sub.Ref_Id,
		sub.isEditable,
		sub.IsMultiline,
		sub.AllowSingle,
		sub.IsNewRegime,
		sub.Font,
		sub.IsBold,
		sub.Created_Date,
		sub.Status as HeaderStatus,
		sublimit.Limit_id,
		sublimit.OldRegimeLimit,
		sublimit.NewRegimeLimit,
		sublimit.Status as LimitStatus
	FROM TDS_t_CalChart_SubHeaders sub with(nolock)
		LEFT JOIN TDS_t_CalChart_SubHeader_Limits sublimit with(nolock) on sub.SubHeader_Id=sublimit.SubHeader_Id
		JOIN TDS_t_Year y with(nolock) on sublimit.Year_Id=y.Year_Id
