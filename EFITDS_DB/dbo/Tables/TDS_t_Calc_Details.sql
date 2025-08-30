CREATE TABLE [dbo].[TDS_t_Calc_Details] (
    [CalcDetails_Id] INT            IDENTITY (1, 1) NOT NULL,
    [CalcSheet_Id]   INT            NULL,
    [Header_Id]      INT            NULL,
    [SubHeader_Id]   INT            NULL,
    [Description]    NVARCHAR (MAX) NULL,
    [Amount]         DECIMAL (18)   NULL,
    CONSTRAINT [PK_TDS_t_Calc_Details] PRIMARY KEY CLUSTERED ([CalcDetails_Id] ASC),
    CONSTRAINT [FK_TDS_t_Calc_Details_TDS_t_Calc_Sheets] FOREIGN KEY ([CalcSheet_Id]) REFERENCES [dbo].[TDS_t_Calc_Sheets] ([CalcSheet_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

