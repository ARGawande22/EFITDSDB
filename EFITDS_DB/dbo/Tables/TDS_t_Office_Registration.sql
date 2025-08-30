CREATE TABLE [dbo].[TDS_t_Office_Registration] (
    [Reg_Id]          INT            IDENTITY (1, 1) NOT NULL,
    [TAN_No]          NVARCHAR (10)  NULL,
    [Office_Name]     NVARCHAR (255) NULL,
    [PAN_No]          NVARCHAR (10)  NULL,
    [AIN_No]          NVARCHAR (7)   NULL,
    [Address]         NVARCHAR (255) NULL,
    [City_Id]         INT            NULL,
    [PinCode]         INT            NULL,
    [Contact_No]      NVARCHAR (13)  NULL,
    [Email_Id]        NVARCHAR (50)  NULL,
    [Type_Id]         INT            NULL,
    [Reg_Date]        DATETIME       NULL,
    [CheckedBy]       INT            NULL,
    [Checked_Date]    DATETIME       NULL,
    [ApproveBy]       INT            NULL,
    [Approved_Date]   DATETIME       NULL,
    [RefOffice_Id]    INT            NULL,
    [RejectedBy]      INT            NULL,
    [Rejected_Date]   DATETIME       NULL,
    [Rejected_Reason] INT            NULL,
    CONSTRAINT [PK_TDS_t_Office_Registration] PRIMARY KEY CLUSTERED ([Reg_Id] ASC)
);

