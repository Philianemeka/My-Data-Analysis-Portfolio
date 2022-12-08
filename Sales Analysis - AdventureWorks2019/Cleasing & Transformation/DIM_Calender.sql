-- Cleaning Dim_Date Table (Dimension Date Table)

SELECT
	   [DateKey]
      ,[FullDateAlternateKey] As Date
      ,[EnglishDayNameOfWeek] As Day
      --,[DayNumberOfMonth]
      --,[DayNumberOfYear]
      ,[WeekNumberOfYear] As WeekNum
      ,[EnglishMonthName] As Month,
	  Left([EnglishMonthName], 3) As MonthShort
      --,[SpanishMonthName]
      --,[FrenchMonthName] 
      ,[MonthNumberOfYear] As MonthNum
      ,[CalendarQuarter] As Quarter
      ,[CalendarYear] As Year
      --,[CalendarSemester]
      --,[FiscalQuarter]
      --,[FiscalYear]
     --,[FiscalSemester]
  FROM [AdventureWorksDW2019].[dbo].[DimDate]
  WHERE
	   CalendarYear >= 2011
 