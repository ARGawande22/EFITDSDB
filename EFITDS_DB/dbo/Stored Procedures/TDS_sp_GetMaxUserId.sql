
Create   Procedure [dbo].[TDS_sp_GetMaxUserId]
	@office_Id INT,
	@userID NVARCHAR(20) OUTPUT

--***********************************************************
--***
--*** Created On 05 Apr 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255),
			@Id NVARCHAR(20),
			@Count Int,
			@Prefix CHAR(3)='EFI'
	
	SELECT @Id=Max(ul.[User_Id]) 
	FROM TDS_t_UserLogin ul
		LEFT JOIN TDS_t_UserRole ur ON ul.Role_Id=ur.Role_Id
	WHERE Office_Id=@office_Id and ur.[Role] not in('Admin','Client')

	IF(@Id Is Null OR @Id ='')
	BEGIN
		SET @Count=0
	END
	ELSE
	BEGIN
		SET @Count=CONVERT(INT,SUBSTRING(@Id,4,LEN(@Id)))
	END

	SET @userID=CONCAT(@Prefix,FORMAT(@Count+1,'D3'))

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