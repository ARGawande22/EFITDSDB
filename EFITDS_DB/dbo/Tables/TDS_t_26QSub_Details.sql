USE [TDSLive]
GO

/****** Object:  Table [dbo].[TDS_t_26QSub_Details]    Script Date: 30/11/2025 13:47:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TDS_t_26QSub_Details](
	[Yealy_Id] [int] IDENTITY(1,1) NOT NULL,
	[Supplier_Id] [nvarchar](15) NULL,
	[Supplier_Name] [nvarchar](Max) NULL,
	[PAN_No] [nvarchar](10) NULL,
	[Pan_Status] [char](1) NULL,
	[DDO_Code] [nvarchar](11) NULL,
	[Voucher_Id] [int] NULL,
	[Fin_Year] [nvarchar](11) NULL,
	[Vourcher_Date] [date] NULL,
	[Voucher_No] [int] NULL,
	[Income_Tax] [decimal](18, 0) NULL,
	[Gross_Amt] [decimal](18, 0) NULL,
	[Section_Id] [int] NULL,
	[Section] [nvarchar](4) NULL,
	[InterestRate] [decimal](18, 4) NULL,
	[Status] [nvarchar](1) NULL,
 CONSTRAINT [PK_26Q_Sub_Details] PRIMARY KEY CLUSTERED 
(
	[Yealy_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


