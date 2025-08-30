CREATE TABLE [dbo].[TDS_t_Office_Details] (
    [Office_Id]      INT            IDENTITY (1, 1) NOT NULL,
    [TAN_No]         NVARCHAR (10)  NULL,
    [Office_Name]    NVARCHAR (255) NULL,
    [Office_PANNo]   NVARCHAR (10)  NULL,
    [GSTIN]          NVARCHAR (50)  NULL,
    [AIN_No]         NVARCHAR (7)   NULL,
    [Address]        NVARCHAR (255) NULL,
    [City_Id]        INT            NULL,
    [PinCode]        INT            NULL,
    [Contact_No]     NVARCHAR (13)  NULL,
    [Email_Id]       NVARCHAR (50)  NULL,
    [Type_Id]        INT            NULL,
    [Profile_Status] INT            NULL,
    [CreatedOn]      DATETIME       NULL,
    [CreatedBy]      INT            NULL,
    [UpdatedOn]      DATETIME       NULL,
    [UpdatedBy]      INT            NULL,
    [Status]         NVARCHAR (1)   NULL,
    CONSTRAINT [PK_Office_Details] PRIMARY KEY CLUSTERED ([Office_Id] ASC)
);

