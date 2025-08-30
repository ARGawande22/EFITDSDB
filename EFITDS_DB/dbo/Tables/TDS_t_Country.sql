CREATE TABLE [dbo].[TDS_t_Country] (
    [Country_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [CountryCode]  NVARCHAR (2)  NULL,
    [CountryName]  NVARCHAR (50) NULL,
    [Created_Date] DATETIME      NULL,
    [Status]       NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([Country_Id] ASC)
);

