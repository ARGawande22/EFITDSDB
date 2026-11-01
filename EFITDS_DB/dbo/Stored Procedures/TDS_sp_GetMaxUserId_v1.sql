USE TDSLive
GO

Create   Procedure [dbo].[TDS_sp_GetMaxUserId]
	@office_Id INT,
	@userID NVARCHAR(20) OUTPUT

--***********************************************************
--***
--*** Created On 05 Apr 2025 By A.R.Gawande
--*** Modified: 
--***			 22 Oct 2026 By A.R.Gawande next ID is generated per prefix
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),
			@Prefix NVARCHAR(10),
            @MaxNo  INT

	--[1]. Get the configured prefix, default to EFI
    SELECT @Prefix = LTRIM(RTRIM([Value]))
    FROM [dbo].[TDS_t_ConfigurationParameter]
    WHERE KeyName = 'UserPrefix' AND [Status] = 'Y'


	IF(@Prefix IS NULL OR @Prefix='')
	BEGIN
		SET @Prefix='EFI'
	END


	--[2]. Highest numeric part among users that start with the CURRENT prefix only
    SELECT @MaxNo = MAX(TRY_CONVERT(INT, SUBSTRING(ul.[User_Id], LEN(@Prefix) + 1, 20)))
    FROM TDS_t_UserLogin ul
        LEFT JOIN TDS_t_UserRole ur ON ul.Role_Id = ur.Role_Id
    WHERE ul.Office_Id = @office_Id
      AND ur.[Role] NOT IN ('Admin', 'Client')
      AND LEFT(ul.[User_Id], LEN(@Prefix)) = @Prefix

    -- No users with this prefix yet -> start at 1
    SET @MaxNo = ISNULL(@MaxNo, 0)

    SET @userID = CONCAT(@Prefix, FORMAT(@MaxNo + 1, 'D3'))

	SET NOCOUNT OFF

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_GenerateUserId: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	RETURN(-1)
END