USE TDSLive;
GO

CREATE OR ALTER FUNCTION [dbo].[SplitString]
(
    @Ids NVARCHAR(MAX),
    @delimiter CHAR(1)
)
RETURNS @output TABLE(value NVARCHAR(100))
AS
BEGIN
    DECLARE @start INT = 1, @end INT

    SET @end = CHARINDEX(@delimiter, @Ids)

    WHILE @end > 0
    BEGIN
        INSERT INTO @output (value)
        SELECT SUBSTRING(@Ids, @start, @end - @start)

        SET @start = @end + 1
        SET @end = CHARINDEX(@delimiter, @Ids, @start)
    END

    INSERT INTO @output (value)
    SELECT SUBSTRING(@Ids, @start, LEN(@Ids) - @start + 1)

    RETURN
END
