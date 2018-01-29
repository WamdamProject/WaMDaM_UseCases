/*
3.2dentifyDemandSites_SeasonalValues.sql

Use case 3: identify and compare demand data for a site as reported in many sources. 
What is the total agriculture water use or demand in Cache Valley, Utah?



Find node and link Instances within a boundary in space
Adel Abdallah
Updated Jan 27, 2018
*/
--First look for all the instances and their attributes, then query the actual values (present the result with the number of sites)

--DatasetAcronym,ScenarioName,ObjectTypeCV,AttributeNameCV,AttributeDataTypeCV,NumDemandSites,TotalAnnualNumericCacheCanals, TotalAnnualUseCacheCanals
Select DISTINCT DatasetAcronym,ScenarioName,ObjectTypeCV,AttributeNameCV,AttributeDataTypeCV,count(DISTINCT InstanceName) As NumDemandSites,sum(NumericValue) AS TotalNumeric,sum(SeasonNumericValue) As TotalAnnualUseCacheCanals
--DateTimeStamp,Value
--,Longitude_x,Latitude_y

FROM Datasets
LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "InstanceCategories" 
ON "InstanceCategories"."InstanceCategoryID"="Instances"."InstanceCategoryID"

LEFT JOIN "DataValuesMapper" 
ON "DataValuesMapper"."DataValuesMapperID"="Mappings"."DataValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT join "Methods"
 ON "Methods"."MethodID" = "Mappings"."MethodID"

LEFT join "Sources" 
ON "Sources"."SourceID" = "Mappings"."SourceID"


-- Join the DataValuesMapper to get their Seasonal 
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."DataValuesMapperID" = "DataValuesMapper"."DataValuesMapperID"

-- Join the DataValuesMapper to get their Numeric parameters   
LEFT JOIN "NumericValues"
ON "NumericValues"."DataValuesMapperID" = "DataValuesMapper"."DataValuesMapperID"


WHERE  

-- specify the boundary of coordinates of the search domain in space 
-- this Boundary Cache Valley, Utah
("Instances"."Longitude_x">='-112.3' 
AND "Instances"."Longitude_x"<='-111.4'
AND "Instances"."Latitude_y">='41.3'
AND "Instances"."Latitude_y"<='42.100') 

AND ObjectTypeCV='Demand site' 

AND AttributeNameCV='Flow'

-- narrow the search to instances with the category of agriculture
AND InstanceCategory='Agriculture'


AND AttributeDataTypeCV IN ('SeasonalNumericValues' , 'NumericValues')


GROUP  BY DatasetAcronym,ObjectType,MasterNetworkName,ScenarioName