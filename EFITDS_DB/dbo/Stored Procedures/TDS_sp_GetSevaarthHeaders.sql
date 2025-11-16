
Create   Procedure [dbo].[TDS_sp_GetSevaarthHeaders]
	@Regards Nvarchar(20)=null

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
				
	----Get Sevaarth Headers Information
	--IF @Regards is  Null
	--  BEGIN
	--    Select
	--		h.Header_Id,
	--		h.Regards,
	--		h.MainHeader_Name,
	--		h.IsDisplay,
	--		h.[Status]
	--	FROM [dbo].[TDS_t_Header] h with(nolock)
	--	WHERE h.Status='Y'
	--	ORDER BY h.Header_Id
	--  END
	--ELSE
	--  BEGIN
	--	Select
	--		h.Header_Id,
	--		h.Regards,
	--		h.MainHeader_Name,
	--		h.IsDisplay,
	--		h.[Status]
	--	FROM [dbo].[TDS_t_Header] h with(nolock)
	--	WHERE h.Status='Y' AND h.Regards=@Regards
	--	ORDER BY h.Header_Id
	--  END

	--Get Sevaarth Headers Information
	Select
			h.Header_Id,
			h.Regards,
			h.MainHeader_Name,
			h.IsDisplay,
			h.[Status]
		FROM [dbo].[TDS_t_Header] h with(nolock)
		WHERE h.Status='Y' AND (@Regards IS NULL OR h.Regards=@Regards)
		ORDER BY h.Header_Id

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END