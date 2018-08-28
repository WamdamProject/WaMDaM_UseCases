/*
5.2FindNodeLinkInstances_refuge.sql

Use case 5: identify inflow and outflow into and out of a node water system component and compare them across data sources or models. 
What is the inflow and outflow of Hyrum Reservoir, Utah? 


Find node and link Instances in the wamdam database WHERE 
a. within a geo-spatial boundary (less than and greater long and lat. coordinates)
   Links are searched based on their center coordinate based on the 
   Midpoint Theorem: The coordinates of the midpoint of a line segment are the average of the coordinates of its endpoints.
b. within a one or many specified Object Types 
   (removing this condition would search for all the available Object Types 
   which might be overwhelming as it might return hundreds of instances)
c. To one dataset name, or node or link typology. Other type of limits are possible too but not mentioned here


-- Note: the query will not show "node instances" that are not associated with links. 
The reason why is because the where clause is based on the start and end node instances 
which join to the connections table, which only has instances related to links.

Adel Abdallah
Updated June 12, 2018

*/

Select ResourceTypeAcronym,ScenarioName,


"Instances"."InstanceName" As LinkInstanceName, ObjectTypes.ObjectType AS LinkObjectType,ObjectTypes.ObjectTypeCV, 
"StartNodeInstance"."InstanceName" As StartEndNode,"StartNodeInstance".Longitude_x As StartInstanceLong,"StartNodeInstance".Latitude_y As StartLatitude_y,ObjectTypeStartNodeInstance.ObjectType AS StartNodeObjectType,
"EndNodeInstance"."InstanceName" As EndNodeInstance,
"EndNodeInstance".Longitude_x As EndStartInstanceLong,"EndNodeInstance".Latitude_y As EndLatitude_y,
ObjectTypeEndNodeInstance.ObjectType AS EndNodeObjectType


FROM ResourceTypes

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

---------------------------------------------------------------------------------------------
-- Join the Connections table to the Instances table   
LEFT JOIN "Connections" 
ON "Connections"."LinkInstanceID"="Instances"."InstanceID"


-- Join the Instances table the Start Node of link   
LEFT JOIN "Instances" As "StartNodeInstance"
ON "StartNodeInstance"."InstanceID"="Connections"."StartNodeInstanceID"

--- Get the Object Type Name for the start node instance 

LEFT JOIN "Mappings" As "MappingStartNodeInstace"
ON "MappingStartNodeInstace"."InstanceID"="StartNodeInstance"."InstanceID"

LEFT JOIN  "Attributes" As "AttributesStartNodeInstance"
ON "AttributesStartNodeInstance"."AttributeID"="MappingStartNodeInstace"."AttributeID"

LEFT JOIN  "ObjectTypes" As "ObjectTypeStartNodeInstance"
ON "ObjectTypeStartNodeInstance"."ObjectTypeID"="AttributesStartNodeInstance"."ObjectTypeID"
---------------------------------------------------------------------------------------------


-- Join the Instances table the End Node of link   
LEFT JOIN "Instances" As "EndNodeInstance"
ON "EndNodeInstance"."InstanceID"="Connections"."EndNodeInstanceID"

--- Get the Object Type Name for the start node instance 

LEFT JOIN "Mappings" As "MappingEndNodeInstace"
ON "MappingEndNodeInstace"."InstanceID"="EndNodeInstance"."InstanceID"

LEFT JOIN  "Attributes" As "AttributesEndNodeInstance"
ON "AttributesEndNodeInstance"."AttributeID"="MappingEndNodeInstace"."AttributeID"

LEFT JOIN  "ObjectTypes" As "ObjectTypeEndNodeInstance"
ON "ObjectTypeEndNodeInstance"."ObjectTypeID"="AttributesEndNodeInstance"."ObjectTypeID"
---------------------------------------------------------------------------------------------



LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT JOIN Methods
on Methods.MethodID = Mappings.MethodID

LEFT JOIN Sources
ON Sources.SourceID = Mappings.SourceID 

-- This clause is needed to only return the Instances of an ObjectType
-- an Instance and its parent ObjectType are connected together in wamdam through this special attribute
WHERE  

Attributes.AttributeName='ObjectTypeInstances' 

AND AttributesStartNodeInstance.AttributeName='ObjectTypeInstances' 

AND AttributesEndNodeInstance.AttributeName='ObjectTypeInstances' 

-- Uncommenting one of the lines below will limit the search for either nodes or link Object typologies
--AND ObjectTypologyCV='Node'
--AND ObjectTypologyCV='Link'

--Limit the search for one or manay specified Object Types 
--AND (ObjectTypes.ObjectTypeCV='Reservoir' or ObjectTypes.ObjectTypeCV='Demand site' or ObjectTypes.ObjectTypeCV='Diversion')

--Limit the search to only one dataset 
--AND DatasetAcronym='WEAP'

--Limit the search to only one scenario
--AND ScenarioName='USU WEAP Model 2017'

--AND ObjectTypes.ObjectTypologyCV='Link'

--AND (StartNodeInstance.InstanceNameCV='Hyrum Reservoir' Or EndNodeInstance.InstanceNameCV='Hyrum Reservoir' )

AND (StartNodeInstance.InstanceNameCV = 'Bear River Migratory Bird Refuge' Or EndNodeInstance.InstanceNameCV ='Bear River Migratory Bird Refuge' )

ORDER BY ResourceTypeAcronym,MasterNetworkName,ScenarioName







