CREATE TABLE [dbo].[TDS_t_UserRole] (
    [Role_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Role]    NVARCHAR (50) NULL,
    [Status]  NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([Role_Id] ASC)
);

