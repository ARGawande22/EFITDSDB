USE TDSLive;
GO

CREATE FUNCTION dbo.fn_IsFullNamev1
(
    @EmpName   VARCHAR(200)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Clean NVARCHAR(200) = LTRIM(RTRIM(REPLACE(@EmpName, '.', ' ')));
    DECLARE @Words INT, @Initials INT;

	SELECT @Words    = COUNT(*),
           @Initials = SUM(CASE WHEN LEN(value) = 1 THEN 1 ELSE 0 END)
    FROM STRING_SPLIT(@Clean, ' ')
    WHERE LTRIM(RTRIM(value)) <> '';

    RETURN CASE WHEN @Words >= 2 AND ISNULL(@Initials, 0) = 0 THEN 1 ELSE 0 END;
END;
GO