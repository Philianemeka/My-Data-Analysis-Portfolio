# -*- coding: utf-8 -*-
"""
Created on Tue Nov 29th 2022
"""
import pandas as pd
import requests

# 1 Data collection

url = 'https://en.wikipedia.org/wiki/COVID-19_pandemic_by_country_and_territory'
req = requests.get(url)
ds_list = pd.read_html(req.text)
target_ds = ds_list[14]

# 2 Data Cleaning

# Cleaning Column Names
# Creating new column Names

target_ds.columns = ['col0','Country Name','Total Cases','Total Deaths','Total Recorvery','Cases/Million','col6','col7']

# Extracting needed column names to be saved in the data set

target_ds = target_ds[['Country Name','Total Cases','Total Deaths','Total Recorvery','Cases/Million']]

# Removing extra rows at the top (for world at index 0)

target_ds = target_ds.drop([0])
first_idx = target_ds.index[-1]
target_ds = target_ds.drop([first_idx, first_idx-1])

# Correcting Inconsistent Country Names with RegEx 

target_ds['Country Name'] = target_ds['Country Name'].str.replace('\[.*]','')

# Filling columns with no data or null with 0

#target_ds['Total Recorvery'] = target_ds['Total Recorvery'].str.replace('No Data','o')

# Changing wrong Data Types

#target_ds['Total Cases'] = pd.to_numeric(target_ds['Total Cases'])
#target_ds['Total Death'] = pd.to_numeric(target_ds['Total Death'])
#target_ds['Total Recorvery'] = pd.to_numeric(target_ds['Total Recorvery'])


# 3 Exporting Data 

target_ds.to_csv(r'covid19_Dataset.csv')

target_ds.to_excel(r'covid19_Dataset.xlsx')





