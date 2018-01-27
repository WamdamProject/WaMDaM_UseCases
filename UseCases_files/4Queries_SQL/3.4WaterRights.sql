/*

3.4WaterRights.sql

Use case 3: identify and compare demand data for a site as reported in many sources. 
What is the total agriculture water use or demand in Cache Valley, Utah?

Adel Abdallah
Updated Jan 27, 2018

*/

Select DISTINCT DatasetAcronym,MasterNetworkName,ScenarioName,ObjectType,ObjectTypeCV,ObjectTypologyCV, AttributeDataTypeCV
,AttributeName,AttributeNameCV,InstanceName,InstanceCategory,InstanceNameCV,NumericValue,UnitName,descriptorvalue 
,Sourcename, Methodname

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

LEFT JOIN "NumericValues" 
ON "NumericValues"."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"

LEFT JOIN DescriptorValues
ON DescriptorValues.DataValuesMapperID=DataValuesMapper.DataValuesMapperID


WHERE  

-- specify the boundary of coordinates of the search domain in space 
-- this Boundary Cache Valley, Utah
("Instances"."Longitude_x">='-112.3' 
AND "Instances"."Longitude_x"<='-111.4'
AND "Instances"."Latitude_y">='41.3'
AND "Instances"."Latitude_y"<='42.100') 

AND ObjectTypeCV='Demand site' 

AND (AttributeNameCV='Flow' OR AttributeName='Beneficial Use')

-- narrow the search to instances with the category of agriculture
--AND InstanceCategory='Water Rights'

AND InstanceName IN ('WATER RESEARCH LAB. UTAH STATE UNIVERSITY 1', 'WATER RESEARCH LAB. UTAH STATE UNIVERSITY 2')

ORDER BY AttributeDataTypeCV ,MasterNetworkName,ScenarioName,InstanceName DESC


