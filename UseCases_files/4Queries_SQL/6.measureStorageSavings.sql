/* 

6.MeasureStorageSavings.sql

Adel Abdallah
October 30, 2017



difference between Scenaro mapping and mapping tables is the shared IDs

Count of distinct Mapping ID in the Scenario mapping is 868-922=54 shared 
So we save space that is 54 recoreds in the Mapping table and we just reused those 
find the base number which is the Mapping IDs for the first scenario 316
find the base number which is the Mapping IDs for the second scenario 606

922 should be the total mapping IDs but it is 868 

54/922 about 6% of savings in storage of MappingIDs


Wyoming model
Scenaro mapping table 7522
mapping table 3966
diff=3556
3556/7522=47%

*/


SELECT DISTINCT "Mapping"."MappingID",DatasetAcronym,ScenarioName,ObjectType,AttributeName,AttributeNameCV,
InstanceName,InstanceNameCV
--SELECT ScenarioName,ScenarioMappingID



FROM "Datasets"

LEFT JOIN "ObjectTypes" 
ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mapping"
ON "Mapping"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mapping"."InstanceID"

LEFT JOIN "ScenarioMapping"
ON "ScenarioMapping"."MappingID"="Mapping"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMapping"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

WHERE DatasetAcronym='BearRiverWyoming' AND MasterNetworkName='Upper Bear River Network' AND ScenarioMappingID IS NOT NULL 
--and scenarioName='UDWR GenRes 2010'
--and scenarioName='Bear Dry Year Model'
