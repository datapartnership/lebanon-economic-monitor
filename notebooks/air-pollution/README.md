# Air Pollution in Lebanon

Air Pollution is typically measured by calculating the density of different pollutants in the atmosphere. Some of the commonly measured pollutants are NO2, O3 and particulate matter. Studies found NO2 levels as a useful proxy for economic activity (Deb, et.al., 2020). One of the reasons is because it is measured during the day when businesses are open and people are at work. It also stays close to the source of emissions —such as engines, vehicles or chimneys — and has a short atmospheric life (Ezran, et.al., 2023). Yailymova et.al., 2023 also posited that air quality and, in particular, levels of fine particulate matter (e.g., PM2.5 and PM 10 ) over cities can be a proxy for assessment of economic activity and density of city populations. NO2 along with other NOx reacts with other chemicals in the air to form both particulate matter and ozone. A 2020 study of cities in Sub-Saharan Africa finds that NO2 provides a useful, albeit “noisy”, real-time proxy measure of how COVID-19 has affected [economic activity](https://blogs.worldbank.org/developmenttalk/what-nitrogen-dioxide-emissions-tell-us-about-fragile-recovery-south-asia). 

In this analysis, we observe the trends in monthly NO2 levels for Lebanon from 2019 to 2023. This analysis can then be used as a proxy for economic activity. 

## Data Description

### NO2 Data

Nitrogen oxides (NO2 and NO) are important trace gases in the Earth's atmosphere, present in both the troposphere and the stratosphere. They enter the atmosphere as a result of anthropogenic activities (notably fossil fuel combustion and biomass burning) and natural processes (wildfires, lightning, and microbiological processes in soils). Here, NO2 is used to represent concentrations of collective nitrogen oxides because during the daytime, i.e. in the presence of sunlight, a photochemical cycle involving ozone (O3) converts NO into NO2 and vice versa on a timescale of minutes.

The **total vertical column density of NO2** is calculated by taking the slant column density (SCD) of NO2, which is the amount of NO2 measured along the line of sight of the satellite instrument, and dividing it by the air mass factor (AMF), which corrects the slant column density for the effect of the path length and the scattering and absorption properties of the atmosphere. The Total Vertical Column Density (VCD) is typically given in molecules per square centimeter (molec/cm²). 

Sentinel 5P collects data on pollutants such as NO2, SO2, CO and O3. This data can be extracted using Google Earth Engine. [Google Earth Engine](https://earthengine.google.com/) is a cloud-based geospatial analysis platform that enables users to visualize and analyze satellite images of our planet. We used JavaScript code to gather NO2 data from Google Earth Engine for each admin region. The raw data is then uploaded to [SharePoint](https://worldbankgroup.sharepoint.com.mcas.ms/teams/DevelopmentDataPartnershipCommunity-WBGroup/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=Yvwh8r&cid=fccdf23e%2D94d5%2D48bf%2Db75d%2D0af291138bde&FolderCTID=0x012000CFAB9FF0F938A64EBB297E7E16BDFCFD&id=%2Fteams%2FDevelopmentDataPartnershipCommunity%2DWBGroup%2FShared%20Documents%2FProjects%2FData%20Lab%2FLebanon%20Economic%20Analytics%2FData%2Fair%5Fpollution%2FNO2&viewid=80cdadb3%2D8bb3%2D47ae%2D8b18%2Dc1dd89c373c5). 

#### Data Access

* Dataset: [Sentinel-5P NRTI NO2: Near Real-Time Nitrogen Dioxide](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S5P_NRTI_L3_NO2) 
* Dataset Provider: [European Space Agency](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-5p-tropomi)
* Granularity: 1113.2 meters of granularity globally
* Frequency: Daily
* License: The use of Sentinel data is governed by the [Copernicus Sentinel Data Terms and Conditions](https://sentinel.esa.int/documents/247904/690755/Sentinel_Data_Legal_Notice).
* **Data Access**: [The Project SharePoint](https://worldbankgroup.sharepoint.com.mcas.ms/teams/DevelopmentDataPartnershipCommunity-WBGroup/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=Yvwh8r&cid=fccdf23e%2D94d5%2D48bf%2Db75d%2D0af291138bde&FolderCTID=0x012000CFAB9FF0F938A64EBB297E7E16BDFCFD&id=%2Fteams%2FDevelopmentDataPartnershipCommunity%2DWBGroup%2FShared%20Documents%2FProjects%2FData%20Lab%2FLebanon%20Economic%20Analytics%2FData%2Fair%5Fpollution%2FNO2&viewid=80cdadb3%2D8bb3%2D47ae%2D8b18%2Dc1dd89c373c5) currently hosts raw data queried from Google Earth Engine and can be accessed by all project team members. 


### Boundary Files

Boundary files for this analysis are obtained on the Humanitarian Data Exchange (HDX). [HDX](https://data.humdata.org/faq) is an open platform for sharing data across crises and organizations. HDX is managed by OCHA's Centre for Humanitarian Data, which is located in The Hague, the Netherlands. OCHA is part of the United Nations Secretariat and is responsible for bringing together humanitarian actors to ensure a coherent response to emergencies. 

#### Data Access

* Dataset: [Lebanon - Subnational Administrative Boundaries](https://data.humdata.org/dataset/cod-ab-lbn?)
* Dataset Provider: Council for Development and Reconstruction (CDR) (administrative level 0-3); Open Street Map and Lebanese Arabic Institute (administrative level 4).
* Granularity: Administrative Levels 0-4
* Frequency: The dataset accessed was last updated in June 2017. 
* License: Creative Commons Attribution for Intergovernmental Organisations (CC BY-IGO)
* **Data Access**: Teams can download the boundary files from HDX directly.


## References

- Deb, P., Furceri, D., Ostry, J. D., & Tawk, N. (2020). The economic effects of COVID-19 containment measures.

- Ezran, Irene; Morris, Stephen D.; Rama, Martín; Riera-Crichton, Daniel. 2023. Measuring Global Economic Activity Using Air Pollution. Policy Research Working Papers; 10445. © World Bank, Washington, DC. http://hdl.handle.net/10986/39827 License: CC BY 3.0 IGO.

- Yailymova, H., Kolotii, A., Kussul, N., & Shelestov, A. (2023, July). Air quality as proxy for assesment of economic activity. In IEEE EUROCON 2023-20th International Conference on Smart Technologies (pp. 89-92). IEEE.