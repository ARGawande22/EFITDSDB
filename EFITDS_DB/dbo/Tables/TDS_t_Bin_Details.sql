CREATE TABLE [dbo].[TDS_t_Bin_Details] (
    [Bin_Id]      INT            IDENTITY (1, 1) NOT NULL,
    [DDO_Code]    NVARCHAR (11)  NULL,
    [Voucher_Ids] NVARCHAR (MAX) NULL,
    [Receipt_No]  NVARCHAR (10)  NULL,
    [Serial_No]   NVARCHAR (10)  NULL,
    [Bin_Date]    DATE           NULL,
    [Ded_Amount]  DECIMAL (18)   NULL,
    [Status]      NVARCHAR (1)   NULL,
    CONSTRAINT [PK_Bin_Details] PRIMARY KEY CLUSTERED ([Bin_Id] ASC)
);

