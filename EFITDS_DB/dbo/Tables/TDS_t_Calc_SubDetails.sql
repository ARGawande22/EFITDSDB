CREATE TABLE [dbo].[TDS_t_Calc_SubDetails] (
    [CalcSubDetails_Id]  INT            IDENTITY (1, 1) NOT NULL,
    [CalcDetails_Id]     INT            NULL,
    [SubHeader_Id]       INT            NULL,
    [SubDetailHeader_Id] INT            NULL,
    [Description]        NVARCHAR (MAX) NULL,
    [Amount]             DECIMAL (18)   NULL,
    CONSTRAINT [PK_TDS_t_Calc_SubDetails] PRIMARY KEY CLUSTERED ([CalcSubDetails_Id] ASC),
    CONSTRAINT [FK_TDS_t_Calc_SubDetails_TDS_t_Calc_Details] FOREIGN KEY ([CalcDetails_Id]) REFERENCES [dbo].[TDS_t_Calc_Details] ([CalcDetails_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

