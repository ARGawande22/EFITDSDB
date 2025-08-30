
Create   Procedure [dbo].[TDS_sp_GetFinYearSlabDetails]
	@Slab_Id int

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

	IF @Slab_Id is null
	BEGIN
	   Select @ErrMsg='TDS_sp_GetFinYearSlabDetails: Slab id parameter is required.'
	   GOTO spError
	END

	--Check Year status	
	  SELECT @Status=[Status]
	  FROM  [dbo].[TDS_t_YearSlabDetails]
	  Where [Slab_Id]=@Slab_Id
	  and Status='Y'

		IF(@@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='TDS_sp_GetFinYearSlabDetails: no slab available for the year.'
			GOTO spError
		END
	  

	--Get Financial Year slab Information	
	    Select
			ys.Slab_Id,
			ysd.Slab_Description,
			ysd.[Value],
			ysd.[Status]
		FROM [dbo].[TDS_t_YearSlab] ys
			JOIN [dbo].[TDS_t_YearSlabDetails] ysd ON ys.Slab_Id=ysd.Slab_Id
		WHERE ysd.Status='Y' and ys.Slab_Id=@Slab_Id
		ORDER BY ysd.Slab_Description

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END