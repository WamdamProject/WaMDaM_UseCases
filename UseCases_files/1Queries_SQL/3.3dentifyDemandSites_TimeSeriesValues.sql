/*
3.3dentifyDemandSites_TimeSeriesValues

Use case 3: identify and compare demand data for a site as reported in many sources. 
What is the total agriculture water use or demand in Cache Valley, Utah?

Convert years to Water Year

Aggregate time series data from daily cfs into cumulative monthly values 
If the time series is a Water Year, then convert it to a Calendar year

--here the use of controlled unit names becomes valuable. 
--Users need to check on the unit name to perform a conversion like from cfs to af/month

Adel Abdallah
Updated October 30, 2017
*/

SELECT DatasetAcronym,ScenarioName,AttributeName,AttributeCategoryName, AggregationStatisticCV,IntervalTimeUnitCV,UnitNameCV,UnitName,
strftime('%Y', WaterYearDate) As WaterYear,CumulativeAnnual,NumDemandSites,CountValues

         FROM (

         SELECT DatasetAcronym,ScenarioName,AttributeName, AttributeNameCV,AttributeCategoryName,InstanceName,AggregationStatisticCV,IntervalTimeUnitCV,UnitNameCV,UnitName,
         WaterOrCalendarYear,count(DISTINCT InstanceName) As NumDemandSites,count(value) As CountValues,

         Case 
                  WHEN WaterOrCalendarYear='CalenderYear' AND (strftime('%m', DateTimeStamp) ='10' or  strftime('%m', DateTimeStamp) ='11' or  strftime('%m', DateTimeStamp) ='12') THEN date(DateTimeStamp,'+1 year')   
                  WHEN WaterOrCalendarYear='WaterYear' AND (strftime('%m', DateTimeStamp) ='10' or  strftime('%m', DateTimeStamp) ='11' or  strftime('%m', DateTimeStamp) ='12') THEN date(DateTimeStamp,'-1 year')   
                  Else DateTimeStamp 
         End WaterYearDate,

         Case 
                  WHEN (UnitNameCV='acre foot' AND  IntervalTimeUnitCV='Year' AND AggregationStatisticCV='Cumulative' )                                                                                               THEN Value
                  WHEN (UnitNameCV='acre foot' AND  IntervalTimeUnitCV='month' AND AggregationStatisticCV='Cumulative'  )                                                                                          THEN      SUM(Value)
                  WHEN (UnitNameCV='Million cubic meter per month' AND  IntervalTimeUnitCV='month' AND AggregationStatisticCV='Cumulative'  AND count(value)>=60 )         THEN      SUM(Value)*810.714402 --convert mcm to Acre-ft  --60 is 12 months * 5 instances in WASH
                  Else null  
         END As CumulativeAnnual


         --the year column should be from the calendar year one after making the shift 

         --check if it is a water year by querying the field "WaterOrCalendarYear" in the TimeSeries table
         --convert the time stamp to be in the format of Month and Year (no days)
         -- If the time series is "WateYear", then convert it to a calendar year.


         FROM "Datasets"

         Left JOIN "ObjectTypes" 
         ON "ObjectTypes"."DatasetID"="Datasets"."DatasetID"

         -- Join the Objects to get their attributes  
         LEFT JOIN  "Attributes"
         ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

         LEFT JOIN "AttributeCategory" 
         ON "AttributeCategory"."AttributeCategoryID"="Attributes"."AttributeCategoryID"

         LEFT JOIN "Mapping"
         ON "Mapping"."AttributeID"= "Attributes"."AttributeID"

         LEFT JOIN "Instances" 
         ON "Instances"."InstanceID"="Mapping"."InstanceID"

         LEFT JOIN "InstanceCategory" 
         ON "InstanceCategory"."InstanceCategoryID"="Instances"."InstanceCategoryID"

         LEFT JOIN "DataValuesMapper" 
         ON "DataValuesMapper"."DataValuesMapperID"="Mapping"."DataValuesMapperID"

         LEFT JOIN "ScenarioMapping"
         ON "ScenarioMapping"."MappingID"="Mapping"."MappingID"

         LEFT JOIN "Scenarios" 
         ON "Scenarios"."ScenarioID"="ScenarioMapping"."ScenarioID"

         LEFT JOIN "MasterNetworks" 
         ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

         LEFT JOIN "TimeSeries" 
         ON "TimeSeries"."DataValuesMapperID"="DataValuesMapper"."DataValuesMapperID"

         LEFT JOIN "TimeSeriesValues" 
         ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

         WHERE
         AttributeDataTypeCV='TimeSeries'

         -- specify the boundary of coordinates of the search domain in space 
         -- this Boundary Cache Valley, Utah
         AND ("Instances"."Longitude_x">='-112.3' 
         AND "Instances"."Longitude_x"<='-111.4'
         AND "Instances"."Latitude_y">='41.3'
         AND "Instances"."Latitude_y"<='42.100') 

         AND ObjectTypeCV='Demand site' 

         AND AttributeNameCV='Flow'

         -- narrow the search to instances with the category of agriculture

         AND InstanceCategory='Agriculture'

         --AND ScenarioName='UDWR GenRes 2010'



         AND (AttributeCategoryName ISNULL or  AttributeCategoryName!= 'Groundwater')

         GROUP BY DatasetAcronym,AttributeName,ScenarioName,AggregationStatisticCV,IntervalTimeUnitCV,UnitNameCV,UnitName,
         WaterOrCalendarYear,strftime('%Y', WaterYearDate)



         --close the second Select statement         
)

-- exclude the years that have less than 12 months (which will have a null value here because of the case above)
WHERE CumulativeAnnual is not null


