CREATE TABLE [dbo].[TDS_t_Calc_HRA] (
    [HRA_Id]       INT           IDENTITY (1, 1) NOT NULL,
    [CalcSheet_Id] INT           NULL,
    [OwnerPAN]     NVARCHAR (11) NULL,
    [RentPaid]     DECIMAL (18)  NULL,
    [IsMetro]      NVARCHAR (1)  NULL,
    [Status]       NVARCHAR (1)  NULL,
    CONSTRAINT [PK_TDS_t_Calc_HRA] PRIMARY KEY CLUSTERED ([HRA_Id] ASC),
    CONSTRAINT [FK_TDS_t_Calc_HRA_TDS_t_Calc_HRA] FOREIGN KEY ([CalcSheet_Id]) REFERENCES [dbo].[TDS_t_Calc_Sheets] ([CalcSheet_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

