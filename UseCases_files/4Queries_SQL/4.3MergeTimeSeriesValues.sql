/*

4.3MergeTimeSeriesValues.sql


Use case 4: identify and compare infrastructure data across many data sources.
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?



Adel Abdallah
Updated October 30, 2017



*/


SELECT  ElevationAttribute,ElevationUnit,VolumeAttribute,VolumeUnit,VolumeDateTimeStamp,ElevationValue,VolumeValue


FROM
(

SELECT DISTINCT DatasetAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS VolumeAttribute,AttributeNameCV,AttributeDataTypeCV,"UnitName" As VolumeUnit,DateTimeStamp As VolumeDateTimeStamp,Value As VolumeValue


FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

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

LEFT JOIN "NumericValues" 
ON "NumericValues"."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"

LEFT JOIN "TimeSeries" 
ON "TimeSeries"."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

-- Join the DataValuesMapper to get their SeasonalNumericValues
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."DataValuesMapperID" = "DataValuesMapper"."DataValuesMapperID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeNameCV = 'Volume'

AND AttributeDataTypeCV='TimeSeries' 

AND DatasetAcronym='RWISE'
)

INNER Join

(

SELECT DISTINCT DatasetAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS ElevationAttribute,AttributeNameCV,AttributeDataTypeCV,"UnitName" As ElevationUnit,DateTimeStamp As ElevationDateTimeStamp,Value As ElevationValue


FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

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


LEFT JOIN "TimeSeries" 
ON "TimeSeries"."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeNameCV ='Elevation' 

AND AttributeDataTypeCV='TimeSeries' 

AND DatasetAcronym='RWISE'

)

ON 
VolumeDateTimeStamp=ElevationDateTimeStamp

--------------------------------


ORDER BY VolumeDateTimeStamp



