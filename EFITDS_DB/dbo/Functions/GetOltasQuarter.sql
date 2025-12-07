USE TDSLive;
GO

CREATE   FUNCTION [dbo].[GetOltasQuarter]
(
    @Challan_Date DATE,
	@FinYear	nvarchar(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @Result VARCHAR(50)

	DECLARE @Year1 NVARCHAR(10),
			@Year2 NVARCHAR(10)

	SELECT @Year1=PARSENAME(REPLACE(@FinYear, '-', '.'), 2), 
       @Year2='20'+PARSENAME(REPLACE(@FinYear, '-', '.'), 1)

   IF(@Challan_Date>=DATEFROMPARTS(@Year1,04,10) AND @Challan_Date<DATEFROMPARTS(@Year1,07,10))
	BEGIN
		SET @Result='Q1'
	END
   ELSE IF(@Challan_Date>=DATEFROMPARTS(@Year1,07,10) AND @Challan_Date<DATEFROMPARTS(@Year1,10,10))
	BEGIN
		SET @Result='Q2'
	END
   ELSE IF(@Challan_Date>=DATEFROMPARTS(@Year1,10,10) AND @Challan_Date<DATEFROMPARTS(@Year2,01,10))
	 BEGIN
		SET @Result='Q3'
	 END
   ELSE IF(@Challan_Date>=DATEFROMPARTS(@Year2,01,10) AND @Challan_Date<DATEFROMPARTS(@Year2,04,10))
	BEGIN
		SET @Result='Q4'
	END
   ELSE
	BEGIN
		SET @Result='NA'
	END

    RETURN @Result
END
