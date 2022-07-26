SELECT FirstName, LastName, City, PostalCode, AddressLine1, pat.Name AS 'Address type', pcr.Name AS 'Country'
FROM Person.Person JOIN Person.BusinessEntityAddress
ON Person.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID
JOIN Person.Address 
ON Person.Address.AddressID = Person.BusinessEntityAddress.AddressID
JOIN Person.AddressType AS pat
ON pat.AddressTypeID = Person.BusinessEntityAddress.AddressTypeID
JOIN Person.StateProvince as psp
ON psp.StateProvinceID = Person.Address.StateProvinceID
JOIN Person.CountryRegion as pcr
ON pcr.CountryRegionCode = psp.CountryRegionCode
WHERE pcr.Name NOT IN (N'Australia', N'Canada', N'United States')
ORDER BY pcr.Name, City