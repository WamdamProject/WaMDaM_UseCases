/*		
 		
3.1IdentifyDemandSites.sql		
		
Use case 3: identify and compare demand data for a site as reported in many sources. 		
What is the total agriculture water use or demand in Cache Valley, Utah?		
		
		
 Find node and link Instances within a boundary in space		
 ---First look for all the instances and their attributes, then query the actual values (present the result with the number of sites)		 		
 Adel Abdallah		
 Updated June 12, 2018		
 		
 */
 
Select DISTINCT ResourceTypeAcronym,MasterNetworkName,ScenarioName,ObjectType,ObjectTypeCV,ObjectTypologyCV, AttributeDataTypeCV
,AttributeName,AttributeName_Abstract,AttributeNameCV,InstanceName,InstanceCategory,InstanceNameCV
,Sourcename, Methodname

--,Longitude_x,Latitude_y

FROM ResourceTypes

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "InstanceCategories" 
ON "InstanceCategories"."InstanceCategoryID"="Instances"."InstanceCategoryID"

LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT join "Methods" 
ON "Methods"."MethodID" = "Mappings"."MethodID"

LEFT join "Sources" 
ON "Sources"."SourceID" = "Mappings"."SourceID"

WHERE  

-- specify the boundary of coordinates of the search domain in space 
-- this Boundary Cache Valley, Utah
("Instances"."Longitude_x">='-112.022' 
AND "Instances"."Longitude_x"<='-111.4'
AND "Instances"."Latitude_y">='41.3'
AND "Instances"."Latitude_y"<='41.95') 

AND ObjectTypeCV='Demand site' 

--AND AttributeNameCV In ('Flow', 'Demand')

-- narrow the search to instances with the category of agriculture
--AND InstanceCategory='Agriculture'

AND ResourceTypeAcronym='WEAP' 

AND ScenarioName='USU WEAP Model 2017'

AND InstanceCategory='Agriculture'

AND AttributeName_Abstract IN ('Annual Water Use Rate','Monthly Demand')


ORDER BY AttributeDataTypeCV ,MasterNetworkName,ScenarioName,InstanceName DESC
