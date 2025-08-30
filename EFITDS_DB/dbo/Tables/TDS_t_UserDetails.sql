CREATE TABLE [dbo].[TDS_t_UserDetails] (
    [Detail_Id]  INT            IDENTITY (1, 1) NOT NULL,
    [login_Id]   INT            NULL,
    [User_Name]  NVARCHAR (50)  NULL,
    [Gender_Id]  INT            NULL,
    [Address]    NVARCHAR (255) NULL,
    [City_Id]    INT            NULL,
    [PinCode]    INT            NULL,
    [Contact_No] NVARCHAR (13)  NULL,
    [Email_Id]   NVARCHAR (50)  NULL,
    CONSTRAINT [PK_UserDetails] PRIMARY KEY CLUSTERED ([Detail_Id] ASC)
);

