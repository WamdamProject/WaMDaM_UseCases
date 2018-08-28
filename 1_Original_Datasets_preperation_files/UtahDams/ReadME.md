

These data are shared by Craig Miller at the Utah Division of Water Resources. To look up each Reservoir curve, first find the identifier of that reservoir and then find the curve for that identifier from the spreadsheet

In the Reservoirs/dams shapefile, I deleted nine records because they didn’t have a reservoir name 


Adel Abdallah, Utah Sate Univiversity		
December 5, 2016		
I complied the data in Sheet 1 in this UtahLargeReservoirs exfel doc from the three separate sources listed below. I joined them using both MS SQL Server. 		
The join between "dbo_ModelResSAC" and "dbo_ModelResData" is based on the shared atttibutes ReservoirID and Model ID in both files		
The join between "dbo_ModelResData" and "Reservoirs" is based on the shared atttibutes Dam number 		
		
Files name	File type	Source /provider
reservoirs	shapefile	Craig Miller/UDWR 
dbo_ModelResSAC	excel	Craig Miller/ UDWR
dbo_ModelResData	excel	Craig Miller /UDWR



Jan 20, 2016
Adel Abdallah