CREATE TABLE [dbo].[TDS_t_IncomeTax_Challan] (
    [ITChallan_Id]  INT          IDENTITY (1, 1) NOT NULL,
    [CalcSheet_Id]  INT          NULL,
    [ChallanAmount] DECIMAL (18) NULL,
    [CreatedDate]   DATE         NULL,
    [Status]        NVARCHAR (1) NULL,
    CONSTRAINT [PK_TDS_t_IncomeTax_Challan] PRIMARY KEY CLUSTERED ([ITChallan_Id] ASC),
    CONSTRAINT [FK_TDS_t_IncomeTax_Challan_TDS_t_Calc_Sheets] FOREIGN KEY ([CalcSheet_Id]) REFERENCES [dbo].[TDS_t_Calc_Sheets] ([CalcSheet_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

