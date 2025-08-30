CREATE TABLE [dbo].[TDS_t_CalChart_SubHeaders] (
    [SubHeader_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Header_Id]      INT            NULL,
    [OrderSeq]       INT            NULL,
    [SubHeader_Name] NVARCHAR (MAX) NULL,
    [Display_Name]   NVARCHAR (50)  NULL,
    [Ref_Id]         INT            NULL,
    [isEditable]     NVARCHAR (1)   NULL,
    [IsMultiline]    NVARCHAR (1)   NULL,
    [IsNewRegime]    NVARCHAR (1)   NULL,
    [Created_Date]   DATETIME       NULL,
    [Status]         NVARCHAR (1)   NULL,
    CONSTRAINT [PK_TDS_t_CalChart_SubHeaders] PRIMARY KEY CLUSTERED ([SubHeader_Id] ASC),
    CONSTRAINT [FK_TDS_t_CalChart_SubHeaders_TDS_t_CalChart_Headers] FOREIGN KEY ([Header_Id]) REFERENCES [dbo].[TDS_t_CalChart_Headers] ([Header_Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_TDS_t_CalChart_SubHeaders_TDS_t_YearlyChart_Headers] FOREIGN KEY ([Ref_Id]) REFERENCES [dbo].[TDS_t_YearlyChart_Headers] ([Header_Id])
);

