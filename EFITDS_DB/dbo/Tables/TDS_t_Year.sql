CREATE TABLE [dbo].[TDS_t_Year] (
    [Year_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [OrderSeq]    INT            NULL,
    [Fin_Year]    NVARCHAR (10)  NULL,
    [ITR_DueDate] DATE           NULL,
    [Lock_Date]   DATE           NULL,
    [RPUPath]     NVARCHAR (255) NULL,
    [RPUName]     NVARCHAR (255) NULL,
    [RPUWinName]  NVARCHAR (255) NULL,
    [Status]      NVARCHAR (1)   NULL,
    CONSTRAINT [PK_Years] PRIMARY KEY CLUSTERED ([Year_Id] ASC)
);

