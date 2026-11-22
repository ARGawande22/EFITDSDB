USE TDSLive;
GO

Create   View [dbo].[TDS_v_CalChart_Headers]
--***********************************************************
--***
--*** Created On 13 Nov 2026 By A.R.Gawande
--***
--***********************************************************
AS

	--Get Cal Chart Headers Information
	Select
		h.Header_Id,
		h.OrderSeq AS MainHeaderSeq,
		h.Header_Name AS MainHeader,
		h.Display_Name AS MainHeaderDisplayName,
		h.IsNewRegime,
		h.Font AS MainHeaderFont,
		h.IsBold AS MainHeaderBold,
		h.isEditable AS MainHeaderEditable,
		h.Status AS MainHeaderStatus,
		sub.SubHeader_Id,
		sub.OrderSeq AS SubHeaderSeq,
		sub.SubHeader_Name AS SubHeader,
		sub.Display_Name AS SubHeaderDisplayName,
		sub.Ref_Id AS SubHeaderRef,
		sub.isEditable AS SubHeaderEditable,
		sub.IsMultiline AS SubMultipalHeader,
		CASE WHEN sub.IsMultiline=1 THEN 'Multiple' ELSE 'Single' END AS SubMultipal,
		sub.AllowSingle AS SubAllowSingle,
		CASE WHEN sub.IsMultiline=1 THEN
										CASE WHEN sub.AllowSingle=1 THEN 'Only accept single header amount' ELSE 'Multipal amount can accept' END
									ELSE '' END AS SubHeaderType,
		sub.IsNewRegime AS SubIsNewRegime,
		sub.Font AS SubHeaderFont,
		sub.IsBold AS SubHeaderBold,
		sub.Status as SubHeaderStatus,
		detsub.SubDetailHeader_Id,
		detsub.OrderSeq AS SubDetHeaderSeq,
		detsub.SubDetailHeader_Name AS SubDetailHeader,
		detsub.Display_Name AS SubDetHeaderDisplayName,
		detsub.Ref_Id AS SubDetHeaderRef,
		detsub.IsChk AS AllowCheckbox,
		detsub.isEditable AS SubDetHeaderEditable,
		detsub.Status AS SubDetHeaderStatus
	FROM TDS_t_CalChart_Headers h with(nolock)
	    LEFT JOIN TDS_t_CalChart_SubHeaders sub with(nolock) ON h.Header_Id=sub.Header_Id
		LEFT JOIN TDS_t_CalChart_SubDetailHeaders detsub with(nolock) on sub.SubHeader_Id=detsub.SubHeader_Id