
Create   View [dbo].[Year_v]
--***********************************************************
--***
--*** Created On 25 Feb 2025 By A.R.Gawande
--***
--***********************************************************
AS

	--Get City Information
	Select
		y.Year_Id,
		y.Fin_Year,
		y.ITR_DueDate,
		y.Lock_Date,
		y.RPUName,
		y.RPUPath,
		y.RPUWinName,
		ys.Slab_Id,
		ys.StandardDeduction,
		ys.Rebate,
		ys.EducationalCess,
		ys.Surcharge,
		ys.IsNewRegime,
		ys.IsSeniorCitizen,
		ys.[Status] as Status,
		ysd.Slab_DetailId,
		ysd.Slab_Description,
		ysd.Value,
		ysd.[Status] as SlabStatus
	FROM TDS_t_Year y with(nolock)
		JOIN TDS_t_YearSlab ys with(nolock) on y.Year_Id=ys.Year_Id
		JOIN TDS_t_YearSlabDetails ysd with(nolock) on ys.Slab_Id=ysd.Slab_Id
	WHERE y.Status='Y'

