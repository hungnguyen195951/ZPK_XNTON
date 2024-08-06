@EndUserText.label: 'Table mapping glaccount-valuation class'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableMappingGlaccou_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TABLEMAPPINGGLACCOU'
  composition [0..*] of ZI_TableMappingGlaccou as _TableMappingGlaccou
{
  key 1 as SingletonID,
  _TableMappingGlaccou,
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
