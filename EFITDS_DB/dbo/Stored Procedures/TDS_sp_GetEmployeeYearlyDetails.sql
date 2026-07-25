USE TDSLive;
GO

CREATE Procedure [dbo].[TDS_sp_GetEmployeeYearlyDetails]
	@DDOCode NVARCHAR(10)
	,@FinYear NVARCHAR(11)
	,@SevaarthId NVARCHAR(15)
	,@Quarter CHAR(3)

--***********************************************************
--***
--*** Created On 27 Jun 2026 By A.R.Gawande
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
			@ToDate DATE,
			@MinDate DATE,
			@MaxDate DATE

	SELECT  @FromDate=dbo.GetFromDate(@FinYear,@Quarter)
	SELECT  @ToDate=dbo.GetToDate(@FinYear,@Quarter)

	IF OBJECT_ID('tempdb..#EmpYearlyDetails') IS NOT NULL
		DROP TABLE #EmpYearlyDetails

	CREATE TABLE #EmpYearlyDetails(
			Sevaarth_Id			nvarchar(15) NOT NULL,
			DDO_Code			nvarchar(11) NULL,
			Yealy_Id			int			 NULL,
			Voucher_Id			int			 NULL,
			Fin_Year			nvarchar(11) NULL,
			Bill_Month			nvarchar(10) NULL,
			Bill_Year			nvarchar(10) NULL,
			PayBill_Type		nvarchar(255) NULL,
			Vourcher_Date		date		 NULL,
			Voucher_No			int			NULL,
			Net_Pay				decimal(18, 0) NULL,
			[Status]			nvarchar(1) NULL,
			Gross_Id			int			NOT NULL,
			PayIn_PB_GP			nvarchar(10) NULL,
			Basic_Pay			nvarchar(10) NULL,
			Basic_Arrear		nvarchar(10) NULL,
			Official_Pay		nvarchar(10) NULL,
			Personal_Pay		nvarchar(10) NULL,
			CLA_Pay				nvarchar(10) NULL,
			Special_Pay			nvarchar(10) NULL,
			Writer_Pay			nvarchar(10) NULL,
			Leave_Salary		nvarchar(10) NULL,
			DA					nvarchar(10) NULL,
			DA_7PC				nvarchar(10) NULL,
			Additional_DA		nvarchar(10) NULL,
			Central_DA			nvarchar(10) NULL,
			DA_Arrear			nvarchar(10) NULL,
			DA_On_TA			nvarchar(10) NULL,
			Dearness_Pay		nvarchar(10) NULL,
			Additional_Pay		nvarchar(10) NULL,
			HRA					nvarchar(10) NULL,
			Additional_HRA		nvarchar(10) NULL,
			HRA_Arrear			nvarchar(10) NULL,
			HRA_Pay				nvarchar(10) NULL,
			TA					nvarchar(10) NULL,
			TA_Arrears			nvarchar(10) NULL,
			TA_Pay				nvarchar(10) NULL,
			Central_TA			nvarchar(10) NULL,
			Leave_TA			nvarchar(10) NULL,
			DCPS_Employer_Contribution nvarchar(10) NULL,
			ATC_Incentive_50	nvarchar(10) NULL,
			ATC_Incentive_30	nvarchar(10) NULL,
			Force_Incentive_100 nvarchar(10) NULL,
			Force_Incentive_25	nvarchar(10) NULL,
			Incentive_For_BDDS	nvarchar(10) NULL,
			Arm_Allowance		nvarchar(10) NULL,
			Armourer_Allowance	nvarchar(10) NULL,
			BMI_Allowance		nvarchar(10) NULL,
			CHPL_CPL_Allowance	nvarchar(10) NULL,
			CID_Allowance		nvarchar(10) NULL,
			Cash_Allowance		nvarchar(10) NULL,
			Children_Educ_Allowance nvarchar(10) NULL,
			Convenyance_Allowance nvarchar(10) NULL,
			ESIS_Allowance		nvarchar(10) NULL,
			Emergency_Allowance nvarchar(10) NULL,
			Extra_Lecture_Allowance nvarchar(10) NULL,
			Family_Planning_Allowance nvarchar(10) NULL,
			Fitness_Allowance	nvarchar(10) NULL,
			Franking_Allowance	nvarchar(10) NULL,
			Hilly_Allowance		nvarchar(10) NULL,
			Kit_Maintenance_Allowance nvarchar(10) NULL,
			Mechanical_Allowance nvarchar(10) NULL,
			Med_St_Allowance	nvarchar(10) NULL,
			Medical_Allowance_MA nvarchar(10) NULL,
			Medical_Education_Allowance nvarchar(10) NULL,
			Mess_Allowance		nvarchar(10) NULL,
			Naxal_Area_Allowance nvarchar(10) NULL,
			Non_Practicing_Allowance nvarchar(10) NULL,
			Other_Allowances	nvarchar(10) NULL,
			Other_Miscellaneous_Allowance nvarchar(10) NULL,
			Outfit_Allowance	nvarchar(10) NULL,
			Peon_Allowance		nvarchar(10) NULL,
			Permanent_Travelling_Allowance nvarchar(10) NULL,
			Post_Graduation_Allowance nvarchar(10) NULL,
			Project_Allowance	nvarchar(10) NULL,
			Qualification_Allowance nvarchar(10) NULL,
			Refreshment_Allowance nvarchar(10) NULL,
			Special_Duty_Allowance nvarchar(10) NULL,
			Sumptuary_Allowance nvarchar(10) NULL,
			Technical_Allowance nvarchar(10) NULL,
			Tribal_Allowance	nvarchar(10) NULL,
			Uniform_Allowance	nvarchar(10) NULL,
			Washing_Allowance	nvarchar(10) NULL,
			Flying_Allowance_For_Pilot nvarchar(10) NULL,
			Inspection_Allowance_For_Pilot nvarchar(10) NULL,
			Instructional_Allowance_For_Pilot nvarchar(10) NULL,
			Flying_Pay_For_Pilot_Cons nvarchar(10) NULL,
			Militery_Serv_Pay_Pilot nvarchar(10) NULL,
			RT_Allowance_For_Pilot nvarchar(10) NULL,
			Special_Pay_For_Pilot nvarchar(10) NULL,
			Gallantry_Awards	nvarchar(10) NULL,
			IR_For_Judges		nvarchar(10) NULL,
			License_Free		nvarchar(10) NULL,
			UCTC				nvarchar(10) NULL,
			Partially_Fully_Tax_Free nvarchar(10) NULL,
			Other				nvarchar(10) NULL,
			Total_Gross			nvarchar(10) NULL,
			Recov_Id			int			 NOT NULL,
			Proffession_Tax		nvarchar(10) NULL,
			Proffession_Tax_Arrears nvarchar(10) NULL,
			Income_Tax			nvarchar(10) NULL,
			DCPS_Employee_Contribution nvarchar(10) NULL,
			DCPS_Pay_Arrear		nvarchar(10) NULL,
			DCPS_Pay_Arrears_Recovery nvarchar(10) NULL,
			DCPS_Regular_Recovery nvarchar(10) NULL,
			DCPS_DA_Arrears_Recovery nvarchar(10) NULL,
			DCPS_Delayed_Recovery nvarchar(10) NULL,
			DedAdj_Employer_Contribution nvarchar(10) NULL,
			GIS					nvarchar(10) NULL,
			Central_GIS			nvarchar(10) NULL,
			GIS_IAS				nvarchar(10) NULL,
			GIS_IFS				nvarchar(10) NULL,
			GIS_IPS				nvarchar(10) NULL,
			GIS_ZP				nvarchar(10) NULL,
			GIS_Arrear			nvarchar(10) NULL,
			GIS_Arrears_Recovery nvarchar(10) NULL,
			Contributory_PF		nvarchar(10) NULL,
			GPF_IAS				nvarchar(10) NULL,
			GPF_IAS_OtherState	nvarchar(10) NULL,
			GPF_IFS				nvarchar(10) NULL,
			GPF_IPS				nvarchar(10) NULL,
			GPF_GRP_ABC			nvarchar(10) NULL,
			GPF_ADV_GRP_ABC		nvarchar(10) NULL,
			GPF_GRP_D			nvarchar(10) NULL,
			GPF_ADV_GRP_D		nvarchar(10) NULL,
			GPF_ABC_Arrears		nvarchar(10) NULL,
			GPF_D_Arrears		nvarchar(10) NULL,
			GPF_IAS_Arrears		nvarchar(10) NULL,
			GPF_IFS_Arrears		nvarchar(10) NULL,
			Group_Account_Policy nvarchar(10) NULL,
			House_Rent_Recovery nvarchar(10) NULL,
			HRR_Arrear			nvarchar(10) NULL,
			MSLI				nvarchar(10) NULL,
			PLI					nvarchar(10) NULL,
			Service_Charge_and_Garage_Charge nvarchar(10) NULL,
			Service_Charge_Arr	nvarchar(10) NULL,
			Co_Housing_Society	nvarchar(10) NULL,
			Co_Housing_Society_Interest nvarchar(10) NULL,
			Computer_Advance	nvarchar(10) NULL,
			Comp_Adv_Int		nvarchar(10) NULL,
			Comp_AIS_Int		nvarchar(10) NULL,
			Recovery_of_Overpayment nvarchar(10) NULL,
			FA					nvarchar(10) NULL,
			HBA_Principal		nvarchar(10) NULL,
			HBA_Interest		nvarchar(10) NULL,
			HBA_AIS				nvarchar(10) NULL,
			HBA_AIS_Int			nvarchar(10) NULL,
			HBA_For_Land		nvarchar(10) NULL,
			HBA_For_Land_Int	nvarchar(10) NULL,
			HBA_House			nvarchar(10) NULL,
			HBA_House_Int		nvarchar(10) NULL,
			HIS					nvarchar(10) NULL,
			MCA					nvarchar(10) NULL,
			MCA_Interest		nvarchar(10) NULL,
			MCA_AIS				nvarchar(10) NULL,
			MCA_AIs_Int			nvarchar(10) NULL,
			Other_Adv			nvarchar(10) NULL,
			Other_Adv_Int		nvarchar(10) NULL,
			Other_Vehical_Advance nvarchar(10) NULL,
			Other_Vehical_Advance_Interest nvarchar(10) NULL,
			Pay_Advance			nvarchar(10) NULL,
			TA_Advance			nvarchar(10) NULL,
			Other_GRecov		nvarchar(10) NULL,
			Total_GRecoveries	nvarchar(10) NULL,
			NonRec_Id			int			 NOT NULL,
			Bank_Loan_1			nvarchar(10) NULL,
			Bank_Loan_2			nvarchar(10) NULL,
			Co_Op_Bank_1		nvarchar(10) NULL,
			Co_Op_Bank_2		nvarchar(10) NULL,
			Co_Op_Cr_Soc_1		nvarchar(10) NULL,
			Co_Op_Cr_Soc_2		nvarchar(10) NULL,
			Co_Op_Hsg_Soc		nvarchar(10) NULL,
			LIC_1				nvarchar(10) NULL,
			LIC_2				nvarchar(10) NULL,
			LIC_3				nvarchar(10) NULL,
			Other_Recovery_1	nvarchar(10) NULL,
			Other_Recovery_2	nvarchar(10) NULL,
			RD_1				nvarchar(10) NULL,
			RD_2				nvarchar(10) NULL,
			Con_Store			nvarchar(10) NULL,
			Matralaya_Bank		nvarchar(10) NULL,
			Mess_Recovery		nvarchar(10) NULL,
			Miscellaneous		nvarchar(10) NULL,
			Elec_Charge			nvarchar(10) NULL,
			Maintenance_Charge	nvarchar(10) NULL,
			Tel_Charge			nvarchar(10) NULL,
			Water_Charge		nvarchar(10) NULL,
			Club_Fund			nvarchar(10) NULL,
			Mess_Dev_Fund		nvarchar(10) NULL,
			Welfare_Fund		nvarchar(10) NULL,
			Other_GNonRecov		nvarchar(10) NULL,
			Total_GNonRecoveries nvarchar(10) NULL
		)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	--[1]. Load Employee yearly details.
	INSERT INTO #EmpYearlyDetails(
					Sevaarth_Id,
					DDO_Code,					Yealy_Id,					Voucher_Id,					Fin_Year,					Bill_Month,					Bill_Year,					PayBill_Type,					Vourcher_Date,					Voucher_No,					Net_Pay,					[Status],					Gross_Id,					PayIn_PB_GP,					Basic_Pay,					Basic_Arrear,					Official_Pay,					Personal_Pay,					CLA_Pay,					Special_Pay,					Writer_Pay,					Leave_Salary,					DA,					DA_7PC,					Additional_DA,					Central_DA,					DA_Arrear,					DA_On_TA,					Dearness_Pay,					Additional_Pay,					HRA,					Additional_HRA,					HRA_Arrear,					HRA_Pay,					TA,					TA_Arrears,					TA_Pay,					Central_TA,					Leave_TA,					DCPS_Employer_Contribution,					ATC_Incentive_50,					ATC_Incentive_30,					Force_Incentive_100,					Force_Incentive_25,					Incentive_For_BDDS,					Arm_Allowance,					Armourer_Allowance,					BMI_Allowance,					CHPL_CPL_Allowance,					CID_Allowance,					Cash_Allowance,					Children_Educ_Allowance,					Convenyance_Allowance,					ESIS_Allowance,					Emergency_Allowance,					Extra_Lecture_Allowance,					Family_Planning_Allowance,					Fitness_Allowance,					Franking_Allowance,					Hilly_Allowance,					Kit_Maintenance_Allowance,					Mechanical_Allowance,					Med_St_Allowance,					Medical_Allowance_MA,					Medical_Education_Allowance,					Mess_Allowance,					Naxal_Area_Allowance,					Non_Practicing_Allowance,					Other_Allowances,					Other_Miscellaneous_Allowance,					Outfit_Allowance,					Peon_Allowance,					Permanent_Travelling_Allowance,					Post_Graduation_Allowance,					Project_Allowance,					Qualification_Allowance,					Refreshment_Allowance,					Special_Duty_Allowance,					Sumptuary_Allowance,					Technical_Allowance,					Tribal_Allowance,					Uniform_Allowance,					Washing_Allowance,					Flying_Allowance_For_Pilot,					Inspection_Allowance_For_Pilot,					Instructional_Allowance_For_Pilot,					Flying_Pay_For_Pilot_Cons,					Militery_Serv_Pay_Pilot,					RT_Allowance_For_Pilot,					Special_Pay_For_Pilot,					Gallantry_Awards,					IR_For_Judges,					License_Free,					UCTC,					Partially_Fully_Tax_Free,					Other,					Total_Gross,					Recov_Id,					Proffession_Tax,					Proffession_Tax_Arrears,					Income_Tax,					DCPS_Employee_Contribution,					DCPS_Pay_Arrear,					DCPS_Pay_Arrears_Recovery,					DCPS_Regular_Recovery,					DCPS_DA_Arrears_Recovery,					DCPS_Delayed_Recovery,					DedAdj_Employer_Contribution,					GIS,					Central_GIS,					GIS_IAS,					GIS_IFS,					GIS_IPS,					GIS_ZP,					GIS_Arrear,					GIS_Arrears_Recovery,					Contributory_PF,					GPF_IAS,					GPF_IAS_OtherState,					GPF_IFS,					GPF_IPS,					GPF_GRP_ABC,					GPF_ADV_GRP_ABC,					GPF_GRP_D,					GPF_ADV_GRP_D,					GPF_ABC_Arrears,					GPF_D_Arrears,					GPF_IAS_Arrears,					GPF_IFS_Arrears,					Group_Account_Policy,					House_Rent_Recovery,					HRR_Arrear,					MSLI,					PLI,					Service_Charge_and_Garage_Charge,					Service_Charge_Arr,					Co_Housing_Society,					Co_Housing_Society_Interest,					Computer_Advance,					Comp_Adv_Int,					Comp_AIS_Int,					Recovery_of_Overpayment,					FA,					HBA_Principal,					HBA_Interest,					HBA_AIS,					HBA_AIS_Int,					HBA_For_Land,					HBA_For_Land_Int,					HBA_House,					HBA_House_Int,					HIS,					MCA,					MCA_Interest,					MCA_AIS,					MCA_AIs_Int,					Other_Adv,					Other_Adv_Int,					Other_Vehical_Advance,					Other_Vehical_Advance_Interest,					Pay_Advance,					TA_Advance,					Other_GRecov,					Total_GRecoveries,					NonRec_Id,					Bank_Loan_1,					Bank_Loan_2,					Co_Op_Bank_1,					Co_Op_Bank_2,					Co_Op_Cr_Soc_1,					Co_Op_Cr_Soc_2,					Co_Op_Hsg_Soc,					LIC_1,					LIC_2,					LIC_3,					Other_Recovery_1,					Other_Recovery_2,					RD_1,					RD_2,					Con_Store,					Matralaya_Bank,					Mess_Recovery,					Miscellaneous,					Elec_Charge,					Maintenance_Charge,					Tel_Charge,					Water_Charge,					Club_Fund,					Mess_Dev_Fund,					Welfare_Fund,					Other_GNonRecov,					Total_GNonRecoveries)
			SELECT  eyd.Sevaarth_Id
					,eyd.DDO_Code
					,eyd.Yealy_Id
					,Voucher_Id=ISNULL(vd.Voucher_Id,eyd.Voucher_Id)
					,Fin_Year=ISNULL(vd.Fin_Year,eyd.Fin_Year)
					,Bill_Month=ISNULL(vd.Bill_Month,eyd.Bill_Month)
					,Bill_Year=ISNULL(vd.Bill_Year,eyd.Bill_Year)
					,PayBill_Type=ISNULL(vd.PayBill_Type,eyd.PayBill_Type)
					,Vourcher_Date=ISNULL(vd.Vourcher_Date,eyd.Vourcher_Date)
					,Voucher_No=ISNULL(vd.Voucher_No,eyd.Voucher_No)
					,eyd.Net_Pay
					,eyd.[Status]
					,eyd.Gross_Id
					,eyd.PayIn_PB_GP
					,eyd.Basic_Pay
					,eyd.Basic_Arrear
					,eyd.Official_Pay
					,eyd.Personal_Pay
					,eyd.CLA_Pay
					,eyd.Special_Pay
					,eyd.Writer_Pay
					,eyd.Leave_Salary
					,eyd.DA
					,eyd.DA_7PC
					,eyd.Additional_DA
					,eyd.Central_DA
					,eyd.DA_Arrear
					,eyd.DA_On_TA
					,eyd.Dearness_Pay
					,eyd.Additional_Pay
					,eyd.HRA
					,eyd.Additional_HRA
					,eyd.HRA_Arrear
					,eyd.HRA_Pay
					,eyd.TA
					,eyd.TA_Arrears
					,eyd.TA_Pay
					,eyd.Central_TA
					,eyd.Leave_TA
					,eyd.DCPS_Employer_Contribution
					,eyd.ATC_Incentive_50
					,eyd.ATC_Incentive_30
					,eyd.Force_Incentive_100
					,eyd.Force_Incentive_25
					,eyd.Incentive_For_BDDS
					,eyd.Arm_Allowance
					,eyd.Armourer_Allowance
					,eyd.BMI_Allowance
					,eyd.CHPL_CPL_Allowance
					,eyd.CID_Allowance
					,eyd.Cash_Allowance
					,eyd.Children_Educ_Allowance
					,eyd.Convenyance_Allowance
					,eyd.ESIS_Allowance
					,eyd.Emergency_Allowance
					,eyd.Extra_Lecture_Allowance
					,eyd.Family_Planning_Allowance
					,eyd.Fitness_Allowance
					,eyd.Franking_Allowance
					,eyd.Hilly_Allowance
					,eyd.Kit_Maintenance_Allowance
					,eyd.Mechanical_Allowance
					,eyd.Med_St_Allowance
					,eyd.Medical_Allowance_MA
					,eyd.Medical_Education_Allowance
					,eyd.Mess_Allowance
					,eyd.Naxal_Area_Allowance
					,eyd.Non_Practicing_Allowance
					,eyd.Other_Allowances
					,eyd.Other_Miscellaneous_Allowance
					,eyd.Outfit_Allowance
					,eyd.Peon_Allowance
					,eyd.Permanent_Travelling_Allowance
					,eyd.Post_Graduation_Allowance
					,eyd.Project_Allowance
					,eyd.Qualification_Allowance
					,eyd.Refreshment_Allowance
					,eyd.Special_Duty_Allowance
					,eyd.Sumptuary_Allowance
					,eyd.Technical_Allowance
					,eyd.Tribal_Allowance
					,eyd.Uniform_Allowance
					,eyd.Washing_Allowance
					,eyd.Flying_Allowance_For_Pilot
					,eyd.Inspection_Allowance_For_Pilot
					,eyd.Instructional_Allowance_For_Pilot
					,eyd.Flying_Pay_For_Pilot_Cons
					,eyd.Militery_Serv_Pay_Pilot
					,eyd.RT_Allowance_For_Pilot
					,eyd.Special_Pay_For_Pilot
					,eyd.Gallantry_Awards
					,eyd.IR_For_Judges
					,eyd.License_Free
					,eyd.UCTC
					,eyd.Partially_Fully_Tax_Free
					,eyd.Other
					,eyd.Total_Gross
					,eyd.Recov_Id
					,eyd.Proffession_Tax
					,eyd.Proffession_Tax_Arrears
					,eyd.Income_Tax
					,eyd.DCPS_Employee_Contribution
					,eyd.DCPS_Pay_Arrear
					,eyd.DCPS_Pay_Arrears_Recovery
					,eyd.DCPS_Regular_Recovery
					,eyd.DCPS_DA_Arrears_Recovery
					,eyd.DCPS_Delayed_Recovery
					,eyd.DedAdj_Employer_Contribution
					,eyd.GIS
					,eyd.Central_GIS
					,eyd.GIS_IAS
					,eyd.GIS_IFS
					,eyd.GIS_IPS
					,eyd.GIS_ZP
					,eyd.GIS_Arrear
					,eyd.GIS_Arrears_Recovery
					,eyd.Contributory_PF
					,eyd.GPF_IAS
					,eyd.GPF_IAS_OtherState
					,eyd.GPF_IFS
					,eyd.GPF_IPS
					,eyd.GPF_GRP_ABC
					,eyd.GPF_ADV_GRP_ABC
					,eyd.GPF_GRP_D
					,eyd.GPF_ADV_GRP_D
					,eyd.GPF_ABC_Arrears
					,eyd.GPF_D_Arrears
					,eyd.GPF_IAS_Arrears
					,eyd.GPF_IFS_Arrears
					,eyd.Group_Account_Policy
					,eyd.House_Rent_Recovery
					,eyd.HRR_Arrear
					,eyd.MSLI
					,eyd.PLI
					,eyd.Service_Charge_and_Garage_Charge
					,eyd.Service_Charge_Arr
					,eyd.Co_Housing_Society
					,eyd.Co_Housing_Society_Interest
					,eyd.Computer_Advance
					,eyd.Comp_Adv_Int
					,eyd.Comp_AIS_Int
					,eyd.Recovery_of_Overpayment
					,eyd.FA
					,eyd.HBA_Principal
					,eyd.HBA_Interest
					,eyd.HBA_AIS
					,eyd.HBA_AIS_Int
					,eyd.HBA_For_Land
					,eyd.HBA_For_Land_Int
					,eyd.HBA_House
					,eyd.HBA_House_Int
					,eyd.HIS
					,eyd.MCA
					,eyd.MCA_Interest
					,eyd.MCA_AIS
					,eyd.MCA_AIs_Int
					,eyd.Other_Adv
					,eyd.Other_Adv_Int
					,eyd.Other_Vehical_Advance
					,eyd.Other_Vehical_Advance_Interest
					,eyd.Pay_Advance
					,eyd.TA_Advance
					,eyd.Other_GRecov
					,eyd.Total_GRecoveries
					,eyd.NonRec_Id
					,eyd.Bank_Loan_1
					,eyd.Bank_Loan_2
					,eyd.Co_Op_Bank_1
					,eyd.Co_Op_Bank_2
					,eyd.Co_Op_Cr_Soc_1
					,eyd.Co_Op_Cr_Soc_2
					,eyd.Co_Op_Hsg_Soc
					,eyd.LIC_1
					,eyd.LIC_2
					,eyd.LIC_3
					,eyd.Other_Recovery_1
					,eyd.Other_Recovery_2
					,eyd.RD_1
					,eyd.RD_2
					,eyd.Con_Store
					,eyd.Matralaya_Bank
					,eyd.Mess_Recovery
					,eyd.Miscellaneous
					,eyd.Elec_Charge
					,eyd.Maintenance_Charge
					,eyd.Tel_Charge
					,eyd.Water_Charge
					,eyd.Club_Fund
					,eyd.Mess_Dev_Fund
					,eyd.Welfare_Fund
					,eyd.Other_GNonRecov
					,eyd.Total_GNonRecoveries
			FROM [dbo].[EmployeeData_v0] eyd 
				LEFT JOIN [dbo].[TDS_t_Voucher_Details] vd ON eyd.Voucher_Id=vd.Voucher_Id
			WHERE eyd.Sevaarth_Id=@SevaarthId --and eyd.DDO_Code=@DDOCode
				  AND vd.Vourcher_Date>=@FromDate AND vd.Vourcher_Date<=@ToDate

	--[2]. Find Min & Max Date for DDO_Code
	SELECT @MinDate=MIN(eyd.Vourcher_Date),@MaxDate=MAX(eyd.Vourcher_Date)
	FROM #EmpYearlyDetails eyd 
	WHERE eyd.DDO_Code=@DDOCode

	--[3]. Update PayBill Type
	UPDATE eyd
			SET PayBill_Type='LPC_'+PayBill_Type,
				Official_Pay=CASE WHEN Official_Pay=0 THEN Basic_Pay ELSE Official_Pay END
	FROM #EmpYearlyDetails eyd 
	WHERE eyd.Vourcher_Date<@MinDate and eyd.DDO_Code<>@DDOCode

	--[4]. Remove Transfer Paybill
	DELETE eyd
	FROM #EmpYearlyDetails eyd 
	WHERE eyd.Vourcher_Date>@MaxDate and eyd.DDO_Code<>@DDOCode


	SELECT * from  #EmpYearlyDetails order by Vourcher_Date

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END