/*
-- 4.2 MultiAttributeValues.sql

Use case 4: identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?


Adel Abdallah
Updated April 3, 2018

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
"DataValue","ValueOrder"

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

-- Join the Object types to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

-- Join the Attributes to get their Mappings   
LEFT JOIN "Mappings"
ON Mappings.AttributeID= Attributes.AttributeID

-- Join the Mappings to get their Instances   
LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

-- Join the Mappings to get their ScenarioMappings   
LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

-- Join the ScenarioMappings to get their Scenarios   
LEFT JOIN "Scenarios"
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"


-- Join the Scenarios to get their MasterNetworks   
LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

-- Join the Mappings to get their Methods   
LEFT JOIN "Methods" 
ON "Methods"."MethodID"="Mappings"."MethodID"

-- Join the Mappings to get their Sources   
LEFT JOIN "Sources" 
ON "Sources"."SourceID"="Mappings"."SourceID"

-- Join the Mappings to get their DataValuesMappers   
LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

-- Join the DataValuesMapper to get their MultiAttributeSeries   
LEFT JOIN "MultiAttributeSeries"  
ON "MultiAttributeSeries" ."ValuesMapperID"="ValuesMapper"."ValuesMapperID"


/*This is an extra join to get to each column name within the MultiColumn Array */

-- Join the MultiAttributeSeries to get to their specific DataValuesMapper, now called DataValuesMapperColumn
LEFT JOIN "ValuesMapper" As "ValuesMapperColumn"
ON "ValuesMapperColumn"."ValuesMapperID"="MultiAttributeSeries"."MappingID_Attribute"

-- Join the DataValuesMapperColumn to get back to their specific Mapping, now called MappingColumns
LEFT JOIN "Mappings" As "MappingColumns"
ON "MappingColumns"."ValuesMapperID"="ValuesMapperColumn"."ValuesMapperID"

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
ORDER BY ResourceTypeAcronym,ObjectType,InstanceName,ScenarioName,AttributeName,MultiAttributeName,ValueOrder ASC
