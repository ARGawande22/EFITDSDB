
Create   View [dbo].[City_v]
--***********************************************************
--***
--*** Created On 25 Feb 2025 By A.R.Gawande
--***
--***********************************************************
AS

	--Get City Information
	Select
		c.City_Id,
		c.CityName,
		s.State_Id,
		s.StateCode,
		s.StateCode_AsperGST,
		s.StateName,
		cn.Country_Id,
		cn.CountryCode,
		cn.CountryName	
	FROM TDS_t_City c with(nolock)
		JOIN TDS_t_States s with(nolock) on c.State_Id=s.State_Id
		JOIN TDS_t_Country cn with(nolock) on s.Country_Id=cn.Country_Id
   WHERE c.Status='Y'

