CREATE TABLE [dbo].[TDS_t_Header] (
    [Header_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Regards]         NVARCHAR (20)  NULL,
    [MainHeader_Name] NVARCHAR (255) NULL,
    [IsDisplay]       NVARCHAR (1)   NULL,
    [Status]          NVARCHAR (1)   NULL,
    CONSTRAINT [PK_MainHeader] PRIMARY KEY CLUSTERED ([Header_Id] ASC)
);

