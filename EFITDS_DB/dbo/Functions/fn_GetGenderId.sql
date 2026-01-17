USE TDSLive;
GO

CREATE FUNCTION [dbo].[fn_GetGenderId]
(
    @Gender NVARCHAR(15)
)
RETURNS INT
AS
BEGIN
    DECLARE @GenderId INT;

    SELECT @GenderId = Gender_Id
    FROM [dbo].[TDS_t_Gender]
    WHERE Gender = @Gender;

    RETURN @GenderId;
END;