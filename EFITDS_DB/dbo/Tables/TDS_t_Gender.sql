CREATE TABLE [dbo].[TDS_t_Gender] (
    [Gender_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Gender]    NVARCHAR (50) NULL,
    [Status]    NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED ([Gender_Id] ASC)
);

