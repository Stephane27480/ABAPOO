class ZCL_NATIONALIZE_APP definition
  public
  final
  create public .

public section.

  data MV_FIRSTNAME type AD_NAMEFIR read-only .

  methods CONSTRUCTOR
    importing
      !IV_FIRSTNAME type AD_NAMEFIR .
  methods MAIN .
protected section.
private section.

  data MT_DATA type ZCL_NATIONALIZE_HTTP=>TT_NATIONALIZE .

  methods DISPLAY .
  methods GET_HTTP .
ENDCLASS.



CLASS ZCL_NATIONALIZE_APP IMPLEMENTATION.


  method CONSTRUCTOR.
    me->mv_firstname = iv_firstname.
  endmethod.


  METHOD display.
    DATA: lo_table     TYPE REF TO cl_salv_table,
          lo_functions TYPE REF TO cl_salv_functions,
          lo_display   TYPE REF TO cl_salv_display_settings,
          lo_column    TYPE REF TO cl_salv_column_table,
          lo_columns   TYPE REF TO cl_salv_columns_table.

    DATA : ls_dd04t TYPE dd04t.

    cl_salv_table=>factory( IMPORTING r_salv_table = lo_table
                            CHANGING t_table = me->mt_data
                              ).
    lo_functions = lo_table->get_functions( ).
    lo_functions->set_all( abap_true ).

    " column
    lo_columns = lo_table->get_columns( ).
    lo_column ?= lo_columns->get_column( 'PROBABILITY' ).
    SELECT SINGLE * FROM dd04t INTO ls_dd04t
                                WHERE rollname = 'COMT_PROBABILITY'
                                AND ddlanguage = sy-langu
                                 .
    lo_column->set_medium_text( ls_dd04t-scrtext_m ).
    lo_column->set_long_text( ls_dd04t-scrtext_l ).
    lo_column->set_short_text( ls_dd04t-scrtext_s ).

    lo_display = lo_table->get_display_settings( ).
    lo_display->set_striped_pattern( abap_true ).
    lo_table->display( ).
  ENDMETHOD.


  method GET_HTTP.

    data(lo_http) = ZCL_NATIONALIZE_HTTP=>get_instance( ).
    me->mt_data = lo_http->main( me->mv_firstname ).

  endmethod.


  method MAIN.
    me->get_http( ).
    me->display( ).
  endmethod.
ENDCLASS.
