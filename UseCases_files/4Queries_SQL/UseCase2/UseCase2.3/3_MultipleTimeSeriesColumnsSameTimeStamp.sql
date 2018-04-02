/*

4.5MultipleTimeSeriesColumnsSameTimeStamp.sql

Use case 4: identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?


Adel Abdallah
Updated April 2, 2018

*/
--Add metadata about these joins similar to what I have somewhere else 

SELECT  ElevationAttribute,ElevationUnit,VolumeAttribute,VolumeUnit,VolumeDateTimeStamp,ElevationValue,VolumeValue,ReservoirInflowValue,ReservoirReleaseValue


FROM
(

SELECT DISTINCT ResourceTypeAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS VolumeAttribute,AttributeNameCV,AttributeDataTypeCV,"UnitName" As VolumeUnit,DateTimeStamp As VolumeDateTimeStamp,Value As VolumeValue


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

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

-- Join the DataValuesMapper to get their SeasonalNumericValues
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."ValuesMapperID" = "ValuesMapper"."ValuesMapperID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeNameCV ='Volume' 

AND AttributeDataTypeCV='TimeSeries' 

AND ResourceTypeAcronym='RWISE'
)

INNER Join

(

SELECT DISTINCT ResourceTypeAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS ElevationAttribute,AttributeNameCV,AttributeDataTypeCV,"UnitName" As ElevationUnit,DateTimeStamp As ElevationDateTimeStamp,Value As ElevationValue

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

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeNameCV ='Elevation' 

AND AttributeDataTypeCV='TimeSeries' 

AND ResourceTypeAcronym='RWISE'

)

ON 
VolumeDateTimeStamp=ElevationDateTimeStamp

--------------------------------

INNER Join

(

SELECT DISTINCT ResourceTypeAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS ReservoirInflow,AttributeNameCV,AttributeDataTypeCV,"UnitName" As ReservoirInflowUnit,DateTimeStamp As ReservoirInflowDateTimeStamp,Value As ReservoirInflowValue

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

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeName ='Reservoir Inflow'

AND AttributeDataTypeCV='TimeSeries' 

AND ResourceTypeAcronym='RWISE'

)

ON 
VolumeDateTimeStamp=ReservoirInflowDateTimeStamp


------------------------

INNER Join

(

SELECT DISTINCT ResourceTypeAcronym,ScenarioName,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,AttributeName AS ReservoirInflow,AttributeNameCV,AttributeDataTypeCV,"UnitName" As ReservoirReleaseUnit,DateTimeStamp As ReservoirReleaseDateTimeStamp,Value As ReservoirReleaseValue


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

-- Join the DataValuesMapper to get their Time Series   
LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"


-- Specify controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeName ='Reservoir Release'

AND AttributeDataTypeCV='TimeSeries' 

AND ResourceTypeAcronym='RWISE'

)

ON 
VolumeDateTimeStamp=ReservoirReleaseDateTimeStamp

-----------------------


ORDER BY VolumeDateTimeStamp



