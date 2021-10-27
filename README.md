To exploit this project follows these steps:

1 - Create a ressource group in Azure
2 - Create the different cloud resources as shown in the report
	- Azure Blob Storage
	- Azure Data Factory
	- Azure SQL Database
3 - Run create_data_warehouse.sql on Azure SQL Database you have created
	- Connect SSMS to the Azure SQL Database
	- Run the script
4 - Import the ETL pipeline file to Azure Data Factory
5 - Trigger the pipeline
6 - Connect the Sales.pbix file to the data warehouse
	- Open the Sales.pbix file
	- Change source settings to your Azure SQL Database
7 - Create a Microsoft Power BI Server workspace
8 - Create the application from the workspace


This project is organized as follows:
```
Medical-Sales-Intelligence
│   LICENSE
│   README.md
│
├───Data
│       Customers.xlsx
│       Products.xlsx
│       Sales Managers.xlsx
│       Sales Reps and Geographies.xlsx
│       Sales.xlsx
│       Targets.xlsx
│
├───Development
│   ├───Data Orchestration
│   │       ETL.zip
│   │       ETL_support_live.zip
│   │
│   ├───Data Warehouse
│   │       create_data_warehouse.sql
│   │
│   ├───Exploratory Data Analysis
│   │       Data understanding.ipynb
│   │       EDA Customers.ipynb
│   │       EDA Products.ipynb
│   │       EDA Sales.ipynb
│   │       EDA SalesManagers.ipynb
│   │       EDA SalesRepsandGeographies.ipynb
│   │       EDA Targets.ipynb
│   │       utils.py
│   │
│   └───Reporting
│           Sales.pbix
│           Sales.pdf
│
└───Report
        Presentation.pptx
        Project Report.pdf
```