# Power BI template data

Download the [Power BI template - tradecontrol.pbit](https://github.com/tradecontrol/powerbi/releases)

## Overview

Power BI is Microsoft's environment for publishing important analytical data to mobile phones, tablets and websites. It consists of three elements: Desktop to code the reports, Services to consume and distribute them, and Mobile.

Import the template into Power BI Desktop and set the data source to your instance of Azure SQL. The template has been written for compatibility with all [node installations](https://github.com/tradecontrol/sqlnode) 3.27.1 or higher. 

Follow Microsoft's online instructions for publishing to the Power BI Service.

## Data

After opening the template, you can create a PowerBI file for your own business. Select **Edit Queries/Data source Settings** to switch between different installations. 

On the side bar of the BI Desktop are three views for reporting, data and the model. The model uses DirectQuery to connect SQL Server views. These views are not coded specifically for reporting purposes, so they are hidden from the user by abstracting the relevant data into DAX tables. The relations between these tables determine how the data is spliced by the BI interface. They can be amended in the Model. Another reason for using DAX is that data from DirectQuery is inaccessible to the user, but the Data view has access to unaggregated rows in a DAX table.

## Sample

The richness of Business Intelligence reporting depends upon large datasets, built up over time from the volume of transactions. When you start out with a new business, or install an MIS for the first time, there is no data to speak of, so all your visualisations are blank. However, you can create a fictitious dataset from the code in this repository and replicate the visualisations shown. The template can then be customised to suit your own purposes when switching to a live data source. 
 
### Installation

First, install Trade Control onto an Azure SQL instance and [configure a basic setup](https://github.com/tradecontrol/sqlnode). There are then two ways to generate the data:

- Open [the script](https://github.com/TradeControl/powerbi/blob/master/src/TestData/tc_bom_demo_extension.sql) in SSMS and execute directly
- From Visual Studio, open the cloned TestData.sqlproj and execute from inside the IDE

A different result set is generated each time the script is executed on the same instance. That is because areas, products and sectors are randomly applied to both customers and the sales team using the ```RAND()``` function. The amount of data generated can be altered by adding additional historical financial years in the Administration form, setting the status to Closed; and by modifying the ```@MaxCustomers smallint = 20``` declaration at the top of the script.

### Script

The sample data builds on the [Bill of Materials tutorial](https://github.com/tradecontrol/office). The script implements the additional operations:

1. Create six new products by making M/00/70/00 in six different colours, altering the plastic material to change the costs. Arbitrarily alter selling prices to generate different gross profit margins.
2. Add five new users without administrative rights to represent the Sales Team
3. Declare in-memory tables of area and sector codes for random assignment to new customers
4. Assign the BOM tutorial sales order to a member of the Sales Team and assign sector and area codes to the existing customer account
5. Create the new customers and their orders, each time exploding the BOM and scheduling the associated orders.
6. Specify suppliers for the new purchase orders
7. Recurse through the order book and invoice all historical sales and purchases
8. Pay invoices where ```ExpectedOn < EOMONTH(DATEADD(MONTH, -1,CURRENT_TIMESTAMP))```
9. Pay the outstanding VAT and corporation tax

### Power BI Desktop

[Open the template](powerbi.md) in the Power BI Desktop
