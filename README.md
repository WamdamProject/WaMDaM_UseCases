# WaMDaM_UseCases
Demonstrate how WaMDaM enables systematic data query and comparisons across multiple different models and datasets. 

### Application: The Bear River Watershed, Utah 
We demonstrate the WaMDaM design and use cases using twelve data sources and models in the Bear River Watershed which spans three states, Utah, Idaho, and Wyoming. The Watershed covers an area 3,300 square miles (8,547 square kilometers) and it is the largest source of water to the Great Salt Lake in Utah.    

The Watershed has various unique and overlapping available data provided by the three states, the Bear River Commission, national US datasets, and three existing systems models: Wyoming Model which allocates water based on priority for the upper Bear River Basin, the two model versions of the Lower Bear River which also allocate water on priority. Note that when developers organize their model’s input data into WaMDaM, models like the Wyoming model become a new source of data. The datasets and models are an example systems water management data of natural and built water supply and demand, infrastructure connectivity, with different data types, networks and scenarios. 

<p align="center">
  <img width="528" height="408" src="/UseCases_files/BearWatershed_Presentation.jpg">
</p> 

We loaded WaMDaM databsase with twelve data sources and models in the Bear River Watershed that spans three states, Utah, Idaho, and Wyoming (Figure 4). The Watershed covers an area 3,300 square miles (8,547 square kilometers) and it is the largest source of water to the Great Salt Lake in Utah. The Watershed is an interesting one because it has various unique and overlapping available data provided by the three states, the Bear River Commission, national US datasets, and three existing systems models: BRSDM which allocates water based on priority for the upper Bear River Basin, a WEAP model which allocate water on priority, and a WASH model which allocates water to maximum suitable habitat areas in the Lower Bear River. Note that when developers organize their model’s input data into WaMDaM, models become a new source of data. We select a few locations in the Watershed to demonstrate use cases as each location has data from multiple sources: Stewart Dam site in Idaho, Hyrum Reservoir, Bear River Migratory Bird Refuge, and Cache County in Utah which is a major water use area in the Bear River Watershed.

The following presented use cases help users identify and compare two fundamental aspects of water management data: data values with different types and connectivity of scenarios and networks. In the first use case users may identify attributes with available or unavailable data that are needed by a systems model in a study area. In the second to fourth use cases, users may further query one or more available attributes to identify and compare data values across supply, demand, and infrastructure to use as input to a model. In the fifth use case, users may identify inflow and outflow connectivity links to a node of interest. Finally, in the sixth use case, users may compare similarities and differences between network topology, metadata, and data values of two scenarios of the same model. Each use case 1) describes the general problem it addresses, 2) describes the specifics of the case (i.e., location, model, dataset, search parameters), and 3) discusses how the WaMDaM design solves the problem and enables other similar issues to be solved. 


**Download**
1. [Excel Workbook template](https://github.com/WamdamProject/WaMDaM_UseCases/raw/master/UseCases_files/0WorkbookTemplates/InputData_Template/WaMDaM_InputData_template.xlsm) to prepare your data into it. Each dataset into one workbook
2. [WaMDaM Wizard software](https://github.com/WamdamProject/WaMDaM_Wizard#download-the-wizard-gui-for-windows-7-and-10-64-bit-operating-systems) to load your workbook into SQLite  (Windows [7 and 10] 64 bit operating systems)
3. Mozilla FireFox browser and its SQLite Manager Add-Ons to interact with the database
4. Python editor like PyCharm or Jyputer to plot results

## Use Cases in the Bear River Watershed, Utah 

**[Use case 1](/UseCases_files/9Discussion/UseCase1.md):** identify data availability for attributes needed by a model in a study area. 
What attributes that have available data to develop a WEAP and WASH models in the Upper Bear River watershed?



**[Use case 2](/UseCases_files/9Discussion/UseCase2.md):** identify and compare time series and seasonal discharge data across data sources. 
What is the discharge at the node “below Stewart Dam” in Idaho?




**[Use case 3](/UseCases_files/9Discussion/UseCase3.md):** identify and compare demand data for a site as reported in many sources.
What is the total agriculture water use or demand in Cache Valley, Utah?



**[Use case 4](/UseCases_files/9Discussion/UseCase4.md):** identify and compare infrastructure data across many data sources. 
What is the volume, purpose, evaporation, and elevation of Hyrum Reservoir Utah?



**[Use case 5](/UseCases_files/9Discussion/UseCase5.md):** identify inflow and outflow into and out of a node water system component and compare them across data sources or models.
What is the inflow and outflow of Hyrum Reservoir, Utah? 




**[Use case 6](/UseCases_files/9Discussion/UseCase6.md):** compare differences in network topology and data values between two model scenarios.
What is the difference in input data between the two scenarios or the Bear River WEAP model?

 
 ![](/UseCases_files/UseWaMDaM_workflow.jpg)
**Figure:** Flowchart of the steps that users follow to use WaMDaM   





### Licensing  
WaMDaM and materials in this GitHub repository are disturbed under a BSD 3-Clause [LICENSE](/LICENSE). 
For alternative licensing arrangements, contact Adel M. Abdallah or David E. Rosenberg directly.    


### Sponsors and Credit  
WaMDaM and related software development have been developed under funding from several different sources. It was primarily supported by the National Science Foundation <a href="http://www.nsf.gov/awardsearch/showAward?AWD_ID=1135482" target="_blank">CI-Water Project</a> and later from the <a href="https://www.nsf.gov/awardsearch/showAward?AWD_ID=1208732" target="_blank">iUtah Project</a>. 
Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.    

WaMDaM has been developed at and also additionally funded by the Utah Water Research Lab at Utah State University, Logan Utah during the period of August, 2012-2017. Thanks to Dr. Steven Burian at the Unviversity of Utah, Salt Lake City Utah for hosting Adel Abdallah as a visiting scholar 2014-2017.  

