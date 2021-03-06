/*
1.121WHICHAvailableDataForModel_WASH.sql


This query identifies the available ObjectTypes and Attributes that the loaded datasets inside wamdam 
meet the data requirement of a model (e.g., WASH) within a specified geospatial boundary 
(or it works with no boundary too if you want to search the entire wamdam db) 

Logic of the  qurey:

First, query all the ObjectTypes and Attributes in the wamdam db. 

Second, limit the query to the specified coordinates.

Third, limit the query results to only to what the model (e.g., WASH) requires for its list of Objects and then Attributes. 

The query uses controlled vocabulary of both Object Types and Attributes to map and relate the existing native terms
of ObjectTypes and Attributes between the all the datasets and the model (e.g., WASH)

Geospatial boundary here is defined by the x,y coordinates of node instances which are related to object types and attributes. 
An instance is always associated with an Object Type. The instance could have data values for zero or many attributes of the Object Type.  

An alternative way to search for data without the coordinates is to use the dataset(s) that are known to have data that 
covers the area of interest but its instances do not necessarily have coordinates values entered (coordinates are optional in WaMDaM) 


The query is generic to other areas: just change the coordinate boundary
The query is generic to other models (if they are already defined in WaMDaM): just change Acronym value
--WHERE "DatasetAcronym"='WASH'-- 


Result:
Users can see the number of available instances and attributes for object types that WASH requires. 
They can see the sources of each Object types and the native name in its original source along with the 
controlled or common name. 
Users can further search for more metadata and data about these instances. 
Then they can choose which ones to import to their model 

Adel Abdallah 
April 2, 2018

*/
-- This SELECT statement shows the list of WASH Objects and their Attributes that have one or many native terms available them that have available data in the datasets
--Select Distinct WASHObjectType ,ObjectTypeCV,ObjectType,DatasetAcronym, WASHAttributeName,AttributeNameCV,AttributeName

--**This other SELECT statement limits the result to the WASH Objects and Attributes. So it shows the list of them that have available data
Select Distinct WASHObjectType ,WASHAttributeName

From 

----------------------------------------------------------------------------------------------
-- Get the WASH data requirement of ObjectTypes and Attributes
(
SELECT  Distinct ObjectTypeCV AS WASHObjectTypeCV , ObjectType AS WASHObjectType, AttributeNameCV AS WASHAttributeNameCV , AttributeName AS WASHAttributeName

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

WHERE "ResourceTypeAcronym"='WASH' 

)
----------------------------------------------------------------------------------------------
-- The join here 
--**************************************************

Inner Join
(
--Get all the the ObjectTypes and their Attributes in all the datasets in WaMDaM db WHERE
--They have nodes or links within the specified boundary 
-- the controlled ObjectTypes and Attributes match between WASH and the other datasets   

SELECT Distinct ObjectTypeCV,ObjectType,ResourceTypeAcronym, AttributeNameCV,AttributeName

--SELECT Distinct ObjectTypeCV, AttributeNameCV
--SELECT COUNT(Distinct ObjectTypeCV) as CountOfObjects,COUNT(Distinct AttributeNameCV) As CountOfAttributes
FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

Left JOIN "Mappings"
ON Mappings.AttributeID= Attributes.AttributeID

Left JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

Left JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

Left JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

-- If a native attribute is not registered with a controlled attribute, then exclude the native one 
-- because it has no value as far as it cannot be related to other attributes  
WHERE AttributeNameCV is not null
  
and
-- limit the search to within the specified boundaries
("Longitude_x">='-111.648' 
AND "Longitude_x"<='-110.82'
AND "Latitude_y">='40.712'
AND "Latitude_y"<='42.848') 

--
AND (ObjectTypeCV IN 

(
-- #################  
-- limit the available ObjectTypes in the datasets to only the ones that their controlled ObjectTypes match the controlled ObjectTypes of WASH  
SELECT Distinct ObjectTypeCV

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

WHERE "ResourceTypeAcronym"='WASH'

))

-- #################  


AND (AttributeNameCV IN 

(
--/////////////////////////////
-- limit the available Attributes in the datasets to only the ones that their controlled Attributes match the controlled Attributes of WASH  

SELECT Distinct AttributeNameCV

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

WHERE "ResourceTypeAcronym"='WASH'
--WHERE "ResourceTypeAcronym"='WASH'

))
  
--/////////////////////////////

  
-- Optional: filter the results to focus on one Object Type and one Attribute (e.g., Search for Reservoir volume)
--AND ObjectTypeCV='Reservoir'

--AND AttributeNameCV='Volume'

)
--**************************************************
-- This is the join crtieria: Both the controlled ObjectType and controlled Attribute in WASH must match the same
--controlled ObjectType and controlled Attribute in all available datasets within the specified boundary

On WASHObjectTypeCV=ObjectTypeCV
AND 
WASHAttributeNameCV =AttributeNameCV


