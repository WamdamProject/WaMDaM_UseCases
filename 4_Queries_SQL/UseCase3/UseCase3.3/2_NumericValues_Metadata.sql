/*
4.4NumericValues_Metadata.sql

Use case 4: identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?


This query shows parameters data values, their attributes, units, object names, and instances, and data source 
for all the parameters in WaM-DaM

Result:
users can import the data values to their model. WaM-DaM keeps track of the meanings of data values, their units, 
to what instance they apply too.... 

Adel Abdallah
Updated June 12, 2018

*/

SELECT DISTINCT Attributes.AttributeName,
"Methods"."MethodName",
"OrganizationsMethods"."OrganizationName" As "MethodOrganizationName",
"PeopleMethods"."PersonName" As "MethodContactName",
PeopleMethods.Phone As "MethodPersonPhone",
MethodWebpage,

"Sources"."SourceName","OrganizationsSources"."OrganizationName" As "SourceOrganizationName",
PeopleSources.Phone As "SourcePersonPhone",
"PeopleSources"."PersonName" As "SourceContactName",
SourceWebpage	

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

Left JOIN "Methods" 
ON "Methods"."MethodID"="Mappings"."MethodID"

Left JOIN "Sources" 
ON "Sources"."SourceID"="Mappings"."SourceID"

Left JOIN "People" As "PeopleSources"
ON "PeopleSources"."PersonID"="Sources"."PersonID"

Left JOIN "People" As "PeopleMethods" 
ON "PeopleMethods"."PersonID"="Methods"."PersonID"

Left JOIN "Organizations" As "OrganizationsMethods" 
ON "OrganizationsMethods" ."OrganizationID"="PeopleMethods"."OrganizationID"

Left JOIN "Organizations" As "OrganizationsSources" 
ON "OrganizationsSources" ."OrganizationID"="PeopleSources"."OrganizationID"



LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT JOIN "NumericValues" 
ON "NumericValues"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

LEFT JOIN "TimeSeries" 
ON "TimeSeries"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

-- Join the DataValuesMapper to get their SeasonalNumericValues
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."ValuesMapperID" = "ValuesMapper"."ValuesMapperID"

LEFT JOIN CategoricalValues
ON CategoricalValues.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN CV_Categorical
ON CV_Categorical.Name=CategoricalValues.CategoricalValueCV	


-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  
--AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeNameCV IN ('Volume') 

ORDER BY AttributeNameCV,ObjectType,ObjectTypeCV,InstanceName desc

