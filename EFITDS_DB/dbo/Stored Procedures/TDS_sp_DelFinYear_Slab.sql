Use TDSLive
Go

Create   Procedure [dbo].[TDS_sp_DelFinYear_Slab]
	@Year_Id int=0,
	@Slab_Id int=0,
	@Status NVARCHAR(1)

--***********************************************************
--***
--*** Created On 08 Feb 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)	

	--Enable/Disable Financial Year OR Slab Information
	IF @Year_Id <> 0  AND @Slab_Id = 0 
	  BEGIN
	    Update y
		SET y.[Status]=@Status
		FROM [dbo].[TDS_t_Year] y with(nolock)
		WHERE y.Year_Id=@Year_Id
	  END
	ELSE
	  BEGIN
		Update ys
		SET ys.[Status]=@Status
		FROM [dbo].[TDS_t_YearSlab] ys with(nolock)
		WHERE ys.Year_Id=@Year_Id and ys.Slab_Id=@Slab_Id
	  END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END