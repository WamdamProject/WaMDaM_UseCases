/*
4.4NumericValues_Metadata.sql

Use case 4: identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?


This query shows parameters data values, their attributes, units, object names, and instances, and data source 
for all the parameters in WaM-DaM

Result:
users can import the data values to their model. WaM-DaM keeps track of the meanings of data values, their units, 
to what instance they apply too.... 

Adel Abdallah
October 30, 2017

*/

SELECT DISTINCT Attributes.AttributeName,
"Methods"."MethodName",
"OrganizationsMethods"."OrganizationName" As "MethodOrganizationName",
"PeopleMethods"."PersonName" As "MethodContactName",
PeopleMethods.Phone As "MethodPersonPhone",
MethodWebpage,

"Sources"."SourceName","OrganizationsSources"."OrganizationName" As "SourceOrganizationName",
PeopleSources.Phone As "SourcePersonPhone",
"PeopleSources"."PersonName" As "SourceContactName",
SourceWebpage	

FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mapping"
ON "Mapping"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mapping"."InstanceID"

Left JOIN "Methods" 
ON "Methods"."MethodID"="Mapping"."MethodID"

Left JOIN "Sources" 
ON "Sources"."SourceID"="Mapping"."SourceID"

Left JOIN "People" As "PeopleSources"
ON "PeopleSources"."PersonID"="Sources"."PersonID"

Left JOIN "People" As "PeopleMethods" 
ON "PeopleMethods"."PersonID"="Methods"."PersonID"

Left JOIN "Organizations" As "OrganizationsMethods" 
ON "OrganizationsMethods" ."OrganizationID"="PeopleMethods"."OrganizationID"

Left JOIN "Organizations" As "OrganizationsSources" 
ON "OrganizationsSources" ."OrganizationID"="PeopleSources"."OrganizationID"



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

AND InstanceNameCV='Hyrum Reservoir'  
--AND InstanceNameCV='Hyrum Reservoir'  

AND AttributeNameCV IN ('Volume') 

ORDER BY AttributeNameCV,ObjectType,ObjectTypeCV,InstanceName desc


