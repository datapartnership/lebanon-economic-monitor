# Seaborn Trade Activity Estimation

This section introduces the use of an alternative big data source – Automatic Identification System (hereafter, AIS) – to monitor seaborn trade activity in Lebanon. AIS was originally developed by the International Maritime Organization in 2004 to prevent collisions between large vessels. This system requires all commercial ships (gross tonnage greater than 300) and passenger ships to broadcast their position via ground stations and satellites.

A nascent literature has been dedicated to convert raw AIS messages into volumes of trade ({cite:t}`TrackingTradefromSpaceAnApplicationtoPacificIslandCountries`; {cite:t}`Cerdeiro2020WorldST`; {cite:t}`Jia2019`; {cite:t}`Verschuur2021`; {cite:t}`Verschuur2021-fw`). These papers utilize dynamic information on ship movements, static characteristics of each ship, and reported draft (depth of submergence), to estimate the amount of goods offloaded or loaded at a certain port. While this methodology has produced results that correlate with aggregated trade value statistics, users should use the results with caution as a near real-time proxy for relative trends in trade. The methodology is based primarily on draft values from AIS data which are subject to a few limitations. Thus, AIS-derived trade values may not match perfectly with reported values.

For the purposes of the monitor, we implement and adjust the methodology described in “**Tracking trade from space: an application to pacific island countries**” {cite}`TrackingTradefromSpaceAnApplicationtoPacificIslandCountries`, using the same AIS data used by the authors, facilitated by the [UN Global Platform AIS Task Team](https://unstats.un.org/wiki/display/AIS/AIS+Handbook+Outline).

The final data product, Trade Estimation for Lebanon, visualized in the subsequent notebooks, can also be accessed through [Project SharePoint](https://worldbankgroup.sharepoint.com.mcas.ms/teams/DevelopmentDataPartnershipCommunity-WBGroup/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=Yvwh8r&cid=fccdf23e%2D94d5%2D48bf%2Db75d%2D0af291138bde&FolderCTID=0x012000CFAB9FF0F938A64EBB297E7E16BDFCFD&id=%2Fteams%2FDevelopmentDataPartnershipCommunity%2DWBGroup%2FShared%20Documents%2FProjects%2FData%20Lab%2FLebanon%20Economic%20Analytics%2FData%2Ftrade&viewid=80cdadb3%2D8bb3%2D47ae%2D8b18%2Dc1dd89c373c5).

```{note}
This workflow and notebooks were originally developed by Cherryl Chico in support of the World Bank's Pacific Observatory project. It has been adapted for the Lebanon Monitor by Andres Chamorro.
```

## Methodology

The method can be broken down into the following four steps (each step was implemented in a python notebook).

### Step 1. Data Extraction

We retrieve all AIS messages that intersect a 10-kilometer buffer from each port in Lebanon (Bayrut, Sayda, and Tarabulus), available from December 1st, 2018, to November 1st, 2023. We use international port boundaries provided by {cite:t}`Verschuur2021-fw`.

#### Summarize AIS Data by Routes

We collapse the AIS data into routes. An incoming or outgoing route is captured by grouping continous AIS messages from a unique vessel traversing from port buffer to port boundary (or vice versa). We keep the first and last AIS messages for each route as they contain relevant arrival and departure information.

### Step 2. Data Filtering and Ship Registry Information

There may be routes that are quick because of small movements by vessels located at the edges of the boundaries. To remove the noise, we say that a vessel has fully exited the port when it spends at least 1 day outside of Port Boundary. Otherwise, we treat consecutive routes within 24 hours of each other as one.

We then combine the routes data with Ship Registry data to get the finer vessel categories and other information on the vessel required for trade estimation. The matching is done using both MMSI and IMO numbers from both data sources. We validate the match by comparing the vessel names.

### Step 3. Backpropagate Departure Draft

The difference in arrival vs. departure draught is a key calculation to estimate trade. However, the difference between outgoing and incoming draft is only identified in a subset of port calls. For the remaining routes, we apply the *back-propagation* technique, searching for the arrival draft at the next port visited.

### Step 4. Trade Estimation

#### Volume Displacement Method

We estimate the volume of the load of the ship based on the volume of the displaced water. The volume of the displaced water by the ship is derived from the volume of a rectangular block with the same length and width. The ship's draught or the height of the ship submerged in water is the height of the rectangular block. Since the ship is not rectangular, we reduce this by a factor called block coefficent that is dependent on the ship's draught. To convert volume into weight (in tonnes), we multiply the volume by the density of saltwater.

#### Design Block Coefficient

From any reported draught $D_r$​, displacement at reported draught $Disp_r$ can be estimated as the volume of a rectangular block with the same dimensions of the ship. The length and width of the ship represents the length and width of the rectangular block and the draught represents the height. The volume is adjusted by a factor called block coefficient and then converted to tonnes by multiplying by the density of salt water.

$$Disp_r = Cb_rLW\rho d_r$$


> where $Cb_{r}$ is the block coefficient at draught $d_{r}$, $L$ is the length, $W$ is the width, $\rho$ = density of salt water, and $d_r$ = reported draught

We can derive the block coefficent for any given draught as follows:

$$Cb_{r} = \frac{Disp_{r}}{LW\rho*d_{r}}$$

Given design draught, and design block coeffient, the block coefficient at reported draught can be estimated as:

$$ Cb_r = 1 - (1 - Cb_d) \frac{d_d}{d_r} ^ \frac{1}{3} $$

## Implementation

- [01 Data Extraction](./01-lebanon.ipynb)
- [02 Data Filtering and Ship Registry Information](./02-lebanon.ipynb)
- [03 Backpropagate Departure Draft](./03-lebanon.ipynb)
- [04 Trade Estimation](./04-lebanon.ipynb)

## Findings

We present results of the estimated volume of trade (imports and exports) across all ports in Lebanon. The trade flow is consistently dominated by imports. We find a decrease in trade volume in 2023.

```{figure} ./ais-trade.JPG
---
align: center
---
Estimated Monthly Trade Volume from AIS signal
```

## Limitations

- The accuracy of the trade estimation method depends heavily on the level of draft reporting in ports, which varies globally.

- The methodology doesn’t currently account for transshipment (goods that are offloaded at a port and then loaded onto another vessel without going through customs).

- AIS data can be noisy, and the methodology is sensitive to days with data blackouts.

## References

```{bibliography}
```
