-- Cleaning DIM_Customers Table (Customers Dimension Table)

SELECT 
	  CustomerKey
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,[FirstName] As [First Name]
      --,[MiddleName]
      ,[LastName] As [Last Name],
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      Case Gender When 'M' Then 'Male' When 'F' Then 'Female' End as Gender
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,[DateFirstPurchase] As [Date of First Purchase]
      --,[CommuteDistance]
	  ,g.city As [Customer City] -- Joining Customer City from Geograpgy Table
  FROM [AdventureWorksDW2019].[dbo].[DimCustomer] As c
       Left Join dbo.DimGeography As g On g.GeographyKey = c.GeographyKey
  ORDER BY
	  [Customer City] ASC -- Ordering List from CustomerKey
