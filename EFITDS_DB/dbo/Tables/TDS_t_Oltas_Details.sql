CREATE TABLE [dbo].[TDS_t_Oltas_Details] (
    [Oltas_Id]      INT           IDENTITY (1, 1) NOT NULL,
    [DDO_Code]      NVARCHAR (11) NULL,
    [Voucher_Id]    NVARCHAR (50) NULL,
    [Challan_Date]  DATE          NULL,
    [Challan_No]    NVARCHAR (10) NULL,
    [Received_Date] DATE          NULL,
    [BSR_Code]      NVARCHAR (10) NULL,
    [Ded_Amount]    DECIMAL (18)  NULL,
    [Status]        NVARCHAR (1)  NULL,
    CONSTRAINT [PK_Oltas_Details] PRIMARY KEY CLUSTERED ([Oltas_Id] ASC)
);

