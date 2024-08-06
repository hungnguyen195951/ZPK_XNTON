@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nhập xuất tồn số lượng, giá trị'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE,
                                      #EXTRACTION_DATA_SOURCE]
define view entity ZWM_I_NXT_SLGT
  with parameters
    @EndUserText.label: 'Start Date'
    @Consumption.hidden: false
    P_StartDate  : vdm_v_start_date,

    @EndUserText.label: 'End Date'
    @Consumption.hidden: false
    P_EndDate    : vdm_v_end_date,

    @EndUserText.label: 'Period Type'
    @Consumption.hidden: false
    P_PeriodType : nsdm_period_type

  as select from I_MaterialStockTimeSeries( P_StartDate: $parameters.P_StartDate, P_EndDate: $parameters.P_EndDate, P_PeriodType: $parameters.P_PeriodType ) as I_MaterialStockTimeSeries
  left outer join I_MaterialDocumentItem_2                                      as item on  item.Material = I_MaterialStockTimeSeries.Material
                                                                                and item.Plant    = I_MaterialStockTimeSeries.Plant
                                                                                and item.Batch    = I_MaterialStockTimeSeries.Batch
                                                                                and item.StorageLocation = I_MaterialStockTimeSeries.StorageLocation
  association [0..1] to I_ProductValuationBasic   as ProductValuation           on  ProductValuation.Product       = I_MaterialStockTimeSeries.Material
                                                                                and ProductValuation.ValuationArea = I_MaterialStockTimeSeries.Plant
                                                                                and ProductValuation.ValuationType = I_MaterialStockTimeSeries.Batch
                                                                                and ProductValuation.CompanyCode   = I_MaterialStockTimeSeries.CompanyCode
  association [0..*] to I_MaterialStockTimeSeries as _I_MaterialStockTimeSeries on  _I_MaterialStockTimeSeries.Material = I_MaterialStockTimeSeries.Material
                                                                                and _I_MaterialStockTimeSeries.Plant    = I_MaterialStockTimeSeries.Plant
                                                                                and _I_MaterialStockTimeSeries.Batch    = I_MaterialStockTimeSeries.Batch
  
  association [0..1] to ZI_BATCH_NCC              as _BatchNCC                  on  _BatchNCC.Material = I_MaterialStockTimeSeries.Material
                                                                                and _BatchNCC.Plant    = I_MaterialStockTimeSeries.Plant
                                                                                and _BatchNCC.Batch    = I_MaterialStockTimeSeries.Batch
  association [0..1] to ZI_BATCH_NGAYNHAPKHO      as _NgayNhapKho               on  _NgayNhapKho.Material = I_MaterialStockTimeSeries.Material
                                                                                and _NgayNhapKho.Plant    = I_MaterialStockTimeSeries.Plant
                                                                                and _NgayNhapKho.Batch    = I_MaterialStockTimeSeries.Batch
  association [0..1] to ZI_BATCH_HANSUDUNG        as _HanSuDung                 on  _HanSuDung.Material = I_MaterialStockTimeSeries.Material
                                                                                and _HanSuDung.Plant    = I_MaterialStockTimeSeries.Plant
                                                                                and _HanSuDung.Batch    = I_MaterialStockTimeSeries.Batch

{
  key I_MaterialStockTimeSeries.PeriodType                                                                                                                   as PeriodType,
      @EndUserText.label: 'End of Fiscal Period'
  key I_MaterialStockTimeSeries.EndDate                                                                                                                      as EndDate,
      @EndUserText.label: 'Fiscal Year Period'
  key I_MaterialStockTimeSeries.YearPeriod                                                                                                                   as YearPeriod,
  key I_MaterialStockTimeSeries.Material                                                                                                                     as Material,
  key I_MaterialStockTimeSeries.Plant                                                                                                                        as Plant,
  key I_MaterialStockTimeSeries.StorageLocation                                                                                                              as StorageLocation,
  key I_MaterialStockTimeSeries.Batch                                                                                                                        as Batch,
  key I_MaterialStockTimeSeries.Supplier                                                                                                                     as Supplier,
  key I_MaterialStockTimeSeries.SDDocument                                                                                                                   as SDDocument,
  key I_MaterialStockTimeSeries.SDDocumentItem                                                                                                               as SDDocumentItem,
  key I_MaterialStockTimeSeries.WBSElementInternalID                                                                                                         as WBSElementInternalID,
  key I_MaterialStockTimeSeries.Customer                                                                                                                     as Customer,
  key I_MaterialStockTimeSeries.InventoryStockType                                                                                                           as InventoryStockType,
  key I_MaterialStockTimeSeries.InventorySpecialStockType                                                                                                    as InventorySpecialStockType,
  key I_MaterialStockTimeSeries.FiscalYearVariant                                                                                                            as FiscalYearVariant,
  key I_MaterialStockTimeSeries.MaterialBaseUnit                                                                                                             as MaterialBaseUnit,
      I_MaterialStockTimeSeries.CompanyCode                                                                                                                  as CompanyCode,
      I_MaterialStockTimeSeries._CompanyCode.CompanyCodeName                                                                                                 as CompanyCodeName,
      I_MaterialStockTimeSeries._Plant.Plant                                                                                                                 as Plant_1,
      I_MaterialStockTimeSeries._StorageLocation.StorageLocationName                                                                                         as StorageLocationName,
      ProductValuation.ValuationArea                                                                                                                         as ValuationArea,
      ProductValuation.ValuationType  
                                                                                                                             as ValuationType,
      @EndUserText.label: 'Closing Stock'
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      I_MaterialStockTimeSeries.MatlWrhsStkQtyInMatlBaseUnit                                                                                                 as MatlWrhsStkQtyInMatlBaseUni_1,
      @EndUserText.label: 'Open Stock'
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      _I_MaterialStockTimeSeries( P_StartDate: $parameters.P_StartDate, P_EndDate: $parameters.P_StartDate, P_PeriodType: 'Y' ).MatlWrhsStkQtyInMatlBaseUnit as MatlWrhsStkQtyInMatlBaseUnit,
      //      _I_MaterialStockTimeSeries._Plant.PlantName12
      ProductValuation.Currency,
      item.GoodsMovementType,
      @EndUserText.label: 'Moving price'
      @Semantics.amount.currencyCode: 'Currency'
      ProductValuation.MovingAveragePrice                                                                                                                    as MovingAveragePrice,
      @EndUserText.label: 'Batch NCC'
      _BatchNCC.CharcValue                                                                                                                                   as BatchNCC,
      @EndUserText.label: 'Ngày nhập kho'
      _NgayNhapKho.CharcFromDate                                                                                                                             as NgayNhapKho,
      @EndUserText.label: 'Hạn sử dụng'
      _HanSuDung.CharcFromDate                                                                                                                               as HanSuDung

} where item.GoodsMovementType <> '311'
and item.StorageLocation <> '1003' 
