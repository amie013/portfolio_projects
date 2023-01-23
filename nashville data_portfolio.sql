--Cleaning nashville data in sql
select *
from portfolioproject..NASHVILLE


--edit the salesdate column in the data
select SaleDateconverted, CONVERT(date,SaleDate)
from portfolioproject..NASHVILLE

update NASHVILLE
set SaleDate = CONVERT(date,SaleDate)

Alter Table Nashville
ADD saleDateconverted Date;

update NASHVILLE
set SaleDateconverted = CONVERT(date,SaleDate)


--populate property address data
select *
from portfolioproject..NASHVILLE
order by ParcelID

Where the property address is null
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..NASHVILLE a
join portfolioproject..NASHVILLE b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null


  update a
  Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  from portfolioproject..NASHVILLE a
join portfolioproject..NASHVILLE b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  

--Breaking our address into individual columns
--using substring and charindex
select
substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address ,
substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, len(PropertyAddress)) as Address

from portfolioproject..NASHVILLE


Alter Table Nashville
ADD propertysplitaddress nvarchar(255);

update NASHVILLE
set propertysplitaddress = substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)


Alter Table Nashville
ADD propertysplitcity nvarchar(255);

update NASHVILLE
set propertysplitcity = substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, len(PropertyAddress))

--using parsename

Select PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from portfolioproject..NASHVILLE


Alter Table Nashville
ADD ownersplitaddress nvarchar(255);

update NASHVILLE
set propertysplitaddress =PARSENAME(replace(OwnerAddress, ',', '.'), 3)

Alter Table Nashville
ADD ownersplitcity nvarchar(255);

update NASHVILLE
set propertysplitcity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)


Alter Table Nashville
ADD ownersplitstate nvarchar(255);

update NASHVILLE
set ownersplitstate = PARSENAME(replace(OwnerAddress, ',', '.'), 1)




--change "Y" and N" to a Yes and No in a soldAsVacant column

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from portfolioproject..NASHVILLE
group by SoldAsVacant
order by 2


select SoldAsVacant,
 case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N'then 'No'
	  else SoldAsVacant
	  End
from portfolioproject..NASHVILLE


update NASHVILLE
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N'then 'No'
	  else SoldAsVacant
	  End



 --remove duplicates
 with rownumcte as
 (
 select *,
 ROW_NUMBER () over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  order by UniqueID
			  ) row_num
  from portfolioproject..NASHVILLE
  --order by ParcelID
  )

  select *
  from rownumcte
  where row_num >1
  --order by PropertyAddress



--delete unused colunms
select *
from portfolioproject..NASHVILLE

alter table portfolioproject..NASHVILLE
drop column OwnerAddress,TaxDistrict,LandValue



