CREATE TABLE [dbo].[TDS_t_UserLogin] (
    [login_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Office_Id]    INT            NULL,
    [User_Id]      NVARCHAR (20)  NULL,
    [Password]     NVARCHAR (200) NULL,
    [Role_Id]      INT            NULL,
    [Access_Id]    INT            NULL,
    [Last_Login]   DATETIME       NULL,
    [Created_Date] DATETIME       NULL,
    [Created_By]   INT            NULL,
    [Updated_Date] DATETIME       NULL,
    [Updated_By]   INT            NULL,
    [Status]       NVARCHAR (1)   NULL,
    CONSTRAINT [PK_Logins] PRIMARY KEY CLUSTERED ([login_Id] ASC)
);

