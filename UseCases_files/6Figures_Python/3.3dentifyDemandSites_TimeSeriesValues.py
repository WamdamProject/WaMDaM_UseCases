# Use Case 3.3dentifyDemandSites_TimeSeriesValues.py

# plot time series data aggregated in space and time from multiple sources

# November 13, 2017
# Adel Abdallah

import plotly
import plotly.plotly as py
import plotly.graph_objs as go
from random import randint
import pandas as pd

#6.3dentifyDemandSites_TimeSeriesValues.csv

## read the input data from GitHub csv file which is a direct query output
#To get the data block (WaterYear,CumulativeAnnual) for each curve, you need to look up two columns:
#ScenarioName and then AttributeName. So the combination of these two columns will have their separate set of data.
df = pd.read_csv('https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/3.3dentifyDemandSites_TimeSeriesValues.csv')

subsets = df.groupby('AttributeName')

data = []


# for each subset (curve), set up its legend and line info manually so they can be edited
subsets_settings = {
    '11 sites (time series): WEAP Model 2017': {
        'dash': 'solid',
        'legend_index': 0,
        'legend_name': '<br> 11 sites (seasonal): WEAP Model 2017 <br> "Monthly Demand" ',
        'width':'3',
        'color':'rgb(41, 10, 216)'
        },      
    'Diversions /surface water': {
        'dash': 'solid',
        'legend_index': 1,
        'legend_name': '<br> 1 site (time series): WaDE <br> "Diversions/surface water"',
        'width':'3',
        'color':'rgb(38, 77, 255)'        
        },        
        
    'Water Use /surface and ground': {
        'dash': 'solid',
        'legend_index': 2,
        'legend_name': '<br> 1 site (time series): WaDE  <br> "Water Use/surface and ground water"',
        'width':'3',
        'color':'rgb(63, 160, 255)'
        },
    
    'dReq': { # this one is the name of subset as it appears in the csv file
        'dash': 'solid',     # this is properity of the line (curve)
        'legend_index': 3,   # to order the legend
        'legend_name': '<br> 5 sites (time series): WASH Model <br> "dReq"',  # this is the manual curve name 
         'width':'3',
        'color':'rgb(114, 217, 255)'
        },
    'Monthly Demand': {
        'dash': 'solid',
        'legend_index': 4,
        'legend_name': '<br> 1 site (time series): UDWR GenRes 2010 <br> "Monthly Demand"',
        'width':'3',
        'color':'rgb(170, 247, 255)'
        },

            }
    

# This dict is used to map legend_name to original subset name
subsets_names = {y['legend_name']: x for x,y in subsets_settings.iteritems()}


for subset in subsets.groups.keys():
    print subset
    scenario_name_data = subsets.get_group(name=subset)
    subsets_of_scenario = scenario_name_data.groupby("AttributeName")
    for group in subsets_of_scenario.groups.keys():
        s = go.Scatter(
                x = subsets_of_scenario.get_group(name=group).WaterYear,
                y = subsets_of_scenario.get_group(name=group).CumulativeAnnual,
                name = subsets_settings[subset]['legend_name'],
                line = dict(
                        color =subsets_settings[subset]['color'],
                        width =subsets_settings[subset]['width'], 
                        dash=subsets_settings[subset]['dash']
                        ),
                mode = 'lines',
                opacity = 1)
        data.append(s)
        
      
        
# horizontal line
horizontal_line = go.Scatter(
    x=[2005, 2016],
    y=[232642.28, 232642.28],
    mode='lines',
    name = '<br> 11 sites (seasonal): WEAP Model 2017 <br> "Monthly Demand" ',
    hoverinfo='11 sites: WEAP Model 2017',
    showlegend=True,
    line=dict(
        shape='hv',
        color = 'rgb(38, 15, 153)',
        width='3'
    )
)
data.append(horizontal_line)


# Legend is ordered based on data, so we are sorting the data based 
# on desired legend order indicarted by the index value entered above
data.sort(key=lambda x: subsets_settings[subsets_names[x['name']]]['legend_index'])        
   
layout = dict(
    #title = "Use Case 6",
    yaxis = dict(
        title = "Total volume per water year <br> (acre-feet)",       
        tickformat= ',',
        showline=True,
        range = ['0', '260000'],

                ),
    xaxis = dict(
        title = "Time (Year)",
        range = ['2003', '2016'],
        ticks='outside',
        tickwidth=0.5,
        ticklen=25,
        showline=True
                ),
    legend=dict(x=0.86,y=0.445,
                bordercolor='#00000',
                borderwidth=2  
               ),
     width=1650,
    height=1000,
    margin=go.Margin(
        l=250,
        b=250       ),
    #paper_bgcolor='rgb(233,233,233)',
    #plot_bgcolor='rgb(233,233,233)',
    font=dict(size=28)

)


# see the label Lines with Annotations
# https://plot.ly/python/line-charts/      
annotations = []

label = ['11 sites', '1 site', '1 site', '5 sites','1 site']

for legend_index in subsets_settings:
    annotations.append(dict(xref='paper', x=2004, y=subsets_settings[legend_index],
                                  xanchor='right', yanchor='middle',
                                  text=label)
                      )

layout['annotations'] = annotations
                

# create a figure object          
fig = dict(data=data, layout=layout)

#py.iplot(fig, filename = "3.3dentifyDemandSites_TimeSeriesValues") 

## it can be run from the local machine on Pycharm like this like below
## It would also work here offline but in a seperate window  
plotly.offline.plot(fig, filename = "3.3dentifyDemandSites_TimeSeriesValues")       
