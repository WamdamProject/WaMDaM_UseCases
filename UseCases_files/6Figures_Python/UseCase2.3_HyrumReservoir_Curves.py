# UseCase2.3_HyrumReservoir_Curves.py

# plot multi-attributes from multiple sources


# Adel Abdallah
# Jan 25, 2018

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
        'width':'3',
        'legend_index': 1,   # to order the legend
         'symbol':'square',
        'size':'7',
        'mode':'line+markers',
        'legend_name': 'Utah Dams Dataset (2016)',  # this is the manual curve name 
         'color':'#990F0F'
        },
    
    'USU WEAP Model 2017': {
        'dash': 'solid',
         'width':'3',
          'mode':'line+markers',
          'symbol':'circle',
                'size':'7',

        'legend_index': 3,
        'legend_name': 'USU WEAP Model (2017)',
         'color':'#B26F2C'
        },
    'UDWR GenRes 2010': {
        'dash': 'dash',
        'mode':'line+markers',
        'width':'3',
                'size':'7',

        'symbol':'circle',
        'legend_index': 4,
        'legend_name': 'UDWR WEAP Model (2010)',
         'color':'#7A430C'
        },
    'Rwise': {
        'dash': 'dash',
        'mode':'line+markers',
        'width':'3',
                  'symbol':'star',
                'size':'7',

        'legend_index': 0,
        'legend_name': 'BOR Water Info. System (2017)',
         'color':'#E57E7E'
        },
    'Base case': {
        'dash': 'solid',
        'mode':'lines+markers',
        'width':'3',
                  'symbol':'bowtie',
        'size':'11',

        'legend_index': 2,
        'legend_name': 'BOR Reservoirs Dataset (2006)',
         'color':'#E5B17E'
        },    

    }


# This dict is used to map legend_name to original subset name
subsets_names = {y['legend_name']: x for x,y in subsets_settings.iteritems()}

      
#for each subset (curve), set up its legend and line info manually so they can be edited
subsets_settings2 = {
        'dash': 'solid',     # this is properity of the line (curve)
        'legend_index': 3,   # to order the legend
         'mode':'lines+markers',
        'color':'#E57E7E',
        'legend_name': 'BOR Water Info. System (2017)'  # this is the edited curve name 
                    }


# Get data from first dataframe (Multi-Attributes)
for subset in subsets.groups.keys():
    print subset
    scenario_name_data = subsets.get_group(name=subset)
    subsets_of_scenario = scenario_name_data.groupby("AttributeNameCV")
    s = go.Scatter(
                    x=subsets_of_scenario.get_group(name='Volume').Value,
                    y=subsets_of_scenario.get_group(name='Elevation').Value,
                        mode='lines+markers',

                    name = subsets_settings[subset]['legend_name'],
                    line = dict(
                        color =subsets_settings[subset]['color'],
                        width =subsets_settings[subset]['width'],
                        dash=subsets_settings[subset]['dash']
                                ),
                     marker = dict(
                         size=subsets_settings[subset]['size'],
                         symbol=subsets_settings[subset]['symbol'],
                         #color = '#a50021',
                         maxdisplayed=12
),  
                    opacity = 1)
    data.append(s)




# Get data from second dataframe (merged two time series as two Multi-Attributes)
data2 = go.Scatter(
                x=df2.VolumeValue,
                y=df2['ElevationValue'],
                name = subsets_settings2['legend_name'],
                mode='lines+markers',
                line = dict(
                    color ='#E57E7E',
                    width ='3'),
                marker = dict(
                size ='9',
                color = '#E57E7E',
                maxdisplayed=20,
                symbol ='star',
                         line = dict(
                         color = ['rgb(153, 84, 15)']
                         ),

                            ),
    
    
                opacity =1)
                
data.append(data2)     
    
# Legend is ordered based on data, so we are sorting the data based 
# on desired legend order indicarted by the index value entered above
data.sort(key=lambda x: subsets_settings[subsets_names[x['name']]]['legend_index'])


trace1 = go.Scatter(
    x=[1500, 8000, 16000],
    y=[4680, 4680,4680],
    mode='text',
    showlegend=False,
    text=['Dead<br> storage', 'Live<br>storage', 'Total<br>storage'],
    textposition='top',

)
data.append(trace1)     


# set up the figure layout
layout = {
        'shapes': [
        # Rectangle reference to the axes
        {
            "opacity": 0.3,
            'type': 'rect',
            'xref': 'x',
            'yref': 'y',
            'x0': 0,
            'y0': 4580,
            'x1': 3012,
            'y1': 4750,
            'line': {
                'color': 'rgb(0, 0, 0)',
                'width': 0.1,
            },
            'fillcolor': 'rgb(153, 229, 255)'
        },
     # Rectangle reference to the plot
        {
           "opacity": 0.3,
            'type': 'rect',
            'xref': 'x',
            'yref': 'y',
            'x0': 3012,
            'y0': 4580,
            'x1': 14440,
            'y1': 4750,
            'line': {
                'color': 'rgb(0, 0, 0)',
                'width': 0.1,
            },
            'fillcolor': 'rgb(127, 212, 255)',
        },
        
        {
            "opacity": 0.3,
            'type': 'rect',
            'xref': 'x',
            'yref': 'y',
            'x0': 14440,
            'y0': 4580,
            'x1': 17746,
            'y1': 4750,
            'line': {
                'color': 'rgb(0, 0, 0)',
                'width': 0.1,
            },
            'fillcolor': 'rgb(101, 191, 255)',
        }        
    ],
        'yaxis': {
        'title': 'Elevation (feet)',
        'tickformat': ',',
        'ticks':'outside',
        'ticklen': '10',


        'range' : ['4580', '4700'],
                'showline':'True'

                },
    'xaxis' : {
        'title' : 'Volume (acre-feet)',
        'tickformat': ',',   
         'showgrid':False,

        'ticks':'outside',
        'dtick':'5000',
        'range' : ['0', '30000'],
        'ticklen':20,
        'tick0':0,
        'showline':True,
    },
    'legend':{
        'x':0.45,
        'y':0.04,
        'bordercolor':'#00000',
         'borderwidth':2    
    },
    'width':1200,
    'height':800,
    'margin':go.Margin(
        l=150,
        b=150       ),
    #paper_bgcolor='rgb(233,233,233)',
    #plot_bgcolor='rgb(233,233,233)',
    'font':{'size':32,'family':'arial'},
    

        }


    


    #title = "UseCase5",
    


fig = {
    'data': data,
    'layout': layout,}


#py.iplot(fig, filename = "UseCase2.3_HyrumReservoir_Curves.py") 


## it can be run from the local machine on Pycharm like this like below
## It would also work here offline but in a seperate window  
plotly.offline.plot(fig, filename = "UseCase2.3_HyrumReservoir_Curves.py") 
