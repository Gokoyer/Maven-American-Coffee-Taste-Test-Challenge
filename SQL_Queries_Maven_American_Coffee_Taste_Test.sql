/**********This project is from the Maven American Coffee Taste Test Challenge********************/

---Overview of the dataset--------
SELECT *
FROM [Maven_Coffee_Taste_Test]

------------To remove the unnecessary characters from the Age Column---------

SELECT LEFT(Age, 5) as [Age]
FROM [Maven_Coffee_Taste_Test]

UPDATE [Maven_Coffee_Taste_Test]
SET [Age] = LEFT(Age, 5)

----------------Change the column name Cups of Coffee per Day------------------

EXEC SP_RENAME '[Maven_Coffee_Taste_Test].[Cups of Coffee per Day]', '[Coffee_Cups_per_Day]', 'COLUMN'

/*Replace the NULL values in Coffee_Cups_per_Day' column to 5. However, this means ,more than 4'. 
'More than 4 cant be inserted since its nota float/int.*/

SELECT ISNULL([Coffee_Cups_per_Day], 5) AS [Coffee_Cups_Per_Day]
FROM [Maven_Coffee_Taste_Test]

UPDATE [Maven_Coffee_Taste_Test]
SET [Coffee_Cups_Per_Day] = ISNULL([Coffee_Cups_per_Day], 5) 


--------------Change the column name, 'Lastly, how would you rate your own coffee expertise?'------------------------------

EXEC SP_RENAME '[Maven_Coffee_Taste_Test].[Lastly, how would you rate your own coffee expertise?]', '[Self Rating Coffee Expertise]', 'COLUMN'

--------------Change the column name 'Do you work from home or in person?' to 'Job_Location_Types'---------------------

EXEC SP_RENAME '[Maven_Coffee_Taste_Test].[Do you work from home or in person?]', '[Job_Location_Types]', 'COLUMN'

/*Change 'I primarily work from home' to 'Remote'-
Change 'I do a mix of both' to 'Hybrid'
Change 'I primarily work in person' to 'On-site'*/

SELECT
CASE [Job_Location_Types]
WHEN 'I primarily work from home' THEN 'Remote'
WHEN 'I do a mix of both' THEN 'Hybrid'
WHEN 'I primarily work in person' THEN 'On-site'
ELSE [Job_Location_Types]
END
FROM [Maven_Coffee_Taste_Test]

UPDATE [Maven_Coffee_Taste_Test]
SET [Job_Location_Types] = CASE [Job_Location_Types]
WHEN 'I primarily work from home' THEN 'Remote'
WHEN 'I do a mix of both' THEN 'Hybrid'
WHEN 'I primarily work in person' THEN 'On-site'
ELSE [Job_Location_Types]
END

----------------Change the column name Maximum Amount Paid For Coffee------------------

EXEC SP_RENAME '[Maven_Coffee_Taste_Test].[Maximum Amount Paid For Coffee]', '[Maximum Amount Paid For a Cup of Coffee]', 'COLUMN'

----------------Function to change any type of Case to Proper Case--------------------------------------
GO
CREATE FUNCTION [fnConvert_TitleCase] (@InputString VARCHAR(4000))
RETURNS VARCHAR(4000)
AS
BEGIN
DECLARE @Index INT
DECLARE @Char CHAR(1)
DECLARE @OutputString VARCHAR(255)

SET @OutputString = LOWER(@InputString)
SET @Index = 2
SET @OutputString = STUFF(@OutputString, 1, 1,UPPER(SUBSTRING(@InputString,1,1)))

WHILE @Index <= LEN(@InputString)
BEGIN
    SET @Char = SUBSTRING(@InputString, @Index, 1)
    IF @Char IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&','''','(')
    IF @Index + 1 <= LEN(@InputString)
BEGIN
    IF @Char != ''''
    OR
    UPPER(SUBSTRING(@InputString, @Index + 1, 1)) != 'S'
    SET @OutputString =
    STUFF(@OutputString, @Index + 1, 1,UPPER(SUBSTRING(@InputString, @Index + 1, 1)))
END
    SET @Index = @Index + 1
END

RETURN ISNULL(@OutputString,'')
END
GO

------------------Changing the Coffee Strength and Caffeine Strength to Proper Case-------------------------------
SELECT [dbo].[fnConvert_TitleCase](Upper([Coffee Strength])) AS [Coffee Strength],
[dbo].[fnConvert_TitleCase](Upper([Caffeine Strength])) AS [Caffeine Strength]
FROM [Maven_Coffee_Taste_Test]

UPDATE [Maven_Coffee_Taste_Test]
SET [Coffee Strength] = [dbo].[fnConvert_TitleCase](Upper([Coffee Strength]))

UPDATE [Maven_Coffee_Taste_Test] 
SET[Caffeine Strength] = [dbo].[fnConvert_TitleCase](Upper([Caffeine Strength]))
    




