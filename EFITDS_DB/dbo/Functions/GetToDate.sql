USE TDSLive;
GO

CREATE OR ALTER FUNCTION [dbo].[GetToDate]
(
    @FinYear NVARCHAR(11)
	,@Quarter CHAR(3)
)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE

	DECLARE @Year1 NVARCHAR(10),
			@Year2 NVARCHAR(10)

	SELECT @Year1=PARSENAME(REPLACE(@FinYear, '-', '.'), 2), 
       @Year2='20'+PARSENAME(REPLACE(@FinYear, '-', '.'), 1)

   IF(@Quarter='Q1')
	BEGIN
		SET @Result=DATEFROMPARTS(@Year1,06,30)
	END
   ELSE IF(@Quarter='Q2')
	BEGIN
		SET @Result=DATEFROMPARTS(@Year1,09,30)
	END
   ELSE IF(@Quarter='Q3')
	BEGIN
		SET @Result=DATEFROMPARTS(@Year1,12,31)
	END
   ELSE IF(@Quarter='Q4')
	BEGIN
		SET @Result=DATEFROMPARTS(@Year2,03,31)
	END    

    RETURN @Result
END