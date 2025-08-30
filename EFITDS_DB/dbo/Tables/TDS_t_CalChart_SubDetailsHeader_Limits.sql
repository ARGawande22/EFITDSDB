CREATE TABLE [dbo].[TDS_t_CalChart_SubDetailsHeader_Limits] (
    [Limit_id]           INT           IDENTITY (1, 1) NOT NULL,
    [SubDetailHeader_Id] INT           NULL,
    [Year_Id]            INT           NULL,
    [Limit_Value]        NVARCHAR (10) NULL,
    [Status]             NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_CalChart_SubDetailsHeader_Limits] PRIMARY KEY CLUSTERED ([Limit_id] ASC),
    CONSTRAINT [FK_TDS_t_CalChart_SubDetailsHeader_Limits_TDS_t_CalChart_SubDetailHeaders] FOREIGN KEY ([SubDetailHeader_Id]) REFERENCES [dbo].[TDS_t_CalChart_SubDetailHeaders] ([SubDetailHeader_Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_TDS_t_CalChart_SubDetailsHeader_Limits_TDS_t_Year] FOREIGN KEY ([Year_Id]) REFERENCES [dbo].[TDS_t_Year] ([Year_Id])
);

