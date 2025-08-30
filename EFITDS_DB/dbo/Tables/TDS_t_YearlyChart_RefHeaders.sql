CREATE TABLE [dbo].[TDS_t_YearlyChart_RefHeaders] (
    [Ref_Id]       INT IDENTITY (1, 1) NOT NULL,
    [Header_Id]    INT NULL,
    [Ref_HeaderId] INT NULL,
    CONSTRAINT [PK_TDS_t_Yearly_ChartRefHeaders] PRIMARY KEY CLUSTERED ([Ref_Id] ASC),
    CONSTRAINT [FK_TDS_t_Yearly_ChartRefHeaders_TDS_t_Yearly_ChartHeaders] FOREIGN KEY ([Header_Id]) REFERENCES [dbo].[TDS_t_YearlyChart_Headers] ([Header_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

