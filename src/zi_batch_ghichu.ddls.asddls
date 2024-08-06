@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy GRN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BATCH_GHICHU as select from I_Batch
   inner join I_ClfnObjectCharcValForKeyDate(P_KeyDate: $session.system_date) on I_ClfnObjectCharcValForKeyDate.ClfnObjectInternalID = I_Batch.ClfnObjectInternalID
   inner join I_ClfnCharacteristic on  I_ClfnCharacteristic.CharcInternalID = I_ClfnObjectCharcValForKeyDate.CharcInternalID
                                  and I_ClfnCharacteristic.Characteristic  = 'Z_GHICHU'
{   
  key I_Batch.Material,
  key I_Batch.Plant,
  key I_Batch.Batch,
//  key I_BatchDistinct.ClfnObjectInter1nalID,
      I_ClfnObjectCharcValForKeyDate.CharcValue
}
