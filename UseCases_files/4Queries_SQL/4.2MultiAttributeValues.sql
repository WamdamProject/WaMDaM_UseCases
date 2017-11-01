/*
-- 4.2 MultiAttributeValues.sql

Use case 4: identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?


Adel Abdallah
Updated October 30, 2017

This query shows data values for a particular MultiColumns of a reservoir InstanceName: area, and capacity, and stage 

Result:
Users can import these data columns to their model 
WaM-DaM keeps track of the meanings of data values, their CV_Units, to what instance they apply too.... 
*/

SELECT "ObjectTypes"."ObjectType",
"Instances"."InstanceName",ScenarioName,"Attributes"."AttributeName" AS MultiAttributeName,"Attributes".AttributeDataTypeCV,
"AttributesColumns"."AttributeName" AS "AttributeName",
"AttributesColumns"."AttributeNameCV",
"AttributesColumns"."UnitNameCV" AS "AttributeNameUnitName",
"Value","ValueOrder"

FROM "Datasets"

-- Join the dataset to get its Object Types 
LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

-- Join the Object types to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

-- Join the Attributes to get their Mappings   
LEFT JOIN "Mapping"
ON Mapping.AttributeID= Attributes.AttributeID

-- Join the Mapping to get their Instances   
LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mapping"."InstanceID"

-- Join the Mappings to get their ScenarioMappings   
LEFT JOIN "ScenarioMapping"
ON "ScenarioMapping"."MappingID"="Mapping"."MappingID"

-- Join the ScenarioMappings to get their Scenarios   
LEFT JOIN "Scenarios"
ON "Scenarios"."ScenarioID"="ScenarioMapping"."ScenarioID"


-- Join the Scenarios to get their MasterNetworks   
LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

-- Join the Mappings to get their Methods   
LEFT JOIN "Methods" 
ON "Methods"."MethodID"="Mapping"."MethodID"

-- Join the Mappings to get their Sources   
LEFT JOIN "Sources" 
ON "Sources"."SourceID"="Mapping"."SourceID"

-- Join the Mappings to get their DataValuesMappers   
LEFT JOIN "DataValuesMapper" 
ON "DataValuesMapper"."DataValuesMapperID"="Mapping"."DataValuesMapperID"

-- Join the DataValuesMapper to get their MultiAttributeSeries   
LEFT JOIN "MultiAttributeSeries"  
ON "MultiAttributeSeries" ."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"


/*This is an extra join to get to each column name within the MultiColumn Array */

-- Join the MultiAttributeSeries to get to their specific DataValuesMapper, now called DataValuesMapperColumn
LEFT JOIN "DataValuesMapper" As "DataValuesMapperColumn"
ON "DataValuesMapperColumn"."DataValuesMapperID"="MultiAttributeSeries"."AttributeNameID"

-- Join the DataValuesMapperColumn to get back to their specific Mapping, now called MappingColumns
LEFT JOIN "Mapping" As "MappingColumns"
ON "MappingColumns"."DataValuesMapperID"="DataValuesMapperColumn"."DataValuesMapperID"

-- Join the MappingColumns to get back to their specific Attribute, now called AttributeColumns
LEFT JOIN  "Attributes" AS "AttributesColumns"
ON "AttributesColumns"."AttributeID"="MappingColumns"."AttributeID"
/* Finishes here */

-- Join the MultiAttributeSeries to get access to their MultiAttributeSeriesValues   
LEFT JOIN "MultiAttributeSeriesValues"
ON "MultiAttributeSeriesValues"."MultiAttributeSeriesID"="MultiAttributeSeries"."MultiAttributeSeriesID"

-- Select one InstanceName and restrict the query AttributeDataTypeCV that is MultiAttributeSeries   

WHERE  Attributes.AttributeDataTypeCV='MultiAttributeSeries' 


AND "Instances"."InstanceNameCV"='Hyrum Reservoir'  

AND ("AttributesColumns"."AttributeNameCV" ='Volume' or "AttributesColumns"."AttributeNameCV" ='Elevation' )

--AND ScenarioName='Reference_LowerBear'

-- Sort the the values of each column name based on their ascending order
ORDER BY DatasetName,ObjectType,InstanceName,ScenarioName,AttributeName,MultiAttributeName,ValueOrder ASC



