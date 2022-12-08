-- Cleaning The Product Table
SELECT 
       p.[ProductKey]
      ,p.[ProductAlternateKey] As [Product Item Code]
      --,[ProductSubcategoryKey]
      --,[WeightUnitMeasureCode]
      --,[SizeUnitMeasureCode]
      ,p.[EnglishProductName] As [Product Name]
	  ,pc.[EnglishProductCategoryName] As [Product Category] -- Joining From Product Category Table
	  ,ps.[EnglishProductSubcategoryName] As [Product Subcategory] -- Joining from Product Subcategory Table
      --,[SpanishProductName]
      --,[FrenchProductName]
      ,[StandardCost] As [Cost Price]
      --,[FinishedGoodsFlag]
      ,p.[Color] As [Product Color]
      --,[SafetyStockLevel]
      --,[ReorderPoint]
      --,[ListPrice]
      ,p.[Size] As [Product Size]
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,p.[ProductLine]
      --,[DealerPrice]
      --,[Class]
      --,[Style]
      ,p.[ModelName] As [Product Model Name]
      --,[LargePhoto]
      ,p.[EnglishDescription] As [Product Description]
      --,[FrenchDescription]
      --,[ChineseDescription]
      --,[ArabicDescription]
      --,[HebrewDescription]
      --,[ThaiDescription]
      --,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
      --,[StartDate]
      --,[EndDate]
	  ,p.Status As Example 
      ,ISNULL (p.[Status], 'Outdated') As [Product Status] -- Checking the Status Column to replace NULL with Outdated and name it as Product Status
  FROM 
      [AdventureWorksDW2019].[dbo].[DimProduct] as p 
	  Left Join dbo.DimProductSubcategory as ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey	  
	  Left Join dbo.DimProductCategory as pc on ps.ProductCategoryKey = pc.ProductCategoryKey
  ORDER BY
	  p.ProductKey ASC