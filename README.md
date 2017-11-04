# WaMDaM_UseCases
Demonstrate how WaMDaM enables systematic data query and comparisons across multiple different models and datasets. 

**Download**
1. [Excel Workbook template](https://github.com/WamdamProject/WaMDaM_UseCases/raw/master/UseCases_files/0WorkbookTemplates/InputData_Template/WaMDaM_InputData_template.xlsm) to prepare your data into it. Each dataset into one workbook
2. WaMDaM Wizard software to load your workbook into SQLite
3. Mozilla FireFox browser and its SQLite Manager Add-Ons to interact with the database
4. Python editor like PyCharm or Jyputer to plot results


Follow these four steps to use WaMDaM and enable its use cases on your data:        
1. populate each of your datas into this empty Excel (.xlsx) workbook, one at a time, which is the generic data importer into WaMDaM
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
