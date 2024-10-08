﻿CREATE DATABASE XFab_TT24
GO

USE [XFab_TT24]
GO

CREATE TABLE [XFab_TT24].[dbo].[Dim_company]
(
	[FK_CompanyID] INT NOT NULL PRIMARY KEY, 
    [Company_Code] NVARCHAR(MAX) NULL,
	[Company_name] NVARCHAR(MAX) NULL, 
	[DCOMPC] NVARCHAR(MAX) NULL, 
	[Wafer_Size] NVARCHAR(MAX) NULL
	);

CREATE TABLE [XFab_TT24].[dbo].[Dim_customer]
(
	[FK_CustomerID] INT NOT NULL PRIMARY KEY, 
	[FK_CompanyID] INT NOT NULL, 
	[Customer_Code] NVARCHAR(MAX) NULL,
	[Party_ID] NVARCHAR(MAX) NULL,
	[Service_Level] NVARCHAR(MAX) NULL,
	[Country] NVARCHAR(MAX) NULL, 
	[Region] NVARCHAR(MAX) NULL,
	[Customer_Name] NVARCHAR(MAX) NULL
	) ; 

CREATE TABLE [XFab_TT24].[dbo].[Dim_Date]
(
	[FK_DateID] INT NOT NULL PRIMARY KEY,
	[DATE] DATETIME NULL,
	[DAY] INT NULL, 
	[MONTH] INT NULL,
	[QUARTER] INT NULL,
	[YEAR] INT NULL,
	[MONTH_YEAR] NVARCHAR(MAX) NULL,
	[QUARTER_YEAR] NVARCHAR(MAX) NULL
) ; 

CREATE TABLE [XFab_TT24].[dbo].[Dim_Currency]
(
	[FK_CURRENCYID] INT NOT NULL PRIMARY KEY,
	[CURRENCY_CODE] NVARCHAR(MAX) NULL,
	[CURRENCY_DESCRIPTION] NVARCHAR(MAX) NULL,
	[FC_EXCHRATE] FLOAT NULL
) ;

CREATE TABLE [XFab_TT24].[dbo].[Stage_Trade_Agreement]
(
	[FK_CUSTOMERID] INT NOT NULL,
	[FK_CURRENCYID] INT NOT NULL,
	[FK_COMPANYID] INT NOT NULL,
	[ITEMID] NVARCHAR(MAX) NULL,
	[QUANTITY] INT NULL,
	[PRICE] FLOAT NULL,
	[CONTRACTUAL_PRICE] INT NULL,
	[VOLUME_QUANTITY] INT NULL,
	[VOLUME_PRICE] INT NULL, 
	[NOT_VOLUME_RELATED] INT NULL,
	[QUOTATIONID] NVARCHAR(MAX) NULL,
	[INACTIVE_FLAG] INT NULL,
	[EXCHANGE_RATE] FLOAT NULL,
	[FROM_DATE] DATETIME NULL,
	[TO_DATE] DATETIME NULL,
	[RECID] BIGINT NULL,
	[MODIFIED_DATE_TIME] DATETIME NULL,
) ;

CREATE TABLE [XFab_TT24].[dbo].[Trade_Agreement]
(	
	[FK_DATEID] INT NULL,
	[RECIDKEY] BIGINT NOT NULL PRIMARY KEY,
	[FK_CUSTOMERID] INT NULL,
	[FK_CURRENCYID] INT NULL,
	[FK_COMPANYID] INT NULL,
	[ITEMID] NVARCHAR(MAX) NULL,
	[QUANTITY] INT NULL,
	[PRICE] INT NULL,
	[CONTRACTUAL_PRICE] INT NULL,
	[VOLUME_QUANTITY] INT NULL,
	[VOLUME_PRICE] FLOAT NULL, 
	[NOT_VOLUME_RELATED] INT NULL,
	[QUOTATIONID] NVARCHAR(MAX) NULL,
	[INACTIVE_FLAG] INT NULL,
	[EXCHANGE_RATE] FLOAT NULL,
	[FROM_DATE] DATETIME NULL,
	[TO_DATE] DATETIME NULL,
	[RECID] BIGINT NULL,
	[MODIFIED_DATE_TIME] DATETIME NULL,
) ;

-- Add relationship between Trade_Agreement and dim_Customer tables
ALTER TABLE [dbo].[Trade_Agreement] WITH CHECK 
ADD CONSTRAINT [FK_CustomerID] FOREIGN KEY ([FK_CustomerID]) 
REFERENCES [dbo].[Dim_Customer] ([FK_CUSTOMERID])
GO 

-- Add relationship between Trade_Agreement and dim_Currency tables
ALTER TABLE [dbo].[Trade_Agreement] WITH CHECK 
ADD CONSTRAINT [FK_currencyID] FOREIGN KEY ([FK_CurrencyID]) 
REFERENCES [dbo].[Dim_Currency] ([FK_CurrencyID])
GO 

-- Add relationship between Trade_Agreement and dim_Company tables
ALTER TABLE [dbo].[Trade_Agreement] WITH CHECK 
ADD CONSTRAINT [FK_CompanyID] FOREIGN KEY ([FK_CompanyID]) 
REFERENCES [dbo].[Dim_Company] ([FK_CompanyID])
GO

-- Add relationship between Trade_Agreement and dim_date tables
ALTER TABLE [dbo].[Trade_Agreement] WITH NOCHECK
ADD CONSTRAINT [FK_DATEID] FOREIGN KEY ([FK_DATEID])
REFERENCES [dbo].[Dim_Date] ([FK_DateID])
GO

drop table [dbo].[Dim_Company];
drop table [dbo].[Dim_Date];
drop table [dbo].[Dim_Currency];
drop table [dbo].[Dim_Customer];
drop table [dbo].[Stage_Trade_Agreement];
drop table [dbo].[Trade_Agreement];
-- Remove relationship between trade_agreement and dim_company
ALTER TABLE [dbo].[trade_agreement] DROP CONSTRAINT [FK_CompanyID]
ALTER TABLE [dbo].[trade_agreement] DROP CONSTRAINT [FK_CustomerID]
ALTER TABLE [dbo].[trade_agreement] DROP CONSTRAINT [FK_CurrencyID]
ALTER TABLE [dbo].[trade_agreement] DROP CONSTRAINT [FK_DATEID]