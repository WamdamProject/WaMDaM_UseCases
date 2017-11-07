# Use Case 4_HyrumReservoir_Curves.py

# plot multi-attributes from multiple sources


# Adel Abdallah
# November 6, 2017

import plotly
import plotly.plotly as py
import plotly.graph_objs as go
from random import randint
import pandas as pd

## read the input data from GitHub csv file which is a direct query output for these queries:

# 4.2MultiAttributeValues.csv
df = pd.read_csv("https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/4.2MultiAttributeValues.csv")

# 4.3MergeTimeSeriesValues.sql
df2 = pd.read_csv("https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/4.3MergeTimeSeriesValues.csv")


subsets = df.groupby('ScenarioName')
data = []

#for each subset (curve), set up its legend and line info manually so they can be edited
subsets_settings = {
    'Utah Dams shapefile_as is': { # this oone is the name of subset as it appears in the csv file
        'dash': 'solid',     # this is properity of the line (curve)
        'width':'2',
        'legend_index': 1,   # to order the legend
        'mode':'line',
        'legend_name': 'Utah Dams Dataset 2016',  # this is the manual curve name 
         'color':'#f76d5e'
        },
    
    'USU WEAP Model 2017': {
        'dash': 'solid',
         'width':'3',
          'mode':'line',
        'legend_index': 3,
        'legend_name': 'USU WEAP Model, 2017',
         'color':'rgb(0,0,0)'
        },
    'UDWR GenRes 2010': {
        'dash': 'dash',
        'mode':'line',
        'width':'3',
        'legend_index': 4,
        'legend_name': 'UDWR GenRes Model, 2010',
         'color':'#999999'
        },
    'Rwise': {
        'dash': 'dash',
        'mode':'line',
        'width':'3',
        'legend_index': 0,
        'legend_name': 'BOR Water Info. System, 2017',
         'color':'#a50021'
        },
    'Base case': {
        'dash': 'solid',
        'mode':'line+marker',
        'width':'3',
        'legend_index': 2,
        'legend_name': 'BOR Reservoirs Dataset, 2017',
         'color':'#999999'
        },    
    
    'MAX_STOR': {
        'dash': 'dash',
        'mode':'line',
        'width':'3',
        'legend_index': 5,
        'legend_name': 'MAX_STOR: US Major Dams, 2010',
         'color':'rgb(0, 0, 0)'

        },
    'MaxCap': {
        'dash': 'dash',
        'mode':'line',
        'width':'3',
        'legend_index':6,
        'legend_name': 'MaxCap: Utah Dams shapefile, 2015',
         'color':'rgb(0, 0, 0)'

        },
    'StorageCapacity': {
        'dash': 'dash',
        'mode':'line',
        'width':'3',
        'legend_index': 7,
        'legend_name': 'Storage Capacity: USU WEAP Model, 2017',
        'color':'rgb(0, 0, 0)'
        },
    'STORG_ACFT': {
        'dash': 'dash',
        'mode':'line',
        'width':'3',
        'legend_index': 8,
        'legend_name': 'STORG_ACFT: Utah Dams shapefile, 2015',
        'color':'rgb(0, 0, 0)'

        }

    }


# This dict is used to map legend_name to original subset name
subsets_names = {y['legend_name']: x for x,y in subsets_settings.iteritems()}

      
#for each subset (curve), set up its legend and line info manually so they can be edited
subsets_settings2 = {
        'dash': 'solid',     # this is properity of the line (curve)
        'legend_index': 3,   # to order the legend
         'mode':'lines+markers',
        'color':'#a50021',
        'legend_name': 'BOR Water Info. System, 2017'  # this is the edited curve name 
                    }


# Get data from first dataframe (Multi-Attributes)
for subset in subsets.groups.keys():
    print subset
    scenario_name_data = subsets.get_group(name=subset)
    subsets_of_scenario = scenario_name_data.groupby("AttributeNameCV")
    s = go.Scatter(
                    x=subsets_of_scenario.get_group(name='Volume').Value,
                    y=subsets_of_scenario.get_group(name='Elevation').Value,
                    name = subsets_settings[subset]['legend_name'],
                    line = dict(
                        color =subsets_settings[subset]['color'],
                        width =subsets_settings[subset]['width'],
                        dash=subsets_settings[subset]['dash']
                                ),
#                     marker = dict(
#                         size ='15',
#                         color = '#a50021'),  
                    opacity = 1)
    data.append(s)




# Get data from second dataframe (merged two time series as two Multi-Attributes)
data2 = go.Scatter(
                x=df2.VolumeValue,
                y=df2['ElevationValue'],
                name = subsets_settings2['legend_name'],
                mode='lines+markers',
                line = dict(
                    color ='#a50021',
                    width ='2'),
                marker = dict(
                size ='5',
                color = '#a50021',      
#                 symbol ='square',
#                         line = dict(
#                         color = ['rgb(153, 84, 15)'],
#                         width = [1]),

                            ),
    
    
                opacity =1)
                
data.append(data2)     
                

# vertical line2
MAX_STOR = go.Scatter(
    x=[14440, 14440],
    y=[4540, 4750],
    mode='lines',
    name='MAX_STOR: US Major Dams, 2010',
    hoverinfo='MAX_STOR',
    showlegend=True,
    line=dict(
        shape='vh',
        width='2',
        color = '#72d9ff'
            )
                    )
data.append(MAX_STOR)


# vertical line3
MaxCap = go.Scatter(
    x=[15760, 15760],
    y=[4540, 4750],
    mode='lines',
    name='MaxCap: Utah Dams shapefile, 2015',
    hoverinfo='MaxCap',
    showlegend=True,
    line=dict(
        shape='vh',
        width='2',
        color = '#3fa0ff'
            )
                    )
data.append(MaxCap)


# vertical line1
StorageCapacity = go.Scatter(
    x=[18684, 18684],
    y=[4540, 4750],
    mode='lines',
    name='Storage Capacity: USU WEAP Model, 2017',
    hoverinfo='Storage Capacity',
    showlegend=True,
    line=dict(
        shape='vh',
        width='2',
        color = '#264dff',
            )
                    )
data.append(StorageCapacity)


# vertical line4
STORG_ACFT = go.Scatter(
    x=[18800, 18800],
    y=[4540, 4750],
    mode='lines',
    name='STORG_ACFT: Utah Dams shapefile, 2015',
    hoverinfo='STORG_ACFT',
    showlegend=True,
    line=dict(
        shape='vh',
        width='2',
        color = '#290ad8'
            )
)
                              
data.append(STORG_ACFT)


# Legend is ordered based on data, so we are sorting the data based 
# on desired legend order indicarted by the index value entered above
data.sort(key=lambda x: subsets_settings[subsets_names[x['name']]]['legend_index'])


# set up the figure layout
layout = dict(
    #title = "UseCase5",
    yaxis = dict(
        title = "Elevation (feet)",
        tickformat= ',',
                ticks='outside',
                ticklen=10,


        range = ['4580', '4700'],
                showline=True

                ),
    xaxis = dict(
        title = "Volume (acre-feet)",
        tickformat= ',',       
        ticks='outside',
        dtick='5000',
        range = ['0', '30000'],
        ticklen=20,
        tick0=0,
        showline=True,
        ),
    legend=dict(
        x=0.65,y=0.1,
            bordercolor='#00000',
            borderwidth=2    
    ),
    width=1200,
    height=800,
    margin=go.Margin(
        l=150,
        b=150       ),
    #paper_bgcolor='rgb(233,233,233)',
    #plot_bgcolor='rgb(233,233,233)',
    font=dict(size=28,family='arial'),


)

fig = dict(data=data, layout=layout)
#py.iplot(fig, filename = "4_HyrumReservoir_Curves.py") 


## it can be run from the local machine on Pycharm like this like below
## It would also work here offline but in a seperate window  
plotly.offline.plot(fig, filename = "4_HyrumReservoir_Curves.py") 

