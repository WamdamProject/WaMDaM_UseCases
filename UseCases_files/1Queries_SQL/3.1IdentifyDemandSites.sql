/*

3.1IdentifyDemandSites.sql

Use case 3: identify and compare demand data for a site as reported in many sources. 
What is the total agriculture water use or demand in Cache Valley, Utah?


Find node and link Instances within a boundary in space
--First look for all the instances and their attributes, then query the actual values (present the result with the number of sites)

Adel Abdallah
Updated October 30, 2017

*/

Select DISTINCT DatasetAcronym,MasterNetworkName,ScenarioName,ObjectType,ObjectTypeCV,ObjectTypologyCV, AttributeDataTypeCV
,AttributeName,AttributeNameCV,InstanceName,InstanceCategory,InstanceNameCV
,Sourcename, Methodname

--,Longitude_x,Latitude_y

FROM Datasets
LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mapping"
ON "Mapping"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mapping"."InstanceID"

LEFT JOIN "InstanceCategory" 
ON "InstanceCategory"."InstanceCategoryID"="Instances"."InstanceCategoryID"

LEFT JOIN "DataValuesMapper" 
ON "DataValuesMapper"."DataValuesMapperID"="Mapping"."DataValuesMapperID"

LEFT JOIN "ScenarioMapping"
ON "ScenarioMapping"."MappingID"="Mapping"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMapping"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT join "Methods" 
ON "Methods"."MethodID" = "Mapping"."MethodID"

LEFT join "Sources" 
ON "Sources"."SourceID" = "Mapping"."SourceID"

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
--AND InstanceCategory='Agriculture'



ORDER BY AttributeDataTypeCV ,MasterNetworkName,ScenarioName,InstanceName DESC


