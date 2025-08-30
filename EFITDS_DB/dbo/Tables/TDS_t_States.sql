CREATE TABLE [dbo].[TDS_t_States] (
    [State_Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Country_Id]         INT           NULL,
    [StateCode]          NVARCHAR (2)  NULL,
    [StateCode_AsperGST] INT           NULL,
    [StateName]          NVARCHAR (50) NULL,
    [Created_Date]       DATETIME      NULL,
    [Status]             NVARCHAR (1)  NULL,
    CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([State_Id] ASC),
    CONSTRAINT [FK_State_Country] FOREIGN KEY ([Country_Id]) REFERENCES [dbo].[TDS_t_Country] ([Country_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

