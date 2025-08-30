CREATE TABLE [dbo].[TDS_t_Relief89_Details] (
    [Relief_DetailId]     INT           IDENTITY (1, 1) NOT NULL,
    [Relief_Id]           INT           NULL,
    [FinYear]             NVARCHAR (20) NULL,
    [SalaryExcluding_Arr] DECIMAL (18)  NULL,
    [Arrier]              DECIMAL (18)  NULL,
    [TaxOnEmployment]     DECIMAL (18)  NULL,
    [OtherIncome]         DECIMAL (18)  NULL,
    [DeductionUnder_VIA]  DECIMAL (18)  NULL,
    [CalcRelief]          DECIMAL (18)  NULL,
    [Status]              NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_Relief89_Details] PRIMARY KEY CLUSTERED ([Relief_DetailId] ASC),
    CONSTRAINT [FK_TDS_t_Relief89_Details_TDS_t_Relief89] FOREIGN KEY ([Relief_Id]) REFERENCES [dbo].[TDS_t_Relief89] ([Relief_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

