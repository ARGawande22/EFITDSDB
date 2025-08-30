CREATE TABLE [dbo].[TDS_t_Office_Credentials] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [Office_Id]     INT           NULL,
    [Credential_Id] INT           NULL,
    [User_Id]       NVARCHAR (50) NULL,
    [Password]      NVARCHAR (50) NULL,
    [Status]        NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TDS_t_Office_Credentials_TDS_t_Office_Details] FOREIGN KEY ([Office_Id]) REFERENCES [dbo].[TDS_t_Office_Details] ([Office_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

