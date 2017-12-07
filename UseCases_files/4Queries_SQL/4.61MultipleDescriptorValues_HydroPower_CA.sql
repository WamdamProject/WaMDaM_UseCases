/*
4.6MultipleDescriptorValues_HydroPower.sql

Use case 4: identify and compare infrastructure data across many data sources.
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?

This query shows the list of Reservoirs in Utah that have HydroPower purpose

Result:


Adel Abdallah
Dec 6, 2017

*/

SELECT  DISTINCT DatasetAcronymPurpose,InstanceNamePurpose ,DescriptorValuePurpose,DatasetAcronymState,InstanceNameState,DescriptorValueState

FROM

(
----------------------

SELECT DatasetAcronym AS DatasetAcronymState,InstanceName As InstanceNameState ,descriptorvalue As DescriptorValueState


FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "DataValuesMapper" 
ON "DataValuesMapper"."DataValuesMapperID"="Mappings"."DataValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

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

LEFT JOIN DescriptorValues
ON DescriptorValues.DataValuesMapperID=DataValuesMapper.DataValuesMapperID

LEFT JOIN CV_DescriptorValues
ON CV_DescriptorValues.Name=DescriptorValues.DescriptorValueCV	

LEFT JOIN DualValues
ON DualValues.DataValuesMapperID=DataValuesMapper.DataValuesMapperID

LEFT JOIN CV_DualValueMeaning
ON CV_DualValueMeaning.Name=DualValues.DualValueMeaningCV

-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND Attributes.AttributeName='STATE'

AND DatasetAcronym='US Major Dams'

AND Descriptorvalue='CA'


---------------
)

INNER JOIN
(
SELECT DatasetAcronym AS DatasetAcronymPurpose,InstanceName As InstanceNamePurpose ,descriptorvalue As DescriptorValuePurpose


FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "DataValuesMapper" 
ON "DataValuesMapper"."DataValuesMapperID"="Mappings"."DataValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

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

LEFT JOIN DescriptorValues
ON DescriptorValues.DataValuesMapperID=DataValuesMapper.DataValuesMapperID

LEFT JOIN CV_DescriptorValues
ON CV_DescriptorValues.Name=DescriptorValues.DescriptorValueCV	

LEFT JOIN DualValues
ON DualValues.DataValuesMapperID=DataValuesMapper.DataValuesMapperID

LEFT JOIN CV_DualValueMeaning
ON CV_DualValueMeaning.Name=DualValues.DualValueMeaningCV

-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND DatasetAcronym='US Major Dams'

AND (Attributes.AttributeName ='PURPOSE' or Attributes.AttributeName ='SYMBOL')

AND descriptorvalue='H'

)

ON 
InstanceNameState=InstanceNamePurpose


--ORDER BY AttributeNameCV,ObjectType,ObjectTypeCV,InstanceName desc






