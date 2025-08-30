CREATE TABLE [dbo].[TDS_t_Relief89_Header] (
    [Header_Id]    INT           IDENTITY (1, 1) NOT NULL,
    [OrderSeq]     INT           NULL,
    [Header_Name]  NVARCHAR (20) NULL,
    [Created_Date] DATE          NULL,
    [Status]       NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_Relief89_Header] PRIMARY KEY CLUSTERED ([Header_Id] ASC)
);

