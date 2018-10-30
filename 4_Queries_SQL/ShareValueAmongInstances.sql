SELECT ResourceTypeAcronym,ObjectType,InstanceName,Categoricalvalue As Categoricalvalue,CategoricalValueCV	,CategoricalValueID

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


LEFT JOIN Categoricalvalues
ON Categoricalvalues.ValuesMapperID=ValuesMapper.ValuesMapperID

LEFT JOIN CV_Categorical
ON CV_Categorical.Name=Categoricalvalues.CategoricalvalueCV	

-- Specifiy controlled Object Type, instance name, and an attribute of interest
WHERE ObjectTypeCV='Reservoir' 

AND ResourceTypeAcronym='US Major Dams'

AND (Attributes.AttributeName ='PURPOSE')

AND Categoricalvalue='H'
