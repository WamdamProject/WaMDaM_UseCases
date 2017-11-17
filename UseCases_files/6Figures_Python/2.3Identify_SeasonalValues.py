# Use Case 2.3Identify_SeasonalValues

# plot Seasonal data for multiple scenarios

# Adel Abdallah
# November 16, 2017


import plotly
import plotly.plotly as py
import plotly.graph_objs as go
from random import randint
import pandas as pd

## read the input data from GitHub csv file which is a direct query output
# 3.3Identify_SeasonalValues.csv 
df = pd.read_csv("https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/2.3Identify_SeasonalValues.csv")


#get the many curves by looking under "ScenarioName" column header. 
#Then plot Season name vs season value
column_name = "ScenarioName"
subsets = df.groupby(column_name)

data = []


#for each subset (curve), set up its legend and line info manually so they can be edited
subsets_settings = {
    'Bear Wet Year Model': {
        'dash': 'solid',
         'mode':'lines+markers',
        'width':'4',
        'legend_index': 0,
        'legend_name': 'Wet Year Model',
         'color':'rgb(41, 10, 216)'
        },

    'Bear Normal Year Model': { # this oone is the name of subset as it appears in the csv file
        'dash': 'solid',     # this is properity of the line (curve)
        'width':'4',
        'mode':'lines+markers',
        'legend_index': 1,   # to order the legend
        'legend_name': 'Normal Year Model',  # this is the manual curve name 
         'color':'rgb(38, 77, 255)'

        },
    'Bear Dry Year Model': {
        'dash': 'solid',
        'mode':'lines+markers',
         'width':'4',
        'legend_index': 2,
        'legend_name': 'Dry Year Model',
         'color':'rgb(63, 160, 255)'
        },


        }


# This dict is used to map legend_name to original subset name
subsets_names = {y['legend_name']: x for x,y in subsets_settings.iteritems()}


for subset in subsets.groups.keys():
    print subset
    dt = subsets.get_group(name=subset)
    s = go.Scatter(
                    x=df.SeasonName,
                    y=dt['SeasonNumericValue'],
                    name = subsets_settings[subset]['legend_name'],
                    line = dict(
                        color =subsets_settings[subset]['color'],
                        width =subsets_settings[subset]['width'],
                        dash=subsets_settings[subset]['dash']
                                ),
                    marker=dict(size=10),            
                    opacity = 0.8
                   )
    data.append(s)
    
    
# Legend is ordered based on data, so we are sorting the data based 
# on desired legend order indicarted by the index value entered above
data.sort(key=lambda x: subsets_settings[subsets_names[x['name']]]['legend_index'])

    

layout = dict(
    #title = "Use Case 3.3",
    yaxis = dict(
        title = "Cumulative flow <br> (acre-feet/month)",
        tickformat= ',',
        showline=True,
        dtick='5000',
        ticks='outside',
        ticklen=10

                ),
    
    xaxis = dict(
        #title = "Month",
        ticks='inside',

        ticklen=25
                    ),
    legend=dict(
        x=0.6,y=0.5,
          bordercolor='#00000',
            borderwidth=2
               ),
    width=1200,
    height=800,
    #paper_bgcolor='rgb(233,233,233)',
    #plot_bgcolor='rgb(233,233,233)',
    margin=go.Margin(l=260,b=100),
    font=dict(size=35)
             )
# create a figure object
fig = dict(data=data, layout=layout)
#py.iplot(fig, filename = "2.3Identify_SeasonalValues") 


## it can be run from the local machine on Pycharm like this like below
## It would also work here offline but in a seperate window  
plotly.offline.plot(fig, filename = "2.3Identify_SeasonalValues") 


