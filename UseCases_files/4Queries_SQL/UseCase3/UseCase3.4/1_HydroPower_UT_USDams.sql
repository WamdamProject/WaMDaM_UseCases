/*
4.6MultipleCategoricalvalues_HydroPower.sql

Use case 4: identify and compare infrastructure data across many data sources.
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?

This query shows the list of Reservoirs in Utah that have HydroPower purpose

Result:


Adel Abdallah
Updated June 13, 2018

*/

SELECT  DISTINCT ResourceTypeAcronymPurpose,InstanceNamePurpose ,CategoricalvaluePurpose,ResourceTypeAcronymState,InstanceNameState,FreeTextValueState

FROM

(
----------------------

SELECT ResourceTypeAcronym AS ResourceTypeAcronymState,InstanceName As InstanceNameState ,FreeTextValue As FreeTextValueState


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


LEFT JOIN FreeText
ON FreeText.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN Categoricalvalues
ON Categoricalvalues.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN CV_Categorical
ON CV_Categorical.Name=Categoricalvalues.CategoricalvalueCV	


-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND Attributes.AttributeName='STATE'

AND ResourceTypeAcronym='US Major Dams'

AND FreeTextValue='UT'


---------------
)

INNER JOIN
(
SELECT ResourceTypeAcronym AS ResourceTypeAcronymPurpose,InstanceName As InstanceNamePurpose ,Categoricalvalue As CategoricalvaluePurpose

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


LEFT JOIN FreeText
ON FreeText.ValuesMapperID=ValuesMapper.ValuesMapperID


LEFT JOIN Categoricalvalues
ON Categoricalvalues.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN CV_Categorical
ON CV_Categorical.Name=Categoricalvalues.CategoricalvalueCV	

-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND ResourceTypeAcronym='US Major Dams'

AND (Attributes.AttributeName ='PURPOSE' or Attributes.AttributeName ='SYMBOL')

AND Categoricalvalue='H'

)

ON 
InstanceNameState=InstanceNamePurpose


--ORDER BY AttributeNameCV,ObjectType,ObjectTypeCV,InstanceName desc



