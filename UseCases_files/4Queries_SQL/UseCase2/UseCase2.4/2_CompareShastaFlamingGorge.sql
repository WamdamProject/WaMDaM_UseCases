/*
4.6MultipleNumericValues_HydroPower.sql

Use case 4: identify and compare infrastructure data across many data sources.
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?

This query shows the list of Reservoirs in Utah that have HydroPower purpose

Result:


Adel Abdallah
Dec 24, 2017

*/

SELECT  DISTINCT DatasetAcronymDamHEIGHT,InstanceNameCVDamHEIGHT,DamHEIGHT,UnitNameHeight,InstalledCapacity,UnitNameCap,N_Gen
FROM

(
----------------------

SELECT DatasetAcronym AS DatasetAcronymDamHEIGHT,InstanceNameCV As InstanceNameCVDamHEIGHT ,NumericValue As DamHEIGHT,UnitName AS UnitNameHeight


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

AND Attributes.AttributeName='NID_HEIGHT'

AND DatasetAcronym='US Major Dams'

--AND Descriptorvalue='UT'


---------------
)



-- join to get the installed capacity

INNER JOIN
(
SELECT DatasetAcronym AS DatasetAcronymCapacity,InstanceNameCV As InstanceNameCVCap,NumericValue As InstalledCapacity,UnitName as UnitNameCap


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

AND DatasetAcronym='NHAAP'

AND Attributes.AttributeName ='HY_MW'


)

ON 
InstanceNameCVDamHEIGHT=InstanceNameCVCap


--

-- join to get the installed N_Gen

INNER JOIN
(
SELECT DatasetAcronym AS DatasetAcronymN_Gen,InstanceNameCV As InstanceNameCVN_Gen,NumericValue As N_Gen


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

AND DatasetAcronym='NHAAP'

AND Attributes.AttributeName ='N_Gen'


)

ON 
InstanceNameCVDamHEIGHT=InstanceNameCVN_Gen



