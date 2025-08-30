
Create   Procedure [dbo].[TDS_sp_selVoucherDetails]
	@DDOCode	NVARCHAR(10),
	@FinYear	NVARCHAR(11)=NULL,
	@Quarter	NVARCHAR(3)=NULL,
	@FromDate	DATETIME,
	@ToDate		DATETIME,
	@IsBinMatching		INT=0
	

--***********************************************************
--***
--*** Created On 26 Jul 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg		NVARCHAR(255)

	SELECT Voucher_Id
			,DDO_Code
			,BillHead
			,Fin_Year
			,[Quarter]
			,Bill_Month
			,Bill_Year
			,PayBill_Type
			,Form_Type
			,Vourcher_Date
			,Voucher_No
			,Voucher_Amount
			,Koshwahini=CASE WHEN IsKoshwahini='N' THEN
								CASE WHEN Voucher_Amount=0 THEN 'Matched'
								ELSE 'UnMatched' END
							ELSE 'Matched'
						END
			,Binview=CASE WHEN IsBinview='Y'THEN 'Matched'
						ELSE  'UnMatched'							 
					 END
			,Oltas=CASE WHEN IsOltas='Y'THEN 'Matched'
						ELSE CASE WHEN SourceId in(1,2) THEN ''
								ELSE 'UnMatched'
							 END
					 END
			,[Source]=CASE WHEN SourceId=1 THEN 'Sevaarth'
						   WHEN SourceId=2 THEN 'Koshwahini'
						   WHEN SourceId=3 THEN 'Oltas'
						ELSE 'Undefined'
					  END
			,InsertedOn=CONVERT(Date, InsertedOn,23)
			,InsertedBy
			,iUserId=ul.[User_Id]
			,UpdatedOn=CONVERT(Date, UpdatedOn,23)
			,updatedBy
			,uUserId=ul1.[User_Id]
			,vd.[Status]
	FROM [dbo].[TDS_t_Voucher_Details] vd with(nolock)
		LEFT JOIN [dbo].[TDS_t_UserLogin] ul with(nolock) on vd.InsertedBy=ul.login_Id
		LEFT JOIN [dbo].[TDS_t_UserLogin] ul1 with(nolock) on vd.updatedBy=ul1.login_Id
	WHERE DDO_Code=@DDOCode 
			AND Vourcher_Date>=@FromDate AND Vourcher_Date <=@ToDate
			AND ((@IsBinMatching=1 AND SourceId IN(1,2) AND Voucher_Amount>0) OR (@IsBinMatching=0 AND SourceId IN(1,2,3)))
	ORDER BY Vourcher_Date,Voucher_No

	IF(@@ERROR <> 0)
		BEGIN
			Select @ErrMsg='Error fetching Voucher details...'
			GOTO spError
		END

	SET NOCOUNT OFF

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_selVoucherDetails: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET NOCOUNT OFF

	RETURN(-1)
END