--Data Cleaning In SQL

--1. uploding project

select *
from MyPortfolio.dbo.NashvilleHousing

--2. Changing Date format

select SaleDate, CONVERT(Date,SaleDate)
from MyPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = Convert(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted, CONVERT(Date,SaleDate)
from MyPortfolio.dbo.NashvilleHousing

--3. Populate PropertyAddress Data to fill up the NULL value
--Property Address has some null values, so to populate it we reference it to a relative column with consistent data ie ParcelID which has a unique link to the property address

Select *
From MyPortfolio.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--Then we join the table to itself (Self Join) so that whatever ParcelID would fill up the null space on the corresponding 
--Property Address by using ISNULL

Select x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress) 
From MyPortfolio.dbo.NashvilleHousing x
join MyPortfolio.dbo.NashvilleHousing y
	on x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
where x.PropertyAddress is null

--Now Update a, which is the new property address

Update x
Set PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
From MyPortfolio.dbo.NashvilleHousing x
join MyPortfolio.dbo.NashvilleHousing y
	on x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
where x.PropertyAddress is null

--4. Seperating Address into different Colunms for Address, City and State

Select PropertyAddress
From MyPortfolio.dbo.NashvilleHousing
--Where PropertyAddress is Null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress), LEN(PropertyAddress)) as Address
From MyPortfolio.dbo.NashvilleHousing

--Putting +1 to remove the 'coma' sign

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From MyPortfolio.dbo.NashvilleHousing

--Creating a two new colunms (We cant seperate two values from one colunm without creating another colunm)

alter table NashvilleHousing
add Address Nvarchar(255);

update NashvilleHousing
set Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

alter table NashvilleHousing
add City Nvarchar;

update NashvilleHousing
set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from MyPortfolio.dbo.NashvilleHousing

--5. Seperate Owners Address into City and State using 'PARESENAME' (PARSENAME useful with periods not comas)


select OwnerAddress
from MyPortfolio.dbo.NashvilleHousing 


select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
from MyPortfolio.dbo.NashvilleHousing

--Rearranging them as Street(3), City(2) and State(1)

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Owner,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
from MyPortfolio.dbo.NashvilleHousing

--Creating Seperate Columns for them

alter table NashvilleHousing
add Street Nvarchar(255);

update NashvilleHousing
set Street = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


alter table NashvilleHousing
add OwnerCity Nvarchar(255);

update NashvilleHousing
set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


alter table NashvilleHousing
add State Nvarchar(255);

update NashvilleHousing
set State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from MyPortfolio.dbo.NashvilleHousing

--6. Changing Y and N to Yes and No in the "Sold as Vacaant Column"

select SoldAsVacant
from MyPortfolio.dbo.NashvilleHousing

select DISTINCT(SoldAsVacant)
from MyPortfolio.dbo.NashvilleHousing

--There is a mixture of N, Y Yes and No
--Checking how many they are each

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from MyPortfolio.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

--From the above, I observed there are more Yes and No compared to the number of Y and N
--So I convert all Y to Yes and N to No

Select SoldAsVacant,
CASE  when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'	
	  else SoldAsVacant
	  end
from MyPortfolio.dbo.NashvilleHousing

--Updating the table

Update NashvilleHousing
set SoldAsVacant = CASE  when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'	
	  else SoldAsVacant
	  end
from MyPortfolio.dbo.NashvilleHousing

--Checking changes

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from MyPortfolio.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


--7. Removing Duplicates and Unused Colunms
--Doing this we need to identify the rows by partition using row numbers because we hve duplicate rows

select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					)row_num

from MyPortfolio.dbo.NashvilleHousing
order by ParcelID

--We Identified some duplicates on row_num as 2
--Then we put it in a CTE

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					)row_num

from MyPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE

--Deleting Duplicate

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					)row_num

from MyPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					)row_num

from MyPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
DELETE
from RowNumCTE
where row_num > 1
--order by PropertyAddress

--Confirming deleted duplicate rows

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					)row_num

from MyPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


--Delete Unused Columns

Alter Table MyPortfolio.dbo.NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, SaleDate, SplitCity, TaxDistrict


select *
from MyPortfolio.dbo.NashvilleHousing












