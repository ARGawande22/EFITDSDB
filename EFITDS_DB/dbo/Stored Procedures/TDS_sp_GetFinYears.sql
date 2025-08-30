
Create   Procedure [dbo].[TDS_sp_GetFinYears]
	@Year_Id int=0

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

	--Check Year status
	IF @Year_Id <> 0
	  BEGIN
	  SELECT @Status=Status
	  FROM  [dbo].[TDS_t_Year]
	  Where [Year_Id]=@Year_Id
	  and Status='Y'

		IF(@@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='TDS_sp_GetFinYears: Financial Year no longer available.'
			GOTO spError
		END
	  END
	

	--Get Financial Year Information
	IF @Year_Id <> 0
	  BEGIN
	    Select
			y.Year_Id,
			y.Fin_Year,
			y.ITR_DueDate,
			y.Lock_Date,
			y.RPUPath,
			y.RPUName,
			y.RPUWinName
		FROM [dbo].[TDS_t_Year] y with(nolock)
		WHERE y.Status='Y' and y.Year_Id=@Year_Id
		ORDER BY y.Fin_Year DESC
	  END
	ELSE
	  BEGIN
		Select
			y.Year_Id,
			y.Fin_Year,
			y.ITR_DueDate,
			y.Lock_Date,
			y.RPUPath,
			y.RPUName,
			y.RPUWinName			
		FROM [dbo].[TDS_t_Year] y with(nolock)
			WHERE y.Status='Y'
		ORDER BY y.Fin_Year DESC
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