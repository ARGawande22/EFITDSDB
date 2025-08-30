CREATE TABLE [dbo].[TDS_t_Relief89_SubHeader] (
    [SubHeader_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Header_Id]      INT           NULL,
    [OrderSeq]       INT           NULL,
    [SubHeader_Name] NVARCHAR (20) NULL,
    [Created_Date]   DATE          NULL,
    [Status]         NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_Relief89_SubHeader] PRIMARY KEY CLUSTERED ([SubHeader_Id] ASC),
    CONSTRAINT [FK_TDS_t_Relief89_SubHeader_TDS_t_Relief89_Header] FOREIGN KEY ([Header_Id]) REFERENCES [dbo].[TDS_t_Relief89_Header] ([Header_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

