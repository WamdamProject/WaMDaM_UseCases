/*
--1.21AdditionalDataForModel_WEAP.sql

This query identifies the available ObjectTypes and Attributes that the loaded datasets inside wamdam 
meet the data requirement of a model (e.g., WEAP) within a specified geospatial boundary 
(or it works with no boundary too if you want to search the entire wamdam db) 

Logic of the query

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
--WHERE "DatasetAcronym"=’WASH’

Adel Abdallah 
Jan 27, 2018

*/
-- Show the join results for the native WEAP Object Types and Attributes
SELECT Distinct WEAPObjectType, ObjectCategoryName,WEAPAttributeName,AttributeCategoryName

-- Show the join results for the native WEAP Object Types and Attributes and the controlled ones as well
--SELECT DISTINCT WEAPObjectType,ObjectCategoryName ,WEAPObjectTypeCV , WEAPAttributeName,AttributeCategoryName,WEAPAttributeNameCV

From 

(

----------------------------------------------------------------------------------------------
-- Get the WEAP data requirement of ObjectTypes and Attributes
	
SELECT DISTINCT  ObjectType AS WEAPObjectType,ObjectCategoryName,ObjectTypeCV AS WEAPObjectTypeCV ,AttributeName AS WEAPAttributeName,AttributeCategoryName,AttributeCategoryName,AttributeNameCV AS WEAPAttributeNameCV
FROM Datasets

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "ObjectCategories"
ON "ObjectCategories"."ObjectCategoryID"="ObjectTypes"."ObjectCategoryID" 

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

LEFT JOIN  "AttributeCategories"
ON "AttributeCategories"."AttributeCategoryID"="Attributes"."AttributeCategoryID" 


WHERE "DatasetAcronym"='WEAP' 

-- Users can limit the search of additional attributes based on Attribute Category 
-- They can excldue all the attributes that have a native category (or controlled too) of "Water Quality" or "cost" 	

AND AttributeCategoryName!='Water Quality'
AND AttributeCategoryName!='Cost'
--AND ObjectCategoryName!='Supply and Resources'



OR "DatasetAcronym"='WEAP'  AND AttributeCategoryName is null AND WEAPAttributeName!='ObjectTypeInstances'


AND WEAPAttributeName!='ObjectTypeInstances'

)

-- The join here returns the non-matching controlled vocabulary between WEAP and the existing datasets
--**************************************************

LEFT OUTER Join

(
--Get all the ObjectTypes and their Attributes in all the datasets in WaMDaM db WHERE
--They have nodes or links within the specified boundary 
-- the controlled ObjectTypes and Attributes match between WEAP and the other datasets
	
SELECT Distinct ObjectTypeCV,AttributeNameCV

FROM Datasets

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

LEFT JOIN "Mappings"
ON Mappings.AttributeID= Attributes.AttributeID

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

WHERE
("Longitude_x">='-111.648' 
AND "Longitude_x"<='-110.82'
AND "Latitude_y_x">='40.712'
AND "Latitude_y"<='42.848') 


)
--**************************************************

-- This is the join criteria: Both the controlled ObjectType and controlled Attribute in WEAP must match the same
--controlled ObjectType and controlled Attribute in all available datasets within the specified boundary

On WEAPObjectTypeCV=ObjectTypeCV
AND 
WEAPAttributeNameCV =AttributeNameCV

-- the left outer join in SQLite still return the common matching data. This criteria below removes the matching results.
-- full outer join which only returns the non-matching results is not supported in SQLite. So this condition below is a work around this limitation

WHERE ObjectTypeCV is null AND AttributeNameCV is null