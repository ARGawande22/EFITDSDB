CREATE TABLE [dbo].[TDS_t_HeadersDetails] (
    [Details_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Header_Id]         INT            NULL,
    [DetailHeader_Name] NVARCHAR (255) NULL,
    [Status]            NVARCHAR (1)   NULL,
    CONSTRAINT [PK_DetailHeaders] PRIMARY KEY CLUSTERED ([Details_Id] ASC),
    CONSTRAINT [FK_DetailHeaders_MainHeader] FOREIGN KEY ([Header_Id]) REFERENCES [dbo].[TDS_t_Header] ([Header_Id])
);

