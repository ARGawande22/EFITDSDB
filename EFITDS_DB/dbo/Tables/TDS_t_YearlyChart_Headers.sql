CREATE TABLE [dbo].[TDS_t_YearlyChart_Headers] (
    [Header_Id]    INT           IDENTITY (1, 1) NOT NULL,
    [OrderSeq]     INT           NULL,
    [Type]         NVARCHAR (10) NULL,
    [Header_Name]  NVARCHAR (10) NULL,
    [Display_Name] NVARCHAR (10) NULL,
    [Status]       NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_Yearly_ChartHeaders] PRIMARY KEY CLUSTERED ([Header_Id] ASC)
);

