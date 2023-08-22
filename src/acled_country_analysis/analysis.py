
import pandas as pd
import numpy as np
import geopandas as gpd

from shapely.geometry import Point

from scipy.stats import gmean

def convert_to_gdf(df):
    geometry = [Point(xy) for xy in zip(df.longitude, df.latitude)]
    gdf = gpd.GeoDataFrame(df, crs="EPSG:4326", geometry=geometry)

    return gdf

def get_acled_by_admin(adm, acled, columns = ['ADM4_EN','ADM3_EN','ADM2_EN', 'ADM1_EN'], nearest=False):
    acled_adm2 = convert_to_gdf(acled)
    if nearest == True:
        acled_adm2 = adm.sjoin_nearest(acled_adm2, max_distance=2000)[[ 'event_date', 'fatalities' ]+columns].groupby([pd.Grouper(key='event_date', freq='M')]+columns)['fatalities'].agg(['sum', 'count']).reset_index()
    else:
        acled_adm2 = adm.sjoin(acled_adm2)[[ 'event_date', 'fatalities', ]+columns].groupby([pd.Grouper(key='event_date', freq='M')]+columns)['fatalities'].agg(['sum', 'count']).reset_index()
    acled_adm2.rename(columns = {'sum':'fatalities', 'count':'nrEvents'}, inplace=True)
    acled_adm2['conflictIndex'] = acled_adm2.apply(lambda row: gmean([row['nrEvents'], row['fatalities']]), axis=1)
    acled_adm2['conflictIndexLog'] = np.log(acled_adm2['conflictIndex'])
    #acled_adm2['event_date_map'] = acled_adm2['event_date'].apply(lambda x: x.date().replace(day=1))

    return acled_adm2.reset_index()