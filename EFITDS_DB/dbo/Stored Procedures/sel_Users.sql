

CREATE     Procedure [dbo].[sel_Users]
	@OffiiceId int

--***********************************************************
--***
--*** Purpose: To Get all the user to generate the reports.
--***
--*** Created On 23 Feb 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255)

	--Get Users Information
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
	WHERE ul.Office_Id=@OffiiceId

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
