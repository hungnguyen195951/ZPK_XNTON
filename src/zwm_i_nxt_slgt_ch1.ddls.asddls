@EndUserText.label: 'Nhập xuất tồn số lượng, giá trị cl'
@ObjectModel.query.implementedBy: 'ABAP:ZWM_CL_XNT_SLGT_CH1' 
define custom entity ZWM_I_NXT_SLGT_CH1
  with parameters

    @EndUserText.label: 'Fiscal Year'
    @Consumption.hidden: false
    P_FiscalYear : gjahr,
    @EndUserText.label: 'Start Date'
    @Consumption.hidden: false
    P_StartDate  : vdm_v_start_date,
    @EndUserText.label: 'End Date'
    @Consumption.hidden: false
    P_EndDate    : vdm_v_end_date,
    P_PeriodType : nsdm_period_type
{
      @EndUserText.label        : 'Period Type'
      @Consumption.filter.hidden: true
      @UI.hidden                : true
  key PeriodType                : nsdm_period_type;
      @EndUserText.label        : 'End Date'
      @Consumption.filter.hidden: true
      @UI.hidden                : true
  key EndDate                   : vdm_v_end_date;
      @EndUserText.label        : 'Year Period'
      @Consumption.filter.hidden: true
  key YearPeriod                : periv;
      @EndUserText.label        : 'Material'
      @UI.lineItem              : [{ position: 1 }]
      @UI.selectionField        : [{ position: 1 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' } }]
  key Material                  : matnr;
      @UI.lineItem              : [{ position: 2 }]
      @UI.selectionField        : [{ position: 3 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
      @EndUserText.label        : 'Plant'
  key Plant                     : werks_d;
      @UI.lineItem              : [{ position: 3 }]
      @UI.selectionField        : [{ position: 4 }]
      @EndUserText.label        : 'Storage Location'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_StorageLocation', element: 'StorageLocation' } }]
  key StorageLocation           : zde_lgort_d;
      @UI.lineItem              : [{ position: 4 }]
      @UI.selectionField        : [{ position: 5 }]
      @EndUserText.label        : 'Batch'
  key Batch                     : charg_d;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 5 }]
      @EndUserText.label        : 'Supplier'
  key Supplier                  : lifnr;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 6 }]
      @EndUserText.label        : 'SD Document'
  key SDDocument                : sd_sls_document;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 7 }]
      @EndUserText.label        : 'SD Document Item'
  key SDDocumentItem            : sd_sls_document_item;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 8 }]
      @EndUserText.label        : 'Customer'
  key Customer                  : sd_customer_number;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 9 }]
      @EndUserText.label        : 'Inventory Stock Type'
      @UI.hidden                : true
  key InventoryStockType        : zde_lgort_d;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 10 }]
      @EndUserText.label        : 'Inventory Special Stock Type'
  key InventorySpecialStockType : sobkz;
      @Consumption.filter.hidden: true
      @UI.lineItem              : [{ position: 11 }]
      @EndUserText.label        : 'Material Base Unit'
  key MaterialBaseUnit          : meins;
      @UI.hidden                : true
      @Consumption.filter.hidden: true
      @EndUserText.label        : 'Fiscal Year Variant'
      @Semantics.fiscal.yearVariant: true
  key FiscalYearVariant         : abap.char(2);
      //Stock description
      @EndUserText.label        : 'Material Type'
      @UI.lineItem              : [{ position: 12 }]
      @UI.selectionField        : [{ position: 17 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Producttype', element: 'ProductType' } }]
      ProductType               : abap.char(4);
      @EndUserText.label        : 'Material Type Description'
      @UI.lineItem              : [{ position: 13 }]
      @Consumption.filter.hidden: true
      ProductTypeName           : abap.char(25);
      @EndUserText.label        : 'Company Code'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCodeStdVH', element: 'CompanyCode' } }]
      @UI.selectionField        : [{ position: 2 }]
      CompanyCode               : bukrs;
      @EndUserText.label        : 'Company name'
      @Consumption.filter.hidden: true
      CompanyCodeName           : abap.char(60);
      @EndUserText.label        : 'Storage Loc. name'
      @Consumption.filter.hidden: true
      StorageLocationName       : abap.char(60);
      @EndUserText.label        : 'Valuation Area'
      @Consumption.filter.hidden: true
      ValuationArea             : werks_d;
      @EndUserText.label        : 'Valuation Type'
      @UI.selectionField        : [{ position: 7 }]
      ValuationType             : abap.char(10);
      @EndUserText.label        : 'Batch NCC'
      @UI.selectionField        : [{ position: 9 }]
      @UI.lineItem              : [{ position: 16 }]
      BatchNCC                  : abap.char(40);
      @UI.lineItem              : [{ position: 17 }]
      @EndUserText.label        : 'Ngày nhập kho'
      @Consumption.filter.hidden: true
      NgayNhapKho               : abap.dats;
      @UI.lineItem              : [{ position: 18 }]
      @EndUserText.label        : 'Ngày sản xuất'
      @Consumption.filter.hidden: true
      NgaySanXuat               : abap.dats;
      @UI.lineItem              : [{ position: 19 }]
      @UI.selectionField        : [{ position: 110 }]
      @EndUserText.label        : 'Hạn sử dụng'
      HanSuDung                 : abap.dats;
      @UI.lineItem              : [{ position: 20 }]
      @EndUserText.label        : 'ASN Number'
      @Consumption.filter.hidden: true
      ASN                       : abap.char(40);
      @UI.lineItem              : [{ position: 21 }]
      @EndUserText.label        : 'GRN Number'
      @Consumption.filter.hidden: true
      GRN                       : abap.char(40);
      @UI.lineItem              : [{ position: 22 }]
      @EndUserText.label        : 'Ghi chú'
      @Consumption.filter.hidden: true
      GhiChu                    : abap.char(40);
      //Stock quantity
      @EndUserText.label        : 'Closing Stock'
      @UI.lineItem              : [{ position: 23 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Consumption.filter.hidden: true
      @Aggregation.default      : #SUM
      ClosingStock              : abap.quan(31,14);
      @UI.lineItem              : [{ position: 24 }]
      @EndUserText.label        : 'Opening Stock'
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Consumption.filter.hidden: true
      @Aggregation.default      : #SUM
      OpeningStock              : abap.quan(31,14);
      @Semantics.currencyCode   : true
      @EndUserText.label        : 'Currency'
      @Consumption.filter.hidden: true
      CurrencyPrice             : abap.cuky(5);
      @UI.lineItem              : [{ position: 25 }]
      @Semantics.amount.currencyCode: 'CurrencyPrice'
      @EndUserText.label        : 'Moving Price'
      @Consumption.filter.hidden: true
      MovingAveragePrice        : abap.curr(31,2);
      @UI.lineItem              : [{ position: 26 }]
      @EndUserText.label        : 'Total Receipt Quantities '
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default      : #SUM
      @Consumption.filter.hidden: true
      TOTALRECEIPTQUANTITY      : abap.quan(31,14);
      @UI.lineItem              : [{ position: 27 }]
      @EndUserText.label        : 'Total Issue Quantities '
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default      : #SUM
      @Consumption.filter.hidden: true
      TOTALISSUEQUANTITY        : abap.quan(31,14);
      ///////Stock value
      @Consumption.filter.hidden: true
      @Semantics.amount.currencyCode: 'CurrencyPrice'
      @UI.lineItem              : [{ position: 28 }]
      @EndUserText.label        : 'Opening Value'
      @Aggregation.default      : #SUM
      OpeningValue              : abap.curr(23,2);
      @Consumption.filter.hidden: true
      @Semantics.amount.currencyCode: 'CurrencyPrice'
      @UI.lineItem              : [{ position: 29 }]
      @EndUserText.label        : 'Total Receipt Values'
      @Aggregation.default      : #SUM
      TotalReceiptValues        : abap.curr(23,2);
      @Consumption.filter.hidden: true
      @Semantics.amount.currencyCode: 'CurrencyPrice'
      @UI.lineItem              : [{ position: 30 }]
      @EndUserText.label        : 'Total Issue Values'
      @Aggregation.default      : #SUM
      TotalIssueValues          : abap.curr(23,2);
      @Consumption.filter.hidden: true
      @Semantics.amount.currencyCode: 'CurrencyPrice'
      @UI.lineItem              : [{ position: 31 }]
      @EndUserText.label        : 'Closing Value'
      @Aggregation.default      : #SUM
      ClosingValue              : abap.curr(23,2);
      ///////////////////////////////////////////////////////////////
      @UI.hidden                : true
      DisplayMaHuy              : abap.char(6);
      @UI.hidden                : true
      @Consumption.filter.hidden: true
      ProductOldID              : abap.char(40);
      @EndUserText.label        : 'Supplier of Batch'
      SupplierOfBatch           : lifnr;
      @EndUserText.label        : 'Supplier of Batch Name'
      SupplierOfBatchName       : abap.char(80);
      @UI.hidden                : true
      @UI.lineItem              : [{ position: 35 }]
      @UI.selectionField        : [{ position: 160 }]
         @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
          name: 'ZSH_i_MVTYPE',
          element: 'GoodsMovementType'
      } }]
      @EndUserText.label        : 'Goods Movement Type'
      GoodsMovementType          : bwart;
    
}
