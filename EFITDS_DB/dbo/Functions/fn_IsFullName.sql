USE TDSLive;
GO

CREATE FUNCTION dbo.fn_IsFullName
(
    @EmpName   VARCHAR(200)
)
RETURNS BIT
AS
BEGIN
	IF @EmpName IS NULL RETURN 0;

    -- Treat dots as spaces
    DECLARE @Clean NVARCHAR(200) = LTRIM(RTRIM(REPLACE(@EmpName, '.', ' ')));

    -- Collapse repeated spaces into one
    WHILE CHARINDEX('  ', @Clean) > 0
        SET @Clean = REPLACE(@Clean, '  ', ' ');

    -- Number of words
    DECLARE @Words INT = LEN(@Clean) - LEN(REPLACE(@Clean, ' ', '')) + 1;

    -- Any single-letter word (initial)? Pad with spaces so edges are matched too
    DECLARE @HasInitial BIT =
        CASE WHEN (' ' + @Clean + ' ') LIKE '% [A-Za-z] %' THEN 1 ELSE 0 END;

    RETURN CASE WHEN @Words >= 2 AND @HasInitial = 0 THEN 1 ELSE 0 END;    
END;
GO