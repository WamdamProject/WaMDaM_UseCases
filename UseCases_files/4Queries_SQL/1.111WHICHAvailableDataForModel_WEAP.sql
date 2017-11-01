/*
1.111WHICHAvailableDataForModel_WEAP.sql

This query identifies the available ObjectTypes and Attributes that the loaded datasets inside wamdam 
meet the data requirement of a model (e.g., WEAP) within a specified geospatial boundary 
(or it works with no boundary too if you want to search the entire wamdam db) 

Logic of the  qurey:

First, query all the ObjectTypes and Attributes in the wamdam db. 

Second, limit the query to the specified coordinates.

Third, limit the query results to only to what the model (e.g., WEAP) requires for its list of Objects and then Attributes. 

The query uses controlled vocabulary of both Object Types and Attributes to map and relate the existing native terms
of ObjectTypes and Attributes between the all the datasets and the model (e.g., WEAP)

Geospatial boundary here is defined by the x,y coordinates of node instances which are related to object types and attributes. 
An instance is always associated with an Object Type. The instance could have data values for zero or many attributes of the Object Type.  

An alternative way to search for data without the coordinates is to use the dataset(s) that are known to have data that 
covers the area of interest but its instances do not necessarily have coordinates values entered (coordinates are optional in WaMDaM) 


The query is generic to other areas: just change the coordinate boundary
The query is generic to other models (if they are already defined in WaMDaM): just change Acronym value
--WHERE "DatasetAcronym"='WEAP'-- 


Result:
Users can see the number of available instances and attributes for object types that WEAP requires. 
They can see the sources of each Object types and the native name in its original source along with the 
controlled or common name. 
Users can further search for more metadata and data about these instances. 
Then they can choose which ones to import to their model 

Adel Abdallah 
Last updated October 29, 2017

*/
-- This SELECT statement shows the list of WEAP Objects and their Attributes that have one or many native terms available them that have available data in the datasets
--Select Distinct WEAPObjectType ,ObjectTypeCV,ObjectType,DatasetAcronym, WEAPAttributeName,AttributeNameCV,AttributeName

--**This other SELECT statement limits the result to the WEAP Objects and Attributes. So it shows the list of them that have available data
Select Distinct WEAPObjectType ,WEAPAttributeName

From 

----------------------------------------------------------------------------------------------
-- Get the WEAP data requirement of ObjectTypes and Attributes
(
SELECT  Distinct ObjectTypeCV AS WEAPObjectTypeCV , ObjectType AS WEAPObjectType, AttributeNameCV AS WEAPAttributeNameCV , AttributeName AS WEAPAttributeName

FROM Datasets

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

WHERE "DatasetAcronym"='WEAP' 
--WHERE "DatasetAcronym"='WASH' 

)
----------------------------------------------------------------------------------------------
-- The join here 
--**************************************************

Inner Join
(
--Get all the the ObjectTypes and their Attributes in all the datasets in WaMDaM db WHERE
--They have nodes or links within the specified boundary 
-- the controlled ObjectTypes and Attributes match between WEAP and the other datasets   

SELECT Distinct ObjectTypeCV,ObjectType,DatasetAcronym, AttributeNameCV,AttributeName

--SELECT Distinct ObjectTypeCV, AttributeNameCV
--SELECT COUNT(Distinct ObjectTypeCV) as CountOfObjects,COUNT(Distinct AttributeNameCV) As CountOfAttributes
FROM Datasets

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

Left JOIN "Mapping"
ON Mapping.AttributeID= Attributes.AttributeID

Left JOIN "Instances" 
ON "Instances"."InstanceID"="Mapping"."InstanceID"

LEFT JOIN "ScenarioMapping"
ON "ScenarioMapping"."MappingID"="Mapping"."MappingID"

Left JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMapping"."ScenarioID"

Left JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

-- If a native attribute is not registered with a controlled attribute, then exclude the native one 
-- because it has no value as far as it cannot be related to other attributes  
WHERE AttributeNameCV is not null
  
and
-- limit the search to within the specified boundaries
("Longitude_x">='-111.648' 
AND "Longitude_x"<='-110.82'
AND "Latitude_y_x">='40.712'
AND "Latitude_y"<='42.848') 

--
AND (ObjectTypeCV IN 

(
-- #################  
-- limit the available ObjectTypes in the datasets to only the ones that their controlled ObjectTypes match the controlled ObjectTypes of WEAP  
SELECT Distinct ObjectTypeCV

FROM Datasets

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

WHERE "DatasetAcronym"='WEAP'
--WHERE "DatasetAcronym"='WASH'

))

-- #################  


AND (AttributeNameCV IN 

(
--/////////////////////////////
-- limit the available Attributes in the datasets to only the ones that their controlled Attributes match the controlled Attributes of WEAP  

SELECT Distinct AttributeNameCV

FROM Datasets

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

Left JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

WHERE "DatasetAcronym"='WEAP'
--WHERE "DatasetAcronym"='WASH'

))
  
--/////////////////////////////

  
-- Optional: filter the results to focus on one Object Type and one Attribute (e.g., Search for Reservoir volume)
--AND ObjectTypeCV='Reservoir'

--AND AttributeNameCV='Volume'

)
--**************************************************
-- This is the join crtieria: Both the controlled ObjectType and controlled Attribute in WEAP must match the same
--controlled ObjectType and controlled Attribute in all available datasets within the specified boundary

On WEAPObjectTypeCV=ObjectTypeCV
AND 
WEAPAttributeNameCV =AttributeNameCV


