USE TDSLive;
GO

Create OR Alter Procedure [dbo].[TDS_sp_GetEmployeeDetails]
	@DDOCode NVARCHAR(10)
	,@FinYear NVARCHAR(11)
	,@Quarter CHAR(3)

--***********************************************************
--***
--*** Created On 12 Oct 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status CHAR(1),
			@FromDate DATE,
			@ToDate DATE

	SELECT  @FromDate=dbo.GetFromDate(@FinYear,@Quarter)
	SELECT  @ToDate=dbo.GetToDate(@FinYear,@Quarter)

	IF OBJECT_ID('tempdb..#SevaarthIds') IS NOT NULL
		DROP TABLE #SevaarthIds

	CREATE TABLE #SevaarthIds(Sevaarth_Id nvarchar(15) NOT NULL,
								PaybillCnt INT NULL)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	--[1]. Get the SevaarthIds for FinYear
	INSERT INTO #SevaarthIds(Sevaarth_Id,PaybillCnt)
				SELECT eyd.Sevaarth_Id
					   ,Count(eyd.PayBill_Type)
				FROM [dbo].[TDS_t_EmpYearly_Details] eyd WITH(NOLOCK)
					JOIN [dbo].[TDS_t_Voucher_Details] vd WITH(NOLOCK) ON eyd.Voucher_Id=vd.Voucher_Id
				WHERE eyd.DDO_Code=@DDOCode AND vd.Vourcher_Date>=@FromDate AND vd.Vourcher_Date<=@ToDate
				GROUP BY eyd.Sevaarth_Id



	--Get Voucher Details
	SELECT	empv.Sevaarth_Id
			,empv.DDO_Code
			,empv.EMP_PANNo
			,empv.PAN_Status
			,empv.UID_No
			,empv.EID_No
			,empv.Name_AsPerSevaarth
			,empv.DBO_AsPerSevaarth
			,empv.Name_AsPerIT
			,empv.DBO_AsPerIT
			,empv.Designation_Id
			,empv.Designation
			,empv.DOJ
			,empv.DOR
			,empv.Contact_No
			,empv.Email_Id
			,empv.Gender_Id
			,empv.Gender
			,empv.[Address]
			,empv.IsManual
			,empv.IsSeniorCitizen
			,empv.IsDCPS
			,empv.InsertedOn
			,empv.InsertedBy
			,empv.UpdatedOn
			,empv.updatedBy
			,empv.[Status]
			,empv.Bank_Id
			,empv.Bank_Name
			,empv.IFSC_Code
			,empv.Account_No
			,empv.GPF_DCPS_AccountNo
			,empv.BankStatus
			,Transferred=CASE WHEN empv.DDO_Code!=@DDOCode THEN 'Y'
								ELSE 'N' END
			,IsPaybill=CASE WHEN sids.PaybillCnt>0 THEN 'Y'
								ELSE 'N' END
	FROM dbo.EmployeeDetails_v0 empv
		INNER JOIN #SevaarthIds sids  ON empv.Sevaarth_Id=sids.Sevaarth_Id
	WHERE empv.DDO_Code=CASE WHEN sids.Sevaarth_Id IS NULL THEN @DDOCode 
							ELSE empv.DDO_Code 
						END

UNION

	SELECT	empv.Sevaarth_Id
			,empv.DDO_Code
			,empv.EMP_PANNo
			,empv.PAN_Status
			,empv.UID_No
			,empv.EID_No
			,empv.Name_AsPerSevaarth
			,empv.DBO_AsPerSevaarth
			,empv.Name_AsPerIT
			,empv.DBO_AsPerIT
			,empv.Designation_Id
			,empv.Designation
			,empv.DOJ
			,empv.DOR
			,empv.Contact_No
			,empv.Email_Id
			,empv.Gender_Id
			,empv.Gender
			,empv.[Address]
			,empv.IsManual
			,empv.IsSeniorCitizen
			,empv.IsDCPS
			,empv.InsertedOn
			,empv.InsertedBy
			,empv.UpdatedOn
			,empv.updatedBy
			,empv.[Status]
			,empv.Bank_Id
			,empv.Bank_Name
			,empv.IFSC_Code
			,empv.Account_No
			,empv.GPF_DCPS_AccountNo
			,empv.BankStatus
			,Transferred=CASE WHEN empv.DDO_Code!=@DDOCode THEN 'Y'
								ELSE 'N' END
			,IsPaybill='N'
	FROM dbo.EmployeeDetails_v1 empv		
	WHERE empv.DDO_Code=@DDOCode AND empv.IsManual='Y' --and empv.Status='Y'


	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END