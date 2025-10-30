USE [TDSLive];
GO

Create OR Alter View [dbo].[EmployeeDetails_v0]
--***********************************************************
--***
--*** Created On 02 Oct 2025 By A.R.Gawande
--***
--***********************************************************
AS

	--Get Employee Information
	SELECT	ed.Sevaarth_Id
			,ed.DDO_Code
			,ed.EMP_PANNo
			,ed.PAN_Status
			,ed.UID_No
			,ed.EID_No
			,ed.Name_AsPerSevaarth
			,ed.DBO_AsPerSevaarth
			,ed.Name_AsPerIT
			,ed.DBO_AsPerIT
			,ed.Designation_Id
			,d.Designation
			,ed.DOJ
			,ed.DOR
			,ed.Contact_No
			,ed.Email_Id
			,ed.Gender_Id
			,g.Gender
			,ed.[Address]
			,ed.IsManual
			,ed.IsSeniorCitizen
			,ed.IsDCPS
			,ed.InsertedOn
			,ed.InsertedBy
			,ed.UpdatedOn
			,ed.updatedBy
			,ed.[Status]
			,ebd.Bank_Id
			,ebd.Account_No
			,ebd.Bank_Name
			,ebd.IFSC_Code
			,ebd.GPF_DCPS_AccountNo
			,ebd.[Status] AS BankStatus
	FROM TDS_t_Emp_Details ed with(nolock)
	INNER JOIN dbo.TDS_t_Designations d with(nolock) ON ed.Designation_Id=d.Designation_Id
	LEFT JOIN TDS_t_EmpBank_Details ebd with(nolock) ON ed.Sevaarth_Id=ebd.Sevaarth_Id	
	LEFT JOIN dbo.TDS_t_Gender g with(nolock) ON ed.Gender_Id=g.Gender_Id
	WHERE (ebd.[Status] IS NULL OR ebd.[Status]='Y')

GO