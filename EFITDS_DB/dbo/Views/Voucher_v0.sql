USE [TDSLive];
GO

Create OR Alter View [dbo].[Voucher_v0]
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
		v.Vourcher_Date,
		v.Voucher_No,
		v.Voucher_Amount,
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
		Bin=	CASE WHEN v.SourceId in(1,2) AND (v.IsBinview='Y' OR (v.IsBinview='N' AND v.Voucher_Amount=0))
					THEN 'Matched' 
					 WHEN v.SourceId=3 THEN 'NA'
				ELSE 'UnMatched'
				END,
		Oltas=	CASE WHEN v.SourceId=3 AND v.IsOltas='Y' THEN 'Matched'
					 WHEN v.SourceId in(1,2) THEN 'NA'
				ELSE 'UnMatched'
				END,
		v.InsertedOn,
		v.InsertedBy,
		v.UpdatedOn,
		v.updatedBy,
		v.[Status]
	FROM TDS_t_Voucher_Details v with(nolock)

GO