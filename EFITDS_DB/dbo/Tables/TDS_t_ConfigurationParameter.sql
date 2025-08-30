CREATE TABLE [dbo].[TDS_t_ConfigurationParameter] (
    [Config_Id] INT            IDENTITY (1, 1) NOT NULL,
    [KeyName]   NVARCHAR (50)  NULL,
    [Value]     NVARCHAR (MAX) NULL,
    [Status]    NVARCHAR (1)   NULL,
    CONSTRAINT [PK_ConfigurationParameter] PRIMARY KEY CLUSTERED ([Config_Id] ASC)
);

