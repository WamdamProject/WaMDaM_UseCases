/*
2.1IdentifyTimeSeriesSeasonal_Dual.sql

Use case 2: identify and compare time series and seasonal discharge data across data sources. 
What is the discharge at the node “below Stewart Dam” in Idaho?

This query identifies time series and seasonal data and their metadata. and dual values
Users can select one or many of them to get their data values and perform aggregations,
and possibly change water year to calendar year to get comparable values  

Result:
Time series data for a specific attribute 
WaM-DaM keeps track of the meanings of data values, their units, to what instance they apply too.... 

Adel Abdallah
Updated April 2, 2018

*/

SELECT DISTINCT ResourceTypeAcronym,ObjectType,
--AttributeNameCV
AttributeName,
AttributeDataTypeCV,
YearType,
--InstanceNameCV,
InstanceName,
ScenarioName,
AggregationStatisticCV,AggregationInterval,IntervalTimeUnitCV

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

LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT JOIN "TimeSeries" 
ON "TimeSeries"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

-- Join the DataValuesMapper to get their SeasonalNumericValues
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."ValuesMapperID" = "ValuesMapper"."ValuesMapperID"

-- Limit the search for one node using the controlled instance name
WHERE InstanceNameCV='USGS 10046500 BEAR RIVER BL STEWART DAM NR MONTPELIER, ID'  

AND (AttributeNameCV='Flow' or AttributeNameCV='Status')

Order By AttributeDataTypeCV DESC
--,IntervalTimeUnitCV,DatasetAcronym,ScenarioName ASC
