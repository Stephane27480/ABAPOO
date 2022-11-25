class ZCL_ZSALESORDER_BUSINESS definition
  public
  final
  create public .

public section.

  types:
    tt_zsalesorderitem TYPE STANDARD TABLE OF zsalesorderitem
      WITH KEY salesorder salesorderitem .
  types:
    BEGIN OF ts_osalesorderitem,
              salesorder     TYPE vbeln,
              salesorderitem TYPE posnr,
              class          TYPE REF TO zif_zsalesorderitem_gest,
            END OF  ts_osalesorderitem .
  types:
    tt_osalesorderitem TYPE STANDARD TABLE OF ts_osalesorderitem
      WITH KEY salesorder salesorderitem .
  types:
    BEGIN OF ts_osalesorder,
              salesorder TYPE vbeln,
              class      TYPE REF TO zcl_zsalesorder_gest,
            END OF  ts_osalesorder .
  types:
    tt_osalesorder TYPE STANDARD TABLE OF ts_osalesorder
      WITH KEY salesorder .

  methods CONSTRUCTOR .
  methods CREATE
    importing
      !IS_HEADER type ZSALESORDER
      !IT_ITEM type TT_ZSALESORDERITEM
    raising
      ZCX_ZSALESORDER_MSG .
  methods UPDATE
    importing
      !IS_HEADER type ZSALESORDER
      !IT_ITEM type TT_ZSALESORDERITEM
    raising
      CX_OS_ERROR
      ZCX_ZSALESORDER_MSG .
  methods READ
    changing
      !CS_HEADER type ZSALESORDER
    returning
      value(RT_ITEM) type TT_ZSALESORDERITEM
    raising
      CX_OS_ERROR .
  methods DELETE
    importing
      !IS_HEADER type ZSALESORDER
    raising
      CX_OS_ERROR .
protected section.
private section.

  data MS_SALESORDER type TS_OSALESORDER .
  data MT_SALESORDERITEM type TT_OSALESORDERITEM .
  data MO_TX_MANAGER type ref to IF_OS_TRANSACTION_MANAGER .
  data MO_LOG type ref to CL_SWN_LOG .

  methods CREATE_HEADER
    importing
      !IS_HEADER type ZSALESORDER
    raising
      ZCX_ZSALESORDER_MSG
      CX_OS_ERROR .
  methods CREATE_ITEMS
    importing
      !IT_ITEM type TT_ZSALESORDERITEM
    raising
      ZCX_ZSALESORDER_MSG
      CX_OS_ERROR .
  methods UPDATE_ITEMS
    importing
      !IT_ITEM type TT_ZSALESORDERITEM
    raising
      CX_OS_ERROR .
  methods UPDATE_HEADER
    importing
      !IS_HEADER type ZSALESORDER
    raising
      CX_OS_ERROR .
  methods READ_HEADER
    changing
      !CS_HEADER type ZSALESORDER
    raising
      CX_OS_ERROR .
  methods READ_ITEMS
    returning
      value(RT_ITEM) type TT_ZSALESORDERITEM
    raising
      CX_OS_ERROR .
  methods DELETE_HEADER
    importing
      !IS_HEADER type ZSALESORDER
    raising
      CX_OS_ERROR .
  methods DELETE_ITEMS
    raising
      CX_OS_ERROR .
  methods GET_ITEMS
    importing
      !IV_SALESORDER type VBELN .
ENDCLASS.



CLASS ZCL_ZSALESORDER_BUSINESS IMPLEMENTATION.


  METHOD constructor.
    cl_os_system=>init_and_set_modes( EXPORTING i_external_commit = oscon_false ).
    me->mo_tx_manager = cl_os_system=>get_transaction_manager( ).
    mo_log = cl_swn_log=>get_instance( ).
  ENDMETHOD.


  METHOD create.
    DATA: lo_tx         TYPE REF TO if_os_transaction.
    DATA : lv_text TYPE balcval.
    lo_tx = me->mo_tx_manager->create_transaction( ).

    me->mo_log->create_log(
      EXPORTING
        i_object = 'ZABAP100'
        i_subobject = 'SBL'
        ).

    TRY."whole sales order
        lo_tx->start( ).
        me->create_header( is_header ).
        me->create_items( it_item ).
        lo_tx->end( ).
      CATCH cx_os_error.
        lo_tx->undo( ).
        me->mo_log->save_log( ).
        RAISE EXCEPTION TYPE zcx_zsalesorder_msg.
      CATCH zcx_zsalesorder_msg.
        lo_tx->undo( ).
        me->mo_log->save_log( ).
        RAISE EXCEPTION TYPE zcx_zsalesorder_msg.

    ENDTRY.
    lv_text = | Sales Order { is_header-salesorder } créée |.
    me->mo_log->set_message( EXPORTING
                                im_msgty = 'I'
                                im_msgid = 'ZABAP100'
                                im_msgno = 004
                                im_msgv1 = is_header-salesorder
                                ).
    me->mo_log->add_message( EXPORTING
                                    i_probclass = '4'
                                    ).
    me->mo_log->save_log( ).
    "commit work.
  ENDMETHOD.


  METHOD create_header.
    DATA : lo_header TYPE REF TO zcl_zsalesorder_gest.
    DATA : lv_text TYPE balcval.
    IF is_header-salesorder IS NOT INITIAL.
      DATA(ls_header) = is_header.

      lo_header = NEW #( ).
      TRY.
          lo_header->create(
            CHANGING
              cs_structure = ls_header                 " Sales Order Item
          ).
          me->ms_salesorder-salesorder = is_header-salesorder.
          me->ms_salesorder-class = lo_header.
        CATCH cx_os_error.

          lv_text = | Sales Order { is_header-salesorder } non inséré |.
          me->mo_log->set_message( EXPORTING
                      im_msgty = 'E'
                      im_msgid = 'ZABAP100'
                      im_msgno = 000
                      im_msgv1 = is_header-salesorder
                      ).
          me->mo_log->add_message( EXPORTING
                                 i_probclass = '1'
                                 i_context = lv_text
                                 ).
          RAISE EXCEPTION TYPE zcx_zsalesorder_msg.

      ENDTRY.

    ELSE.
      lv_text = | Sales Order pas de numéro |.
      me->mo_log->set_message( EXPORTING
                  im_msgty = 'E'
                  im_msgid = 'ZABAP100'
                  im_msgno = 000
                  im_msgv1 = is_header-salesorder
                  ).
      me->mo_log->add_message( EXPORTING
                             i_probclass = '1'
                             i_context = lv_text
                             ).
      RAISE EXCEPTION TYPE zcx_zsalesorder_msg
        EXPORTING
          textid     = zcx_zsalesorder_msg=>create
          salesorder = CONV #( is_header-salesorder ).
    ENDIF.
  ENDMETHOD.


  METHOD create_items.
    DATA : lo_item TYPE REF TO zcl_zsalesorderitem_gest.
    DATA : ls_oitem  TYPE ts_osalesorderitem.
    DATA : lv_text TYPE balcval.

    LOOP AT it_item INTO DATA(ls_item).
      lo_item = NEW #( ).


      IF ls_item-salesorder IS NOT INITIAL AND
         ls_item-salesorderitem IS NOT INITIAL.
        TRY.
            lo_item->create( CHANGING cs_structure = ls_item ).
          CATCH cx_os_error.
            lv_text = | Sales Order { ls_item-salesorder } poste { ls_item-salesorderitem } ne peut être inséré|.
            me->mo_log->set_message( EXPORTING
              im_msgty = 'E'
              im_msgid = 'ZABAP100'
              im_msgno = 005
              im_msgv1 = ls_item-salesorder
              im_msgv2 = ls_item-salesorderitem
              ).
            me->mo_log->add_message( EXPORTING
                                   i_probclass = '1'
                                   i_context = lv_text
                                   ).
            RAISE EXCEPTION TYPE cx_os_error.
        ENDTRY.
        ls_oitem-salesorder = ls_item-salesorder.
        ls_oitem-salesorderitem = ls_item-salesorderitem.
        ls_oitem-class = lo_item.
        APPEND ls_oitem TO me->mt_salesorderitem.
        CLEAR ls_oitem.
      ELSE.
        lv_text = | Sales Order poste la clée n'est pas complète|.
        me->mo_log->add_text( EXPORTING
                                   i_probclass = '1'
                                   i_text = lv_text
                                   i_context = lv_text
                                   ).

        RAISE EXCEPTION TYPE zcx_zsalesorder_msg
          EXPORTING
            textid     = zcx_zsalesorder_msg=>create
            salesorder = CONV #( ls_item-salesorder ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD delete.
    DATA: lo_tx         TYPE REF TO if_os_transaction.
    DATA : lv_text TYPE balcval.
    lo_tx = me->mo_tx_manager->create_transaction( ).

    TRY.
        lo_tx->start( ).
        me->delete_header( is_header ).
        me->delete_items( ).

        lo_tx->end( ).
      CATCH cx_os_error.
        lo_tx->undo( ).
        me->mo_log->save_log( ).
        RAISE EXCEPTION TYPE cx_os_error.
    ENDTRY.
    lv_text = | Sales Order { is_header-salesorder } supprimée |.
    me->mo_log->set_message( EXPORTING
                         im_msgty = 'I'
                         im_msgid = 'ZABAP100'
                         im_msgno = 008
                         im_msgv1 = is_header-salesorder
                         ).
    me->mo_log->add_message( EXPORTING
                                    i_probclass = '4'
                                    i_context = lv_text
                                    ).
    me->mo_log->save_log( ).
  ENDMETHOD.


  METHOD delete_header.
    DATA : lo_class TYPE REF TO zcl_zsalesorder_gest.
    DATA : lv_text TYPE balcval.
    IF ms_salesorder-class IS BOUND.
      TRY.
          ms_salesorder-class->delete( ).
        CATCH cx_os_error.
          lv_text = | Sales Order { is_header-salesorder } probleme lors de la suppression |.
          me->mo_log->set_message( EXPORTING
                       im_msgty = 'E'
                       im_msgid = 'ZABAP100'
                       im_msgno = 002
                       im_msgv1 = is_header-salesorder
                       ).
          me->mo_log->add_message( EXPORTING
                                 i_probclass = '1'
                                 i_context = lv_text
                                 ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
    ELSE.
      lo_class = NEW #( ).
      lo_class->read( is_header ).
      me->ms_salesorder-class = lo_class.
      me->ms_salesorder-salesorder = is_header-salesorder.
      TRY.
          lo_class->delete( ).
        CATCH cx_os_error.
          lv_text = | Sales Order { is_header-salesorder } probleme lors de la suppression |.
          me->mo_log->add_text( EXPORTING
                                    i_probclass = '4'
                                    i_text = lv_text
                                    i_context = lv_text
                                    ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD delete_items.
    DATA : lv_text TYPE balcval.
    me->get_items( me->ms_salesorder-salesorder ).

    LOOP AT me->mt_salesorderitem INTO DATA(ls_oitem).
      TRY.
          ls_oitem-class->delete( ).

        CATCH cx_os_error.
          lv_text = | Sales Order { ls_oitem-salesorder } poste { ls_oitem-salesorderitem } probleme avec la suppression |.
          me->mo_log->set_message( EXPORTING
           im_msgty = 'E'
           im_msgid = 'ZABAP100'
           im_msgno = 009
           im_msgv1 = ls_oitem-salesorder
           im_msgv2 = ls_oitem-salesorderitem
           ).
          me->mo_log->add_message( EXPORTING
                                 i_probclass = '1'
                                 i_context = lv_text
                                 ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
      CLEAR :  ls_oitem.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_items.
    DATA : agent         TYPE REF TO if_os_ca_persistency,
           query_manager TYPE REF TO if_os_query_manager,
           query         TYPE REF TO if_os_query.

    DATA :lt_osreftab TYPE osreftab,
          lo_object   TYPE REF TO object,
          lo_pers     TYPE REF TO zcl_zsalesorderitem_pers,
          lo_gest     TYPE REF TO zif_zsalesorderitem_gest.
    DATA : ls_item TYPE ts_osalesorderitem.

    IF  me->mt_salesorderitem IS NOT INITIAL.
      CLEAR  me->mt_salesorderitem.
    ENDIF.

    query_manager = cl_os_system=>get_query_manager( ).

    agent = zca_zsalesorderitem_pers=>agent.

    query = query_manager->create_query(
            i_filter = 'SALESORDER = PAR1' ).

    lt_osreftab = agent->get_persistent_by_query(
            i_query = query
            i_par1 = iv_salesorder ).

    LOOP AT lt_osreftab INTO lo_object.
      lo_pers ?= lo_object.
      lo_gest = NEW zcl_zsalesorderitem_gest( lo_pers ).

      ls_item-salesorder = lo_pers->get_salesorder( ).
      ls_item-salesorderitem = lo_pers->get_salesorderitem( ).
      ls_item-class = lo_gest.
      APPEND ls_item TO me->mt_salesorderitem.
    ENDLOOP.
  ENDMETHOD.


  METHOD read.
    DATA: lo_tx         TYPE REF TO if_os_transaction.
    DATA : lv_text TYPE balcval.
    lo_tx = me->mo_tx_manager->create_transaction( ).

    TRY.
        lo_tx->start( ).
        me->read_header( CHANGING cs_header = cs_header ).
        rt_item = me->read_items(  ).
        lo_tx->end( ).
      CATCH cx_os_error.
        lo_tx->undo( ).
        me->mo_log->save_log( ).
        RAISE EXCEPTION TYPE cx_os_error.
    ENDTRY.
    lv_text = | Sales Order { cs_header-salesorder } lue |.
    me->mo_log->set_message( EXPORTING
                            im_msgty = 'I'
                            im_msgid = 'ZABAP100'
                            im_msgno = 010
                            im_msgv1 = cs_header-salesorder
                            ).
    me->mo_log->add_message( EXPORTING
                                    i_probclass = '4'
                                    i_context = lv_text
                                    ).
    me->mo_log->save_log( ).
  ENDMETHOD.


  METHOD read_header.
    DATA : lo_class TYPE REF TO zcl_zsalesorder_gest.
    DATA : lv_text TYPE balcval.
    IF ms_salesorder-class IS BOUND.
      TRY.
          cs_header = ms_salesorder-class->read( cs_header ).
        CATCH cx_os_error.
          lv_text = | Sales Order { cs_header-salesorder } probleme lors de la lecture |.
          me->mo_log->set_message( EXPORTING
                       im_msgty = 'E'
                       im_msgid = 'ZABAP100'
                       im_msgno = 003
                       im_msgv1 = cs_header-salesorder
                       ).
          me->mo_log->add_message( EXPORTING
                                 i_probclass = '1'
                                 i_context = lv_text
                                 ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.

    ELSE.
      lo_class = NEW #( ).
      TRY.
          cs_header = lo_class->read( cs_header ).
        CATCH cx_os_error.
          lv_text = | Sales Order { cs_header-salesorder } probleme lors de la lecture |.
          me->mo_log->add_text( EXPORTING
                                    i_probclass = '4'
                                    i_text = lv_text
                                    i_context = lv_text
                                    ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
      me->ms_salesorder-class = lo_class.
      me->ms_salesorder-salesorder = cs_header-salesorder.
    ENDIF.

  ENDMETHOD.


  METHOD read_items.
    DATA : ls_item TYPE zsalesorderitem.
    DATA : lv_text TYPE balcval.
    me->get_items( me->ms_salesorder-salesorder ).

    LOOP AT me->mt_salesorderitem INTO DATA(ls_oitem).
      TRY.
          ls_item = ls_oitem-class->read( ).
        CATCH cx_os_error.
          lv_text = | Sales Order { ls_oitem-salesorder } poste { ls_oitem-salesorderitem } probleme lors de la lecture |.
          me->mo_log->set_message( EXPORTING
            im_msgty = 'E'
            im_msgid = 'ZABAP100'
            im_msgno = 011
            im_msgv1 = ls_oitem-salesorder
            im_msgv2 = ls_oitem-salesorderitem
            ).
          me->mo_log->add_message( EXPORTING
                                 i_probclass = '1'
                                 i_context = lv_text
                                 ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
      APPEND ls_item TO rt_item.
      CLEAR : ls_item, ls_oitem.
    ENDLOOP.
  ENDMETHOD.


  METHOD update.
    DATA: lo_tx         TYPE REF TO if_os_transaction.
    DATA : lv_text TYPE balcval.
    lo_tx = me->mo_tx_manager->create_transaction( ).

    me->mo_log->create_log(
   EXPORTING
     i_object = 'ZABAP100'
     i_subobject = 'SBL'
     ).

    TRY."whole sales order

        lo_tx->start( ).
        me->update_header( is_header ).
        me->update_items( it_item ).
        lo_tx->end( ).
      CATCH cx_os_error.
        lo_tx->undo( ).
        me->mo_log->save_log( ).
        RAISE EXCEPTION TYPE zcx_zsalesorder_msg.
      CATCH zcx_zsalesorder_msg.
        lo_tx->undo( ).
        me->mo_log->save_log( ).
        RAISE EXCEPTION TYPE zcx_zsalesorder_msg.

    ENDTRY.

    lv_text = | Sales Order { is_header-salesorder } modifiée |.
     me->mo_log->set_message( EXPORTING
                                im_msgty = 'I'
                                im_msgid = 'ZABAP100'
                                im_msgno = 006
                                im_msgv1 = is_header-salesorder
                                ).
    me->mo_log->add_message( EXPORTING
                                    i_probclass = '4'
                                    i_context = lv_text
                                    ).
    me->mo_log->save_log( ).

  ENDMETHOD.


  METHOD update_header.
    DATA : lo_class TYPE REF TO zcl_zsalesorder_gest.
    DATA : lv_text TYPE balcval.
    lo_class = NEW #( ).

    TRY.
        lo_class->update( EXPORTING is_structure = is_header ).
      CATCH cx_os_error.
        lv_text = | Sales Order { is_header-salesorder } |.
        me->mo_log->set_message( EXPORTING
                      im_msgty = 'E'
                      im_msgid = 'ZABAP100'
                      im_msgno = 001
                      im_msgv1 = is_header-salesorder
                      ).
        me->mo_log->add_message( EXPORTING
                               i_probclass = '1'
                               i_context = lv_text
                               ).
        RAISE EXCEPTION TYPE cx_os_error.
    ENDTRY.
  ENDMETHOD.


  METHOD update_items.
    DATA : lo_class TYPE REF TO zcl_zsalesorderitem_gest.
    DATA : lv_text TYPE balcval.

    LOOP AT it_item INTO DATA(ls_item).
      lo_class = NEW #( ).
      TRY.
          lo_class->update( CHANGING cs_structure = ls_item ).

        CATCH cx_os_error.
          lv_text = | Sales Order { ls_item-salesorder } poste { ls_item-salesorderitem } update issue |.
          me->mo_log->set_message( EXPORTING
             im_msgty = 'E'
             im_msgid = 'ZABAP100'
             im_msgno = 007
             im_msgv1 = ls_item-salesorder
             im_msgv2 = ls_item-salesorderitem
             ).
          me->mo_log->add_message( EXPORTING
                                 i_probclass = '1'
                                 i_context = lv_text
                                 ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
