@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hạn sử dụng'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BATCH_SOHD
  as select from I_Batch
    inner join   I_ClfnObjectCharcValForKeyDate(P_KeyDate: $session.system_date) on I_ClfnObjectCharcValForKeyDate.ClfnObjectInternalID = I_Batch.ClfnObjectInternalID
    inner join   I_ClfnCharacteristic                                            on  I_ClfnCharacteristic.CharcInternalID = I_ClfnObjectCharcValForKeyDate.CharcInternalID
                                                                                 and I_ClfnCharacteristic.Characteristic  = 'Z_SOHD'
{
  key I_Batch.Material,
  key I_Batch.Plant,
  key I_Batch.Batch,
      I_ClfnObjectCharcValForKeyDate.CharcFromNumericValue,
      I_ClfnObjectCharcValForKeyDate.CharcValue
}
