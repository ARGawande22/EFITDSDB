USE TDSLive;
GO

Create OR Alter Procedure [dbo].[TDS_sp_GetVoucherDetails]
	@DDOCode NVARCHAR(10)
	,@FinYear NVARCHAR(11)
	,@Quarter CHAR(3)
	,@FormType CHAR(3)=NULL

--***********************************************************
--***
--*** Created On 12 Sep 2025 By A.R.Gawande
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

	--Get Voucher Details
	SELECT	v.Voucher_Id
			,v.DDO_Code
			,v.BillHead
			,v.Bill_Month
			,v.Bill_Year
			,v.PayBill_Type
			,v.Form_Type
			,v.SubForm_Type
			,v.Vourcher_Date
			,v.Voucher_No
			,v.Voucher_Amount
			,v.SourceId
			,v.Source
			,v.Kosh
			,v.Bin
			,v.Oltas
			,v.[Status]		   
	FROM dbo.SelVoucher_v0 v
	WHERE v.DDO_Code=@DDOCode
		AND v.Vourcher_Date >=@FromDate AND v.Vourcher_Date<=@ToDate
		AND (@FormType IS NULL OR v.Form_Type=@FormType)
	ORDER BY v.Vourcher_Date,v.Voucher_No

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
