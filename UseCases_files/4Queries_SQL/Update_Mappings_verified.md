/*
This "Update" SQL query allows users to update the Mappings table to indicate a "verified" DataValue. 
A verified record set to True indicates that the user has verified, curated, checked, or selected this 
data value as ready to be used for models. A verified recored can then be used from an automated script to 
serve data to models. Its particularly useful when the same set of controlled object type, attribute, and instances names 
return multiple data values from different sources with potentially smiliar or different values due to many factors.

*/

UPDATE Mappings 

SET Verified= 'True'
WHERE  MappingID in

(SELECT Mappings.MappingID FROM Mappings

-- Join the Mappings to get their Attributes
LEFT JOIN "Attributes"
ON Attributes.AttributeID= Mappings.AttributeID

-- Join the Attributes to get their ObjectTypes
LEFT JOIN  "ObjectTypes"
ON "ObjectTypes"."ObjectTypeID"="Attributes"."ObjectTypeID"

-- Join the Mappings to get their Instances   
LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

-- Join the Mappings to get their ScenarioMappings   
LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

-- Join the ScenarioMappings to get their Scenarios   
LEFT JOIN "Scenarios"
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

-- Join the Scenarios to get their MasterNetworks   
LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

where 
ObjectTypes.ObjectType='Reservoir'  

AND "Instances"."InstanceName"='Hyrum Reservoir'  

AND AttributeName='Total Capacity Table'

AND ScenarioName='Base case'

AND MasterNetworkName='Bear River'


)
