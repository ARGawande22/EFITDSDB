CREATE TABLE [dbo].[TDS_t_DeductorTypes] (
    [Type_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Type]    NVARCHAR (50) NULL,
    [Status]  NVARCHAR (1)  NULL,
    CONSTRAINT [PK_DeductorTypes] PRIMARY KEY CLUSTERED ([Type_Id] ASC)
);

