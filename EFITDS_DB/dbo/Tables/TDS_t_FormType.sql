CREATE TABLE [dbo].[TDS_t_FormType] (
    [FType_Id] INT            IDENTITY (1, 1) NOT NULL,
    [OrderSeq] INT            NULL,
    [FormType] NVARCHAR (255) NOT NULL,
    [Status]   NVARCHAR (1)   NOT NULL,
    CONSTRAINT [PK_TDS_t_FormType] PRIMARY KEY CLUSTERED ([FType_Id] ASC)
);

