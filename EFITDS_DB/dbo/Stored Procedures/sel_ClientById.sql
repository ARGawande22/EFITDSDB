
Create   Procedure [dbo].[sel_ClientById]
	@OfficeId int

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

	--Check Office status
	SELECT @Status=Status
	FROM  [dbo].[TDS_t_Office_Details]
	Where [Office_Id]=@OfficeId
	and Status='Y'

	IF(@@ROWCOUNT=0)
	BEGIN
		Select @ErrMsg='sel_ClientById: Client is not active' + CONVERT(Varchar,@OfficeId)
		GOTO spError
	END

	--Get Office Information
	Select 
		o.Office_Id,
		o.TAN_No,
		o.Office_Name,
		o.Office_PANNo,
		o.GSTIN,
		o.AIN_No,
		o.[Address],
		c.City_Id,
		c.CityName,
		s.State_Id,
		s.StateName,
		cn.Country_Id,
		cn.CountryName,	
	    o.PinCode,
		o.Contact_No,
		o.Email_Id,
		dt.[Type_Id],
		dt.[type],
	    Case when o.Profile_Status IS NULL 
				then 0 
			  Else o.Profile_Status 
	     END as Profile_Status
	FROM [dbo].[TDS_t_Office_Details] o with(nolock)
	JOIN [dbo].[TDS_t_City] c with(nolock) ON o.City_Id=c.City_Id
	JOIN [dbo].[TDS_t_States] s with(nolock) ON c.State_Id=s.State_Id
	JOIN [dbo].[TDS_t_Country] cn with(nolock) ON s.Country_Id=cn.Country_Id
	JOIN [dbo].[TDS_t_DeductorTypes] dt with(nolock) on o.[Type_Id]=dt.[Type_Id]
	Where o.[Office_Id]=@OfficeId

	--Get DDO Information
	Select
		d.DDO_Code,
		d.DDO_Name,
		d.Designation_Id,
		ds.Designation,
		d.DDO_PANNo,
		d.DOB,
		d.Gender_Id,
		g.Gender,
		d.[Address],
		c.City_Id,
		c.CityName,
		s.State_Id,
		s.StateName,
		cn.Country_Id,
		cn.CountryName,
		d.PinCode,
		d.Contact_No,
		d.Email_Id,
		d.[Status]
	FROM [dbo].[TDS_t_Office_DDODetails] d	with(nolock)
	JOIN [dbo].[TDS_t_City] c with(nolock) ON d.City_Id=c.City_Id
	JOIN [dbo].[TDS_t_States] s with(nolock) ON c.State_Id=s.State_Id
	JOIN [dbo].[TDS_t_Country] cn with(nolock) ON s.Country_Id=cn.Country_Id
	JOIN [dbo].[TDS_t_Gender] g with(nolock) ON d.Gender_Id=g.Gender_Id
	LEFT JOIN [dbo].[TDS_t_Designations] ds with(nolock) ON d.Designation_Id=ds.Designation_Id
	where d.[Office_Id]=@OfficeId

    --Get Office Credential
	Select 
		oc.Id,
		oc.[User_Id],
		oc.[Password],
		ct.Credential_Id,
		ct.Credential_Type,		
		oc.[Status]
	FROM [dbo].[TDS_t_Office_Credentials] oc with(nolock)
	JOIN [dbo].[TDS_t_CrendetialTypes] ct with(nolock) ON oc.Credential_Id=ct.Credential_Id
	Where oc.[Office_Id]=@OfficeId

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END