CREATE TABLE [dbo].[TDS_t_EmpRegime_Type] (
    [Regime_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Sevaarth_Id] NVARCHAR (15) NULL,
    [Year_Id]     INT           NULL,
    [IsNewRegime] NVARCHAR (1)  NULL,
    CONSTRAINT [PK_EmpRegime_Type] PRIMARY KEY CLUSTERED ([Regime_Id] ASC),
    CONSTRAINT [FK_TDS_t_EmpRegime_Type_TDS_t_Emp_Details] FOREIGN KEY ([Sevaarth_Id]) REFERENCES [dbo].[TDS_t_Emp_Details] ([Sevaarth_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

