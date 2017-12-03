# Use Case 2.4_plotcdf 

# plot Cumulative flow for June for the UDWR dataset. 
# Then get the percentage of time it exceeds dry and wet years 

# Adel Abdallah
# Dec 2, 2017


import plotly
import plotly.plotly as py
import plotly.graph_objs as go
import numpy as np
import scipy
import pandas as pd

## read the input data from GitHub csv file which is a direct query output for this  query:
# 3.2Identify_aggregate_TimeSeriesValues.sql
df = pd.read_csv("https://raw.githubusercontent.com/WamdamProject/WaMDaM_UseCases/master/UseCases_files/5Results_CSV/2.2Identify_aggregate_TimeSeriesValues.csv")

# Convert CalenderYear column data type to datetime
df['CalenderYear'] = pd.to_datetime(df['CalenderYear'], errors='coerce')

# Slice rows based on DatasetAcronym column
subsets = df.groupby('DatasetAcronym')

# Select rows where DatasetAcronym is UDWRFlowData
dt = subsets.get_group(name='UDWRFlowData')

# From the selected rows, select rows where month is June
specific_month = dt.CalenderYear.dt.month == 6

# CumulativeMonthly data of the desired DatasetAcronym name and month
cumulative_monthly = dt[specific_month].CumulativeMonthly.values.tolist()

# Sort cumulative_monthly in ascending order
cumulative_monthly.sort()

# Save the filtered data to csv, CumulativeMonthly and CalenderYear columns
filtered_data = dt[specific_month][['CumulativeMonthly', 'CalenderYear']]
filtered_data.to_csv('Filtered Data.csv', index=False)


# Create the y-axis list, which should be same length as x-axis and range
# from 0 to 1, to represent probability and have equal spacing between it's
# numbers, so we create a list of floats starting from 1 to length of
# cumsum(which represents the x-axis) + 1, (+1) because we started from 1 not 0,
# we want the same length of cumsum, and we are dividing the list by length of
# cumsum to produce the desired probability values, So the last number in the
# list should be equal to the length of cumsum, so that when we divide both
# both values we get 1.
# To get the last number equal length of cumsum, we have to use
# max range = len(cumsum)+1, because np.arange will stop before
# the maximum number, so it will stop at len(cumsum)
probability = np.arange(1.0, len(cumulative_monthly)+1) /len(cumulative_monthly) # 1.0 to make it float

data = []
# just plot the sorted_data array against the number of items smaller 
# than each element in the array 

cdf = go.Scatter(
    x = cumulative_monthly,
    y = probability,
        showlegend=True,
name='UDWR from 1923 to 2014',
    marker = dict(
        color='rgb(0, 0, 0)'
        )
    )

cdfdata=pd.DataFrame(data=dict(probability=probability,cumulative_monthly=cumulative_monthly))

data.append(cdf)


# Save the filtered data to csv, CumulativeMonthly and probability columns
filtered_data = cdfdata
filtered_data.to_csv('CDF_data.csv', index=False)


# cdfdata

lowerthanDry=cdfdata.loc[cdfdata['cumulative_monthly'] <= 666, 'probability']
print lowerthanDry


UpperthanWet=cdfdata.loc[cdfdata['cumulative_monthly'] >= 17181, 'probability']
print UpperthanWet

# vertical line dry year 
dry = go.Scatter(
    x=[666, 666 ],
    y=[0, 0.48],
    mode='lines',
        name='Dry year scenario <br> (BRSDM model)',
    hoverinfo='dry',
    showlegend=True,
    line=dict(
        shape='vh',
        width='4',
        dash = 'dot',
        color = '#3FA0FF'
            )
                    )
data.append(dry)



# horizontal line dry year 
dryHo = go.Scatter(
    x=[0, 666 ],
    y=[0.48, 0.48],
    mode='lines',
        name='Dry year scenario <br> (BRSDM model)',
    hoverinfo='dry',
    showlegend=False,
    line=dict(
        shape='vh',
        width='4',
        dash = 'dot',
        color = '#3FA0FF'
            )
                    )
data.append(dryHo)



# vertical line wet year 
wet = go.Scatter(
    x=[17181, 17181],
    y=[0, 0.93],
    mode='lines',
        name='Wet year scenario <br> (BRSDM model)',
    hoverinfo='wet',
    showlegend=True,
    line=dict(
        shape='vh',
        dash = 'dash',
        width='4',
        color = '#290AD8'
            )
                    )
data.append(wet)


# horizontal line wet year 
wetHo = go.Scatter(
    x=[0, 17181],
    y=[0.93, 0.93],
    mode='lines',
        name='Wet year scenario <br> (BRSDM model)',
    hoverinfo='wet',
    showlegend=False,
    line=dict(
        shape='vh',
        dash = 'dash',
        width='4',
        color = '#290AD8'
            )
                    )
data.append(wetHo)


layout = go.Layout(
    xaxis = dict(
        title = "Cumulative flow for June <br> (acre-feet/month)",
        zeroline=True,
         #showline=True,
        tickformat= ',',
        dtick='10000',
        ticks='inside',
        ticklen=25,   
        range = ['0', '40000'],


            ),
    yaxis = dict(
                title = 'Cumulative probability',
                dtick='0.1',
                ticks='outside',
                ticklen=25,
#                 range = ['0', '1'],


             showline=True,
),
    font=dict(size=35,family='arial'),
    width=1100,
    height=800,
    margin=go.Margin(
        l=230,
        b=150       ),
    legend=dict(
        x=0.5,y=0.5,
            bordercolor='#00000',
            borderwidth=2, 
     font=dict(
            family='arial',
            size=35                    )           
    ),
 
        
        
        
    )

fig = dict(data=data, layout=layout)

plotly.offline.plot(fig, filename = "2.4_plotcdf")
