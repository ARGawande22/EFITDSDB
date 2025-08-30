CREATE TABLE [dbo].[TDS_t_EmpYearly_Details] (
    [Yealy_Id]      INT            IDENTITY (1, 1) NOT NULL,
    [Sevaarth_Id]   NVARCHAR (15)  NULL,
    [DDO_Code]      NVARCHAR (11)  NULL,
    [Voucher_Id]    INT            NULL,
    [Fin_Year]      NVARCHAR (11)  NULL,
    [Bill_Month]    NVARCHAR (10)  NULL,
    [Bill_Year]     NVARCHAR (10)  NULL,
    [PayBill_Type]  NVARCHAR (255) NULL,
    [Vourcher_Date] DATE           NULL,
    [Voucher_No]    INT            NULL,
    [Net_Pay]       DECIMAL (18)   NULL,
    [Status]        NVARCHAR (1)   NULL,
    CONSTRAINT [PK_Emp_YearlyDetails] PRIMARY KEY CLUSTERED ([Yealy_Id] ASC),
    CONSTRAINT [FK_TDS_t_EmpYearly_Details_TDS_t_Voucher_Details] FOREIGN KEY ([Voucher_Id]) REFERENCES [dbo].[TDS_t_Voucher_Details] ([Voucher_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

