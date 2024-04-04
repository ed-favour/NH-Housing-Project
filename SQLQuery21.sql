SELECT *      
  FROM [Project].[dbo].[NashvilleHousing ]

  -- cleaning data in sql queries

  --standardize date format i.e remove the time as it serves no purpose

  SELECT SaleDate, convert(date, SaleDate)
  FROM [Project].[dbo].[NashvilleHousing ]

 update [NashvilleHousing]
 set SaleDate = convert(date, SaleDate)

 alter table NashvilleHousing
 add saleDateConverted date

 update [NashvilleHousing ]
 set saleDateConverted = convert(date, SaleDate)

 SELECT saleDateConverted
  FROM [Project].[dbo].[NashvilleHousing ]

  -- poplulate property address
   SELECT * -- PropertyAddress
  FROM [Project].[dbo].[NashvilleHousing ]
  where PropertyAddress is null
  order by ParcelID
 
   SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,  b.PropertyAddress) as newAddress
  FROM [Project].[dbo].[NashvilleHousing ] a
  join [Project].[dbo].[NashvilleHousing ] b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null 

  update a
  set PropertyAddress = ISNULL( a.PropertyAddress,  b.PropertyAddress) 
  FROM [Project].[dbo].[NashvilleHousing ] a
  join [Project].[dbo].[NashvilleHousing ] b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null 

  --Breaking address into different column(address, city and state) i.e property address

   SELECT PropertyAddress
  FROM [Project].[dbo].[NashvilleHousing ]
 

  select 
  SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
  ,SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as State
  from Project.dbo.[NashvilleHousing ]

  
 alter table NashvilleHousing
 drop column PropertySplitAddress

 alter table NashvilleHousing
 add PropertySplitAddress nvarchar(255)

 update [NashvilleHousing ]
 set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

  alter table NashvilleHousing
 add PropertySplitCity nvarchar(255)

 update [NashvilleHousing ]
 set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

 select *
 from Project.dbo.[NashvilleHousing ]

 

--Breaking address into different column(address, city and state) i.e owners address
  SELECT *
  FROM [Project].[dbo].[NashvilleHousing ]
  order by ParcelID 
   

--Using PARSENAME: PARSENAME breake sentence from the back when it see a fullstop (.)
select PARSENAME(REPLACE( OwnerAddress,',', '.' ),3),
 PARSENAME(REPLACE( OwnerAddress,',', '.' ),2),
 PARSENAME(REPLACE( OwnerAddress,',', '.' ),1) 
from Project.dbo.[NashvilleHousing ]


 alter table NashvilleHousing
 add OwnerSplitAddress nvarchar(255)

  update [NashvilleHousing ]
 set OwnerSplitAddress = PARSENAME(REPLACE( OwnerAddress,',', '.' ),3)



  alter table NashvilleHousing
 add OwnerSplitCity nvarchar(255)

  update [NashvilleHousing ]
 set OwnerSplitAddress = PARSENAME(REPLACE( OwnerAddress,',', '.' ),2)


 alter table NashvilleHousing
 add OwnerSplitState nvarchar(255)

  update [NashvilleHousing ]
 set OwnerSplitState = PARSENAME(REPLACE( OwnerAddress,',', '.' ),1)

 -- Change Y and N to Yes and No in SoldAsVancant
 select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
 from Project.dbo.[NashvilleHousing ]
 group by SoldAsVacant
 order by 2

 select SoldAsVacant,
 case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then'No'
	else SoldAsVacant
	end
 from Project.dbo.[NashvilleHousing ]

 update [NashvilleHousing ]
 set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then'No'
	else SoldAsVacant
	end
	

	---REMOVE DUPLICATE
with RowNumCTE as (
select *,
		ROW_NUMBER() over ( 
		partition by
		propertyAddress,
		saleprice,
		saledate,
		legalreference
		order by 
		uniqueid
)as row_num
 from Project.dbo.[NashvilleHousing ]
 )

 select *
 from RowNumCTE
 where row_num > 1
 order by PropertyAddress

 --delete 
 --from RowNumCTE
 --where row_num > 1

 ---delete unused column

 select *
 from Project..[NashvilleHousing ]

 alter table Project..[NashvilleHousing ]
 drop column owneraddress, taxdistrict, propertyaddress, saledate


 
 

 