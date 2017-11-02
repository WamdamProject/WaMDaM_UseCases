Online source:  
https://maps.idwr.idaho.gov/qwraccounting/

The spreadsheet and shapfile were provided by the contact person through FTTP link.


Contact person:
Liz Cresto
Hydrology Section Supervisor
Idaho Department of Water Resources
208-287-4833
liz.cresto@idwr.idaho.gov


D= Diversion
F = Flow station (River flow)
R = Reservoir
Y = Flows through power plants (We don’t currently populate this data set) 


### Describe steps done

Get the time series data for the all the sites and the years for each site. The web portal doesn’t allow this big query at once. Liz asked the IT people to make this query and send it in a spreadsheet for 215 sites. Liz also sent a shapefile for the sites in Idaho/bear River for 191 sites. The shapefile has lots of metadata about the sites where the time series data in the spreadsheet had four columns: site name, site ID, time stamp, and data value. I used the ArcGIS tool: AddXY coordinates for the sites in the attribute table to find the longitude and latitude. I used ArcGIS to join the unique spreadsheet sites and the shapefile sites to get the metadata for the time series in the spreadsheet matched with the time series data. I sorted the joined table based on the site type and then I exported the table to excel. I used the excel table to populate the data structure and nodes table in the WaMDaM spreadsheets. Upon the join, I found a semantic difference in calling the type of the sites between the spreadsheets and the shapefile. The spreadsheet uses “Diversion” while the shapefile uses “D”. The problem occur when the difference is not intuitive like non-consumptive vs P which stands for power plant. I adopted the object type for the site from the spreadsheet which is more informative. 
Site names in the time series data was missing in many sites. I used the site code as a site name. 
Note: change spatial reference foreign key to be for the SRSName

Choose the site status of Active and inactive to be binary 
It will make sure that only two cases are entered 
