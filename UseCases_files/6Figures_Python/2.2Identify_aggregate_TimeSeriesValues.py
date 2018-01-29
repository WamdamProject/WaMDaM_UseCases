# Use Case 2.2Identify_aggregate_TimeSeriesValues.csv
# plot aggregated to monthly and converted to acre-feet time series data of multiple sources

# Adel Abdallah
# November 16, 2017

import plotly
import plotly.plotly as py
import plotly.graph_objs as go

from random import randint
import pandas as pd

## read the input data from GitHub csv file which is a direct query output for this  query:
# 2.2Identify_aggregate_TimeSeriesValues.csv

df = pd.read_csv("https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/2.2Identify_aggregate_TimeSeriesValues.csv")

# identify the data for four time series only based on the DatasetAcronym column header 
column_name = "DatasetAcronym"
subsets = df.groupby(column_name)
data = []

# for each subset (curve), set up its legend and line info manually so they can be edited
subsets_settings = {
    'UDWRFlowData': {
        'dash': 'solid',
        'legend_index': 0,
        'legend_name': 'Utah Division of Water Res.',
        'width':'3',
        'color':'rgb(153, 15, 15)'
        },
    'CUAHSI': {
        'dash': 'dash',
        'legend_index': 1,
        'legend_name': 'USGS',
        'width':'4',
        'color':'rgb(15, 107, 153)'
        },
    'IdahoWRA': {
        'dash': 'soild',
        'legend_index': 2,
        'legend_name': 'Idaho Department of Water Res.',
        'width':'3',
        'color':'rgb(38, 15, 153)'
        },    
    'BearRiverCommission': { # this oone is the name of subset as it appears in the csv file
        'dash': 'dot',     # this is properity of the line (curve)
        'legend_index': 3,   # to order the legend
        'legend_name': 'Bear River Commission',  # this is the manual curve name 
         'width':'4',
        'color':'rgb(107, 153, 15)'
        }
    }
    
# This dict is used to map legend_name to original subset name
subsets_names = {y['legend_name']: x for x,y in subsets_settings.iteritems()}

# prepare the scater plot for each curve
for subset in subsets.groups.keys():
    print subset
    dt = subsets.get_group(name=subset)
    s = go.Scatter(
                    x=dt.CalenderYear.map(lambda z: str(z)[:-3]),
                    y=dt['CumulativeMonthly'],
                    name = subsets_settings[subset]['legend_name'],
                    line = dict(
                        color =subsets_settings[subset]['color'],
                        width =subsets_settings[subset]['width'], 
                        dash=subsets_settings[subset]['dash']
                               ),
                        opacity = 1                                
                  )
    data.append(s)
    
# Legend is ordered based on data, so we are sorting the data based 
# on desired legend order indicarted by the index value entered above
data.sort(key=lambda x: subsets_settings[subsets_names[x['name']]]['legend_index'])

# set up the figure layout parameters
layout = dict(
     #title = "UseCase3.2",
     yaxis = dict(
         title = "Cumulative monthly flow <br> (acre-feet/month)",
         tickformat= ',',
         zeroline=True,
         showline=True,
         ticks='outside',
         ticklen=15,
         #zerolinewidth=4,
         zerolinecolor='#00000',

         dtick=30000,
                 ),
    xaxis = dict(
         #title = "Time <br> (month/year)",
         #autotick=False,
        tick0='1900-01-01',
        dtick='M180',
        ticks='inside',
        tickwidth=0.5,
        #zerolinewidth=4,
        ticklen=27,
        zerolinecolor='#00000',
        tickcolor='#000',
        tickformat= "%Y",
       range = ['1920', '2020']

                ),
    legend=dict(
        x=0.2,y=0.9,
        bordercolor='#00000',
            borderwidth=2


                ),
    autosize=False,
    width=1200,
    height=800,
    margin=go.Margin(l=300, b=150),
    #paper_bgcolor='rgb(233,233,233)',
    #plot_bgcolor='rgb(233,233,233)',
    
    
    font=dict( size=35)
             )
# create the figure object            
fig = dict(data=data, layout=layout)

# plot the figure 
#py.iplot(fig, filename = "2.2Identify_aggregate_TimeSeriesValues")       


## it can be run from the local machine on Pycharm like this like below
## It would also work here offline but in a seperate window  
plotly.offline.plot(fig, filename = "2.2Identify_aggregate_TimeSeriesValues")       
