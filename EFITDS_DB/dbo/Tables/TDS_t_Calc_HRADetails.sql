CREATE TABLE [dbo].[TDS_t_Calc_HRADetails] (
    [HRA_DetailId]  INT            IDENTITY (1, 1) NOT NULL,
    [HRA_Id]        INT            NOT NULL,
    [Property_Type] NVARCHAR (50)  NULL,
    [NoOfMonth]     INT            NULL,
    [StartDate]     DATE           NULL,
    [MonthlyRent]   DECIMAL (18)   NULL,
    [OwnerPAN]      NVARCHAR (11)  NULL,
    [NameOfOwner]   NVARCHAR (MAX) NULL,
    [Address]       NVARCHAR (MAX) NULL,
    [ContactNo]     NVARCHAR (11)  NULL,
    [Email]         NVARCHAR (50)  NULL,
    [Status]        NVARCHAR (1)   NULL,
    CONSTRAINT [PK_TDS_t_Calc_HRADetails] PRIMARY KEY CLUSTERED ([HRA_DetailId] ASC),
    CONSTRAINT [FK_TDS_t_Calc_HRADetails_TDS_t_Calc_HRA] FOREIGN KEY ([HRA_Id]) REFERENCES [dbo].[TDS_t_Calc_HRA] ([HRA_Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

