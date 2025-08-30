CREATE TABLE [dbo].[TDS_t_Reject_Reasons] (
    [Reason_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Reason]       NVARCHAR (255) NULL,
    [Created_Date] DATETIME       NULL,
    [CreatedBy]    INT            NULL,
    [Status]       NVARCHAR (1)   NULL,
    CONSTRAINT [PK_Reject_Reasons] PRIMARY KEY CLUSTERED ([Reason_Id] ASC)
);

