CREATE TABLE [dbo].[TDS_t_Quarter] (
    [Quarter_Id] INT           IDENTITY (1, 1) NOT NULL,
    [OrderSeq]   INT           NULL,
    [Quarter]    NVARCHAR (10) NOT NULL,
    [Status]     NVARCHAR (1)  NOT NULL,
    CONSTRAINT [PK_TDS_t_Quarter] PRIMARY KEY CLUSTERED ([Quarter_Id] ASC)
);

