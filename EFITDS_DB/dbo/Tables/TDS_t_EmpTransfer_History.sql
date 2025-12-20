CREATE TABLE [dbo].[TDS_t_EmpTransfer_History] (
    [Transfer_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Sevaarth_Id]   NVARCHAR (15) NULL,
    [CurDDO_Code]   NCHAR (10)    NULL,
    [ExtDDO_Code]   NVARCHAR (11) NULL,
    [ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL,
    [Transfer_Date] DATE          NULL,
    [Status]        NVARCHAR (1)  NULL,
    CONSTRAINT [PK_EmpTransfer_History] PRIMARY KEY CLUSTERED ([Transfer_Id] ASC),
    CONSTRAINT [FK_TDS_t_EmpTransfer_History_TDS_t_Emp_Details] FOREIGN KEY ([Sevaarth_Id]) REFERENCES [dbo].[TDS_t_Emp_Details] ([Sevaarth_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

