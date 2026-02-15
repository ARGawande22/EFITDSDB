USE TDSLive;
GO

CREATE FUNCTION dbo.fn_GetTransferId
(
    @Sevaarth_Id VARCHAR(15),
    @VDate       DATETIME,
    @DDO_Code    VARCHAR(10)
)
RETURNS INT
AS
BEGIN
    DECLARE @Transfer_Id INT
			,@SystemEndDate DATETIME
			,@CDDO_Code NVARCHAR(10)
			,@ValidFrom  DATETIME
			,@ValidTo    DATETIME

	SET @SystemEndDate=(Select [dbo].[fn_GetSystemEndDate]());

    /*  Find matching effective row */
    SELECT TOP 1
        @Transfer_Id = Transfer_Id,
        @ValidFrom  = ValidFrom,
        @ValidTo    = ValidTo
    FROM TDS_t_EmpTransfer_History
    WHERE Sevaarth_Id = @Sevaarth_Id
      AND CurDDO_Code = @DDO_Code
      AND @VDate BETWEEN ValidFrom AND ValidTo
    ORDER BY ValidFrom DESC;

	IF @Transfer_Id IS NULL
	BEGIN
		SELECT TOP 1
		    @Transfer_Id= e.Transfer_Id,
		     @CDDO_Code =e.CurDDO_Code,
			 @ValidFrom=e.ValidFrom,
			 @ValidTo=e.ValidTo
		FROM TDS_t_EmpTransfer_History e
		WHERE e.Sevaarth_Id = @Sevaarth_Id
		      AND e.ValidFrom > @VDate
		    ORDER BY e.ValidFrom ASC;
	END 

	IF @CDDO_Code<>@DDO_Code
	BEGIN
		SELECT TOP 1
		     @Transfer_Id=e.Transfer_Id,
			 @CDDO_Code =e.CurDDO_Code,
		      @ValidFrom=e.ValidFrom,
			 @ValidTo=e.ValidTo
		FROM TDS_t_EmpTransfer_History e
		WHERE e.Sevaarth_Id = @Sevaarth_Id
		      AND e.Transfer_Id < @Transfer_Id
		    ORDER BY e.ValidFrom DESC;
	END

	IF @CDDO_Code<>@DDO_Code
	BEGIN
		SET @Transfer_Id= NULL;
	END    

	RETURN @Transfer_Id;
END;
GO