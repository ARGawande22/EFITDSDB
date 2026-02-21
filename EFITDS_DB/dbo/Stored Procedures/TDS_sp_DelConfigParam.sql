Use TDSLive
Go

Create   Procedure [dbo].[TDS_sp_DelConfigParam]
	@Config_Id int=0,
	@Status NVARCHAR(1)

--***********************************************************
--***
--*** Created On 21 Feb 2026 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)	

	--Enable/Disable Config Parameters
	IF @Config_Id <> 0
	  BEGIN
	    Update cp
		SET cp.[Status]=@Status
		FROM [dbo].[TDS_t_ConfigurationParameter] cp with(nolock)
		WHERE cp.Config_Id=@Config_Id
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