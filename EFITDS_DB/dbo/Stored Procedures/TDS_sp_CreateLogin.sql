
Create   Procedure [dbo].[TDS_sp_CreateLogin]
	@office_Id INT,
	@updated_By INT,
	@userID NVARCHAR(20),
	@password NVARCHAR(200),
	@userName NVARCHAR(50),
	@gender INT,
	@address NVARCHAR(255),
	@city INT,
	@pincode INT,
	@contact NVARCHAR(13),
	@email NVARCHAR(50),
	@role NVARCHAR(50),
	@access NVARCHAR(50),
	@status CHAR(1)

--***********************************************************
--***
--*** Created On 09 Mar 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@ErrMsg		NVARCHAR(255)


	DECLARE @login_Id INT,
			@detail_Id INT

	SET @GetDate=GETDATE();

	--Check login already present OR not.
	SELECT @login_Id=login_Id FROM [dbo].[TDS_t_UserLogin] WHERE Office_Id=@office_Id AND [User_Id]=@userID

	--[1]. Insert / Update Login Details
	IF(@login_Id<>0)
	BEGIN
		UPDATE l
		SET l.Password=@password,
			l.Role_Id=ur.Role_Id,
			l.Access_Id=up.Access_Id,
			l.Updated_Date=@GetDate,
			l.Updated_By=@updated_By,
			l.Status=@status
		FROM [dbo].[TDS_t_UserLogin] l
		JOIN [dbo].[TDS_t_UserRole] ur ON ur.Role=@role
		JOIN [dbo].[TDS_t_UserPermission] up ON up.Access=@access
		WHERE l.login_Id=@login_Id and Office_Id=@office_Id

		IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error updating logins details.'
			GOTO spError
		END
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[TDS_t_UserLogin](
						Office_Id,
						[User_Id],
						[Password],
						Role_Id,
						Access_Id,
						Created_Date,
						Created_By,
						[Status])
				SELECT  @office_Id,
						@userID,
						@password,
						Role_Id=(SELECT Role_Id FROM [dbo].[TDS_t_UserRole] ur WHERE ur.Role=@role),
						Access_Id=(SELECT Access_Id FROM [dbo].[TDS_t_UserPermission] up WHERE up.Access=@access),
						@GetDate,
						@updated_By,
						@status

		IF(@@ERROR <> 0 OR @@IDENTITY=0)
		BEGIN
			Select @ErrMsg='Error creating logins.'
			GOTO spError
		END

		SET @login_Id=@@IDENTITY;		
	END


	--[2]. Insert / Update the  User Details
	IF EXISTS (SELECT Detail_Id FROM [dbo].[TDS_t_UserDetails] WHERE login_Id=@login_Id)
	BEGIN
		UPDATE ud
		SET ud.[User_Name]=@userName,
			ud.Gender_Id=@gender,
			ud.Address=@address,
			ud.City_Id=@city,
			ud.PinCode=@pincode,
			ud.Contact_No=@contact,
			ud.Email_Id=@email
		FROM [dbo].[TDS_t_UserDetails] ud
		WHERE login_Id=@login_Id
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[TDS_t_UserDetails](
						login_Id,
						User_Name,
						Gender_Id,
						Address,
						City_Id,
						PinCode,
						Contact_No,
						Email_Id)
				VALUES(	@login_Id,
						@userName,
						@gender,
						@address,
						@city,
						@pincode,
						@contact,
						@email)
	END

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_CreateLogin: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END