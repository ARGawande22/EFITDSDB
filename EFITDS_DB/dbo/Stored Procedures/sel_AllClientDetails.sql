
Create   Procedure [dbo].[sel_AllClientDetails]
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

	--Get All Office Information
	Select 
		o.Office_Id,
		o.TAN_No,
		o.Office_Name,
		d.DDO_Code,
		o.Office_PANNo,
		c.City_Id,
		c.CityName,
		O.AIN_No,
		Case when o.Profile_Status IS NULL 
				then 0 
			  Else o.Profile_Status 
	     END as Profile_Status
	FROM [dbo].[TDS_t_Office_Details] o with(nolock)
	LEFT JOIN [dbo].[TDS_t_Office_DDODetails] d	with(nolock) on o.Office_Id=d.Office_Id
	JOIN [dbo].[TDS_t_City] c with(nolock) ON o.City_Id=c.City_Id
	Where o.[Status]='Y' --and o.[Office_Id]<>1

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END