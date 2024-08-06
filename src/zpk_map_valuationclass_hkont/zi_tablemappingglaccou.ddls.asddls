@EndUserText.label: 'Table mapping glaccount-valuation class'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableMappingGlaccou
  as select from ztb_map_hkont
  association to parent ZI_TableMappingGlaccou_S as _TableMappingGlacAll on $projection.SingletonID = _TableMappingGlacAll.SingletonID
{
  key valuationarea as Valuationarea,
  key valuationclass as Valuationclass,
  glaccount as Glaccount,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableMappingGlacAll
  
}
