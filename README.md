# WaMDaM_UseCases
Demonstrate how WaMDaM enables systematic data query and comparisons across multiple different models and datasets. 

**Download**
1. [Excel Workbook template](https://github.com/WamdamProject/WaMDaM_UseCases/raw/master/UseCases_files/0WorkbookTemplates/InputData_Template/WaMDaM_InputData_template.xlsm) to prepare your data into it. Each dataset into one workbook
2. [WaMDaM Wizard software](https://github.com/WamdamProject/WaMDaM_Wizard#download-the-wizard-gui-for-windows-7-and-10-64-bit-operating-systems) to load your workbook into SQLite  (Windows [7 and 10] 64 bit operating systems)
3. Mozilla FireFox browser and its SQLite Manager Add-Ons to interact with the database
4. Python editor like PyCharm or Jyputer to plot results


**Follow these four steps to use WaMDaM and enable its use cases on your data:**        
1. Populate each of your datas into this empty Excel (.xlsx) workbook, one at a time, which is the generic data importer into WaMDaM
You can see numerous populated examples here. You may use the data manipulation services to help fit your data into WaMDaM sheets.    
2. Use the WaMDaM Wizard to load each workbook into a SQLite database.    
3. Use the Mozilla SQLite Manager to interact with the WaMDaM database. There are a list of example quries to identify and compare data in WaMDaM.    
4. Use or adapt the example Python scripts that plot some query results.     


 
 ![](/UseCases_files/UseWaMDaM_workflow.jpg)
**Figure:** Flowchart of the steps that users follow to use WaMDaM   

### Application: The Bear River Watershed, Utah 
We demonstrate the WaMDaM design and use cases using twelve data sources and models in the Bear River Watershed which spans three states, Utah, Idaho, and Wyoming (Figure below). The Watershed covers an area 3,300 square miles (8,547 square kilometers) and it is the largest source of water to the Great Salt Lake in Utah.    

The Watershed has various unique and overlapping available data provided by the three states, the Bear River Commission, national US datasets, and three existing systems models: Wyoming Model which allocates water based on priority for the upper Bear River Basin, the two model versions of the Lower Bear River which also allocate water on priority. Note that when developers organize their model’s input data into WaMDaM, models like the Wyoming model become a new source of data. The datasets and models are an example systems water management data of natural and built water supply and demand, infrastructure connectivity, with different data types, networks and scenarios. 

<p align="center">
  <img width="528" height="408" src="/UseCases_files/BearWatershed_Presentation.jpg">
</p> 
**Figure:** The Bear River Watershed in the Western US and example available data sources used to demonstrate WaMDaM     


### Licensing  
WaMDaM and materials in this GitHub repository are disturbed under a BSD 3-Clause [LICENSE](/LICENSE). 
For alternative licensing arrangements, contact Adel M. Abdallah or David E. Rosenberg directly.    


### Sponsors and Credit  
WaMDaM and related software development have been developed under funding from several different sources. It was primarily supported by the National Science Foundation <a href="http://www.nsf.gov/awardsearch/showAward?AWD_ID=1135482" target="_blank">CI-Water Project</a> and later from the <a href="https://www.nsf.gov/awardsearch/showAward?AWD_ID=1208732" target="_blank">iUtah Project</a>. 
Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.    

WaMDaM has been developed at and also additionally funded by the Utah Water Research Lab at Utah State University, Logan Utah during the period of August, 2012-2017. Thanks to Dr. Steven Burian at the Unviversity of Utah, Salt Lake City Utah for hosting Adel Abdallah as a visiting scholar 2014-2017.  

