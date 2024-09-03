XFab Sarawak Technical Test 09/2024, Data Engineering position

SQL query to create tables and FK Relationships can be located in "Create_tables_n_relationships.sql".
![image](https://github.com/user-attachments/assets/97670cb5-449d-4e98-a828-be0da575e530)


The XFab TT24 SSIS project solution has containers. Containers are named for what they do. Such as the "Push Dim_Data into Tables" container has a Data Flow Task which takes the "Dimension Data.xlsx" and each sheet inside and loads the data into their respective Dim_tables

The "Push Fact_Data into Staging Table" has a Data Flow Task which takes the "Trade Agreement.xlsx" file and loads the data to the Stage_Trade_Agreement Table.

In the final container "ETL using Python" executes an XFab_TT24_ETL.py script. This script contains functions that connect to the localdb, (E)xtracts data from the Staging Table, (T)ransforms it, and (L)oads the clean data into the Trade_Agreement table.

Finally, the "XFab_TT24.pbix" file is the PowerBI file that imports data from the Trade_Agreement table and visualizes the data based on CustomerID or CompanyName.
![image](https://github.com/user-attachments/assets/3572132c-dc37-4fd7-80dd-8a3608d5e73c)
Screenshot of the CustomerID visuals

![image](https://github.com/user-attachments/assets/ab12db18-937c-410c-a674-77583d8b02cd)
Screenshot of the CompanyName visuals
