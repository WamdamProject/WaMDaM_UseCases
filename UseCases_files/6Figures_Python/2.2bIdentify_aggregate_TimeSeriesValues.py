# Use Case 2.2bIdentify_aggregate_TimeSeriesValues.py
# plot aggregated to monthly and converted to acre-feet time series data of multiple sources

# Adel Abdallah
# November 16, 2017

import plotly
import plotly.plotly as py
import plotly.graph_objs as go

from random import randint
import pandas as pd

## read the input data from GitHub csv file which is a direct query output for this  query:
# 3.2Identify_aggregate_TimeSeriesValues.sql
df = pd.read_csv("https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/2.2Identify_aggregate_TimeSeriesValues.csv")

# identify the data for four time series only based on the DatasetAcronym column header 
column_name = "DatasetAcronym"
subsets = df.groupby(column_name)
data = []

# for each subset (curve), set up its legend and line info manually so they can be edited

subsets_settings = {
    'UDWRFlowData': {
        'symbol': "star",
        'legend_index': 0,
        'legend_name': 'Utah Division of Water Res.',
        'width':'2',
        'size' :'7',
        'color':'rgb(153, 15, 15)',
        'mode': 'lines+markers'
        },
    'CUHASI': {
        'symbol': "square",
        'legend_index': 1,
         'size' :'10',
        'legend_name': 'CUAHSI',
        'width':'3',
        'color':'rgb(15, 107, 153)',
        'show_legend': False,
        },
    'IdahoWRA': {
        'symbol': "triangle-down",
        'legend_index': 2,
         'size' :'6',
        'legend_name': 'Idaho Department of Water Res.',
        'width':'3',
        'color':'rgb(38, 15, 153)'
        },    
    'BearRiverCommission': { # this one is the name of subset as it appears in the csv file
        'symbol': "106",     # this is property of the line (curve)
                'size' :'6',

        'legend_index': 3,   # to order the legend
        'legend_name': "Bear River Commission",  # this is the manual curve name 
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
        opacity = 1,
        
        # Get mode from settings dictionary, if there is no mode
        # defined in dictinoary, then default is markers.
        mode = subsets_settings[subset].get('mode', 'markers'),
        
        # Get legend mode from settings dictionary, if there is no mode
        # defined in dictinoary, then default is to show item in legend.
        showlegend = subsets_settings[subset].get('show_legend', True),
        
        marker = dict(
            size =subsets_settings[subset]['size'],
            color = '#FFFFFF',      # white
            symbol =subsets_settings[subset]['symbol'],
            line = dict(
                color =subsets_settings[subset]['color'],
                width =subsets_settings[subset]['width'], 
                ),
            ),
            
        line = dict(
            color =subsets_settings[subset]['color'],
            width =subsets_settings[subset]['width'], 
            ),
        )
    
    data.append(s)
    
# Legend is ordered based on data, so we are sorting the data based 
# on desired legend order indicated by the index value entered above
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
         range = ['0', '6000'],
         dtick=1000,
                 ),
    xaxis = dict(
         #title = "Time <br> (month/year)",
         #autotick=False,
        tick0='1994-01-01',
        showline=True,
        dtick='M12',
        ticks='outside',
        tickwidth=0.5,
        #zerolinewidth=4,
        ticklen=27,
        #zerolinecolor='#00000',
        tickcolor='#000',
        tickformat= "%Y",
        range = ['1994', '2000']
                ),
    legend=dict(
        x=0.3,y=1,
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
#py.iplot(fig, filename = "2.2bIdentify_aggregate_TimeSeriesValues")       


## it can be run from the local machine on Pycharm like this like below
## It would also work here offline but in a seperate window  
plotly.offline.plot(fig, filename = "2.2bIdentify_aggregate_TimeSeriesValues")       
