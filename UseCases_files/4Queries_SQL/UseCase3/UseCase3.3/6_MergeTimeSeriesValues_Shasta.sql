/*

4.32MergeTimeSeriesValues_Shasta.sql


Use case 4: identify and compare infrastructure data across many data sources.
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?



Adel Abdallah
Updated April 3, 2018



*/


SELECT  ElevationAttribute,ElevationUnit,VolumeAttribute,VolumeUnit,VolumeDateTimeStamp,ElevationValue,VolumeValue


FROM
(

SELECT DISTINCT ResourceTypeAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS VolumeAttribute,AttributeNameCV,AttributeDataTypeCV,"UnitName" As VolumeUnit,DateTimeStamp As VolumeDateTimeStamp,DataValue As VolumeValue


FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

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

LEFT JOIN "NumericValues" 
ON "NumericValues"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

LEFT JOIN "TimeSeries" 
ON "TimeSeries"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

-- Join the ValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

-- Join the ValuesMapper to get their SeasonalNumericValues
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."ValuesMapperID" = "ValuesMapper"."ValuesMapperID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Shasta Reservoir'  

AND AttributeNameCV = 'Volume'

AND AttributeDataTypeCV='TimeSeries' 

AND ResourceTypeAcronym='RWISE'
)

INNER Join

(

SELECT DISTINCT ResourceTypeAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS ElevationAttribute,AttributeNameCV,AttributeDataTypeCV,"UnitName" As ElevationUnit,DateTimeStamp As ElevationDateTimeStamp,DataValue As ElevationValue


FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

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

-- Join the ValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Shasta Reservoir'  

AND AttributeNameCV ='Elevation' 

AND AttributeDataTypeCV='TimeSeries' 

AND ResourceTypeAcronym='RWISE'

)

ON 
VolumeDateTimeStamp=ElevationDateTimeStamp

--------------------------------


ORDER BY VolumeDateTimeStamp



