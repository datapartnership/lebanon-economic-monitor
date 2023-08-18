# Night Time Lights in Lebanon

Nighttime lights have become a commonly used resource to estimate changes in local economic activity. This section shows where nighttime lights are concentrated across Lebanon and observed changes over time.

## Data

We use nighttime lights data from two sources: for data from 1992 to 2012, we use data from DMSP-OLS; for data from 2013 to present, we use VIIRS Black Marble data. Raw nighttime lights data requires correction due to cloud cover and stray light, such as lunar light. Both nighttime lights dataset apply algorithms to correct raw nighttime light values and calibrate data so that trends in lights over time can be meaningfully analyzed. 

For further information, please refer to {ref}`foundational_datasets`.

## Methodology

We create a consistent time series from DMSP data and VIIRS data. Both data sources provide data in 2013. We scale find the difference between DMSP and VIIRs in 2013, and apply this scaling factor across DMSP data to merge the two time series. The below figure shows the individual VIIRS and DMSP series and the harmonized series.

```{figure} figures/viirs_dmsp_adm0.png
---
scale: 40%
align: center
---
Harmonizing VIIRS and DMSP
```

## Results

### Map of Nighttime Lights

```{figure} figures/ntl_2022.png
---
scale: 40%
align: center
---
Map of Nighttime Lights in 2022
```

### Trends in Nighttime Lights: Annual

```{figure} figures/annual_trends_adm0.png
---
scale: 40%
align: center
---
Annual Trends in Nighttime Lights: Country Level
```

```{figure} figures/annual_trends_adm1.png
---
scale: 40%
align: center
---
Annual Trends in Nighttime Lights: ADM 1 Level
```

### Trends in Nighttime Lights: Monthly

```{figure} figures/monthly_trends_adm0.png
---
scale: 40%
align: center
---
Monthly Trends in Nighttime Lights: Country Level
```

```{figure} figures/monthly_trends_adm1.png
---
scale: 40%
align: center
---
Monthly Trends in Nighttime Lights: ADM 1 Level
```

### Change in Nighttime Lights: 2019 to 2022

```{figure} figures/pc_map_lbn_adm1.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 1
```

```{figure} figures/pc_map_lbn_adm2.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 2
```

```{figure} figures/pc_map_lbn_adm3.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 3
```

```{figure} figures/pc_map_lbn_adm4.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 4 in Beirut
```

