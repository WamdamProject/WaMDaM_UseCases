/*
4.12NumericValues_otherTypes_Shasta.sql

Use case 4: identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?


This query shows parameters data values, their attributes, units, object names, and instances, and data source 
for all the parameters in WaM-DaM

Result:
users can import the data values to their model. WaM-DaM keeps track of the meanings of data values, their units, 
to what instance they apply too.... 

Adel Abdallah
Dec 5, 2017

*/

SELECT DISTINCT DatasetAcronym,ObjectType,ObjectTypeCV,InstanceName,InstanceNameCV,Attributes.AttributeName,AttributeNameCV,AttributeDataTypeCV,"UnitNameCV",ScenarioName
,"NumericValues"."NumericValue",descriptorvalue,CV_DescriptorValues.Definition AS DescriptorValueDefinition ,DualValueMeaningCV


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

AND InstanceNameCV='Shasta Reservoir'  

AND AttributeNameCV IN ('Volume','Elevation','Evaporation','Purpose','Hydro Capacity') 

ORDER BY AttributeNameCV,ObjectType,ObjectTypeCV,InstanceName desc





