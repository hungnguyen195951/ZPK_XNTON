@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Characteristic of batch'
define root view entity zi_batch_charc
  as select from I_Batch
  association [1..1] to ZI_BATCH_SOHD        as _SoHD        on  _SoHD.Material = $projection.Material
                                                             and _SoHD.Plant    = $projection.Plant
                                                             and _SoHD.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_GET_ASN     as _ASN         on  _ASN.Material = $projection.Material
                                                             and _ASN.Plant    = $projection.Plant
                                                             and _ASN.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_GET_GRN     as _GRN         on  _GRN.Material = $projection.Material
                                                             and _GRN.Plant    = $projection.Plant
                                                             and _GRN.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_GHICHU      as _GhiChu      on  _GhiChu.Material = $projection.Material
                                                             and _GhiChu.Plant    = $projection.Plant
                                                             and _GhiChu.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_NCC         as _BatchNCC    on  _BatchNCC.Material = $projection.Material
                                                             and _BatchNCC.Plant    = $projection.Plant
                                                             and _BatchNCC.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_HANSUDUNG   as _HanSuDung   on  _HanSuDung.Material = $projection.Material
                                                             and _HanSuDung.Plant    = $projection.Plant
                                                             and _HanSuDung.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_NGAYNHAPKHO as _NgayNhapKho on  _NgayNhapKho.Material = $projection.Material
                                                             and _NgayNhapKho.Plant    = $projection.Plant
                                                             and _NgayNhapKho.Batch    = $projection.Batch
  association [1..1] to ZI_BATCH_NGAYSANXUAT as _NgaySanXuat on  _NgaySanXuat.Material = $projection.Material
                                                             and _NgaySanXuat.Plant    = $projection.Plant
                                                             and _NgaySanXuat.Batch    = $projection.Batch
{

  key I_Batch.Material,
  key I_Batch.Plant,
  key I_Batch.Batch,
      _SoHD,
      _ASN,
      _GRN,
      _GhiChu,
      _BatchNCC,
      _HanSuDung,
      _NgayNhapKho,
      _NgaySanXuat
}
