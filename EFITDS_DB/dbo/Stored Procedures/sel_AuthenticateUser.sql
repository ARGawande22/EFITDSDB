

CREATE     Procedure [dbo].[sel_AuthenticateUser]
	@UserId Nvarchar(20),
	@Password Nvarchar(200)

--***********************************************************
--***
--*** Created On 06 Nov 2024 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@LoginID SMALLINT

	--Verify User Exists
	--SELECT @LoginID=login_Id
	--FROM  [dbo].[TDS_t_UserLogin]
	--Where [User_Id]=@UserId and [Password]=@Password
	--and Status='Y'

	SELECT @LoginID=login_Id
	FROM  [dbo].[TDS_t_UserLogin] l with(nolock)
	 JOIN [dbo].[TDS_t_Office_Details] o with(nolock) ON l.Office_Id=o.Office_Id
	Where [User_Id]=@UserId and [Password]=@Password
	and l.Status='Y' AND o.[Status]='Y'

	IF(@@ROWCOUNT=0)
	BEGIN
		Select @ErrMsg='sel_AuthenticateUser: User does not exist'
		GOTO spError
	END

	--Get User  Information
	SELECT 
		ul.Office_Id,
		ul.login_Id,
		ul.[User_Id],
		ul.Password,
		ud.User_Name,
		ud.Contact_No,
		ud.Email_Id,
		ud.Gender_Id,
		ge.Gender,
		cn.Country_Id,
		cn.CountryName,
		st.State_Id,
		st.StateName,
		ud.City_Id,
		ci.CityName,
		ud.Address,
		ud.PinCode,
		ul.Access_Id,
		up.Access,
		ul.Role_Id,
		ur.Role
	FROM [dbo].[TDS_t_UserLogin] ul with(nolock)
	JOIN [dbo].[TDS_t_UserDetails] ud with(nolock) ON ul.login_Id=ud.login_Id
	JOIN [dbo].[TDS_t_UserPermission] up with(nolock) ON ul.Access_Id=up.Access_Id
	JOIN [dbo].[TDS_t_UserRole] ur  with(nolock) ON ul.Role_Id=ur.Role_Id
	JOIN [dbo].[TDS_t_City] ci with(nolock) ON ud.City_Id=ci.City_Id
	JOIN [dbo].[TDS_t_States] st with(nolock) ON ci.State_Id=st.State_Id
	JOIN [dbo].[TDS_t_Country] cn with(nolock) ON st.Country_Id=cn.Country_Id
	JOIN [dbo].[TDS_t_Gender] ge with(nolock) ON ud.Gender_Id=ge.Gender_Id
	Where ul.login_Id=@LoginID

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
