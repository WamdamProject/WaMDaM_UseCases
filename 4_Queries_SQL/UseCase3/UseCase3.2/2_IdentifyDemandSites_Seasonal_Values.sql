/*
2_IdentifyDemandSites_Seasonal_Values.sql

Use case 3: identify and compare demand data for a site as reported in many sources. 
What is the total agriculture water use or demand in Cache Valley, Utah?



Find node and link Instances within a boundary in space
Adel Abdallah
Updated June 21, 2018
*/
--First look for all the instances and their attributes, then query the actual values (present the result with the number of sites)

--DatasetAcronym,ScenarioName,ObjectTypeCV,AttributeNameCV,AttributeDataTypeCV,NumDemandSites,TotalAnnualNumericCacheCanals, TotalAnnualUseCacheCanals
Select DISTINCT ResourceTypeAcronym,ScenarioName,ObjectTypeCV,AttributeName_Abstract,AttributeNameCV,UnitName,InstanceName,SeasonName,SeasonOrder,SeasonNumericValue
--DateTimeStamp,Value
--,Longitude_x,Latitude_y

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "InstanceCategories" 
ON "InstanceCategories"."InstanceCategoryID"="Instances"."InstanceCategoryID"

LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

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
ON "SeasonalNumericValues"."ValuesMapperID" = "ValuesMapper"."ValuesMapperID" 

-- Join the DataValuesMapper to get their Numeric parameters   
LEFT JOIN "NumericValues"
ON "NumericValues"."ValuesMapperID" = "ValuesMapper"."ValuesMapperID"


WHERE  

-- specify the boundary of coordinates of the search domain in space 
-- this Boundary Cache Valley, Utah
("Instances"."Longitude_x">='-112.1' 
AND "Instances"."Longitude_x"<='-111.6'
AND "Instances"."Latitude_y">='41.5'
AND "Instances"."Latitude_y"<='41.91') 

AND ObjectTypeCV='Demand site' 

AND AttributeNameCV in ('Demand')

-- narrow the search to instances with the category of agriculture
AND InstanceCategory='Agriculture'

AND ScenarioName=='Bear River WEAP Model 2017'

AND AttributeDataTypeCV IN ('SeasonalNumericValues')


GROUP  BY ScenarioName, InstanceName,SeasonOrder
