CREATE TABLE [dbo].[TDS_t_Months] (
    [Month_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Month_Name] NVARCHAR (50) NULL,
    [Status]     NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Months] PRIMARY KEY CLUSTERED ([Month_Id] ASC)
);

