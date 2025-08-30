
Create   Procedure [dbo].[TDS_sp_GetSevaarthSubHeaders]
	@Header_Id int=0

--***********************************************************
--***
--*** Created On 18 Apr 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status Char(1)

	IF @Header_Id is null
	BEGIN
	   Select @ErrMsg='TDS_sp_GetSevaarthSubHeaders: Header id parameter is required.'
	   GOTO spError
	END
				

	--Get Sevaarth Sub Header Information
	IF @Header_Id <> 0
	  BEGIN
		SELECT
			h.Header_Id,			
			sh.Details_Id,
			sh.DetailHeader_Name,
			sh.Status
		FROM [dbo].[TDS_t_Header] h with(nolock)
			JOIN [dbo].[TDS_t_HeadersDetails] sh with(nolock) ON h.Header_Id=sh.Header_Id
		WHERE sh.Status='Y' and h.Header_Id=@Header_Id
		ORDER BY sh.Details_Id
	  END
	ELSE
	  BEGIN
	    Select
			h.Header_Id,			
			sh.Details_Id,
			sh.DetailHeader_Name,
			sh.Status
		FROM [dbo].[TDS_t_Header] h with(nolock)
			JOIN [dbo].[TDS_t_HeadersDetails] sh with(nolock) ON h.Header_Id=sh.Header_Id
		WHERE sh.Status='Y'
		ORDER BY sh.Details_Id
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