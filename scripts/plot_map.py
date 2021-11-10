import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('coordinate_data.csv')

BBox = [df['Longitude'].min(), df['Longitude'].max(), df['Latitude'].min(), df['Latitude'].max()]

