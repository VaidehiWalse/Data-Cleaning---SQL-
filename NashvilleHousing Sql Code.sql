
--Cleaning Data in SQL Queries--

Select * From Project2..Nashvillehousing;

--Standardize Date Format--

Select SaleDate, Convert(Date,SaleDate) from Project2..Nashvillehousing

--or another method--

Alter Table Project2..NashvilleHousing
Add SaleDateConverted Date;

Update Project2..NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

Select SaleDateConverted, Convert(Date,SaleDate) from Project2..Nashvillehousing;

--Populate Property Address Data--

Select * From Project2..Nashvillehousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.propertyaddress)
From Project2..Nashvillehousing a
Join Project2..Nashvillehousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Project2.dbo.NashvilleHousing a
JOIN Project2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---- Breaking out Address into Individual Columns (Address, City, State)--

Select PropertyAddress From Project2..Nashvillehousing
--Where PropertyAddress is null
Order by ParcelID

Select 
Substring(PropertyAddress,1,Charindex(',',Propertyaddress)-1) as Address,
Substring(PropertyAddress,Charindex(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Project2..Nashvillehousing
--Substring() is used to extract character--
--CHARINDEX() function searches for a substring in a string, and returns the position in numeric format
--Add this data into two seperate column we need to alter table for this--

Alter Table Project2..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update Project2..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter Table Project2..NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update Project2..NashvilleHousing
SET PropertySplitcity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *from Project2..Nashvillehousing

--for Owner Address Using PARSENAME--

Select 
Parsename(Replace(OwnerAddress, ',','.'),3),
Parsename(Replace(OwnerAddress, ',','.'),2),
Parsename(Replace(OwnerAddress, ',','.'),1)
From Project2..Nashvillehousing;

ALTER TABLE Project2..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Project2..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Project2..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Project2..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Project2..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Project2..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Project2..Nashvillehousing;


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From Project2..Nashvillehousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Project2..NashVilleHousing


Update Project2..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


  Select * From Project2..Nashvillehousing


  -- Remove Duplicates-- 

  WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Project2..Nashvillehousing)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Project2..nashvillehousing



  -- Delete Unused Columns



Select *
From Project2..Nashvillehousing


ALTER TABLE Project2..Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
