CREATE TABLE [dbo].[TDS_t_CalChart_Headers] (
    [Header_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [OrderSeq]     INT            NULL,
    [Header_Name]  NVARCHAR (MAX) NULL,
    [Display_Name] NVARCHAR (10)  NULL,
    [isEditable]   NVARCHAR (1)   NULL,
    [Created_Date] DATETIME       NULL,
    [Status]       NVARCHAR (1)   NULL,
    CONSTRAINT [PK_TDS_t_CalChart_Headers] PRIMARY KEY CLUSTERED ([Header_Id] ASC)
);

