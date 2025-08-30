CREATE TABLE [dbo].[TDS_t_IncomeTax_ChallanDetails] (
    [ITChallan_DetailId] INT          IDENTITY (1, 1) NOT NULL,
    [ITChallan_Id]       INT          NULL,
    [ChallanDate]        DATE         NULL,
    [ChallanNo]          NVARCHAR (8) NULL,
    [ReceivedDate]       DATE         NULL,
    [BSRCode]            NVARCHAR (8) NULL,
    [Amount]             DECIMAL (18) NULL,
    [Status]             NVARCHAR (1) NULL,
    CONSTRAINT [PK_TDS_t_IncomeTax_ChallanDetails] PRIMARY KEY CLUSTERED ([ITChallan_DetailId] ASC),
    CONSTRAINT [FK_TDS_t_IncomeTax_ChallanDetails_TDS_t_IncomeTax_Challan] FOREIGN KEY ([ITChallan_Id]) REFERENCES [dbo].[TDS_t_IncomeTax_Challan] ([ITChallan_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

