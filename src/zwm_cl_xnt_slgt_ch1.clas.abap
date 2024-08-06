CLASS zwm_cl_xnt_slgt_ch1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  interfaces if_rap_query_provider .
    data:
      p_startdate   type dats,
      p_startperiod type periv,
      p_enddate     type dats,
      p_fiscalyear  type gjahr,
      p_periodtype  type nsdm_period_type.

    data: gr_material        type range of matnr,
          gr_storagelocation type range of zde_lgort_d,
          gr_plant           type range of werks_d,
          gr_bukrs           type range of bukrs,
          gr_batch           type range of charg_d,
          gr_mtart           type range of i_product-producttype,
          gr_hansudung       type range of dats,
          gr_valuationtype   type range of i_productvaluationbasic-valuationtype,
          gr_batchncc        type range of zi_batch_ncc-charcvalue,
          p_displaymahuy     type abap_boolean.
    data:
        gt_data type table of zwm_i_nxt_slgt_ch1,
        gt_data1 type table of ZWM_I_NXT_slgt.
  protected section.
  private section.
    methods: get_tabname importing fieldname      type string
                         returning value(tabname) type string,
      is_calculation_field importing fieldname      type string
                           returning value(is_true) type abap_boolean,
      get_data.
ENDCLASS.


CLASS zwm_cl_xnt_slgt_ch1 IMPLEMENTATION.

method get_data.

    data:
         lv_lastdateofprevper type dats.

    lv_lastdateofprevper = p_startdate - 1.

    select
      max( source~enddate ) as enddate,
      source~periodtype,
      source~material,
      source~plant,
      source~storagelocation,
      source~batch,
      source~supplier,
      source~sddocument,
      source~sddocumentitem,
      source~customer,
      source~inventorystocktype,
      source~inventoryspecialstocktype,
      source~fiscalyearvariant,
      source~materialbaseunit
   from  i_materialstocktimeseries( p_enddate = @p_enddate,
                                    p_startdate = @p_startdate,
                                    p_periodtype = @p_periodtype ) as source
   inner join i_product on i_product~product = source~material

   where source~storagelocation in @gr_storagelocation
     and source~material in @gr_material
     and source~plant in @gr_plant
     and source~batch in @gr_batch
     and source~companycode in @gr_bukrs
*    and item~GoodsMovementType <> '311'
   group by source~periodtype,
            source~material,
            source~plant,
            source~storagelocation,
            source~batch,
            source~supplier,
            source~sddocument,
            source~sddocumentitem,
            source~customer,
            source~inventorystocktype,
            source~inventoryspecialstocktype,
            source~fiscalyearvariant,
            source~materialbaseunit
   into table @data(lt_stock_key).

    select
        source~material,
        source~plant,
        source~storagelocation,
        source~batch,
        source~supplier,
        source~sddocument,
        source~sddocumentitem,
        source~customer,
        source~inventorystocktype,
        source~inventoryspecialstocktype,
        source~materialbaseunit,
       sum( currentstock~matlstkincrqtyinmatlbaseunit ) as matlstkincrqtyinmatlbaseunit,
       sum( currentstock~matlstkdecrqtyinmatlbaseunit ) as matlstkdecrqtyinmatlbaseunit
      from  i_materialstock as currentstock
      inner join @lt_stock_key as source on source~material = currentstock~material
                                        and source~plant = currentstock~plant
                                        and source~storagelocation = currentstock~storagelocation
                                        and source~batch = currentstock~batch
                                        and source~supplier = currentstock~supplier
                                        and source~sddocument = currentstock~sddocument
                                        and source~sddocumentitem = currentstock~sddocumentitem
                                        and source~customer = currentstock~customer
                                        and source~inventorystocktype = currentstock~inventorystocktype
                                        and source~inventoryspecialstocktype = currentstock~inventoryspecialstocktype
                                        and currentstock~matldoclatestpostgdate <= @p_enddate
                                        and currentstock~matldoclatestpostgdate >= @p_startdate
    group by  source~material,
              source~plant,
              source~storagelocation,
              source~batch,
              source~supplier,
              source~sddocument,
              source~sddocumentitem,
              source~customer,
              source~inventorystocktype,
              source~inventoryspecialstocktype,
              source~materialbaseunit
   order by   source~material,
              source~plant,
              source~storagelocation,
              source~batch,
              source~supplier,
              source~sddocument,
              source~sddocumentitem,
              source~customer,
              source~inventorystocktype,
              source~inventoryspecialstocktype,
              source~materialbaseunit
   into table @data(lt_currentstock).


    select
        source~yearperiod,
        source~material,
        i_product~productoldid,
        source~plant,
        source~storagelocation,
        source~batch,
        source~supplier,
        source~sddocument,
        source~sddocumentitem,
        source~customer,
        source~inventorystocktype,
        source~inventoryspecialstocktype,
        source~fiscalyearvariant,
        source~materialbaseunit,
        source~companycode,
        source~matlwrhsstkqtyinmatlbaseunit as closingstock,
        i_product~producttype,
        item~GoodsMovementType,
        opening~matlwrhsstkqtyinmatlbaseunit as openingstock,
        batchcharc~\_batchncc-charcvalue as batchncc,
        batchcharc~\_hansudung-charcfromdate as hansudung,
        batchcharc~\_ngaynhapkho-charcfromdate as ngaynhapkho,
        batchcharc~\_ngaysanxuat-charcfromdate as ngaysanxuat,
        batchcharc~\_asn-charcvalue as asn,
        batchcharc~\_ghichu-charcvalue as ghichu,
        batchcharc~\_grn-charcvalue as grn,
        i_producttypetext~materialtypename as producttypename,
        i_batch~supplier as supplierofbatch,
        supplierofbatchinfo~supplierfullname as supplierofbatchname,
        companycodeinfo~name as companycodename,
        storagelocationinfo~storagelocationname
    from i_materialstocktimeseries( p_enddate = @p_enddate,
                                    p_startdate = @p_startdate,
                                    p_periodtype = @p_periodtype ) as source
    inner join @lt_stock_key as stock_ekey on source~periodtype = stock_ekey~periodtype
    and source~enddate = stock_ekey~enddate
    and source~material = stock_ekey~material
    and source~plant = stock_ekey~plant
    and source~storagelocation = stock_ekey~storagelocation
    and source~batch = stock_ekey~batch
    and source~supplier = stock_ekey~supplier
    and source~sddocument = stock_ekey~sddocument
    and source~sddocumentitem = stock_ekey~sddocumentitem
    and source~customer = stock_ekey~customer
    and source~inventorystocktype = stock_ekey~inventorystocktype
    and source~inventoryspecialstocktype = stock_ekey~inventoryspecialstocktype
    and source~fiscalyearvariant = stock_ekey~fiscalyearvariant
    inner join i_product on i_product~product = source~material
    left outer join I_materialdocumentItem_2  as item on  item~Material = source~Material
                                        and item~Plant    = source~Plant
                                       and item~Batch    = source~Batch
                                        and item~StorageLocation = source~StorageLocation
    left join i_producttypetext  on i_producttypetext~producttype = i_product~producttype
    and i_producttypetext~language = @sy-langu
    left join i_batch on i_batch~material = source~material
    and i_batch~plant = source~plant
    and i_batch~batch = source~batch
    left join zi_batch_charc as batchcharc on batchcharc~batch = source~batch
    and batchcharc~plant = source~plant
    and batchcharc~material = source~material
    left join zcore_i_profile_supplier as supplierofbatchinfo on supplierofbatchinfo~supplier = i_batch~supplier
    left join zcore_i_profile_companycode as companycodeinfo on companycodeinfo~companycode = source~companycode
    left join i_storagelocation as storagelocationinfo on source~storagelocation = storagelocationinfo~storagelocation
    and source~plant = storagelocationinfo~plant
    left join i_materialstocktimeseries( p_enddate = @lv_lastdateofprevper,
    p_startdate = @lv_lastdateofprevper,
    p_periodtype = 'Y' ) as opening on source~material = opening~material
                                  and source~plant = opening~plant
                                  and source~storagelocation = opening~storagelocation
                                  and source~batch = opening~batch
                                  and source~supplier = opening~supplier
                                  and source~sddocument = opening~sddocument
                                  and source~sddocumentitem = opening~sddocumentitem
                                  and source~customer = opening~customer
                                  and source~inventorystocktype = opening~inventorystocktype
                                  and source~inventoryspecialstocktype = opening~inventoryspecialstocktype
    where source~storagelocation in @gr_storagelocation
    and source~material in @gr_material
    and source~plant in @gr_plant
    and source~batch in @gr_batch
    and source~companycode in @gr_bukrs
    and i_product~producttype in @gr_mtart
    and batchcharc~\_hansudung-charcfromdate in @gr_hansudung
    and batchcharc~\_batchncc-charcvalue in @gr_batchncc
    and item~GoodsMovementType <> '311'
    into corresponding fields of table @gt_data.

    select
        inventoryamt~material,
        inventoryamt~valuationarea,
        i_batch~batch,
        inventoryamt~valuationtype,
        inventoryamt~companycodecurrency,
        inventoryamt~amountincompanycodecurrency,
        inventoryamt~valuationquantity
    from @lt_stock_key as stock_key
    inner join i_batch on i_batch~material =  stock_key~material
                      and i_batch~plant =  stock_key~plant
                      and i_batch~batch =  stock_key~batch
    inner join i_inventoryamtbyfsclperd( p_fiscalperiod = @p_startperiod,
                                         p_fiscalyear =  @p_fiscalyear ) as inventoryamt
                                       on inventoryamt~material = i_batch~material
                                      and inventoryamt~valuationarea = i_batch~plant
                                      and inventoryamt~valuationtype = i_batch~inventoryvaluationtype
    order by inventoryamt~material,
             inventoryamt~valuationarea,
             i_batch~batch
    into table @data(lt_inventoryamount).


    loop at gt_data reference into data(ls_data) .

      read table lt_currentstock reference into data(ls_currentstock)
      with key material                  = ls_data->material
               plant                     = ls_data->plant
               storagelocation           = ls_data->storagelocation
               batch                     = ls_data->batch
               supplier                  = ls_data->supplier
               sddocument                = ls_data->sddocument
               sddocumentitem            = ls_data->sddocumentitem
               customer                  = ls_data->customer
               inventorystocktype        = ls_data->inventorystocktype
               inventoryspecialstocktype = ls_data->inventoryspecialstocktype
               materialbaseunit          = ls_data->materialbaseunit binary search.
      if sy-subrc = 0.
        ls_data->totalissuequantity = ls_currentstock->matlstkdecrqtyinmatlbaseunit.
        ls_data->totalreceiptquantity = ls_currentstock->matlstkincrqtyinmatlbaseunit.
      endif.

      read table lt_inventoryamount reference into data(ls_inventoryamount)
      with key material = ls_data->material
               valuationarea = ls_data->plant
               batch = ls_data->batch binary search.
      if sy-subrc = 0.
        ls_data->movingaverageprice = ls_inventoryamount->amountincompanycodecurrency / ls_inventoryamount->valuationquantity.
        ls_data->totalissuevalues   = ls_data->totalissuequantity * ( ls_inventoryamount->amountincompanycodecurrency / ls_inventoryamount->valuationquantity ).
        ls_data->totalreceiptvalues = ls_data->totalreceiptquantity * ( ls_inventoryamount->amountincompanycodecurrency / ls_inventoryamount->valuationquantity ).
        ls_data->openingvalue       = ls_data->openingstock * ( ls_inventoryamount->amountincompanycodecurrency / ls_inventoryamount->valuationquantity ).
        ls_data->closingvalue       = ls_data->closingstock * ( ls_inventoryamount->amountincompanycodecurrency / ls_inventoryamount->valuationquantity ).
        ls_data->currencyprice      = ls_inventoryamount->companycodecurrency.
        ls_data->valuationtype      = ls_inventoryamount->valuationtype.
      endif.

      if p_displaymahuy = abap_false.
        if ls_data->producttype = 'M97'.
          ls_data->material = ls_data->productoldid.
        endif.
      endif.
    endloop.
    DATA: lv_index TYPE sy-tabix.

DO lines( gt_data ) TIMES.
  lv_index = lines( gt_data ) - sy-tabix + 1.
  READ TABLE gt_data INDEX lv_index REFERENCE INTO DATA(ls_data1).
  IF sy-subrc = 0.
    IF ls_data1->storagelocation = '1003'.
      DELETE gt_data INDEX lv_index.
    ENDIF.
  ENDIF.
ENDDO.
  endmethod.


  method get_tabname.
    data: lv_field type string.
    lv_field = |{ fieldname case = upper }|.
    case lv_field.
      when 'YEARPERIOD'.
        tabname = 'source~yearperiod'.

      when 'MATERIAL'.
        tabname = 'source~material'.

      when 'PRODUCTOLDID'.
        tabname = 'i_product~productoldid'.

      when 'PLANT'.
        tabname = 'source~plant'.

      when 'STORAGELOCATION'.
        tabname = 'source~storagelocation'.

      when 'BATCH'.
        tabname = 'source~batch'.

      when 'SUPPLIER'.
        tabname = 'source~supplier'.

      when 'SDDOCUMENT'.
        tabname = 'source~sddocument'.

      when 'SDDOCUMENTITEM'.
        tabname = 'source~sddocumentitem'.

      when 'CUSTOMER'.
        tabname = 'source~customer'.

      when 'INVENTORYSTOCKTYPE'.
        tabname = 'source~inventorystocktype'.

      when 'INVENTORYSPECIALSTOCKTYPE'.
        tabname = 'source~inventoryspecialstocktype'.

      when 'FISCALYEARVARIANT'.
        tabname = 'source~fiscalyearvariant'.

      when 'MATERIALBASEUNIT'.
        tabname = 'source~materialbaseunit'.

      when 'COMPANYCODE'.
        tabname = 'source~companycode'.

      when 'CLOSINGSTOCK'.
        tabname = 'source~matlwrhsstkqtyinmatlbaseunit'.

      when 'PRODUCTTYPE'.
        tabname = 'i_product~producttype'.
      when 'OPENINGSTOCK'.
        tabname = 'opening~matlwrhsstkqtyinmatlbaseunit'.
      when 'BATCHNCC'.
        tabname = 'batchcharc~\_batchncc-charcvalue'.
      when 'HANSUDUNG'.
        tabname = 'batchcharc~\_hansudung-charcfromdate'.
      when 'NGAYNHAPKHO'.
        tabname = 'batchcharc~\_ngaynhapkho-charcfromdate'.
      when 'NGAYSANXUAT'.
        tabname = 'batchcharc~\_ngaysanxuat-charcfromdate'.
      when 'ASN'.
        tabname = 'batchcharc~\_asn-charcvalue'.
      when 'GHICHU'.
        tabname = 'batchcharc~\_ghichu-charcvalue'.
      when 'GRN'.
        tabname = 'batchcharc~\_grn-charcvalue'.
      when 'PRODUCTTYPENAME'.
        tabname = 'i_producttypetext~MaterialTypeName'.
      when 'SUPPLIEROFBATCH'.
        tabname = 'i_batch~Supplier'.
      when 'SUPPLIEROFBATCHNAME'.
        tabname = 'supplierofbatchinfo~SupplierFullName'.

      when 'COMPANYCODENAME'.
        tabname = 'companycodeinfo~name'.

      when 'STORAGELOCATIONNAME'.
        tabname = 'storagelocationinfo~StorageLocationName'.

    endcase.
  endmethod.


  method if_rap_query_provider~select.

    data: lv_sort_string type string,
          lv_grouping    type string.
    data(lv_top)           = io_request->get_paging( )->get_page_size( ).
    data(lv_skip)          = io_request->get_paging( )->get_offset( ).
    data(lv_max_rows) = cond #( when lv_top = if_rap_query_paging=>page_size_unlimited then 0
                                else lv_top ).
    if lv_max_rows = -1 .
      lv_max_rows = 1.
    endif.

    data(lt_sort)          = io_request->get_sort_elements( ).
    data(lt_sort_criteria) = value string_table( for sort_element in lt_sort
                                                     ( sort_element-element_name && cond #( when sort_element-descending = abap_true
                                                                                            then ` descending`
                                                                                            else ` ascending` ) ) ).
    data(lv_defautl) = 'PeriodType, EndDate, YearPeriod, Material, Plant, StorageLocation, Batch, Supplier, SDDocument, SDDocumentItem, Customer,InventoryStockType,InventorySpecialStockType,MaterialBaseUnit,FiscalYearVariant'.
    lv_sort_string  = cond #( when lt_sort_criteria is initial then lv_defautl
                                else concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).


    data(lt_req_elements) = io_request->get_requested_elements( ).

    data(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).
    if lt_aggr_element is not initial.
      loop at lt_aggr_element assigning field-symbol(<fs_aggr_element>).
        delete lt_req_elements where table_line = <fs_aggr_element>-result_element.
        data(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
        append lv_aggregation to lt_req_elements.
      endloop.
    endif.

    data(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).

    data(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    lv_grouping = concat_lines_of(  table = lt_grouped_element sep = `, ` ).


*-----parameters and filters
    data(lt_parameter)     = io_request->get_parameters( ).
    loop at lt_parameter reference into data(ls_parameter).
      case ls_parameter->parameter_name.
        when 'P_STARTDATE'.
          p_startdate = ls_parameter->value .
          p_startperiod = |{ p_startdate+4(2) alpha = in }|.
        when 'P_ENDDATE'.
          p_enddate = ls_parameter->value .
        when 'P_PERIODTYPE'.
          p_periodtype = ls_parameter->value .
        when 'P_FISCALYEAR'.
          p_fiscalyear = ls_parameter->value .
      endcase.
    endloop.

    try.
        data(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      catch cx_rap_query_filter_no_range into data(lx_no_sel_option).
    endtry.
    loop at lt_filter_cond reference into data(ls_filter_cond).
      if ls_filter_cond->name = |{ 'StorageLocation' case = upper }|.
        gr_storagelocation = corresponding #( ls_filter_cond->range[] ).

      elseif  ls_filter_cond->name = |{ 'Material' case = upper }|.
        gr_material = corresponding #( ls_filter_cond->range[] ).

      elseif  ls_filter_cond->name = |{ 'Plant' case = upper }|.
        gr_plant = corresponding #( ls_filter_cond->range[] ).

      elseif  ls_filter_cond->name = |{ 'Batch' case = upper }|.
        gr_batch = corresponding #( ls_filter_cond->range[] ).

      elseif  ls_filter_cond->name = |{ 'CompanyCode' case = upper }|.
        gr_bukrs = corresponding #( ls_filter_cond->range[] ).

      elseif ls_filter_cond->name = |{ 'ProductType' case = upper }|.
        gr_mtart = corresponding #( ls_filter_cond->range[] ).

      elseif ls_filter_cond->name = |{ 'HanSuDung' case = upper }|.
        gr_hansudung = corresponding #( ls_filter_cond->range[] ).

      elseif ls_filter_cond->name = |{ 'ValuationType' case = upper }|.
        gr_valuationtype = corresponding #( ls_filter_cond->range[] ).

      elseif ls_filter_cond->name = |{ 'BatchNCC' case = upper }|.
        gr_batchncc = corresponding #( ls_filter_cond->range[] ).

      elseif ls_filter_cond->name = |{ 'DISPLAYMAHUY' case = upper }|.
        if  ls_filter_cond->range[ 1 ]-low = 'true'.
          p_displaymahuy = 'X'.
        else.
          p_displaymahuy = ''.
        endif.

      endif.
    endloop.
*// TR
    if lv_grouping is not initial and lv_sort_string ne lv_grouping.
      lv_sort_string = lv_grouping.
    endif.

    get_data( ).
    "offset by required order by
    data: lt_response like gt_data.
    select (lv_req_elements) from @gt_data as data
            group by (lv_grouping)
            order by (lv_sort_string)
            into corresponding fields of table @lt_response
            offset @lv_skip up to @lv_max_rows rows.
    io_response->set_total_number_of_records( lines( gt_data ) ).
    io_response->set_data( lt_response ).

  endmethod.


  method is_calculation_field.
    data: lv_field type string.
    lv_field = |{ fieldname case = upper }|.
    case  lv_field.
      when 'TOTALRECEIPTVALUES'
        or 'TOTALISSUEVALUES'
        or 'CLOSINGVALUE'
        or 'OPENINGVALUE'
        or 'TOTALRECEIPTQUANTITY'
        or 'VALUATIONAREA'
        or 'VALUATIONTYPE'
        or 'CURRENCYPRICE'
        or 'MOVINGAVERAGEPRICE'
        or 'TOTALISSUEQUANTITY'.
        is_true = abap_true.
      when others.
        is_true = abap_false.
    endcase.
  endmethod.
ENDCLASS.
