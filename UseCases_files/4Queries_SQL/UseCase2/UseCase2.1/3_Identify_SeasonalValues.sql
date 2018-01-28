/*
2.3Identify_SeasonalValues.sql

Use case 2: identify and compare time series and seasonal discharge data across data sources. 
What is the discharge at the node “below Stewart Dam” in Idaho?

This query identifies time series and seasonal data values, their time stamps and time series metadata

Result:
Time series data for a specific attribute 
WaM-DaM keeps track of the meanings of data values, their units, to what instance they apply too.... 

Adel Abdallah
Updated Jan 27, 2018

*/
--DatasetAcronym,ScenarioName,ObjectType,AttributeName,AttributeNameCV,InstanceName,InstanceNameCV,SeasonName,SeasonOrder,SeasonNumericValue

SELECT DatasetAcronym,ScenarioName,ObjectType,AttributeName,AttributeNameCV,
InstanceName,InstanceNameCV,SeasonName,SeasonOrder,SeasonNumericValue

FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON Mappings.AttributeID= Attributes.AttributeID

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

-- Join the DataValuesMapper to get their SeasonalParameters   
LEFT JOIN "SeasonalNumericValues"
ON "SeasonalNumericValues"."DataValuesMapperID" = "DataValuesMapper"."DataValuesMapperID" 

WHERE
 InstanceNameCV='USGS 10046500 BEAR RIVER BL STEWART DAM NR MONTPELIER, ID'   

AND AttributeNameCV='Flow'
AND AttributeName ='Average Monthly Streamflow '

--AND AttributeName NOT IN ('Import/Export net inflow', 'Historic Diversion outflow')

AND AttributeDataTypeCV='SeasonalNumericValues'

--exclude the "Total" season name. This is the sum of the 12 months values which is the annual value 
AND SeasonName!='Total'

--sort the results and show the seasons in the order they were entered
ORDER BY DatasetAcronym,ObjectType,AttributeName,InstanceName, ScenarioName,SeasonOrder,SeasonName ASC
