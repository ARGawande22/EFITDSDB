CREATE TABLE [dbo].[TDS_t_EmpBank_Details] (
    [Bank_Id]            INT           IDENTITY (1, 1) NOT NULL,
    [Sevaarth_Id]        NVARCHAR (15) NULL,
    [Account_No]         NVARCHAR (50) NULL,
    [Bank_Name]          NVARCHAR (50) NULL,
    [IFSC_Code]          NVARCHAR (11) NULL,
    [GPF_DCPS_AccountNo] NVARCHAR (50) NULL,
    [Status]             NVARCHAR (1)  NULL,
    CONSTRAINT [PK_EmpBank_Details] PRIMARY KEY CLUSTERED ([Bank_Id] ASC),
    CONSTRAINT [FK_TDS_t_EmpBank_Details_TDS_t_Emp_Details] FOREIGN KEY ([Sevaarth_Id]) REFERENCES [dbo].[TDS_t_Emp_Details] ([Sevaarth_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

