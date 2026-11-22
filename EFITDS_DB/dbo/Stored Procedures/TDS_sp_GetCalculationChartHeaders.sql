Use TDSLive;
GO

Create   Procedure [dbo].[TDS_sp_GetCalculationChartHeaders]
	@UserId Nvarchar(20)=NULL

--***********************************************************
--***
--*** Created On 17 Nov 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status Char(1)

	--[1]. Get Calculation Chart Headers Information
	 SELECT cch.Header_Id,
			cch.OrderSeq,
			cch.Header_Name,
			cch.Display_Name,
			cch.IsNewRegime,
			cch.Font,
			cch.IsBold,
			cch.isEditable,
			cch.Created_Date,
			cch.[Status]
		FROM [dbo].[TDS_t_CalChart_Headers] cch with(nolock)
		WHERE (@UserId='Admin' OR cch.[Status]=1)
		ORDER BY cch.OrderSeq

	--[2]. Get Calculation Chart HeadersFooter Information
	 SELECT cchf.HeaderFooter_Id,
			cchf.Header_Id,
			cchf.OrderSeq,
			cchf.HeaderFooterName,
			cchf.Display_Name,
			cchf.IsHeader,
			cchf.Ref_Id,
			cchf.IsButton,
			cchf.IsComboBox,
			cchf.isEditable,
			cchf.IsNewRegime,
			cchf.Font,
			cchf.IsBold,
			cchf.Created_Date,
			cchf.[Status]
		FROM [dbo].[TDS_t_CalChart_HeaderFooter] cchf with(nolock)
		WHERE (@UserId='Admin' OR cchf.[Status]=1)
		ORDER BY cchf.Header_Id,cchf.OrderSeq

	--[3]. Get Calculation Chart SubHeaders Information
	 SELECT ccsh.SubHeader_Id,
			ccsh.Header_Id,
			ccsh.OrderSeq,
			ccsh.SubHeader_Name,
			ccsh.Display_Name,
			ccsh.Ref_Id,
			ccsh.isEditable,
			ccsh.IsMultiline,
			ccsh.AllowSingle,
			ccsh.IsNewRegime,
			ccsh.Font,
			ccsh.IsBold,
			ccsh.Created_Date,
			ccsh.[Status]
		FROM [dbo].[TDS_t_CalChart_SubHeaders] ccsh with(nolock)
		WHERE (@UserId='Admin' OR ccsh.[Status]=1)
		ORDER BY ccsh.Header_Id,ccsh.OrderSeq

	--[4]. Get Calculation Chart SubHeaders Limit Information
	 SELECT ccshl.Limit_id,
			ccshl.SubHeader_Id,
			ccshl.Year_Id,
			y.Fin_Year,
			ccshl.OldRegimeLimit,
			ccshl.NewRegimeLimit,
			ccshl.[Status]
		FROM [dbo].[TDS_t_CalChart_SubHeader_Limits] ccshl with(nolock)
			JOIN [dbo].[TDS_t_Year] y ON ccshl.Year_Id=y.Year_Id
		WHERE (@UserId='Admin' OR ccshl.[Status]=1)
			AND y.[Status]='Y'
		ORDER BY ccshl.Year_Id,ccshl.SubHeader_Id

	--[5]. Get Calculation Chart SubDetailHeaders Information
	 SELECT ccsdh.SubDetailHeader_Id,
			ccsdh.SubHeader_Id,
			ccsdh.OrderSeq,
			ccsdh.SubDetailHeader_Name,
			ccsdh.Display_Name,
			ccsdh.Ref_Id,
			ccsdh.IsChk,
			ccsdh.isEditable,
			ccsdh.Created_Date,
			ccsdh.[Status]
		FROM [dbo].[TDS_t_CalChart_SubDetailHeaders] ccsdh with(nolock)
		WHERE (@UserId='Admin' OR ccsdh.[Status]=1)
		ORDER BY ccsdh.SubHeader_Id,ccsdh.OrderSeq

	--[6]. Get Calculation Chart SubDetailHeaders Limit Information
	 SELECT ccsdhl.Limit_id,
			ccsdhl.SubDetailHeader_Id,
			ccsdhl.Year_Id,
			y.Fin_Year,
			ccsdhl.OldRegimeLimit,
			ccsdhl.NewRegimeLimit,
			ccsdhl.[Status]
		 FROM [dbo].[TDS_t_CalChart_SubDetailsHeader_Limits] ccsdhl with(nolock)
			JOIN [dbo].[TDS_t_Year] y ON ccsdhl.Year_Id=y.Year_Id
		 WHERE (@UserId='Admin' OR ccsdhl.[Status]=1)
			AND y.[Status]='Y'		
		 ORDER BY ccsdhl.Year_Id,ccsdhl.SubDetailHeader_Id
	 
	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END