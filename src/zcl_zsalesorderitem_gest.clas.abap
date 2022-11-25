class ZCL_ZSALESORDERITEM_GEST definition
  public
  final
  create public .

public section.

  interfaces ZIF_ZSALESORDERITEM_GEST .

  aliases CREATE
    for ZIF_ZSALESORDERITEM_GEST~CREATE .
  aliases DELETE
    for ZIF_ZSALESORDERITEM_GEST~DELETE .
  aliases READ
    for ZIF_ZSALESORDERITEM_GEST~READ .
  aliases UPDATE
    for ZIF_ZSALESORDERITEM_GEST~UPDATE .

  methods CONSTRUCTOR
    importing
      !IO_PERS type ref to ZCL_ZSALESORDERITEM_PERS optional .
protected section.
private section.

  data MO_HELP type ref to ZIF_TOOL_PERS_HELPER .
  data MO_TX_MANAGER type ref to IF_OS_TRANSACTION_MANAGER .
  data MO_AGENT type ref to ZCA_ZSALESORDERITEM_PERS .
  data MO_PERS type ref to ZCL_ZSALESORDERITEM_PERS .

  methods GET_PERS
    importing
      !IS_STRUCTURE type ZSALESORDERITEM
      !IV_CREATE type ABAP_BOOL default ABAP_FALSE
    raising
      CX_OS_OBJECT_NOT_FOUND
      CX_OS_OBJECT_EXISTING .
  methods GET_HELPER .
ENDCLASS.



CLASS ZCL_ZSALESORDERITEM_GEST IMPLEMENTATION.


  METHOD constructor.
    CONSTANTS : lc_class TYPE seoclskey VALUE 'ZCL_ZSALESORDERITEM_PERS'.

    me->mo_agent =  zca_zsalesorderitem_pers=>agent.
    me->mo_tx_manager = cl_os_system=>get_transaction_manager( ).

    IF io_pers IS BOUND.
      me->mo_pers = io_pers.
    ENDIF.

  ENDMETHOD.


  METHOD get_helper.
    CONSTANTS : lc_table TYPE tabname16 VALUE 'ZSALESORDERITEM'.
    IF me->mo_help IS NOT BOUND.
      me->mo_help = NEW zcl_tool_pers_helper(  iv_name = lc_table
                                                 io_pers =  me->mo_pers
                                          ).
    ENDIF.

  ENDMETHOD.


  METHOD get_pers.
    IF me->mo_pers IS NOT BOUND.
      TRY.
          CALL METHOD me->mo_agent->get_persistent
            EXPORTING
              i_salesorder     = is_structure-salesorder
              i_salesorderitem = is_structure-salesorderitem
            RECEIVING
              result           = me->mo_pers.

          IF iv_create EQ abap_true.
            RAISE EXCEPTION TYPE cx_os_object_existing.
          ENDIF.
        CATCH cx_os_object_not_found.

          CALL METHOD me->mo_agent->create_persistent
            EXPORTING
              i_salesorder     = is_structure-salesorder
              i_salesorderitem = is_structure-salesorderitem
            RECEIVING
              result           = me->mo_pers.

      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD zif_zsalesorderitem_gest~create.
    DATA: lo_tx         TYPE REF TO if_os_transaction.
*    cs_structure-uuid = cl_system_uuid=>create_uuid_x16_static( ).

    lo_tx = me->mo_tx_manager->create_transaction( ).

    TRY.
        lo_tx->start( ).
        IF me->mo_pers  IS NOT BOUND.
          me->get_pers( EXPORTING is_structure = cs_structure
                                  iv_create = abap_true ).
        ENDIF.
*Check helper
        IF me->mo_help IS NOT BOUND.
          me->get_helper( ).
        ENDIF.
*get the component

        DATA(lt_change) = me->mo_help->set( EXPORTING  is_structure = cs_structure ).
        lo_tx->end( ).
      CATCH cx_os_object_not_found.
        lo_tx->undo( ).
        RAISE EXCEPTION TYPE cx_os_error.
      CATCH cx_os_error.
        lo_tx->undo( ).
        RAISE EXCEPTION TYPE cx_os_error.
    ENDTRY.


  ENDMETHOD.


  METHOD ZIF_ZSALESORDERITEM_GEST~DELETE.
    DATA: lo_tx         TYPE REF TO if_os_transaction.

    "get the persistent class
    IF me->mo_pers IS NOT BOUND
      AND is_structure IS NOT INITIAL.
      me->get_pers( is_structure ).
    ENDIF.

    IF me->mo_pers IS BOUND.
      lo_tx = me->mo_tx_manager->create_transaction( ).

      TRY.
          lo_tx->start( ).
          me->mo_agent->if_os_factory~delete_persistent( EXPORTING i_object = me->mo_pers ).
          lo_tx->end( ).
        CATCH cx_os_error.
          lo_tx->undo( ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD zif_zsalesorderitem_gest~read.
    DATA: lo_tx         TYPE REF TO if_os_transaction.

*get the persistent class
    IF me->mo_pers IS NOT BOUND
      AND is_structure IS NOT INITIAL.
      me->get_pers( is_structure ).
    ENDIF.

    IF me->mo_pers IS BOUND.
      lo_tx = me->mo_tx_manager->create_transaction( ).

      TRY.
          lo_tx->start( ).
          "Check helper
          IF me->mo_help IS NOT BOUND.
            me->get_helper( ).
          ENDIF.
          me->mo_help->get( CHANGING cs_structure = rs_structure ).
          lo_tx->end( ).
        CATCH cx_os_error.
          lo_tx->undo( ).
          RAISE EXCEPTION TYPE cx_os_error.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD zif_zsalesorderitem_gest~update.
    DATA: lo_tx         TYPE REF TO if_os_transaction.
    lo_tx = me->mo_tx_manager->create_transaction( ).

    TRY.
        lo_tx->start( ).
* get the persistent class
        IF me->mo_pers  IS NOT BOUND.
          me->get_pers( cs_structure ).
        ENDIF.
*Check helper
        IF me->mo_help IS NOT BOUND.
          me->get_helper( ).
        ENDIF.
**get the component
        DATA(lt_change) = me->mo_help->set( EXPORTING is_structure = cs_structure ).
        lo_tx->end( ).
      CATCH cx_os_error.
        lo_tx->undo( ).
        RAISE EXCEPTION TYPE cx_os_error.
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
