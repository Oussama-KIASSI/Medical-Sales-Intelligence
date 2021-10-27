CREATE SCHEMA Sales
GO


/****** Drop constraints    Script Date: 18/10/2021 16:23:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DECLARE @sql NVARCHAR(MAX)
SET @sql = N''

SELECT @sql = @sql + N'
  ALTER TABLE ' + QUOTENAME(s.name) + N'.'
  + QUOTENAME(t.name) + N' DROP CONSTRAINT '
  + QUOTENAME(c.name) + ';'
FROM sys.objects AS c
INNER JOIN sys.tables AS t
ON c.parent_object_id = t.[object_id]
INNER JOIN sys.schemas AS s 
ON t.[schema_id] = s.[schema_id]
WHERE c.[type] IN ('D','C','F','PK','UQ')
AND s.[name] LIKE '[Sales]%'
ORDER BY c.[type]

EXEC sys.sp_executesql  @sql
GO

/****** Object:  Table [Sales].[Fact_targets]    Script Date: 18/10/2021 16:23:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Fact_targets]') AND type in (N'U'))
DROP TABLE [Sales].[Fact_targets]
GO

/****** Object:  Table [Sales].[Fact_sales]    Script Date: 18/10/2021 16:24:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Fact_sales]') AND type in (N'U'))
DROP TABLE [Sales].[Fact_sales]
GO

/****** Object:  Table [Sales].[Dim_salesrep]    Script Date: 18/10/2021 16:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_salesrep]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_salesrep]
GO

/****** Object:  Table [Sales].[Dim_salesmanager]    Script Date: 18/10/2021 16:28:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_salesmanager]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_salesmanager]
GO

/****** Object:  Table [Sales].[Dim_product]    Script Date: 18/10/2021 16:29:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_product]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_product]
GO

/****** Object:  Table [Sales].[Dim_customer]    Script Date: 18/10/2021 16:30:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_customer]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_customer]
GO

/****** Object:  Table [Sales].[Dim_customerregion]    Script Date: 18/10/2021 16:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_customerregion]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_customerregion]
GO

/****** Object:  Table [Sales].[Dim_customerregion]    Script Date: 18/10/2021 16:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_salesrepregion]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_salesrepregion]
GO

/****** Object:  Table [Sales].[Dim_date]    Script Date: 18/10/2021 16:57:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[Dim_date]') AND type in (N'U'))
DROP TABLE [Sales].[Dim_date]
GO

/****** Object:  Table [Sales].[Dim_date]    Script Date: 18/10/2021 16:57:18 ******/
CREATE TABLE [Sales].[Dim_date](
	[Date_ID] [int] NOT NULL,
	[Date] [date] NULL,
	[Month] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_Dim_date] PRIMARY KEY CLUSTERED 
(
	[Date_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 
DECLARE @StartDate DATETIME = '01/01/2017' --Starting value of Date Range
DECLARE @EndDate DATETIME = '12/31/2018' --End Value of Date Range

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

--Extract and assign various parts of Values from Current Date to Variable
DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above
WHILE @CurrentDate < @EndDate
BEGIN
/* Populate Your Dimension Table with values*/
	INSERT INTO [Sales].[Dim_date]
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as Date_ID,

		@CurrentDate AS Date,

		DATEPART(MM, @CurrentDate) AS Month,

		DATEPART(QQ, @CurrentDate) AS Quarter,

		DATEPART(YEAR, @CurrentDate) AS Year

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END
GO

/****** Object:  Table [Sales].[Dim_customerregion]    Script Date: 18/10/2021 15:44:36 ******/
CREATE TABLE [Sales].[Dim_customerregion](
	[CustomerRegion_ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerRegionName] [varchar](25) NOT NULL,
 CONSTRAINT [PK_Dim_customerregion] PRIMARY KEY CLUSTERED 
(
	[CustomerRegion_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [Sales].[Dim_salesrepregion]    Script Date: 18/10/2021 15:44:36 ******/
CREATE TABLE [Sales].[Dim_salesrepregion](
	[SalesRepRegion_ID] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepRegionName] [varchar](25) NOT NULL,
 CONSTRAINT [PK_Dim_salesrepregion] PRIMARY KEY CLUSTERED 
(
	[SalesRepRegion_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [Sales].[Dim_product]    Script Date: 18/10/2021 15:46:47 ******/
CREATE TABLE [Sales].[Dim_product](
	[Product_ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [varchar](17) NOT NULL,
	[P02] [varchar](31) NULL,
	[P03] [varchar](31) NULL,
	[P04] [varchar](33) NULL,
	[P05] [varchar](40) NULL,
	[P06] [varchar](40) NULL,
	[P07] [varchar](40) NULL,
	[P08] [varchar](40) NULL,
 CONSTRAINT [PK_Dim_product] PRIMARY KEY CLUSTERED 
(
	[Product_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [Sales].[Dim_salesmanager]    Script Date: 18/10/2021 15:47:26 ******/
CREATE TABLE [Sales].[Dim_salesmanager](
	[Manager_ID] [int] IDENTITY(1,1) NOT NULL,
	[ManagerName] [varchar](25) NOT NULL,
 CONSTRAINT [PK_Dim_salesmanager] PRIMARY KEY CLUSTERED 
(
	[Manager_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [Sales].[Dim_salesrep]    Script Date: 18/10/2021 15:48:34 ******/
CREATE TABLE [Sales].[Dim_salesrep](
	[Rep_ID] [int] IDENTITY(1,1) NOT NULL,
	[RepName] [varchar](25) NOT NULL,
	[Manager_ID] [int] NULL,
	[SalesRepRegion_ID] [int] NULL,
 CONSTRAINT [PK_Dim_salesrep] PRIMARY KEY CLUSTERED 
(
	[Rep_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[Dim_salesrep]  WITH CHECK ADD  CONSTRAINT [FK_Dim_salesrep_Dim_salesmanager] FOREIGN KEY([Manager_ID])
REFERENCES [Sales].[Dim_salesmanager] ([Manager_ID])
GO

ALTER TABLE [Sales].[Dim_salesrep] CHECK CONSTRAINT [FK_Dim_salesrep_Dim_salesmanager]
GO

ALTER TABLE [Sales].[Dim_salesrep]  WITH CHECK ADD  CONSTRAINT [FK_Dim_salesrep_Dim_salesrepregion] FOREIGN KEY([SalesRepRegion_ID])
REFERENCES [Sales].[Dim_salesrepregion] ([SalesRepRegion_ID])
GO

ALTER TABLE [Sales].[Dim_salesrep] CHECK CONSTRAINT [FK_Dim_salesrep_Dim_salesrepregion]
GO

/****** Object:  Table [Sales].[Dim_customer]    Script Date: 18/10/2021 15:50:00 ******/
CREATE TABLE [Sales].[Dim_customer](
	[Customer_ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerNbr] [char](10) NOT NULL,
	[CustomerName] [varchar](40) NOT NULL,
	[C01] [varchar](17) NULL,
	[C02] [varchar](14) NULL,
	[C03] [varchar](16) NULL,
	[C04] [varchar](31) NULL,
	[C05] [varchar](35) NULL,
	[C06] [varchar](35) NULL,
	[C07] [varchar](35) NULL,
	[CustomerRegion_ID] [int] NOT NULL,
 CONSTRAINT [PK_Dim_customer] PRIMARY KEY CLUSTERED 
(
	[Customer_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[Dim_customer]  WITH CHECK ADD  CONSTRAINT [FK_Dim_customer_Dim_customerregion] FOREIGN KEY([CustomerRegion_ID])
REFERENCES [Sales].[Dim_customerregion] ([CustomerRegion_ID])
GO

ALTER TABLE [Sales].[Dim_customer] CHECK CONSTRAINT [FK_Dim_customer_Dim_customerregion]
GO

/****** Object:  Table [Sales].[Fact_targets]    Script Date: 18/10/2021 15:42:35 ******/
CREATE TABLE [Sales].[Fact_targets](
	[Target_ID] [int] IDENTITY(1,1) NOT NULL,
	[Target] [decimal](30, 20) NULL,
	[Date_ID] [int] NOT NULL,
	[Rep_ID] [int] NOT NULL,
	[SalesRepRegion_ID] [int] NULL,
 CONSTRAINT [PK_Fact_targets] PRIMARY KEY CLUSTERED 
(
	[Target_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[Fact_targets]  WITH CHECK ADD  CONSTRAINT [FK_Fact_targets_Dim_date] FOREIGN KEY([Date_ID])
REFERENCES [Sales].[Dim_date] ([Date_ID])
GO

ALTER TABLE [Sales].[Fact_targets] CHECK CONSTRAINT [FK_Fact_targets_Dim_date]
GO

ALTER TABLE [Sales].[Fact_targets]  WITH CHECK ADD  CONSTRAINT [FK_Fact_targets_Dim_salesrep] FOREIGN KEY([Rep_ID])
REFERENCES [Sales].[Dim_salesrep] ([Rep_ID])
GO

ALTER TABLE [Sales].[Fact_targets] CHECK CONSTRAINT [FK_Fact_targets_Dim_salesrep]
GO

ALTER TABLE [Sales].[Fact_targets]  WITH CHECK ADD  CONSTRAINT [FK_Fact_targets_Dim_salesrepregion] FOREIGN KEY([SalesRepRegion_ID])
REFERENCES [Sales].[Dim_salesrepregion] ([SalesRepRegion_ID])
GO

ALTER TABLE [Sales].[Fact_targets] CHECK CONSTRAINT [FK_Fact_targets_Dim_salesrepregion]
GO

/****** Object:  Table [Sales].[Fact_sales]    Script Date: 18/10/2021 15:40:30 ******/
CREATE TABLE [Sales].[Fact_sales](
	[Sale_ID] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [decimal](30, 20) NULL,
	[ValueBasedRebate] [decimal](30, 20) NULL,
	[InvoicedSaleValue] [decimal](30, 20) NOT NULL,
	[LogisticSurcharge] [decimal](30, 20) NULL,
	[CostOfSale] [decimal](30, 20) NOT NULL,
	[DistributionCost] [decimal](30, 20) NULL,
	[NetSalesValue] [decimal](30, 20) NULL,
	[GrossMargin] [decimal](30, 20) NULL,
	[Date_ID] [int] NOT NULL,
	[Rep_ID] [int] NOT NULL,
	[SalesRepRegion_ID] [int] NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Product_ID] [int] NOT NULL,
 CONSTRAINT [PK_Fact_sales] PRIMARY KEY CLUSTERED 
(
	[Sale_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[Fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_sales_Dim_customer] FOREIGN KEY([Customer_ID])
REFERENCES [Sales].[Dim_customer] ([Customer_ID])
GO

ALTER TABLE [Sales].[Fact_sales] CHECK CONSTRAINT [FK_Fact_sales_Dim_customer]
GO

ALTER TABLE [Sales].[Fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_sales_Dim_date] FOREIGN KEY([Date_ID])
REFERENCES [Sales].[Dim_date] ([Date_ID])
GO

ALTER TABLE [Sales].[Fact_sales] CHECK CONSTRAINT [FK_Fact_sales_Dim_date]
GO

ALTER TABLE [Sales].[Fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_sales_Dim_product] FOREIGN KEY([Product_ID])
REFERENCES [Sales].[Dim_product] ([Product_ID])
GO

ALTER TABLE [Sales].[Fact_sales] CHECK CONSTRAINT [FK_Fact_sales_Dim_product]
GO

ALTER TABLE [Sales].[Fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_sales_Dim_salesrep] FOREIGN KEY([Rep_ID])
REFERENCES [Sales].[Dim_salesrep] ([Rep_ID])
GO

ALTER TABLE [Sales].[Fact_sales] CHECK CONSTRAINT [FK_Fact_sales_Dim_salesrep]
GO

ALTER TABLE [Sales].[Fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_sales_Dim_salesrepregion] FOREIGN KEY([SalesRepRegion_ID])
REFERENCES [Sales].[Dim_salesrepregion] ([SalesRepRegion_ID])
GO

ALTER TABLE [Sales].[Fact_sales] CHECK CONSTRAINT [FK_Fact_sales_Dim_salesrepregion]
GO