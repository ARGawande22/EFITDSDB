CREATE TABLE [dbo].[TDS_t_Designations] (
    [Designation_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Designation]    NVARCHAR (50) NULL,
    [Status]         NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Designations] PRIMARY KEY CLUSTERED ([Designation_Id] ASC)
);

