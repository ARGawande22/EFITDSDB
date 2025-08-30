CREATE TABLE [dbo].[TDS_t_Oltas_OtherDetails] (
    [Oltas_DetailId]      INT            IDENTITY (1, 1) NOT NULL,
    [Oltas_Id]            INT            NULL,
    [TAN_No]              NVARCHAR (10)  NULL,
    [Office_Name]         NVARCHAR (MAX) NULL,
    [AssessmentYear]      NVARCHAR (50)  NULL,
    [FinancialYear]       NVARCHAR (50)  NULL,
    [MajorHead]           NVARCHAR (MAX) NULL,
    [MinorHead]           NVARCHAR (MAX) NULL,
    [NatureofPayment]     NVARCHAR (MAX) NULL,
    [AmountinWords]       NVARCHAR (MAX) NULL,
    [CIN]                 NVARCHAR (MAX) NULL,
    [ModeofPayment]       NVARCHAR (MAX) NULL,
    [BankName]            NVARCHAR (MAX) NULL,
    [BankReferenceNumber] NVARCHAR (MAX) NULL,
    [Source]              NVARCHAR (MAX) NULL
);

