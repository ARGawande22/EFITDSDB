CREATE TABLE [dbo].[TDS_t_Office_DDODetails] (
    [DDO_Code]       NVARCHAR (11)  NOT NULL,
    [Office_Id]      INT            NULL,
    [DDO_Name]       NVARCHAR (50)  NULL,
    [Designation_Id] INT            NULL,
    [DDO_PANNo]      NVARCHAR (10)  NULL,
    [DOB]            DATE           NULL,
    [Gender_Id]      INT            NULL,
    [Address]        NVARCHAR (255) NULL,
    [City_Id]        INT            NULL,
    [PinCode]        INT            NULL,
    [Contact_No]     NVARCHAR (13)  NULL,
    [Email_Id]       NVARCHAR (50)  NULL,
    [Status]         NVARCHAR (1)   NULL,
    CONSTRAINT [PK_DDO_Details] PRIMARY KEY CLUSTERED ([DDO_Code] ASC),
    CONSTRAINT [FK_TDS_t_Office_DDODetails_TDS_t_Office_Details] FOREIGN KEY ([Office_Id]) REFERENCES [dbo].[TDS_t_Office_Details] ([Office_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

