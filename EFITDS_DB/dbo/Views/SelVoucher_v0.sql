USE [TDSLive]
GO

/****** Object:  View [dbo].[SelVoucher_v0]    Script Date: 13/09/2025 15:09:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER   View [dbo].[SelVoucher_v0]
--***********************************************************
--***
--*** Created On 12 Sep 2025 By A.R.Gawande
--***
--***********************************************************
AS

	--Get Voucher Information
	Select
		v.Voucher_Id,
		v.DDO_Code,
		v.BillHead,
		v.Fin_Year,
		v.[Quarter],
		v.Bill_Month,
		v.Bill_Year,
		v.PayBill_Type,
		v.Form_Type,
		v.SubForm_Type,
		v.Vourcher_Date,
		v.Voucher_No,
		v.Voucher_Amount,
		v.SourceId,
		Source=	CASE WHEN v.SourceId=1 THEN 'Sevaarth'
					 WHEN v.SourceId=2 THEN 'Koshwahini'
					 WHEN v.SourceId=3 THEN 'Olttas'
				ELSE 'NA'
				END,
        Kosh=	CASE WHEN v.SourceId in(1,2) AND (v.IsKoshwahini='Y' OR (v.IsKoshwahini='N' AND v.Voucher_Amount=0))
					 THEN 'Matched'
					 WHEN v.SourceId=3 THEN 'NA'
				ELSE 'UnMatched'
				END,
		Bin=	CASE WHEN v.SourceId in(1,2) AND (v.IsBinview='Y' OR (v.IsBinview='N' AND v.Voucher_Amount=0) OR ((v.IsBinview='N' OR v.IsBinview IS NULL) AND (v.SubForm_Type IS NOT NULL OR v.SubForm_Type<>'')))
					THEN 'Matched' 
					 WHEN v.SourceId=3 THEN 'NA'
				ELSE 'UnMatched'
				END,
		Oltas=	CASE WHEN v.SourceId=3 AND v.IsOltas='Y' THEN 'Matched'
					 WHEN v.SourceId in(1,2) THEN 'NA'
				ELSE 'UnMatched'
				END,
		InsertedOn=CONVERT(DATE, v.InsertedOn,23),
		v.InsertedBy,
		iUserId=ul.[User_Id],
		UpdatedOn=CONVERT(DATE, v.UpdatedOn,23),
		v.updatedBy,
		uUserId=ul1.[User_Id],
		v.[Status]
	FROM TDS_t_Voucher_Details v with(nolock)
		LEFT JOIN [dbo].[TDS_t_UserLogin] ul with(nolock) on v.InsertedBy=ul.login_Id
		LEFT JOIN [dbo].[TDS_t_UserLogin] ul1 with(nolock) on v.updatedBy=ul1.login_Id

GO


