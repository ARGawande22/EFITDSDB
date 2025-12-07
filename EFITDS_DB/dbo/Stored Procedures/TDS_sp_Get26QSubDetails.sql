USE [TDSLive]
GO

/****** Object:  StoredProcedure [dbo].[TDS_sp_Get26QSubDetails]    Script Date: 30/11/2025 14:17:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create   Procedure [dbo].[TDS_sp_Get26QSubDetails]
	@VoucherId INT

--***********************************************************
--***
--*** Created On 02 Oct 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@Status CHAR(1)

	--Get Voucher Employee Details
	SELECT	sd.Yealy_Id
			,sd.Supplier_Id
			,sd.Supplier_Name
			,sd.PAN_No
			,sd.Pan_Status
			,sd.DDO_Code
			,sd.Voucher_Id
			,Fin_Year=ISNULL(vd.Fin_Year, sd.Fin_Year)
			,Vourcher_Date=ISNULL(vd.Vourcher_Date, sd.Vourcher_Date)
			,Voucher_No=ISNULL(vd.Voucher_No, sd.Voucher_No)
			,sd.Income_Tax
			,sd.Gross_Amt
			,sd.Section_Id
			,s.Section
			,sd.InterestRate
			,sd.Status
	FROM dbo.TDS_t_26QSub_Details sd	    
		INNER JOIN dbo.TDS_t_ITSection s ON sd.Section_Id=s.Section_Id
		LEFT JOIN dbo.TDS_t_Voucher_Details  vd ON sd.Voucher_Id=vd.Voucher_Id
	WHERE sd.Voucher_Id=@VoucherId and sd.[Status]='Y'
	ORDER BY sd.Yealy_Id

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
GO


