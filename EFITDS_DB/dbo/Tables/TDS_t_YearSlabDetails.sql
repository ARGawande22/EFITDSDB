CREATE TABLE [dbo].[TDS_t_YearSlabDetails] (
    [Slab_DetailId]    INT           IDENTITY (1, 1) NOT NULL,
    [Slab_Id]          INT           NULL,
    [Slab_Description] NVARCHAR (20) NULL,
    [Value]            NVARCHAR (20) NULL,
    [Status]           NVARCHAR (1)  NULL,
    CONSTRAINT [PK_SlabDetails] PRIMARY KEY CLUSTERED ([Slab_DetailId] ASC),
    CONSTRAINT [FK_SlabDetails_SlabMaster] FOREIGN KEY ([Slab_Id]) REFERENCES [dbo].[TDS_t_YearSlab] ([Slab_Id])
);

