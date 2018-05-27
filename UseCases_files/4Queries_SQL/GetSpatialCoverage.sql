/*

Ge the spatial covergae of data inside a WaMDaM SQLite file to use in HydroShare metadata

Get the min and max long and lat coordinates 


*/


Select

Min(Longitude_x) As MinLong,Min(Latitude_y) as MinLat,
Max(Longitude_x) As MaxLong,Max(Latitude_y) as MaxLat

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

WHERE AttributeNameCV is not null
  
and
-- limit the search to within the specified boundaries
("Longitude_x">='-111.648' 
AND "Longitude_x"<='-110.82'
AND "Latitude_y">='40.712'
AND "Latitude_y"<='42.848') 
