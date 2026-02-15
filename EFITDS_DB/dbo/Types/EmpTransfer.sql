Use TDSLive
GO

CREATE TYPE [dbo].[EmpTransfer] AS TABLE
(
    Sevaarth_Id NVARCHAR(15),
    DDO_Code NVARCHAR(10),
    MinDate DATETIME,
	MaxDate DATETIME
);