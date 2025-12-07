
Create   Procedure [dbo].[TDS_sp_insupdOltasData]
	@loginId INT
	,@DDOCode NVARCHAR(10) = NULL
	,@FinYear NVARCHAR(11) = NULL
	,@Oltasxml TEXT
	,@Status INT  OUTPUT
--***********************************************************
--***
--*** Created On 27 July 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @GetDate	DATETIME,
			@XMLDocumentHandle  INT,
			@XMLPrepared	INT,
			@ErrMsg		NVARCHAR(255),			
			@rc			SMALLINT,
			@Exists		INT
			
			
	SET @GetDate=GETDATE();

	--open & prepare the XML document for reading into temporary tables.
	EXEC @XMLPrepared=sp_XML_preparedocument @XMLDocumentHandle OUTPUT,@Oltasxml

	IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error while loading XML.'
		GOTO spError
	END

	IF OBJECT_ID('tempdb..#OltasDetails') IS NOT NULL
		DROP TABLE #OltasDetails

	CREATE TABLE #OltasDetails(
				Form_Type		char(3)			 NOT NULL,
				Challan_Date	date			 NOT NULL,
				Challan_No		nvarchar(10)	 NOT NULL,
				Received_Date	date			 NOT NULL,
				BSR_Code		nvarchar(10)	 NOT NULL,
				Ded_Amount		decimal(18, 0)	 NOT NULL,
				TAN_No			nvarchar(10)	 NULL,
				Office_Name		nvarchar(Max)	 NULL,
				AssessmentYear	nvarchar(50)	 NULL,
				FinancialYear	nvarchar(50)	 NULL,
				MajorHead		nvarchar(Max)	 NULL,
				MinorHead		nvarchar(Max)	 NULL,
				NatureofPayment	nvarchar(Max)	 NULL,
				AmountinWords	nvarchar(Max)	 NULL,
				CIN				nvarchar(Max)	 NULL,
				ModeofPayment	nvarchar(Max)	 NULL,
				BankName		nvarchar(Max)	 NULL,
				BankReferenceNumber	nvarchar(Max)	 NULL,
				[Source]		nvarchar(Max)	 NULL				
		)

    IF(@@ERROR <> 0)
	BEGIN
		Select @ErrMsg='Error creating temporary Table.'
		GOTO spError
	END

	INSERT INTO #OltasDetails(
					Form_Type,
					Challan_Date,
					Challan_No,					Received_Date,					BSR_Code,					Ded_Amount,
					TAN_No,
					Office_Name,
					AssessmentYear,
					FinancialYear,
					MajorHead,
					MinorHead,
					NatureofPayment,
					AmountinWords,
					CIN,
					ModeofPayment,
					BankName,
					BankReferenceNumber,
					[Source])
		SELECT		Form_Type,
					Challan_Date=CASE WHEN Challan_Date=CAST('0001-01-01' as date) THEN NULL ELSE Challan_Date END,
					Challan_No,					Received_Date=CASE WHEN Challan_Date=CAST('0001-01-01' as date) THEN NULL ELSE Challan_Date END,					BSR_Code,					Ded_Amount,
					TAN_No,
					Office_Name,
					AssessmentYear,
					FinancialYear,
					MajorHead,
					MinorHead,
					NatureofPayment,
					AmountinWords,
					CIN,
					ModeofPayment,
					BankName,
					BankReferenceNumber,
					[Source]
			FROM OPENXML(@XMLDocumentHandle ,'/OltasVouchers/OltasVoucher', 2) WITH
						   (Form_Type			char(3) 'FormType',
							Challan_Date			date 'ChallanDate',
							Challan_No			nvarchar(10) 'ChallanNo',	
							Received_Date			date 'ReceivedDate',
							BSR_Code			nvarchar(10) 'BSRCode',
							Ded_Amount			Decimal 'VoucherAmount',
							TAN_No				nvarchar(10) 'TANNo',
							Office_Name			nvarchar(Max) 'OfficeName',
							AssessmentYear		nvarchar(50)  'AssessmentYear',
							FinancialYear		nvarchar(50)   'FinancialYear',
							MajorHead			nvarchar(Max) 'MajorHead',
							MinorHead			nvarchar(Max) 'MinorHead',
							NatureofPayment		nvarchar(Max) 'NatureofPayment',
							AmountinWords		nvarchar(Max) 'AmountinWords',
							CIN					nvarchar(Max) 'CIN',
							ModeofPayment		nvarchar(Max) 'ModeofPayment',
							BankName			nvarchar(Max) 'BankName',
							BankReferenceNumber	nvarchar(Max) 'BankReferenceNumber',
							[Source]			nvarchar(Max) 'Source')

    IF(@@ERROR <> 0)
	 BEGIN
	 	Select @ErrMsg='Error while loading bin details from XML.'
	 	GOTO spError
	 END	
	 	
	DECLARE	@Oltas_Id				INT,
			@Voucher_Id				INT,
			@Quarter				NVARCHAR(3)

    DECLARE @DDO_Code				NVARCHAR(11),
			@Form_Type				NVARCHAR(3),
			@Challan_Date			Datetime,
			@Challan_No				NVARCHAR(10),
			@Received_Date			Datetime,
			@BSR_Code				NVARCHAR(10),
			@Ded_Amount				Decimal,
			@TAN_No					NVARCHAR(10),
			@Office_Name			NVARCHAR(MAX),
			@AssessmentYear			NVARCHAR(50),
			@FinancialYear			NVARCHAR(50),
			@MajorHead				NVARCHAR(MAX),
			@MinorHead				NVARCHAR(MAX),
			@NatureofPayment		NVARCHAR(MAX),
			@AmountinWords			NVARCHAR(MAX),
			@CIN					NVARCHAR(MAX),
			@ModeofPayment			NVARCHAR(MAX),
			@BankName				NVARCHAR(MAX),
			@BankReferenceNumber	NVARCHAR(MAX),
			@Source					NVARCHAR(MAX)

	DECLARE K CURSOR LOCAL READ_ONLY FOR
	SELECT Form_Type,Challan_Date,Challan_No,Received_Date,BSR_Code,Ded_Amount,TAN_No,Office_Name,AssessmentYear,FinancialYear,MajorHead,MinorHead,
	NatureofPayment,AmountinWords,CIN,ModeofPayment,BankName,BankReferenceNumber,[Source] FROM #OltasDetails 
	OPEN K
		FETCH NEXT FROM K INTO @Form_Type,@Challan_Date,@Challan_No,@Received_Date,@BSR_Code,@Ded_Amount,@TAN_No,@Office_Name,@AssessmentYear,
							@FinancialYear,@MajorHead,@MinorHead,@NatureofPayment,@AmountinWords,@CIN,@ModeofPayment,@BankName,@BankReferenceNumber,@Source
		WHILE (@@FETCH_STATUS<>-1)
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				--[1]. Get the DDO Code based on TAN_No
				SET @DDO_Code=(SELECT ddo.DDO_Code FROM [dbo].[TDS_t_Office_Details] o JOIN [dbo].[TDS_t_Office_DDODetails] ddo 
													 ON o.Office_Id=ddo.Office_Id WHERE o.TAN_No=@TAN_No AND o.Status='Y')

				IF(@DDO_Code IS NOT NULL)
				BEGIN
					SET @Oltas_Id=(SELECT Oltas_Id FROM [dbo].[TDS_t_Oltas_Details] WHERE Challan_Date=@Challan_Date AND Challan_No=@Challan_No
													AND Received_Date=@Received_Date AND BSR_Code=@BSR_Code AND Ded_Amount=@Ded_Amount
													AND  DDO_Code=@DDO_Code)
					SET @Voucher_Id=(SELECT Voucher_Id FROM [dbo].[TDS_t_Oltas_Details] WHERE Oltas_Id=@Oltas_Id)

					SET @Quarter= (SELECT [dbo].[GetOltasQuarter] (@Challan_Date ,@FinancialYear))

					If(@Oltas_Id<=0 OR @Oltas_Id IS NULL)
					BEGIN
						--[2]. Insert Voucher Details
							INSERT INTO [dbo].[TDS_t_Voucher_Details](
												[DDO_Code],
												[BillHead],
												[Fin_Year],
												[Quarter],
												[Bill_Month],
												[Bill_Year],
												[PayBill_Type],
												[Form_Type],
												[Voucher_No],
												[Vourcher_Date],
												[Voucher_Amount],
												[IsKoshwahini],
												[IsBinview],
												[IsOltas],
												[SourceId],
												[InsertedOn],
												[InsertedBy],
												[Status])
									     VALUES(@DDO_Code,
												@CIN,
												@FinancialYear,
												@Quarter,
												NULL,
												Year(@Challan_Date),
												NULL,
												@Form_Type,
												@Challan_No,
												CONVERT(DATE, @Challan_Date),
												@Ded_Amount,
												'N',
												'N',
												'N',
												'3',
												@GetDate,
												@loginId,
												'Y')
						
							IF(@@ERROR <> 0 OR @@IDENTITY=0)
							BEGIN
								Select @ErrMsg='Error checking Voucher details'
								GOTO spError
							END

							SET @Voucher_Id=@@IDENTITY;

							IF(@Voucher_Id<>0)
							BEGIN
								   INSERT INTO [dbo].[TDS_t_Oltas_Details](
												DDO_Code,
												Voucher_Id,
												Challan_Date,
												Challan_No,
												Received_Date,
												BSR_Code,
												Ded_Amount,
												[Status])
										 VALUES(@DDO_Code,
												@Voucher_Id,
												CONVERT(DATE, @Challan_Date),
												@Challan_No,
												CONVERT(DATE, @Received_Date),
												@BSR_Code,
												@Ded_Amount,
												'Y')
									
									IF(@@ERROR <> 0 OR @@IDENTITY=0)
									BEGIN
										Select @ErrMsg='Error checking Voucher details'
										GOTO spError
									END

									SET @Oltas_Id=@@IDENTITY;

									IF(@Oltas_Id<>0)
									BEGIN
										INSERT INTO [dbo].[TDS_t_Oltas_OtherDetails](
														Oltas_Id,
														TAN_No,
														Office_Name,
														AssessmentYear,
														FinancialYear,
														MajorHead,
														MinorHead,
														NatureofPayment,
														AmountinWords,
														CIN,
														ModeofPayment,
														BankName,
														BankReferenceNumber,
														[Source])
												VALUES(@Oltas_Id,
														@TAN_No,
														@Office_Name,
														@AssessmentYear,
														@FinancialYear,
														@MajorHead,
														@MinorHead,
														@NatureofPayment,
														@AmountinWords,
														@CIN,
														@ModeofPayment,
														@BankName,
														@BankReferenceNumber,
														@Source)
									END
								END
					END
				END
			END
			FETCH NEXT FROM K INTO @Form_Type,@Challan_Date,@Challan_No,@Received_Date,@BSR_Code,@Ded_Amount,@TAN_No,@Office_Name,@AssessmentYear,
							@FinancialYear,@MajorHead,@MinorHead,@NatureofPayment,@AmountinWords,@CIN,@ModeofPayment,@BankName,@BankReferenceNumber,@Source
		END
	CLOSE K
	DEALLOCATE K

	SET @Status=1;

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg='TDS_sp_insupdBinData: '+@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	SET @Status=0;

	RETURN(-1)
END