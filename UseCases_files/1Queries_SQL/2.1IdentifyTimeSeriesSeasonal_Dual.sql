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
Updated October 30, 2017

*/

SELECT DISTINCT DatasetAcronym,ObjectType,
--AttributeNameCV
AttributeName,
AttributeDataTypeCV,
WaterOrCalendarYear,
--InstanceNameCV,
InstanceName,
ScenarioName,
AggregationStatisticCV,AggregationInterval,IntervalTimeUnitCV,
DualValue AS DualValue,BooleanValue


FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mapping"
ON "Mapping"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mapping"."InstanceID"

LEFT JOIN "DataValuesMapper" 
ON "DataValuesMapper"."DataValuesMapperID"="Mapping"."DataValuesMapperID"

LEFT JOIN "ScenarioMapping"
ON "ScenarioMapping"."MappingID"="Mapping"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMapping"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT JOIN "DualValues"
ON DualValues.DataValuesMapperID=DataValuesMapper.DataValuesMapperID

LEFT JOIN "CV_DualValueMeaning"
ON CV_DualValueMeaning.Name=DualValues.DualValueMeaningCV


LEFT JOIN "TimeSeries" 
ON "TimeSeries"."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

-- Join the DataValuesMapper to get their SeasonalNumericValues
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."DataValuesMapperID" = "DataValuesMapper"."DataValuesMapperID"

-- Limit the search for one node using the controlled instance name
WHERE InstanceNameCV='USGS 10046500 BEAR RIVER BL STEWART DAM NR MONTPELIER, ID'  

AND (AttributeNameCV='Flow' or AttributeNameCV='Status')

Order By AttributeDataTypeCV DESC
--,IntervalTimeUnitCV,DatasetAcronym,ScenarioName ASC

