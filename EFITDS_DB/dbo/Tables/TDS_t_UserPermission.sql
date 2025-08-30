CREATE TABLE [dbo].[TDS_t_UserPermission] (
    [Access_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Access]    NVARCHAR (50) NULL,
    [Status]    NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Access] PRIMARY KEY CLUSTERED ([Access_Id] ASC)
);

