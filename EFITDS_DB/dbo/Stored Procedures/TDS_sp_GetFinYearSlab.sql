Use TDSLive
Go

Create   Procedure [dbo].[TDS_sp_GetFinYearSlab]
	@Year_Id int

--***********************************************************
--***
--*** Created On 23 Dec 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status Char(1)

	IF @Year_Id is null
	BEGIN
	   Select @ErrMsg='TDS_sp_GetFinYearSlab: Year id parameter is required.'
	   GOTO spError
	END

	--Check Year status	
	  SELECT @Status=[Status]
	  FROM  [dbo].[TDS_t_YearSlab]
	  Where [Year_Id]=@Year_Id
	  --and Status='Y'

		IF(@@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='TDS_sp_GetFinYearSlab: no slab available for the year.'
			GOTO spError
		END
	  

	--Get Financial Year slab Information	
	    Select
			y.Year_Id,			
			ys.Slab_Id,
			ys.StandardDeduction,
			ys.Rebate,
			ys.EducationalCess,
			ys.Surcharge,
			ys.IsNewRegime,
			ys.IsSeniorCitizen,
			ys.[Status]
		FROM [dbo].[TDS_t_Year] y with(nolock)
			JOIN [dbo].[TDS_t_YearSlab] ys with(nolock) ON y.Year_Id=ys.Year_Id
		WHERE --ys.Status='Y' and 
		ys.Year_Id=@Year_Id
		ORDER BY ys.Slab_Id

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END