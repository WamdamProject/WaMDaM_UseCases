/*
1.01Identify_WEAPmodel_requirements.sql

Users can automatically identify the list of Object types and their attributes that are required/used by a model. 
The model must be already defined in WaMDaM previously. Users can define a model input data at once 
using the WaMDaM Excel template. 
Once in WaMDaM, users can filter the model requirements based on object types and/or categories. They also can use these lists 
or required object types and their attributes to automatically search for available data in 
datasets in WaMDaM and identify additional needed data not available in WaMDaM database.


Adel Abdallah 
Last updated Jan 27, 2018

*/

SELECT DISTINCT  ObjectType,ObjectCategoryName,ObjectTypeCV ,AttributeName, AttributeCategoryName,AttributeNameCV 
FROM Datasets

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "ObjectCategories"
ON "ObjectCategories"."ObjectCategoryID"="ObjectTypes"."ObjectCategoryID" 

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID" 

LEFT JOIN  "AttributeCategories"
ON "AttributeCategories"."AttributeCategoryID"="Attributes"."AttributeCategoryID" 

-- Provide the model name 
WHERE "DatasetAcronym"='WEAP' 
--WHERE "DatasetAcronym"='WASH' 

--exclude the dummy attributes that are just used to connect Object Types with their Instances. 
AND AttributeName!='ObjectTypeInstances' 
