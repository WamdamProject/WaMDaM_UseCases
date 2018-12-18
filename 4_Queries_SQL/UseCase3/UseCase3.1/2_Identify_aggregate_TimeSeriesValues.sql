/*
2.2Identify_aggregate_TimeSeriesValues.sql

Use case 2: identify and compare time series and seasonal discharge data across data sources. 
What is the discharge at the node “below Stewart Dam” in Idaho?


Aggregate time series data from daily cfs into cumulative monthly values in acre-feet
If the time series is a Water Year, then convert it to a Calendar year

Here the use of controlled unit names become valuable. 
Users need to check on the unit name to perform a conversion like from cfs to af/month

The query below has two parts: 
The first gets the daily data and aggregate it to monthly and convert its unit af 
The second gets the monthly data and keep it monthly but convert it from cfs to af 
The two parts are needed because of the “Having” function in the second part (to check on the days of the month)

Adel Abdallah
Updated April 3, 2018
*/
--                                               Two select statements will be join together by UNION ALL function
--                                    both Select Statements return identical column headers. Otherwise the Union will not work
--*************************************************************************************************************************************************************

                                                   --The first SELECT statement (get the daily data and convert to monthly)

--ResourceTypeAcronym,AttributeName, InstanceName,AggregationStatisticCV,IntervalTimeUnitCV,UnitNameCV,YearType,YearMonth, TimeSeriesValueID,CountDays,CalenderYear,CumulativeMonthly

SELECT ResourceTypeAcronym,AttributeName, InstanceName,AggregationStatisticCV,IntervalTimeUnitCV,UnitNameCV,
YearType,strftime('%m/%Y', DateTimeStamp) as YearMonth, TimeSeriesValueID,count(DataValue) As CountDays,
--convert the time stamp to be in the format of Month and Year (no days)


--check if it is a water year by querying the field "YearType" in the TimeSeries table
Case 
        WHEN YearType='WaterYear' AND (strftime('%m', DateTimeStamp) ='10' or  strftime('%m', DateTimeStamp) ='11' or  strftime('%m', DateTimeStamp) ='12')
        -- if it is a water year, then subtract one year from the time stamps of Oct., Nov., and Dec. months in each year
        THEN date(DateTimeStamp,'-1 year')   
        --if not a water year, then keep the time stamp as is
        Else DateTimeStamp 
End CalenderYear,


--covert the cfs/month to cumulative acre-ft per month 
-- Divide by 43560 square feet then multiply by 60*60*24 (and 30) to convert
Case 
         WHEN (UnitNameCV='cubic foot per second' AND  IntervalTimeUnitCV='day' AND AggregationStatisticCV='Cumulative' AND count(Datavalue)>=27)   THEN SUM(DataValue)/43560*60*60
         WHEN (UnitNameCV='cubic foot per second' AND  IntervalTimeUnitCV='day' AND AggregationStatisticCV='Average' AND count(DataValue)>=27)   THEN SUM(DataValue)/43560*60*60*24
         Else null
END As CumulativeMonthly


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

LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT JOIN "TimeSeries" 
ON "TimeSeries"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"


WHERE
AttributeDataTypeCV='TimeSeries'

AND "InstanceNameCV"='USGS 10046500 BEAR RIVER BL STEWART DAM NR MONTPELIER, ID'

AND "AttributeNameCV"='Flow'

--AND ResourceTypeAcronym='BearRiverCommission'


-- Daily time series. 
AND IntervalTimeUnitCV='day'

GROUP BY ResourceTypeAcronym,AttributeName,InstanceName,YearType,YearMonth

-- use this only if converting from daily to monthly (otherwise, months wont show up because their count is just 1)
--The use of "HAVING" clause enables you to specify conditions that filter which group results appear in the final results.

-- exclude the months that have data for less than 29days
Having CountDays>=27


--*************************************************************************************************************************************************************

                                                                                                 UNION ALL

--*************************************************************************************************************************************************************

                                                   --The second SELECT statement (get the monthly data and keep it monthly)

SELECT ResourceTypeAcronym,AttributeName, InstanceName,AggregationStatisticCV,IntervalTimeUnitCV,UnitNameCV,
YearType,strftime('%m/%Y', DateTimeStamp) as YearMonth, TimeSeriesValueID,count(DataValue) As CountDays,


--check if it is a water year by querying the field "YearType" in the TimeSeries table
--convert the time stamp to be in the format of Month and Year (no days)
-- If the time series is "WateYear", then convert it to a calendar year.
Case 
        WHEN YearType='WaterYear' AND (strftime('%m', DateTimeStamp) ='10' or  strftime('%m', DateTimeStamp) ='11' or  strftime('%m', DateTimeStamp) ='12')
        -- if it is a water year, then subtract one year from the time stamps of Oct., Nov., and Dec. months in each year
        THEN date(DateTimeStamp,'-1 year')   
        --if not a water year, then keep the time stamp as is
Else DateTimeStamp 
End As CalenderYear,


--covert the cfs/month to cumulative acre-ft per month 
-- Divide by 43559.9 square feet then multiply by 60*60*24
Case 
         WHEN (UnitNameCV='cubic foot per second' AND  IntervalTimeUnitCV='month' AND AggregationStatisticCV='Cumulative') THEN DataValue/43560
         WHEN (UnitNameCV='cubic foot per second' AND  IntervalTimeUnitCV='month' AND AggregationStatisticCV='Average' )   THEN DataValue/43560*60*60*24*30
         Else DataValue
END As CumulativeMonthly



FROM "ResourceTypes"

Left JOIN "ObjectTypes" 
ON "ObjectTypes"."ResourceTypeID"="ResourceTypes"."ResourceTypeID"

-- Join the Objects to get their attributes  
LEFT JOIN  "Attributes"
ON "Attributes"."ObjectTypeID"="ObjectTypes"."ObjectTypeID"

LEFT JOIN "Mappings"
ON "Mappings"."AttributeID"= "Attributes"."AttributeID"

LEFT JOIN "Instances" 
ON "Instances"."InstanceID"="Mappings"."InstanceID"

LEFT JOIN "ValuesMapper" 
ON "ValuesMapper"."ValuesMapperID"="Mappings"."ValuesMapperID"

LEFT JOIN "ScenarioMappings"
ON "ScenarioMappings"."MappingID"="Mappings"."MappingID"

LEFT JOIN "Scenarios" 
ON "Scenarios"."ScenarioID"="ScenarioMappings"."ScenarioID"

LEFT JOIN "MasterNetworks" 
ON "MasterNetworks"."MasterNetworkID"="Scenarios"."MasterNetworkID"

LEFT JOIN "TimeSeries" 
ON "TimeSeries"."ValuesMapperID"="ValuesMapper"."ValuesMapperID"

LEFT JOIN "TimeSeriesValues" 
ON "TimeSeriesValues"."TimeSeriesID"="TimeSeries"."TimeSeriesID"

--WHERE InstanceName='BEAR RIVER BL STEWART DAM NR MONTPELIER, ID'

WHERE
AttributeDataTypeCV='TimeSeries'

AND "InstanceNameCV"='USGS 10046500 BEAR RIVER BL STEWART DAM NR MONTPELIER, ID'

AND "AttributeNameCV"='Flow'

--AND datasetacronym='BearRiverCommission'


-- It is best to filter by day or month values. 
--Then you can use the “Having” clause below for daily but need to comment it for monthly
AND IntervalTimeUnitCV='month'

GROUP BY ResourceTypeAcronym,AttributeName,InstanceName,YearType,YearMonth

-- use this only if converting from daily to monthly (otherwise, months wont show up because their count is just 1)
--The use of "HAVING" clause enables you to specify conditions that filter which group results appear in the final results.
-- exclude the months that have data for less than 27 days
--Having CountDays>=27

--*************************************************************************************************************************************************************

ORDER BY TimeSeriesValueID ,ResourceTypeAcronym,CalenderYear,AttributeName,InstanceName ASC


