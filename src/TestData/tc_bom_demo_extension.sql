/**************************************************************************************
Trade Control
Power BI Sample Data Creation Script
Compatibility: >= 3.24.1 

Date: 31 January 2020
Author: Ian Monnox

Trade Control by Trade Control Ltd is licensed under GNU General Public License v3.0. 

You may obtain a copy of the License at

	https://www.gnu.org/licenses/gpl-3.0.en.html

***********************************************************************************/


SET NOCOUNT, XACT_ABORT ON;

DECLARE 
	@MaxCustomers smallint = 6,
	@MaxOrders smallint,
	@ProdCounter smallint, 
	@CustCounter smallint,
	@AccountCode nvarchar(10),
	@AddressCode nvarchar(15),
	@AccountName nvarchar(255),
	@Quantity int, 
	@ActivityCode nvarchar(50), 
	@ActionOn datetime,
	@InvoiceTypeCode smallint, 
	@InvoiceNumber nvarchar(20),
	@InvoicedOn datetime,
	@Id smallint,
	@AreaCode nvarchar(50),
	@IndustrySector nvarchar(50),
	@UserId NVARCHAR(10),
	@TaskCode NVARCHAR(20),
	@ParentTaskCode NVARCHAR(20), 
	@ToTaskCode NVARCHAR(20),
	@CashAccountCode nvarchar(10);

DECLARE @tbAreas TABLE (AreaId smallint, AreaCode nvarchar(10));
DECLARE @tbSectors TABLE (SectorId smallint, IndustrySector nvarchar(50));

BEGIN TRY

	EXEC App.proc_DemoBom @CreateOrders = 1, @InvoiceOrders = 1, @PayInvoices = 0;

	INSERT INTO Activity.tbActivity (ActivityCode, TaskStatusCode, DefaultText, UnitOfMeasure, CashCode, UnitCharge, Printed, RegisterName)
	VALUES ('M/00/70/01', 1, 'PIGEON HOLE SHELF ASSEMBLY WHITE', 'each', '103', 18.3240, 1, 'Sales Order')
	, ('M/100/70/01', 1, 'PIGEON HOLE SUB SHELF WHITE', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/101/70/01', 1, 'PIGEON HOLE BACK DIVIDER', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/97/70/01', 1, 'SHELF DIVIDER (WIDE FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/99/70/01', 1, 'SHELF DIVIDER (NARROW FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('PC/997', 1, 'CALIBRE 303EP WHITE UL94-V2', 'kilo', '200', 2.6500, 1, 'Purchase Order')
	;
	INSERT INTO Activity.tbAttribute (ActivityCode, Attribute, PrintOrder, AttributeTypeCode, DefaultText)
	VALUES ('M/00/70/01', 'Colour', 20, 0, 'WHITE')
	, ('M/00/70/01', 'Colour Number', 10, 0, '-')
	, ('M/00/70/01', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/00/70/01', 'Drawing Issue', 40, 0, '1')
	, ('M/00/70/01', 'Drawing Number', 30, 0, '321554')
	, ('M/00/70/01', 'Label Type', 70, 0, 'Assembly Card')
	, ('M/00/70/01', 'Mould Tool Specification', 110, 1, NULL)
	, ('M/00/70/01', 'Pack Type', 60, 0, 'Despatched')
	, ('M/00/70/01', 'Quantity/Box', 80, 0, '101')
	, ('M/100/70/01', 'Cavities', 170, 0, '1')
	, ('M/100/70/01', 'Colour', 20, 0, 'WHITE')
	, ('M/100/70/01', 'Colour Number', 10, 0, '-')
	, ('M/100/70/01', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/100/70/01', 'Drawing Issue', 40, 0, '1')
	, ('M/100/70/01', 'Drawing Number', 30, 0, '321554-01')
	, ('M/100/70/01', 'Impressions', 180, 0, '1')
	, ('M/100/70/01', 'Label Type', 70, 0, 'Route Card')
	, ('M/100/70/01', 'Location', 150, 0, 'STORES')
	, ('M/100/70/01', 'Pack Type', 60, 0, 'Assembled')
	, ('M/100/70/01', 'Part Weight', 160, 0, '175g')
	, ('M/100/70/01', 'Quantity/Box', 80, 0, '101')
	, ('M/100/70/01', 'Tool Number', 190, 0, '1437')
	, ('M/101/70/01', 'Cavities', 170, 0, '2')
	, ('M/101/70/01', 'Colour', 20, 0, 'WHITE')
	, ('M/101/70/01', 'Colour Number', 10, 0, '-')
	, ('M/101/70/01', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/101/70/01', 'Drawing Issue', 40, 0, '1')
	, ('M/101/70/01', 'Drawing Number', 30, 0, '321554-02')
	, ('M/101/70/01', 'Impressions', 180, 0, '2')
	, ('M/101/70/01', 'Label Type', 70, 0, 'Route Card')
	, ('M/101/70/01', 'Location', 150, 0, 'STORES')
	, ('M/101/70/01', 'Pack Type', 60, 0, 'Assembled')
	, ('M/101/70/01', 'Part Weight', 160, 0, '61g')
	, ('M/101/70/01', 'Quantity/Box', 80, 0, '101')
	, ('M/101/70/01', 'Tool Number', 190, 0, '1439')
	, ('M/97/70/01', 'Cavities', 170, 0, '4')
	, ('M/97/70/01', 'Colour', 20, 0, 'WHITE')
	, ('M/97/70/01', 'Colour Number', 10, 0, '-')
	, ('M/97/70/01', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/97/70/01', 'Drawing Issue', 40, 0, '1')
	, ('M/97/70/01', 'Drawing Number', 30, 0, '321554A')
	, ('M/97/70/01', 'Impressions', 180, 0, '4')
	, ('M/97/70/01', 'Label Type', 70, 0, 'Route Card')
	, ('M/97/70/01', 'Location', 150, 0, 'STORES')
	, ('M/97/70/01', 'Pack Type', 60, 0, 'Assembled')
	, ('M/97/70/01', 'Part Weight', 160, 0, '171g')
	, ('M/97/70/01', 'Quantity/Box', 80, 0, '101')
	, ('M/97/70/01', 'Tool Number', 190, 0, '1440')
	, ('M/99/70/01', 'Cavities', 170, 0, '1')
	, ('M/99/70/01', 'Colour', 20, 0, 'WHITE')
	, ('M/99/70/01', 'Colour Number', 10, 0, '-')
	, ('M/99/70/01', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/99/70/01', 'Drawing Issue', 40, 0, '1')
	, ('M/99/70/01', 'Drawing Number', 30, 0, '321554A')
	, ('M/99/70/01', 'Impressions', 180, 0, '1')
	, ('M/99/70/01', 'Label Type', 70, 0, 'Route Card')
	, ('M/99/70/01', 'Location', 150, 0, 'STORES')
	, ('M/99/70/01', 'Pack Type', 60, 0, 'Assembled')
	, ('M/99/70/01', 'Part Weight', 160, 0, '171g')
	, ('M/99/70/01', 'Quantity/Box', 80, 0, '101')
	, ('M/99/70/01', 'Tool Number', 190, 0, '1441')
	, ('PC/997', 'Colour', 50, 0, 'WHITE')
	, ('PC/997', 'Grade', 20, 0, '303EP')
	, ('PC/997', 'Location', 60, 0, 'R2123-9')
	, ('PC/997', 'Material Type', 10, 0, 'PC')
	, ('PC/997', 'Name', 30, 0, 'Calibre')
	, ('PC/997', 'SG', 40, 0, '1.21')
	;
	INSERT INTO Activity.tbOp (ActivityCode, OperationNumber, SyncTypeCode, Operation, Duration, OffsetDays)
	VALUES ('M/00/70/01', 10, 0, 'ASSEMBLE', 0.5, 3)
	, ('M/00/70/01', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/00/70/01', 30, 0, 'PACK', 0, 1)
	, ('M/00/70/01', 40, 2, 'DELIVER', 0, 1)
	, ('M/100/70/01', 10, 0, 'MOULD', 10, 2)
	, ('M/100/70/01', 20, 1, 'INSERTS', 0, 0)
	, ('M/100/70/01', 30, 0, 'QUALITY CHECK', 0, 0)
	, ('M/101/70/01', 10, 0, 'MOULD', 10, 0)
	, ('M/101/70/01', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/97/70/01', 10, 0, 'MOULD', 10, 2)
	, ('M/97/70/01', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/99/70/01', 10, 0, 'MOULD', 0, 2)
	, ('M/99/70/01', 20, 0, 'QUALITY CHECK', 0, 0)
	;
	INSERT INTO Activity.tbFlow (ParentCode, StepNumber, ChildCode, SyncTypeCode, OffsetDays, UsedOnQuantity)
	VALUES ('M/00/70/01', 10, 'M/100/70/01', 1, 0, 8)
	, ('M/00/70/01', 20, 'M/101/70/01', 1, 0, 4)
	, ('M/00/70/01', 30, 'M/97/70/01', 1, 0, 3)
	, ('M/00/70/01', 40, 'M/99/70/01', 0, 0, 2)
	, ('M/00/70/01', 50, 'BOX/41', 1, 0, 1)
	, ('M/00/70/01', 60, 'PALLET/01', 1, 0, 0.01)
	, ('M/00/70/01', 70, 'DELIVERY', 2, 1, 0)
	, ('M/100/70/01', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/100/70/01', 20, 'PC/997', 1, 0, 0.175)
	, ('M/101/70/01', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/101/70/01', 20, 'PC/997', 1, 0, 0.061)
	, ('M/97/70/01', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/97/70/01', 20, 'PC/997', 1, 0, 0.172)
	, ('M/99/70/01', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/99/70/01', 20, 'PC/997', 1, 0, 0.171)
	, ('M/100/70/01', 30, 'INSERT/09', 1, 0, 2)
	;

	/**********************************************************************************************************/

	INSERT INTO Activity.tbActivity (ActivityCode, TaskStatusCode, DefaultText, UnitOfMeasure, CashCode, UnitCharge, Printed, RegisterName)
	VALUES ('M/00/70/02', 1, 'PIGEON HOLE SHELF ASSEMBLY BLUE', 'each', '103', 17.500, 1, 'Sales Order')
	, ('M/100/70/02', 1, 'PIGEON HOLE SUB SHELF BLUE', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/101/70/02', 1, 'PIGEON HOLE BACK DIVIDER', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/97/70/02', 1, 'SHELF DIVIDER (WIDE FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/99/70/02', 1, 'SHELF DIVIDER (NARROW FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('PC/998', 1, 'CALIBRE 303EP BLUE UL94-V2', 'kilo', '200', 2.5500, 1, 'Purchase Order')
	;
	INSERT INTO Activity.tbAttribute (ActivityCode, Attribute, PrintOrder, AttributeTypeCode, DefaultText)
	VALUES ('M/00/70/02', 'Colour', 20, 0, 'BLUE')
	, ('M/00/70/02', 'Colour Number', 10, 0, '-')
	, ('M/00/70/02', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/00/70/02', 'Drawing Issue', 40, 0, '1')
	, ('M/00/70/02', 'Drawing Number', 30, 0, '321554')
	, ('M/00/70/02', 'Label Type', 70, 0, 'Assembly Card')
	, ('M/00/70/02', 'Mould Tool Specification', 110, 1, NULL)
	, ('M/00/70/02', 'Pack Type', 60, 0, 'Despatched')
	, ('M/00/70/02', 'Quantity/Box', 80, 0, '102')
	, ('M/100/70/02', 'Cavities', 170, 0, '1')
	, ('M/100/70/02', 'Colour', 20, 0, 'BLUE')
	, ('M/100/70/02', 'Colour Number', 10, 0, '-')
	, ('M/100/70/02', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/100/70/02', 'Drawing Issue', 40, 0, '1')
	, ('M/100/70/02', 'Drawing Number', 30, 0, '321554-01')
	, ('M/100/70/02', 'Impressions', 180, 0, '1')
	, ('M/100/70/02', 'Label Type', 70, 0, 'Route Card')
	, ('M/100/70/02', 'Location', 150, 0, 'STORES')
	, ('M/100/70/02', 'Pack Type', 60, 0, 'Assembled')
	, ('M/100/70/02', 'Part Weight', 160, 0, '175g')
	, ('M/100/70/02', 'Quantity/Box', 80, 0, '102')
	, ('M/100/70/02', 'Tool Number', 190, 0, '1437')
	, ('M/101/70/02', 'Cavities', 170, 0, '2')
	, ('M/101/70/02', 'Colour', 20, 0, 'BLUE')
	, ('M/101/70/02', 'Colour Number', 10, 0, '-')
	, ('M/101/70/02', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/101/70/02', 'Drawing Issue', 40, 0, '1')
	, ('M/101/70/02', 'Drawing Number', 30, 0, '321554-02')
	, ('M/101/70/02', 'Impressions', 180, 0, '2')
	, ('M/101/70/02', 'Label Type', 70, 0, 'Route Card')
	, ('M/101/70/02', 'Location', 150, 0, 'STORES')
	, ('M/101/70/02', 'Pack Type', 60, 0, 'Assembled')
	, ('M/101/70/02', 'Part Weight', 160, 0, '61g')
	, ('M/101/70/02', 'Quantity/Box', 80, 0, '102')
	, ('M/101/70/02', 'Tool Number', 190, 0, '1439')
	, ('M/97/70/02', 'Cavities', 170, 0, '4')
	, ('M/97/70/02', 'Colour', 20, 0, 'BLUE')
	, ('M/97/70/02', 'Colour Number', 10, 0, '-')
	, ('M/97/70/02', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/97/70/02', 'Drawing Issue', 40, 0, '1')
	, ('M/97/70/02', 'Drawing Number', 30, 0, '321554A')
	, ('M/97/70/02', 'Impressions', 180, 0, '4')
	, ('M/97/70/02', 'Label Type', 70, 0, 'Route Card')
	, ('M/97/70/02', 'Location', 150, 0, 'STORES')
	, ('M/97/70/02', 'Pack Type', 60, 0, 'Assembled')
	, ('M/97/70/02', 'Part Weight', 160, 0, '171g')
	, ('M/97/70/02', 'Quantity/Box', 80, 0, '102')
	, ('M/97/70/02', 'Tool Number', 190, 0, '1440')
	, ('M/99/70/02', 'Cavities', 170, 0, '1')
	, ('M/99/70/02', 'Colour', 20, 0, 'BLUE')
	, ('M/99/70/02', 'Colour Number', 10, 0, '-')
	, ('M/99/70/02', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/99/70/02', 'Drawing Issue', 40, 0, '1')
	, ('M/99/70/02', 'Drawing Number', 30, 0, '321554A')
	, ('M/99/70/02', 'Impressions', 180, 0, '1')
	, ('M/99/70/02', 'Label Type', 70, 0, 'Route Card')
	, ('M/99/70/02', 'Location', 150, 0, 'STORES')
	, ('M/99/70/02', 'Pack Type', 60, 0, 'Assembled')
	, ('M/99/70/02', 'Part Weight', 160, 0, '171g')
	, ('M/99/70/02', 'Quantity/Box', 80, 0, '102')
	, ('M/99/70/02', 'Tool Number', 190, 0, '1441')
	, ('PC/998', 'Colour', 50, 0, 'BLUE')
	, ('PC/998', 'Grade', 20, 0, '303EP')
	, ('PC/998', 'Location', 60, 0, 'R2123-9')
	, ('PC/998', 'Material Type', 10, 0, 'PC')
	, ('PC/998', 'Name', 30, 0, 'Calibre')
	, ('PC/998', 'SG', 40, 0, '1.21')
	;
	INSERT INTO Activity.tbOp (ActivityCode, OperationNumber, SyncTypeCode, Operation, Duration, OffsetDays)
	VALUES ('M/00/70/02', 10, 0, 'ASSEMBLE', 0.5, 3)
	, ('M/00/70/02', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/00/70/02', 30, 0, 'PACK', 0, 1)
	, ('M/00/70/02', 40, 2, 'DELIVER', 0, 1)
	, ('M/100/70/02', 10, 0, 'MOULD', 10, 2)
	, ('M/100/70/02', 20, 1, 'INSERTS', 0, 0)
	, ('M/100/70/02', 30, 0, 'QUALITY CHECK', 0, 0)
	, ('M/101/70/02', 10, 0, 'MOULD', 10, 0)
	, ('M/101/70/02', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/97/70/02', 10, 0, 'MOULD', 10, 2)
	, ('M/97/70/02', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/99/70/02', 10, 0, 'MOULD', 0, 2)
	, ('M/99/70/02', 20, 0, 'QUALITY CHECK', 0, 0)
	;
	INSERT INTO Activity.tbFlow (ParentCode, StepNumber, ChildCode, SyncTypeCode, OffsetDays, UsedOnQuantity)
	VALUES ('M/00/70/02', 10, 'M/100/70/02', 1, 0, 8)
	, ('M/00/70/02', 20, 'M/101/70/02', 1, 0, 4)
	, ('M/00/70/02', 30, 'M/97/70/02', 1, 0, 3)
	, ('M/00/70/02', 40, 'M/99/70/02', 0, 0, 2)
	, ('M/00/70/02', 50, 'BOX/41', 1, 0, 1)
	, ('M/00/70/02', 60, 'PALLET/01', 1, 0, 0.01)
	, ('M/00/70/02', 70, 'DELIVERY', 2, 1, 0)
	, ('M/100/70/02', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/100/70/02', 20, 'PC/998', 1, 0, 0.175)
	, ('M/101/70/02', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/101/70/02', 20, 'PC/998', 1, 0, 0.061)
	, ('M/97/70/02', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/97/70/02', 20, 'PC/998', 1, 0, 0.172)
	, ('M/99/70/02', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/99/70/02', 20, 'PC/998', 1, 0, 0.171)
	, ('M/100/70/02', 30, 'INSERT/09', 1, 0, 2)
	;

	/***********************************************************************************/

	INSERT INTO Activity.tbActivity (ActivityCode, TaskStatusCode, DefaultText, UnitOfMeasure, CashCode, UnitCharge, Printed, RegisterName)
	VALUES ('M/00/70/03', 1, 'PIGEON HOLE SHELF ASSEMBLY GREEN', 'each', '103', 14.2240, 1, 'Sales Order')
	, ('M/100/70/03', 1, 'PIGEON HOLE SUB SHELF GREEN', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/101/70/03', 1, 'PIGEON HOLE BACK DIVIDER', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/97/70/03', 1, 'SHELF DIVIDER (WIDE FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/99/70/03', 1, 'SHELF DIVIDER (NARROW FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('PC/996', 1, 'CALIBRE 303EP GREEN UL94-V2', 'kilo', '200', 2.000, 1, 'Purchase Order')
	;
	INSERT INTO Activity.tbAttribute (ActivityCode, Attribute, PrintOrder, AttributeTypeCode, DefaultText)
	VALUES ('M/00/70/03', 'Colour', 20, 0, 'GREEN')
	, ('M/00/70/03', 'Colour Number', 10, 0, '-')
	, ('M/00/70/03', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/00/70/03', 'Drawing Issue', 40, 0, '1')
	, ('M/00/70/03', 'Drawing Number', 30, 0, '321554')
	, ('M/00/70/03', 'Label Type', 70, 0, 'Assembly Card')
	, ('M/00/70/03', 'Mould Tool Specification', 110, 1, NULL)
	, ('M/00/70/03', 'Pack Type', 60, 0, 'Despatched')
	, ('M/00/70/03', 'Quantity/Box', 80, 0, '103')
	, ('M/100/70/03', 'Cavities', 170, 0, '1')
	, ('M/100/70/03', 'Colour', 20, 0, 'GREEN')
	, ('M/100/70/03', 'Colour Number', 10, 0, '-')
	, ('M/100/70/03', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/100/70/03', 'Drawing Issue', 40, 0, '1')
	, ('M/100/70/03', 'Drawing Number', 30, 0, '321554-03')
	, ('M/100/70/03', 'Impressions', 180, 0, '1')
	, ('M/100/70/03', 'Label Type', 70, 0, 'Route Card')
	, ('M/100/70/03', 'Location', 150, 0, 'STORES')
	, ('M/100/70/03', 'Pack Type', 60, 0, 'Assembled')
	, ('M/100/70/03', 'Part Weight', 160, 0, '175g')
	, ('M/100/70/03', 'Quantity/Box', 80, 0, '103')
	, ('M/100/70/03', 'Tool Number', 190, 0, '1437')
	, ('M/101/70/03', 'Cavities', 170, 0, '2')
	, ('M/101/70/03', 'Colour', 20, 0, 'GREEN')
	, ('M/101/70/03', 'Colour Number', 10, 0, '-')
	, ('M/101/70/03', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/101/70/03', 'Drawing Issue', 40, 0, '1')
	, ('M/101/70/03', 'Drawing Number', 30, 0, '321554-02')
	, ('M/101/70/03', 'Impressions', 180, 0, '2')
	, ('M/101/70/03', 'Label Type', 70, 0, 'Route Card')
	, ('M/101/70/03', 'Location', 150, 0, 'STORES')
	, ('M/101/70/03', 'Pack Type', 60, 0, 'Assembled')
	, ('M/101/70/03', 'Part Weight', 160, 0, '61g')
	, ('M/101/70/03', 'Quantity/Box', 80, 0, '103')
	, ('M/101/70/03', 'Tool Number', 190, 0, '1439')
	, ('M/97/70/03', 'Cavities', 170, 0, '4')
	, ('M/97/70/03', 'Colour', 20, 0, 'GREEN')
	, ('M/97/70/03', 'Colour Number', 10, 0, '-')
	, ('M/97/70/03', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/97/70/03', 'Drawing Issue', 40, 0, '1')
	, ('M/97/70/03', 'Drawing Number', 30, 0, '321554A')
	, ('M/97/70/03', 'Impressions', 180, 0, '4')
	, ('M/97/70/03', 'Label Type', 70, 0, 'Route Card')
	, ('M/97/70/03', 'Location', 150, 0, 'STORES')
	, ('M/97/70/03', 'Pack Type', 60, 0, 'Assembled')
	, ('M/97/70/03', 'Part Weight', 160, 0, '171g')
	, ('M/97/70/03', 'Quantity/Box', 80, 0, '103')
	, ('M/97/70/03', 'Tool Number', 190, 0, '1440')
	, ('M/99/70/03', 'Cavities', 170, 0, '1')
	, ('M/99/70/03', 'Colour', 20, 0, 'GREEN')
	, ('M/99/70/03', 'Colour Number', 10, 0, '-')
	, ('M/99/70/03', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/99/70/03', 'Drawing Issue', 40, 0, '1')
	, ('M/99/70/03', 'Drawing Number', 30, 0, '321554A')
	, ('M/99/70/03', 'Impressions', 180, 0, '1')
	, ('M/99/70/03', 'Label Type', 70, 0, 'Route Card')
	, ('M/99/70/03', 'Location', 150, 0, 'STORES')
	, ('M/99/70/03', 'Pack Type', 60, 0, 'Assembled')
	, ('M/99/70/03', 'Part Weight', 160, 0, '171g')
	, ('M/99/70/03', 'Quantity/Box', 80, 0, '103')
	, ('M/99/70/03', 'Tool Number', 190, 0, '1441')
	, ('PC/996', 'Colour', 50, 0, 'GREEN')
	, ('PC/996', 'Grade', 20, 0, '303EP')
	, ('PC/996', 'Location', 60, 0, 'R2123-9')
	, ('PC/996', 'Material Type', 10, 0, 'PC')
	, ('PC/996', 'Name', 30, 0, 'Calibre')
	, ('PC/996', 'SG', 40, 0, '1.21')
	;
	INSERT INTO Activity.tbOp (ActivityCode, OperationNumber, SyncTypeCode, Operation, Duration, OffsetDays)
	VALUES ('M/00/70/03', 10, 0, 'ASSEMBLE', 0.5, 3)
	, ('M/00/70/03', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/00/70/03', 30, 0, 'PACK', 0, 1)
	, ('M/00/70/03', 40, 2, 'DELIVER', 0, 1)
	, ('M/100/70/03', 10, 0, 'MOULD', 10, 2)
	, ('M/100/70/03', 20, 1, 'INSERTS', 0, 0)
	, ('M/100/70/03', 30, 0, 'QUALITY CHECK', 0, 0)
	, ('M/101/70/03', 10, 0, 'MOULD', 10, 0)
	, ('M/101/70/03', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/97/70/03', 10, 0, 'MOULD', 10, 2)
	, ('M/97/70/03', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/99/70/03', 10, 0, 'MOULD', 0, 2)
	, ('M/99/70/03', 20, 0, 'QUALITY CHECK', 0, 0)
	;
	INSERT INTO Activity.tbFlow (ParentCode, StepNumber, ChildCode, SyncTypeCode, OffsetDays, UsedOnQuantity)
	VALUES ('M/00/70/03', 10, 'M/100/70/03', 1, 0, 8)
	, ('M/00/70/03', 20, 'M/101/70/03', 1, 0, 4)
	, ('M/00/70/03', 30, 'M/97/70/03', 1, 0, 3)
	, ('M/00/70/03', 40, 'M/99/70/03', 0, 0, 2)
	, ('M/00/70/03', 50, 'BOX/41', 1, 0, 1)
	, ('M/00/70/03', 60, 'PALLET/01', 1, 0, 0.01)
	, ('M/00/70/03', 70, 'DELIVERY', 2, 1, 0)
	, ('M/100/70/03', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/100/70/03', 20, 'PC/996', 1, 0, 0.175)
	, ('M/101/70/03', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/101/70/03', 20, 'PC/996', 1, 0, 0.061)
	, ('M/97/70/03', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/97/70/03', 20, 'PC/996', 1, 0, 0.172)
	, ('M/99/70/03', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/99/70/03', 20, 'PC/996', 1, 0, 0.171)
	, ('M/100/70/03', 30, 'INSERT/09', 1, 0, 2)
	;

	/**********************************************************************************************************/

	INSERT INTO Activity.tbActivity (ActivityCode, TaskStatusCode, DefaultText, UnitOfMeasure, CashCode, UnitCharge, Printed, RegisterName)
	VALUES ('M/00/70/04', 1, 'PIGEON HOLE SHELF ASSEMBLY GREY', 'each', '103', 12.10, 1, 'Sales Order')
	, ('M/100/70/04', 1, 'PIGEON HOLE SUB SHELF GREY', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/101/70/04', 1, 'PIGEON HOLE BACK DIVIDER', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/97/70/04', 1, 'SHELF DIVIDER (WIDE FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/99/70/04', 1, 'SHELF DIVIDER (NARROW FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('PC/001', 1, 'CALIBRE 303EP GREY UL94-V2', 'kilo', '200', 3.1500, 1, 'Purchase Order')
	;
	INSERT INTO Activity.tbAttribute (ActivityCode, Attribute, PrintOrder, AttributeTypeCode, DefaultText)
	VALUES ('M/00/70/04', 'Colour', 20, 0, 'GREY')
	, ('M/00/70/04', 'Colour Number', 10, 0, '-')
	, ('M/00/70/04', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/00/70/04', 'Drawing Issue', 40, 0, '1')
	, ('M/00/70/04', 'Drawing Number', 30, 0, '321554')
	, ('M/00/70/04', 'Label Type', 70, 0, 'Assembly Card')
	, ('M/00/70/04', 'Mould Tool Specification', 110, 1, NULL)
	, ('M/00/70/04', 'Pack Type', 60, 0, 'Despatched')
	, ('M/00/70/04', 'Quantity/Box', 80, 0, '104')
	, ('M/100/70/04', 'Cavities', 170, 0, '1')
	, ('M/100/70/04', 'Colour', 20, 0, 'GREY')
	, ('M/100/70/04', 'Colour Number', 10, 0, '-')
	, ('M/100/70/04', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/100/70/04', 'Drawing Issue', 40, 0, '1')
	, ('M/100/70/04', 'Drawing Number', 30, 0, '321554-04')
	, ('M/100/70/04', 'Impressions', 180, 0, '1')
	, ('M/100/70/04', 'Label Type', 70, 0, 'Route Card')
	, ('M/100/70/04', 'Location', 150, 0, 'STORES')
	, ('M/100/70/04', 'Pack Type', 60, 0, 'Assembled')
	, ('M/100/70/04', 'Part Weight', 160, 0, '175g')
	, ('M/100/70/04', 'Quantity/Box', 80, 0, '104')
	, ('M/100/70/04', 'Tool Number', 190, 0, '1437')
	, ('M/101/70/04', 'Cavities', 170, 0, '2')
	, ('M/101/70/04', 'Colour', 20, 0, 'GREY')
	, ('M/101/70/04', 'Colour Number', 10, 0, '-')
	, ('M/101/70/04', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/101/70/04', 'Drawing Issue', 40, 0, '1')
	, ('M/101/70/04', 'Drawing Number', 30, 0, '321554-05')
	, ('M/101/70/04', 'Impressions', 180, 0, '2')
	, ('M/101/70/04', 'Label Type', 70, 0, 'Route Card')
	, ('M/101/70/04', 'Location', 150, 0, 'STORES')
	, ('M/101/70/04', 'Pack Type', 60, 0, 'Assembled')
	, ('M/101/70/04', 'Part Weight', 160, 0, '61g')
	, ('M/101/70/04', 'Quantity/Box', 80, 0, '104')
	, ('M/101/70/04', 'Tool Number', 190, 0, '1439')
	, ('M/97/70/04', 'Cavities', 170, 0, '4')
	, ('M/97/70/04', 'Colour', 20, 0, 'GREY')
	, ('M/97/70/04', 'Colour Number', 10, 0, '-')
	, ('M/97/70/04', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/97/70/04', 'Drawing Issue', 40, 0, '1')
	, ('M/97/70/04', 'Drawing Number', 30, 0, '321554A')
	, ('M/97/70/04', 'Impressions', 180, 0, '4')
	, ('M/97/70/04', 'Label Type', 70, 0, 'Route Card')
	, ('M/97/70/04', 'Location', 150, 0, 'STORES')
	, ('M/97/70/04', 'Pack Type', 60, 0, 'Assembled')
	, ('M/97/70/04', 'Part Weight', 160, 0, '171g')
	, ('M/97/70/04', 'Quantity/Box', 80, 0, '104')
	, ('M/97/70/04', 'Tool Number', 190, 0, '1440')
	, ('M/99/70/04', 'Cavities', 170, 0, '1')
	, ('M/99/70/04', 'Colour', 20, 0, 'GREY')
	, ('M/99/70/04', 'Colour Number', 10, 0, '-')
	, ('M/99/70/04', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/99/70/04', 'Drawing Issue', 40, 0, '1')
	, ('M/99/70/04', 'Drawing Number', 30, 0, '321554A')
	, ('M/99/70/04', 'Impressions', 180, 0, '1')
	, ('M/99/70/04', 'Label Type', 70, 0, 'Route Card')
	, ('M/99/70/04', 'Location', 150, 0, 'STORES')
	, ('M/99/70/04', 'Pack Type', 60, 0, 'Assembled')
	, ('M/99/70/04', 'Part Weight', 160, 0, '171g')
	, ('M/99/70/04', 'Quantity/Box', 80, 0, '104')
	, ('M/99/70/04', 'Tool Number', 190, 0, '1441')
	, ('PC/001', 'Colour', 50, 0, 'GREY')
	, ('PC/001', 'Grade', 20, 0, '303EP')
	, ('PC/001', 'Location', 60, 0, 'R2123-9')
	, ('PC/001', 'Material Type', 10, 0, 'PC')
	, ('PC/001', 'Name', 30, 0, 'Calibre')
	, ('PC/001', 'SG', 40, 0, '1.21')
	;
	INSERT INTO Activity.tbOp (ActivityCode, OperationNumber, SyncTypeCode, Operation, Duration, OffsetDays)
	VALUES ('M/00/70/04', 10, 0, 'ASSEMBLE', 0.5, 3)
	, ('M/00/70/04', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/00/70/04', 30, 0, 'PACK', 0, 1)
	, ('M/00/70/04', 40, 2, 'DELIVER', 0, 1)
	, ('M/100/70/04', 10, 0, 'MOULD', 10, 2)
	, ('M/100/70/04', 20, 1, 'INSERTS', 0, 0)
	, ('M/100/70/04', 30, 0, 'QUALITY CHECK', 0, 0)
	, ('M/101/70/04', 10, 0, 'MOULD', 10, 0)
	, ('M/101/70/04', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/97/70/04', 10, 0, 'MOULD', 10, 2)
	, ('M/97/70/04', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/99/70/04', 10, 0, 'MOULD', 0, 2)
	, ('M/99/70/04', 20, 0, 'QUALITY CHECK', 0, 0)
	;
	INSERT INTO Activity.tbFlow (ParentCode, StepNumber, ChildCode, SyncTypeCode, OffsetDays, UsedOnQuantity)
	VALUES ('M/00/70/04', 10, 'M/100/70/04', 1, 0, 8)
	, ('M/00/70/04', 20, 'M/101/70/04', 1, 0, 4)
	, ('M/00/70/04', 30, 'M/97/70/04', 1, 0, 3)
	, ('M/00/70/04', 40, 'M/99/70/04', 0, 0, 2)
	, ('M/00/70/04', 50, 'BOX/41', 1, 0, 1)
	, ('M/00/70/04', 60, 'PALLET/01', 1, 0, 0.01)
	, ('M/00/70/04', 70, 'DELIVERY', 2, 1, 0)
	, ('M/100/70/04', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/100/70/04', 20, 'PC/001', 1, 0, 0.175)
	, ('M/101/70/04', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/101/70/04', 20, 'PC/001', 1, 0, 0.061)
	, ('M/97/70/04', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/97/70/04', 20, 'PC/001', 1, 0, 0.172)
	, ('M/99/70/04', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/99/70/04', 20, 'PC/001', 1, 0, 0.171)
	, ('M/100/70/04', 30, 'INSERT/09', 1, 0, 2)
	;

	/**********************************************************************************************************/

	INSERT INTO Activity.tbActivity (ActivityCode, TaskStatusCode, DefaultText, UnitOfMeasure, CashCode, UnitCharge, Printed, RegisterName)
	VALUES ('M/00/70/05', 1, 'PIGEON HOLE SHELF ASSEMBLY RED', 'each', '103', 18.0200, 1, 'Sales Order')
	, ('M/100/70/05', 1, 'PIGEON HOLE SUB SHELF RED', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/101/70/05', 1, 'PIGEON HOLE BACK DIVIDER', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/97/70/05', 1, 'SHELF DIVIDER (WIDE FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/99/70/05', 1, 'SHELF DIVIDER (NARROW FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('PC/005', 1, 'CALIBRE 303EP RED UL94-V2', 'kilo', '200', 3.0000, 1, 'Purchase Order')
	;
	INSERT INTO Activity.tbAttribute (ActivityCode, Attribute, PrintOrder, AttributeTypeCode, DefaultText)
	VALUES ('M/00/70/05', 'Colour', 20, 0, 'RED')
	, ('M/00/70/05', 'Colour Number', 10, 0, '-')
	, ('M/00/70/05', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/00/70/05', 'Drawing Issue', 40, 0, '1')
	, ('M/00/70/05', 'Drawing Number', 30, 0, '321554')
	, ('M/00/70/05', 'Label Type', 70, 0, 'Assembly Card')
	, ('M/00/70/05', 'Mould Tool Specification', 110, 1, NULL)
	, ('M/00/70/05', 'Pack Type', 60, 0, 'Despatched')
	, ('M/00/70/05', 'Quantity/Box', 80, 0, '105')
	, ('M/100/70/05', 'Cavities', 170, 0, '1')
	, ('M/100/70/05', 'Colour', 20, 0, 'RED')
	, ('M/100/70/05', 'Colour Number', 10, 0, '-')
	, ('M/100/70/05', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/100/70/05', 'Drawing Issue', 40, 0, '1')
	, ('M/100/70/05', 'Drawing Number', 30, 0, '321554-04')
	, ('M/100/70/05', 'Impressions', 180, 0, '1')
	, ('M/100/70/05', 'Label Type', 70, 0, 'Route Card')
	, ('M/100/70/05', 'Location', 150, 0, 'STORES')
	, ('M/100/70/05', 'Pack Type', 60, 0, 'Assembled')
	, ('M/100/70/05', 'Part Weight', 160, 0, '175g')
	, ('M/100/70/05', 'Quantity/Box', 80, 0, '105')
	, ('M/100/70/05', 'Tool Number', 190, 0, '1437')
	, ('M/101/70/05', 'Cavities', 170, 0, '2')
	, ('M/101/70/05', 'Colour', 20, 0, 'RED')
	, ('M/101/70/05', 'Colour Number', 10, 0, '-')
	, ('M/101/70/05', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/101/70/05', 'Drawing Issue', 40, 0, '1')
	, ('M/101/70/05', 'Drawing Number', 30, 0, '321554-05')
	, ('M/101/70/05', 'Impressions', 180, 0, '2')
	, ('M/101/70/05', 'Label Type', 70, 0, 'Route Card')
	, ('M/101/70/05', 'Location', 150, 0, 'STORES')
	, ('M/101/70/05', 'Pack Type', 60, 0, 'Assembled')
	, ('M/101/70/05', 'Part Weight', 160, 0, '61g')
	, ('M/101/70/05', 'Quantity/Box', 80, 0, '105')
	, ('M/101/70/05', 'Tool Number', 190, 0, '1439')
	, ('M/97/70/05', 'Cavities', 170, 0, '4')
	, ('M/97/70/05', 'Colour', 20, 0, 'RED')
	, ('M/97/70/05', 'Colour Number', 10, 0, '-')
	, ('M/97/70/05', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/97/70/05', 'Drawing Issue', 40, 0, '1')
	, ('M/97/70/05', 'Drawing Number', 30, 0, '321554A')
	, ('M/97/70/05', 'Impressions', 180, 0, '4')
	, ('M/97/70/05', 'Label Type', 70, 0, 'Route Card')
	, ('M/97/70/05', 'Location', 150, 0, 'STORES')
	, ('M/97/70/05', 'Pack Type', 60, 0, 'Assembled')
	, ('M/97/70/05', 'Part Weight', 160, 0, '171g')
	, ('M/97/70/05', 'Quantity/Box', 80, 0, '105')
	, ('M/97/70/05', 'Tool Number', 190, 0, '1440')
	, ('M/99/70/05', 'Cavities', 170, 0, '1')
	, ('M/99/70/05', 'Colour', 20, 0, 'RED')
	, ('M/99/70/05', 'Colour Number', 10, 0, '-')
	, ('M/99/70/05', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/99/70/05', 'Drawing Issue', 40, 0, '1')
	, ('M/99/70/05', 'Drawing Number', 30, 0, '321554A')
	, ('M/99/70/05', 'Impressions', 180, 0, '1')
	, ('M/99/70/05', 'Label Type', 70, 0, 'Route Card')
	, ('M/99/70/05', 'Location', 150, 0, 'STORES')
	, ('M/99/70/05', 'Pack Type', 60, 0, 'Assembled')
	, ('M/99/70/05', 'Part Weight', 160, 0, '171g')
	, ('M/99/70/05', 'Quantity/Box', 80, 0, '105')
	, ('M/99/70/05', 'Tool Number', 190, 0, '1441')
	, ('PC/005', 'Colour', 50, 0, 'RED')
	, ('PC/005', 'Grade', 20, 0, '303EP')
	, ('PC/005', 'Location', 60, 0, 'R2123-9')
	, ('PC/005', 'Material Type', 10, 0, 'PC')
	, ('PC/005', 'Name', 30, 0, 'Calibre')
	, ('PC/005', 'SG', 40, 0, '1.21')
	;
	INSERT INTO Activity.tbOp (ActivityCode, OperationNumber, SyncTypeCode, Operation, Duration, OffsetDays)
	VALUES ('M/00/70/05', 10, 0, 'ASSEMBLE', 0.5, 3)
	, ('M/00/70/05', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/00/70/05', 30, 0, 'PACK', 0, 1)
	, ('M/00/70/05', 40, 2, 'DELIVER', 0, 1)
	, ('M/100/70/05', 10, 0, 'MOULD', 10, 2)
	, ('M/100/70/05', 20, 1, 'INSERTS', 0, 0)
	, ('M/100/70/05', 30, 0, 'QUALITY CHECK', 0, 0)
	, ('M/101/70/05', 10, 0, 'MOULD', 10, 0)
	, ('M/101/70/05', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/97/70/05', 10, 0, 'MOULD', 10, 2)
	, ('M/97/70/05', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/99/70/05', 10, 0, 'MOULD', 0, 2)
	, ('M/99/70/05', 20, 0, 'QUALITY CHECK', 0, 0)
	;
	INSERT INTO Activity.tbFlow (ParentCode, StepNumber, ChildCode, SyncTypeCode, OffsetDays, UsedOnQuantity)
	VALUES ('M/00/70/05', 10, 'M/100/70/05', 1, 0, 8)
	, ('M/00/70/05', 20, 'M/101/70/05', 1, 0, 4)
	, ('M/00/70/05', 30, 'M/97/70/05', 1, 0, 3)
	, ('M/00/70/05', 40, 'M/99/70/05', 0, 0, 2)
	, ('M/00/70/05', 50, 'BOX/41', 1, 0, 1)
	, ('M/00/70/05', 60, 'PALLET/01', 1, 0, 0.01)
	, ('M/00/70/05', 70, 'DELIVERY', 2, 1, 0)
	, ('M/100/70/05', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/100/70/05', 20, 'PC/005', 1, 0, 0.175)
	, ('M/101/70/05', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/101/70/05', 20, 'PC/005', 1, 0, 0.061)
	, ('M/97/70/05', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/97/70/05', 20, 'PC/005', 1, 0, 0.172)
	, ('M/99/70/05', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/99/70/05', 20, 'PC/005', 1, 0, 0.171)
	, ('M/100/70/05', 30, 'INSERT/09', 1, 0, 2)
	;

	/***********************************************************************************/

	INSERT INTO Activity.tbActivity (ActivityCode, TaskStatusCode, DefaultText, UnitOfMeasure, CashCode, UnitCharge, Printed, RegisterName)
	VALUES ('M/00/70/06', 1, 'PIGEON HOLE SHELF ASSEMBLY YELLOW', 'each', '103', 14.530, 1, 'Sales Order')
	, ('M/100/70/06', 1, 'PIGEON HOLE SUB SHELF YELLOW', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/101/70/06', 1, 'PIGEON HOLE BACK DIVIDER', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/97/70/06', 1, 'SHELF DIVIDER (WIDE FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('M/99/70/06', 1, 'SHELF DIVIDER (NARROW FOOT)', 'each', NULL, 0.0000, 0, 'Works Order')
	, ('PC/004', 1, 'CALIBRE 303EP YELLOW UL94-V2', 'kilo', '200', 1.8500, 1, 'Purchase Order')
	;
	INSERT INTO Activity.tbAttribute (ActivityCode, Attribute, PrintOrder, AttributeTypeCode, DefaultText)
	VALUES ('M/00/70/06', 'Colour', 20, 0, 'YELLOW')
	, ('M/00/70/06', 'Colour Number', 10, 0, '-')
	, ('M/00/70/06', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/00/70/06', 'Drawing Issue', 40, 0, '1')
	, ('M/00/70/06', 'Drawing Number', 30, 0, '321554')
	, ('M/00/70/06', 'Label Type', 70, 0, 'Assembly Card')
	, ('M/00/70/06', 'Mould Tool Specification', 110, 1, NULL)
	, ('M/00/70/06', 'Pack Type', 60, 0, 'Despatched')
	, ('M/00/70/06', 'Quantity/Box', 80, 0, '103')
	, ('M/100/70/06', 'Cavities', 170, 0, '1')
	, ('M/100/70/06', 'Colour', 20, 0, 'YELLOW')
	, ('M/100/70/06', 'Colour Number', 10, 0, '-')
	, ('M/100/70/06', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/100/70/06', 'Drawing Issue', 40, 0, '1')
	, ('M/100/70/06', 'Drawing Number', 30, 0, '321554-03')
	, ('M/100/70/06', 'Impressions', 180, 0, '1')
	, ('M/100/70/06', 'Label Type', 70, 0, 'Route Card')
	, ('M/100/70/06', 'Location', 150, 0, 'STORES')
	, ('M/100/70/06', 'Pack Type', 60, 0, 'Assembled')
	, ('M/100/70/06', 'Part Weight', 160, 0, '175g')
	, ('M/100/70/06', 'Quantity/Box', 80, 0, '103')
	, ('M/100/70/06', 'Tool Number', 190, 0, '1437')
	, ('M/101/70/06', 'Cavities', 170, 0, '2')
	, ('M/101/70/06', 'Colour', 20, 0, 'YELLOW')
	, ('M/101/70/06', 'Colour Number', 10, 0, '-')
	, ('M/101/70/06', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/101/70/06', 'Drawing Issue', 40, 0, '1')
	, ('M/101/70/06', 'Drawing Number', 30, 0, '321554-05')
	, ('M/101/70/06', 'Impressions', 180, 0, '2')
	, ('M/101/70/06', 'Label Type', 70, 0, 'Route Card')
	, ('M/101/70/06', 'Location', 150, 0, 'STORES')
	, ('M/101/70/06', 'Pack Type', 60, 0, 'Assembled')
	, ('M/101/70/06', 'Part Weight', 160, 0, '61g')
	, ('M/101/70/06', 'Quantity/Box', 80, 0, '103')
	, ('M/101/70/06', 'Tool Number', 190, 0, '1439')
	, ('M/97/70/06', 'Cavities', 170, 0, '4')
	, ('M/97/70/06', 'Colour', 20, 0, 'YELLOW')
	, ('M/97/70/06', 'Colour Number', 10, 0, '-')
	, ('M/97/70/06', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/97/70/06', 'Drawing Issue', 40, 0, '1')
	, ('M/97/70/06', 'Drawing Number', 30, 0, '321554A')
	, ('M/97/70/06', 'Impressions', 180, 0, '4')
	, ('M/97/70/06', 'Label Type', 70, 0, 'Route Card')
	, ('M/97/70/06', 'Location', 150, 0, 'STORES')
	, ('M/97/70/06', 'Pack Type', 60, 0, 'Assembled')
	, ('M/97/70/06', 'Part Weight', 160, 0, '171g')
	, ('M/97/70/06', 'Quantity/Box', 80, 0, '103')
	, ('M/97/70/06', 'Tool Number', 190, 0, '1440')
	, ('M/99/70/06', 'Cavities', 170, 0, '1')
	, ('M/99/70/06', 'Colour', 20, 0, 'YELLOW')
	, ('M/99/70/06', 'Colour Number', 10, 0, '-')
	, ('M/99/70/06', 'Count Type', 50, 0, 'Weigh Count')
	, ('M/99/70/06', 'Drawing Issue', 40, 0, '1')
	, ('M/99/70/06', 'Drawing Number', 30, 0, '321554A')
	, ('M/99/70/06', 'Impressions', 180, 0, '1')
	, ('M/99/70/06', 'Label Type', 70, 0, 'Route Card')
	, ('M/99/70/06', 'Location', 150, 0, 'STORES')
	, ('M/99/70/06', 'Pack Type', 60, 0, 'Assembled')
	, ('M/99/70/06', 'Part Weight', 160, 0, '171g')
	, ('M/99/70/06', 'Quantity/Box', 80, 0, '103')
	, ('M/99/70/06', 'Tool Number', 190, 0, '1441')
	, ('PC/004', 'Colour', 50, 0, 'YELLOW')
	, ('PC/004', 'Grade', 20, 0, '303EP')
	, ('PC/004', 'Location', 60, 0, 'R2123-9')
	, ('PC/004', 'Material Type', 10, 0, 'PC')
	, ('PC/004', 'Name', 30, 0, 'Calibre')
	, ('PC/004', 'SG', 40, 0, '1.21')
	;
	INSERT INTO Activity.tbOp (ActivityCode, OperationNumber, SyncTypeCode, Operation, Duration, OffsetDays)
	VALUES ('M/00/70/06', 10, 0, 'ASSEMBLE', 0.5, 3)
	, ('M/00/70/06', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/00/70/06', 30, 0, 'PACK', 0, 1)
	, ('M/00/70/06', 40, 2, 'DELIVER', 0, 1)
	, ('M/100/70/06', 10, 0, 'MOULD', 10, 2)
	, ('M/100/70/06', 20, 1, 'INSERTS', 0, 0)
	, ('M/100/70/06', 30, 0, 'QUALITY CHECK', 0, 0)
	, ('M/101/70/06', 10, 0, 'MOULD', 10, 2)
	, ('M/101/70/06', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/97/70/06', 10, 0, 'MOULD', 10, 2)
	, ('M/97/70/06', 20, 0, 'QUALITY CHECK', 0, 0)
	, ('M/99/70/06', 10, 0, 'MOULD', 0, 2)
	, ('M/99/70/06', 20, 0, 'QUALITY CHECK', 0, 0)
	;
	INSERT INTO Activity.tbFlow (ParentCode, StepNumber, ChildCode, SyncTypeCode, OffsetDays, UsedOnQuantity)
	VALUES ('M/00/70/06', 10, 'M/100/70/06', 1, 0, 8)
	, ('M/00/70/06', 20, 'M/101/70/06', 1, 0, 4)
	, ('M/00/70/06', 30, 'M/97/70/06', 1, 0, 3)
	, ('M/00/70/06', 40, 'M/99/70/06', 0, 0, 2)
	, ('M/00/70/06', 50, 'BOX/41', 1, 0, 1)
	, ('M/00/70/06', 60, 'PALLET/01', 1, 0, 0.01)
	, ('M/00/70/06', 70, 'DELIVERY', 2, 1, 0)
	, ('M/100/70/06', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/100/70/06', 20, 'PC/004', 1, 0, 0.175)
	, ('M/101/70/06', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/101/70/06', 20, 'PC/004', 1, 0, 0.061)
	, ('M/97/70/06', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/97/70/06', 20, 'PC/004', 1, 0, 0.172)
	, ('M/99/70/06', 10, 'BOX/99', 1, 0, 0.01)
	, ('M/99/70/06', 20, 'PC/004', 1, 0, 0.171)
	, ('M/100/70/06', 30, 'INSERT/09', 1, 0, 2)
	;

	IF (NOT EXISTS (SELECT * FROM Usr.tbUser WHERE UserId = 'EN'))
		INSERT INTO Usr.tbUser (UserId, UserName, LogonName, CalendarCode, IsAdministrator, IsEnabled)
		VALUES 
			('EN', 'Emily Nuthatch', 'emily', 'WORKS', 0, 1),
			('GS', 'Georgina Swan', 'georgina', 'WORKS', 0, 1),
			('HS', 'Harry Swift', 'harry', 'WORKS', 0, 1),
			('RC', 'Ralph Corncrake', 'ralph', 'WORKS', 0, 1),
			('SS', 'Sue Starling', 'sue', 'WORKS', 0, 1);

/**********************************************************************************************************/
	UPDATE task
	SET UserId = (SELECT MAX(UserId) FROM Usr.tbUser WHERE IsAdministrator = 0)
	FROM Task.tbTask task
	JOIN
	(SELECT TaskCode 
	FROM Org.vwSales s 
		JOIN Usr.tbUser u ON s.UserId = u.UserId WHERE u.IsAdministrator <> 0) admin_sales
			ON task.TaskCode = admin_sales.TaskCode;

	INSERT INTO @tbAreas (AreaId, AreaCode) VALUES (0, 'NORTH'), (1, 'SOUTH'), (2, 'EAST'), (3, 'WEST'), (4, 'CENTRAL'), (5, 'EUROPE');
	INSERT INTO @tbSectors (SectorId, IndustrySector) 
	VALUES (0,'IT'), (1,'Agriculture'), (2,'Automotive'), (3,'Chemical'), (4,'Distribution'), (5,'Energy'), 
	(6,'Manufacturing'), (7,'Plastics'), (8,'Metals'), (9,'Packaging'), (10,'Paper'), (11,'Pharma'), (12,'Retail'), (13,'Services'),
		(14,'Communications'), (15,'Textile'), (16,'Transport'), (17,'Utilities');

	SET @AccountCode = 'STOBOX'; SET @IndustrySector = 'Manufacturing';
	IF NOT EXISTS (SELECT * FROM Org.tbSector WHERE AccountCode = @AccountCode AND IndustrySector = @IndustrySector)
		INSERT INTO Org.tbSector (AccountCode, IndustrySector) VALUES (@AccountCode, @IndustrySector);

	SET @IndustrySector = 'Plastics';
	IF NOT EXISTS (SELECT * FROM Org.tbSector WHERE AccountCode = @AccountCode AND IndustrySector = @IndustrySector)
		INSERT INTO Org.tbSector (AccountCode, IndustrySector) VALUES (@AccountCode, @IndustrySector);
		
	SET @IndustrySector = 'IT';
	IF NOT EXISTS (SELECT * FROM Org.tbSector WHERE AccountCode = @AccountCode AND IndustrySector = @IndustrySector)
		INSERT INTO Org.tbSector (AccountCode, IndustrySector) VALUES (@AccountCode, @IndustrySector);

	UPDATE Org.tbOrg
	SET AreaCode = @AreaCode
	WHERE AccountCode = @AccountCode;

	SET @CustCounter = 0; 
	WHILE @CustCounter < @MaxCustomers
	BEGIN
		IF @CustCounter < (@MaxCustomers * 0.75)
		BEGIN
			SET @Id = ROUND(RAND() *10000, 0);
	  		SELECT @AreaCode = AreaCode FROM @tbAreas WHERE AreaId = @Id % (SELECT COUNT(*) FROM @tbAreas)
			SELECT @IndustrySector = IndustrySector FROM @tbSectors WHERE SectorId = @Id % (SELECT COUNT(*) FROM @tbSectors)
		END
		ELSE
		BEGIN
	  		SELECT @AreaCode = AreaCode FROM @tbAreas WHERE AreaId = 0
			SELECT @IndustrySector = IndustrySector FROM @tbSectors WHERE SectorId = 6
		END

		SET @AccountName = CONCAT('CUSTOMER ', FORMAT(@CustCounter, '00'));
		EXEC Org.proc_DefaultAccountCode @AccountName, @AccountCode OUTPUT
		EXEC Org.proc_NextAddressCode @AccountCode, @AddressCode OUTPUT
		INSERT INTO Org.tbOrg (AccountCode, AccountName, OrganisationTypeCode, OrganisationStatusCode, TaxCode, AddressCode, AreaCode, PaymentTerms, ExpectedDays, PaymentDays, PayDaysFromMonthEnd, PayBalance, NumberOfEmployees, EUJurisdiction)
		VALUES (@AccountCode,@AccountName, 1, 1, 'T1',@AddressCode,@AreaCode, '30 days from invoice', 5, 30, 0, 1, 0, CASE WHEN @AreaCode = 'EUROPE' THEN 1 ELSE 0 END)

		INSERT INTO Org.tbAddress (AddressCode, AccountCode, Address)
		VALUES (@AddressCode, @AccountCode, @AreaCode);

		INSERT INTO Org.tbSector (AccountCode, IndustrySector) VALUES (@AccountCode, @IndustrySector);

		SELECT @UserId = UserId FROM Usr.vwCredentials;
		EXEC Task.proc_NextCode 'PROJECT', @ParentTaskCode OUTPUT
		INSERT INTO Task.tbTask
								 (TaskCode, UserId, AccountCode, TaskTitle, ActivityCode, TaskStatusCode, ActionById)
		VALUES        (@ParentTaskCode, @UserId, @AccountCode, N'PIGEON HOLE SHELF ASSEMBLY', N'PROJECT', 0, @UserId)

		SET @ProdCounter = 0;  
		SELECT @MaxOrders = COUNT(*) FROM App.tbYearPeriod WHERE StartOn < CURRENT_TIMESTAMP;
		SET @Quantity = ROUND(RAND() *10000, 0) 
		SET @MaxOrders = @Quantity % @MaxOrders;
		SET @MaxOrders = CASE @MaxOrders WHEN 0 THEN 2 ELSE @MaxOrders END; 

		WHILE @ProdCounter < @MaxOrders  
		BEGIN  
			SET @Quantity = ROUND(RAND() *10000, 0) 
			SET @ActivityCode = CONCAT('M/00/70/0', @Quantity % 7)
			SET @ActionOn = CAST(DATEADD(MONTH, @ProdCounter * -1, CURRENT_TIMESTAMP) AS DATE)

			EXEC Task.proc_NextCode @ActivityCode, @TaskCode OUTPUT;
			
			WITH reps AS
			(
				SELECT ROW_NUMBER() OVER (ORDER BY UserId) - 1 RowNo, UserId 
				FROM Usr.tbUser WHERE IsAdministrator = 0
			)
			SELECT @UserId = UserId
			FROM reps
			WHERE RowNo = @Quantity % (SELECT COUNT(*) FROM Usr.tbUser WHERE IsAdministrator = 0)

			INSERT INTO Task.tbTask
					(TaskCode, UserId, AccountCode, TaskTitle, ActivityCode, TaskStatusCode, ActionById, TaskNotes, Quantity, CashCode, TaxCode, UnitCharge, AddressCodeFrom, AddressCodeTo)
			SELECT @TaskCode,@UserId, @AccountCode, N'PIGEON HOLE SHELF ASSEMBLY', ActivityCode, 1,@UserId, 'PIGEON HOLE SHELF ASSEMBLY', @Quantity, cash.CashCode, cash.TaxCode, activity.UnitCharge, @AddressCode, @AddressCode
			FROM Activity.tbActivity activity JOIN Cash.tbCode cash ON activity.CashCode = cash.CashCode
			WHERE ActivityCode = @ActivityCode

			EXEC Task.proc_Configure @TaskCode;
			EXEC Task.proc_AssignToParent @TaskCode, @ParentTaskCode;

			UPDATE Task.tbTask SET ActionOn = @ActionOn WHERE TaskCode = @TaskCode;
			EXEC Task.proc_Schedule @TaskCode;

			SET @ProdCounter += 1  
		END;  


		UPDATE Task.tbTask
		SET AccountCode = 'PACSER', ContactName = 'John OGroats', AddressCodeFrom = 'PACSER_001', AddressCodeTo = 'PACSER_001'
		WHERE ActivityCode = 'BOX/41' AND AccountCode = @AccountCode;

		UPDATE Task.tbTask
		SET AccountCode = 'TFCSPE', ContactName = 'Gary Granger', AddressCodeFrom = 'TFCSPE_001', AddressCodeTo = 'TFCSPE_001'
		WHERE ActivityCode = 'INSERT/09' AND AccountCode = @AccountCode;

		UPDATE Task.tbTask
		SET AccountCode = 'PALSUP', ContactName = 'Allan Rain', AddressCodeFrom = 'PALSUP_001', AddressCodeTo = 'PALSUP_001', CashCode = NULL, UnitCharge = 0
		WHERE ActivityCode = 'PALLET/01' AND AccountCode = @AccountCode;

		UPDATE Task.tbTask
		SET AccountCode = 'PLAPRO', ContactName = 'Kim Burnell', AddressCodeFrom = 'PLAPRO_001', AddressCodeTo = 'PLAPRO_001'
		WHERE (ActivityCode LIKE N'PC/%') AND (AccountCode = @AccountCode);
		
		UPDATE Task.tbTask
		SET AccountCode = 'HAULOG', ContactName = 'John Iron',  AddressCodeFrom = 'HOME_001', AddressCodeTo = @AddressCode, Quantity = 1, UnitCharge = 250, TotalCharge = 250
		WHERE ActivityCode = 'DELIVERY' AND AccountCode = @AccountCode;

		UPDATE Task.tbTask
		SET AccountCode = (SELECT AccountCode FROM App.tbOptions), ContactName = (SELECT UserName FROM Usr.vwCredentials)
		WHERE (CashCode IS NULL) AND (AccountCode <> 'PALSUP') AND AccountCode = @AccountCode;

		DECLARE wf CURSOR FOR
			WITH workflow AS
			(
				SELECT ParentTaskCode, ChildTaskCode
				FROM Task.tbTask task JOIN Task.tbFlow flow ON task.TaskCode = flow.ParentTaskCode
				WHERE AccountCode = @AccountCode

				UNION ALL

				SELECT childflow.ParentTaskCode, childflow.ChildTaskCode
				FROM workflow 
					JOIN Task.tbFlow childflow ON workflow.ChildTaskCode = childflow.ParentTaskCode
			)
			SELECT ChildTaskCode TaskCode FROM workflow 
				JOIN Task.tbTask task ON workflow.ChildTaskCode = task.TaskCode
				JOIN Cash.tbCode cash ON task.CashCode = cash.CashCode
			UNION
			SELECT TaskCode FROM Task.tbTask WHERE AccountCode = @AccountCode;

		OPEN wf
		FETCH NEXT FROM wf INTO @TaskCode
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT 
				@InvoiceTypeCode = CASE Cash.tbCategory.CashModeCode WHEN 0 THEN 2 WHEN 1 THEN 0 END, 
				@InvoicedOn = Task.tbTask.ActionOn
			FROM Task.tbTask 
				INNER JOIN Cash.tbCode ON Task.tbTask.CashCode = Cash.tbCode.CashCode 
				INNER JOIN Cash.tbCategory ON Cash.tbCode.CategoryCode = Cash.tbCategory.CategoryCode
			WHERE  (Task.tbTask.TaskCode = @TaskCode)

			EXEC Invoice.proc_Raise @TaskCode = @TaskCode, @InvoiceTypeCode = @InvoiceTypeCode, @InvoicedOn = @InvoicedOn, @InvoiceNumber = @InvoiceNumber OUTPUT;
			EXEC Invoice.proc_Accept @InvoiceNumber;

			UPDATE Task.tbTask
			SET ActionedOn = ActionOn, TaskStatusCode = 3
			WHERE TaskCode = @TaskCode;

			FETCH NEXT FROM wf INTO @TaskCode
		END

		CLOSE wf		
		DEALLOCATE wf

		SET @CustCounter += 1;
	END

	SELECT @UserId = UserId FROM Usr.vwCredentials;

	EXEC Cash.proc_CurrentAccount @CashAccountCode OUTPUT;

	INSERT INTO Org.tbPayment (CashAccountCode, PaymentCode, UserId, AccountCode, PaidOn, PaidInValue, PaidOutValue)
	SELECT @CashAccountCode CashAccountCode, CONCAT(AccountCode,'_', FORMAT(PaidOn, 'yyyyMMdd')) PaymentCode, @UserId UserId, AccountCode, PaidOn, PaidInValue, PaidOutValue
	FROM 
	(
		SELECT AccountCode, PaidOn, ROUND(SUM(PaidInValue), 2) PaidInValue, ROUND(SUM(PaidOutValue), 2) PaidOutValue
		FROM 
		(
			SELECT        AccountCode, EOMONTH(ExpectedOn) PaidOn, 
				CASE InvoiceTypeCode WHEN 0 THEN InvoiceValue + TaxValue ELSE 0 END PaidInValue,
				CASE InvoiceTypeCode WHEN 2 THEN InvoiceValue + TaxValue ELSE 0 END PaidOutValue
			FROM            Invoice.tbInvoice
			WHERE        (InvoiceStatusCode = 1) AND (ExpectedOn < EOMONTH(DATEADD(MONTH, -1,CURRENT_TIMESTAMP)))
		) invoices
		GROUP BY AccountCode, PaidOn
	) payments;

	EXEC Org.proc_PaymentPost;	

	IF NOT EXISTS(SELECT * FROM Org.tbOrg WHERE AccountCode = @AccountCode)
	BEGIN
		INSERT INTO Org.tbOrg (AccountCode, AccountName, OrganisationStatusCode, OrganisationTypeCode)
		VALUES (@AccountCode, 'Her Majesties Revenue and Customs', 1, 7)
		UPDATE Cash.tbTaxType
		SET AccountCode = @AccountCode
	END

	SELECT @AccountCode = (SELECT MAX(AccountCode) FROM Cash.tbTaxType WHERE NOT AccountCode IS NULL);
	EXEC Cash.proc_CurrentAccount @CashAccountCode OUTPUT;

	INSERT INTO Org.tbPayment (CashAccountCode, PaymentCode, UserId, AccountCode, PaidOn, PaidInValue, PaidOutValue, CashCode, TaxCode)
	SELECT @CashAccountCode CashAccountCode, CONCAT(@AccountCode, '_', FORMAT(PaidOn, 'yyyyMMdd')) PaymentCode, @UserId UserId, @AccountCode AccountCode, PaidOn, 0 AS PaidInValue, PaidOutValue, CashCode, TaxCode
	FROM
	(
		SELECT DATEADD(DAY, -1, StartOn) PaidOn, ROUND(VatDue, 2) PaidOutValue, (SELECT CashCode FROM Cash.tbTaxType WHERE TaxTypeCode = 1) CashCode, 'N/A' TaxCode
		FROM Cash.vwTaxVatStatement vat 
		WHERE StartOn < CURRENT_TIMESTAMP AND VatDue > 0
		UNION
		SELECT DATEADD(DAY, -1, StartOn) PaidOn, ROUND(TaxDue, 2) PaidOutValue, (SELECT CashCode FROM Cash.tbTaxType WHERE TaxTypeCode = 0) CashCode, 'N/A' TaxCode
		FROM Cash.vwTaxCorpStatement
		WHERE StartOn < CURRENT_TIMESTAMP AND TaxDue > 0
	) tax

	EXEC Org.proc_PaymentPost;
	EXEC App.proc_SystemRebuild;

END TRY
BEGIN CATCH
	EXEC App.proc_ErrorLog;
END CATCH
GO  

