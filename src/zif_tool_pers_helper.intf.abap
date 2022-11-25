interface ZIF_TOOL_PERS_HELPER
  public .


  types:
    BEGIN OF change_s .
  TYPES fieldname TYPE fieldname.
  TYPES oldvalue TYPE cdfldvalo .
  TYPES newvalue TYPE cdfldvaln .
  TYPES :END OF change_s .
  types:
    change_tt TYPE STANDARD TABLE OF change_s WITH KEY fieldname .
  types:
    abap_parmbind_tt TYPE STANDARD TABLE OF abap_parmbind WITH KEY name .

  data GT_FIELDS type DDFIELDS read-only .
  data GT_MAPP type OSMA_INF_TAB read-only .
  data GT_METHOD type ABAP_METHDESCR_TAB read-only .
  data GO_PERS type ref to OBJECT read-only .

  "!<h1> Set operation for all the attribute</h1>
  "! @parameter is_structure | Structure of the table with value
  "! @raising cx_os_object | persistent exception
  "! <h2> Example for create </h2>
  "!<p>  DATA: lo_tx         TYPE REF TO if_os_transaction.
  "!<p> lo_tx = me->go_tx_manager->create_transaction( ).
  "!<p>
  "!<p>  TRY.
  "!<p>    lo_tx->start( ).
  "!<p>
  "!<p>      CALL METHOD me->go_agent->create_persistent
  "!<p>      EXPORTING
  "!<p>         i_requnum = lv_number
  "!<p>       RECEIVING
  "!<p>         result    = me->go_pers.
  "!<p>*get the component
  "!<p>      me->go_help->set( EXPORTING io_pers = me->go_pers
  "!<p>                                 is_structure = cs_header ).
  "!<p>     lo_tx->end( ).
  "!<p>   CATCH cx_os_error.
  "!<p>     lo_tx->undo( ).
  "!<p>ENDTRY.
  methods SET
    importing
      !IS_STRUCTURE type ANY
    returning
      value(RT_CHANGE) type CHANGE_TT
    raising
      CX_OS_OBJECT .
  "!<h1> Get operation</h1>
  "! @parameter cs_structure | structure empty sent back with value
  "! @raising cx_os_object | persistent exception
  "!<h2>Example for read</h2>
  "! <p>     DATA: lo_tx         TYPE REF TO if_os_transaction.
  "!<p>    *get the persistent class
  "!<p>        IF me->go_pers IS BOUND.
  "!<p>          lo_tx = me->go_tx_manager->create_transaction( ).
  "!<p>
  "!<p>          TRY.
  "!<p>             lo_tx->start( ).
  "!<p>              me->go_help->get( EXPORTING io_pers = me->go_pers
  "!<p>                                CHANGING cs_structure = rs_header ).
  "!<p>              lo_tx->end( ).
  "!<p>           CATCH cx_os_error.
  "!<p>              lo_tx->undo( ).
  "!<p>         ENDTRY.
  "!<p>       ENDIF.
  methods GET
    changing
      value(CS_STRUCTURE) type ANY
    raising
      CX_OS_OBJECT .

endinterface.
