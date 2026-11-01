USE TDSLive;
GO

Create Procedure [dbo].[TDS_sp_sel24QExportVouchers]
	@DDOCode NVARCHAR(10)
	,@FinYear NVARCHAR(11)
	,@Quarter CHAR(3)
	,@FormType CHAR(3)=NULL
	,@NilVouchers  BIT     = 0        -- 0 = false, 1 = true

--***********************************************************
--***
--*** Created On 24 Oct 2026 By A.R.Gawande
--***
--*** Result sets returned (in this order):
--***   1. Office Details      (TDS_t_Office_Details + TDS_t_Office_DDODetails)
--***   2. Voucher Details     (TDS_t_Voucher_Details, whole quarter)
--***   3. Month 1 employee salary details  (Q1 = Apr)
--***   4. Month 2 employee salary details  (Q1 = May)
--***   5. Month 3 employee salary details  (Q1 = Jun)
--***   6. Bin View            (TDS_t_Bin_Details, voucherd's )
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

	--[1]. Quarter & Month boundaries
	SELECT  @FromDate=dbo.GetFromDate(@FinYear,@Quarter)
	SELECT  @ToDate=dbo.GetToDate(@FinYear,@Quarter)

	DECLARE @M1Start DATE = @FromDate;
    DECLARE @M1End   DATE = EOMONTH(@M1Start);

    DECLARE @M2Start DATE = DATEADD(MONTH, 1, @M1Start);
    DECLARE @M2End   DATE = EOMONTH(@M2Start);

    DECLARE @M3Start DATE = DATEADD(MONTH, 2, @M1Start);
    DECLARE @M3End   DATE = EOMONTH(@M3Start);

	--[2]. Get all the voucher id's within quarter
	IF OBJECT_ID('tempdb..#Vouchers') IS NOT NULL 
		DROP TABLE #Vouchers;

	CREATE TABLE #Vouchers (Voucher_Id BIGINT NOT NULL PRIMARY KEY)

	INSERT INTO #Vouchers (Voucher_Id)
	SELECT v.Voucher_Id
	FROM dbo.SelVoucher_v0 v with(nolock) 
	WHERE v.DDO_Code=@DDOCode
		AND v.Vourcher_Date >=@FromDate AND v.Vourcher_Date<=@ToDate
		AND (@FormType IS NULL OR v.Form_Type=@FormType)
		AND (@NilVouchers = 1 OR v.Voucher_Amount > 0)

	--[3]. Office details
	SELECT	 o.TAN_No
			,o.Office_Name
			,o.AIN_No
			,o.PinCode
			,d.DDO_Code
			,d.DDO_Name
			,d.DDO_PANNo
			,d.[Address]
			,d.Contact_No
			,d.Email_Id
			,c.CityName
	FROM [dbo].[TDS_t_Office_DDODetails] d with(nolock) 
	INNER JOIN [dbo].[TDS_t_Office_Details] o with(nolock) ON d.Office_Id=o.Office_Id
	LEFT JOIN [dbo].[TDS_t_City] c ON o.City_Id=c.City_Id
	WHERE d.DDO_Code=@DDOCode

	--[4]. Get Voucher Details
	SELECT	vd.Bill_Month
			,vd.Bill_Year
			,vd.PayBill_Type
			,vd.Vourcher_Date
			,vd.Voucher_No
			,vd.Voucher_Amount
			,vd.Source
			,vd.Kosh
			,vd.Bin
			,vd.Oltas	   
	FROM [dbo].[SelVoucher_v0] vd with(nolock) 
	INNER JOIN #Vouchers v ON v.Voucher_Id = vd.Voucher_Id        
	ORDER BY vd.Vourcher_Date,vd.Voucher_No

	--[5]. Month 1 employee salary details
	SELECT   ey.Sevaarth_Id
			,e.Name_AsPerSevaarth
			,e.EMP_PANNo
			,e.Name_AsPerIT
			,d.Designation
			,vd.Bill_Month
			,vd.Bill_Year
			,vd.PayBill_Type
			,vd.Vourcher_Date
			,vd.Voucher_No
			,vd.Voucher_Amount
			,ISNULL(TRY_CAST(eg.Total_Gross AS DECIMAL(18,2)), 0)
			- ISNULL(TRY_CAST(egr.Recovery_of_Overpayment AS DECIMAL(18,2)), 0)  AS Total_Gross
			,ISNULL(TRY_CAST(egr.Income_Tax AS DECIMAL(18,2)), 0)                 AS Income_Tax
			,e.PAN_Status
	FROM #Vouchers v
	INNER JOIN [dbo].[SelVoucher_v0] vd with(nolock) ON v.Voucher_Id=vd.Voucher_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearly_Details] ey with(nolock) ON ey.Voucher_Id=v.Voucher_Id
	INNER JOIN  [dbo].[TDS_t_Emp_Details] e with(nolock) ON ey.Sevaarth_Id=e.Sevaarth_Id
	LEFT JOIN [dbo].[TDS_t_Designations] d with(nolock) ON e.Designation_Id=d.Designation_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGross_Details] eg with(nolock) ON eg.Yealy_Id=ey.Yealy_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGRecov_Details] egr with(nolock) ON egr.Yealy_Id=ey.Yealy_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGNonRecov_Details] engr with(nolock) ON engr.Yealy_Id=ey.Yealy_Id
	WHERE vd.DDO_Code = @DDOCode
          AND vd.Vourcher_Date >= @M1Start AND vd.Vourcher_Date <= @M1End
	ORDER BY vd.Vourcher_Date,vd.Voucher_No

	--[6]. Month 2 employee salary details
	SELECT   ey.Sevaarth_Id
			,e.Name_AsPerSevaarth
			,e.EMP_PANNo
			,e.Name_AsPerIT
			,d.Designation
			,vd.Bill_Month
			,vd.Bill_Year
			,vd.PayBill_Type
			,vd.Vourcher_Date
			,vd.Voucher_No
			,vd.Voucher_Amount
			,ISNULL(TRY_CAST(eg.Total_Gross AS DECIMAL(18,2)), 0)
			- ISNULL(TRY_CAST(egr.Recovery_of_Overpayment AS DECIMAL(18,2)), 0)  AS Total_Gross
			,ISNULL(TRY_CAST(egr.Income_Tax AS DECIMAL(18,2)), 0)                 AS Income_Tax
			,e.PAN_Status
	FROM #Vouchers v
	INNER JOIN [dbo].[SelVoucher_v0] vd with(nolock) ON v.Voucher_Id=vd.Voucher_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearly_Details] ey with(nolock) ON ey.Voucher_Id=v.Voucher_Id
	INNER JOIN  [dbo].[TDS_t_Emp_Details] e with(nolock) ON ey.Sevaarth_Id=e.Sevaarth_Id
	LEFT JOIN [dbo].[TDS_t_Designations] d with(nolock) ON e.Designation_Id=d.Designation_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGross_Details] eg with(nolock) ON eg.Yealy_Id=ey.Yealy_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGRecov_Details] egr with(nolock) ON egr.Yealy_Id=ey.Yealy_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGNonRecov_Details] engr with(nolock) ON engr.Yealy_Id=ey.Yealy_Id
	WHERE vd.DDO_Code = @DDOCode
          AND vd.Vourcher_Date >= @M2Start AND vd.Vourcher_Date <= @M2End
	ORDER BY vd.Vourcher_Date,vd.Voucher_No

	--[7]. Month 3 employee salary details
	SELECT   ey.Sevaarth_Id
			,e.Name_AsPerSevaarth
			,e.EMP_PANNo
			,e.Name_AsPerIT
			,d.Designation
			,vd.Bill_Month
			,vd.Bill_Year
			,vd.PayBill_Type
			,vd.Vourcher_Date
			,vd.Voucher_No
			,vd.Voucher_Amount
			,ISNULL(TRY_CAST(eg.Total_Gross AS DECIMAL(18,2)), 0)
			- ISNULL(TRY_CAST(egr.Recovery_of_Overpayment AS DECIMAL(18,2)), 0)  AS Total_Gross
			,ISNULL(TRY_CAST(egr.Income_Tax AS DECIMAL(18,2)), 0)                 AS Income_Tax
			,e.PAN_Status
	FROM #Vouchers v
	INNER JOIN [dbo].[SelVoucher_v0] vd with(nolock) ON v.Voucher_Id=vd.Voucher_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearly_Details] ey with(nolock) ON ey.Voucher_Id=v.Voucher_Id
	INNER JOIN  [dbo].[TDS_t_Emp_Details] e with(nolock) ON ey.Sevaarth_Id=e.Sevaarth_Id
	LEFT JOIN [dbo].[TDS_t_Designations] d with(nolock) ON e.Designation_Id=d.Designation_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGross_Details] eg with(nolock) ON eg.Yealy_Id=ey.Yealy_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGRecov_Details] egr with(nolock) ON egr.Yealy_Id=ey.Yealy_Id
	LEFT JOIN [dbo].[TDS_t_EmpYearlyGNonRecov_Details] engr with(nolock) ON engr.Yealy_Id=ey.Yealy_Id
	WHERE vd.DDO_Code = @DDOCode
          AND vd.Vourcher_Date >= @M3Start AND vd.Vourcher_Date <= @M3End
	ORDER BY vd.Vourcher_Date,vd.Voucher_No

	--[8]. Get Bin details
	SELECT  b.Receipt_No
			,b.Serial_No
			,b.Bin_Date
			,b.Ded_Amount
	FROM dbo.TDS_t_Bin_Details b WITH (NOLOCK)
	WHERE b.DDO_Code = @DDOCode
	  AND b.Bin_Date >= @FromDate AND b.Bin_Date <= @ToDate
	  AND EXISTS (
        SELECT 1
        FROM #Vouchers v
        WHERE ',' + REPLACE(b.Voucher_Ids, ' ', '') + ','
              LIKE '%,' + CAST(v.Voucher_Id AS VARCHAR(20)) + ',%'
		)
	ORDER BY b.Bin_Date;

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
