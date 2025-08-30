CREATE TABLE [dbo].[TDS_t_City] (
    [City_Id]      INT           IDENTITY (1, 1) NOT NULL,
    [State_Id]     INT           NULL,
    [CityName]     NVARCHAR (50) NULL,
    [Created_Date] DATETIME      NULL,
    [Status]       NVARCHAR (1)  NULL,
    CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED ([City_Id] ASC),
    CONSTRAINT [FK_City_State] FOREIGN KEY ([State_Id]) REFERENCES [dbo].[TDS_t_States] ([State_Id])
);

