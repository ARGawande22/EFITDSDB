USE [TDSLive]
GO

/****** Object:  Table [dbo].[TDS_t_ITSection]    Script Date: 30/11/2025 14:12:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TDS_t_ITSection](
	[Section_Id] [int] IDENTITY(1,1) NOT NULL,
	[Section] [nvarchar](4) NULL,
	[Status] [nvarchar](1) NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[Section_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


