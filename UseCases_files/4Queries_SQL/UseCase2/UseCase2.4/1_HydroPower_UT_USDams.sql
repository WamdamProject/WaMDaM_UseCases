/*
4.6MultipleDescriptorValues_HydroPower.sql

Use case 4: identify and compare infrastructure data across many data sources.
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?

This query shows the list of Reservoirs in Utah that have HydroPower purpose

Result:


Adel Abdallah
Updated April 2, 2018

*/

SELECT  DISTINCT ResourceTypeAcronymPurpose,InstanceNamePurpose ,DescriptorValuePurpose,ResourceTypeAcronymState,InstanceNameState,DescriptorValueState

FROM

(
----------------------

SELECT ResourceTypeAcronym AS ResourceTypeAcronymState,InstanceName As InstanceNameState ,descriptorvalue As DescriptorValueState


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

LEFT JOIN DescriptorValues
ON DescriptorValues.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN CV_DescriptorValues
ON CV_DescriptorValues.Name=DescriptorValues.DescriptorValueCV	


-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND Attributes.AttributeName='STATE'

AND ResourceTypeAcronym='US Major Dams'

AND Descriptorvalue='UT'


---------------
)

INNER JOIN
(
SELECT ResourceTypeAcronym AS ResourceTypeAcronymPurpose,InstanceName As InstanceNamePurpose ,descriptorvalue As DescriptorValuePurpose

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

LEFT JOIN DescriptorValues
ON DescriptorValues.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN CV_DescriptorValues
ON CV_DescriptorValues.Name=DescriptorValues.DescriptorValueCV	

-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND ResourceTypeAcronym='US Major Dams'

AND (Attributes.AttributeName ='PURPOSE' or Attributes.AttributeName ='SYMBOL')

AND descriptorvalue='H'

)

ON 
InstanceNameState=InstanceNamePurpose


--ORDER BY AttributeNameCV,ObjectType,ObjectTypeCV,InstanceName desc






