CREATE TABLE [dbo].[TDS_t_CrendetialTypes] (
    [Credential_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Credential_Type] NVARCHAR (50) NULL,
    [Status]          NVARCHAR (1)  NULL,
    CONSTRAINT [PK_CrendetialTypes] PRIMARY KEY CLUSTERED ([Credential_Id] ASC)
);

