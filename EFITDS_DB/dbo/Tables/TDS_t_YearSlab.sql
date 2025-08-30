CREATE TABLE [dbo].[TDS_t_YearSlab] (
    [Slab_Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Year_Id]           INT           NULL,
    [StandardDeduction] NVARCHAR (10) NULL,
    [Rebate]            NVARCHAR (20) NULL,
    [EducationalCess]   INT           NULL,
    [Surcharge]         NVARCHAR (20) NULL,
    [IsNewRegime]       NVARCHAR (1)  NULL,
    [IsSeniorCitizen]   NVARCHAR (1)  NULL,
    [Status]            NVARCHAR (1)  NULL,
    CONSTRAINT [PK_SlabMaster] PRIMARY KEY CLUSTERED ([Slab_Id] ASC),
    CONSTRAINT [FK_SlabMaster_Years] FOREIGN KEY ([Year_Id]) REFERENCES [dbo].[TDS_t_Year] ([Year_Id])
);

