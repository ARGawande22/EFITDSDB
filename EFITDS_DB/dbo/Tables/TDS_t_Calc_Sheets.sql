CREATE TABLE [dbo].[TDS_t_Calc_Sheets] (
    [CalcSheet_Id]  INT           IDENTITY (1, 1) NOT NULL,
    [Sevaarth_Id]   NVARCHAR (15) NULL,
    [Year_Id]       INT           NULL,
    [IsNewRegime]   NVARCHAR (1)  NULL,
    [Created_Date]  DATETIME      NULL,
    [Last_Modified] DATETIME      NULL,
    [ModifiedBy]    INT           NULL,
    [Status]        NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_Calc_Sheets] PRIMARY KEY CLUSTERED ([CalcSheet_Id] ASC),
    CONSTRAINT [FK_TDS_t_Calc_Sheets_TDS_t_Emp_Details] FOREIGN KEY ([Sevaarth_Id]) REFERENCES [dbo].[TDS_t_Emp_Details] ([Sevaarth_Id]),
    CONSTRAINT [FK_TDS_t_Calc_Sheets_TDS_t_Year] FOREIGN KEY ([Year_Id]) REFERENCES [dbo].[TDS_t_Year] ([Year_Id])
);

