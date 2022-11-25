class ZCL_AGIFY_APP definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_COUNTRY_ID type LAND1
      !IT_FIRSTNAME type GHO_TT_FC_SEL_NAME .
  methods MAIN .
protected section.
private section.

  data MT_DATA type ZCL_AGIFY_HTTP=>TT_AGIFY .
  data MV_COUNTRY_ID type LAND1 .
  data MT_FIRSTNAME type GHO_TT_FC_SEL_NAME .

  methods DISPLAY .
  methods GET_HTTP .
  methods ON_CLICK
    for event LINK_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !ROW
      !COLUMN .
ENDCLASS.



CLASS ZCL_AGIFY_APP IMPLEMENTATION.


  method CONSTRUCTOR.
    me->mt_firstname = it_firstname.
    me->mv_country_id = iv_country_id.
  endmethod.


  METHOD display.
    DATA: lo_table     TYPE REF TO cl_salv_table,
          lo_functions TYPE REF TO cl_salv_functions,
          lo_column    TYPE REF TO cl_salv_column_table,
          lo_events    TYPE REF TO cl_salv_events_table,
          lo_columns   TYPE REF TO cl_salv_columns_table,
          lo_display   TYPE REF TO cl_salv_display_settings..

    data : ls_dd04T type dd04T.

    cl_salv_table=>factory( IMPORTING r_salv_table = lo_table
                            CHANGING t_table = me->mt_data
                              ).
    lo_functions = lo_table->get_functions( ).
    lo_functions->set_all( abap_true ).

    " column
    lo_columns = lo_table->get_columns( ).

    lo_column ?= lo_columns->get_column( 'NAME' ).
    lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).

    lo_column ?= lo_columns->get_column( 'COUNT' ).
    select SINGLE * from dd04T into ls_dd04T
                                where ROLLNAME = '/SDF/SMONCNT'
                                and DDLANGUAGE = sy-langu
                                 .
     lo_column->set_medium_text( ls_dd04T-scrtext_m ).
     lo_column->set_long_text( ls_dd04T-scrtext_l ).
     lo_column->set_short_text( ls_dd04T-scrtext_s ).

    lo_display = lo_table->get_display_settings( ).
    lo_display->set_striped_pattern( abap_true ).

    lo_events = lo_table->get_event( ).

    SET HANDLER me->on_click FOR lo_events.

    lo_table->display( ).
  ENDMETHOD.


  METHOD get_http.

    DATA(lo_http) = zcl_agify_http=>get_instance( ).
    me->mt_data = lo_http->main( EXPORTING
                          it_firstname = me->mt_firstname
                          iv_country_id = me->mv_country_id
                           ).

  ENDMETHOD.


  method MAIN.
    me->get_http( ).
    me->display( ).
  endmethod.


  method ON_CLICK.
    READ TABLE  me->mt_data INTO data(ls_data) INDEX ROW.
    CHECK SY-SUBRC = 0.

    CASE COLUMN.
      WHEN 'NAME'.
        data(lo_class) = new ZCL_NATIONALIZE_APP( ls_data-name ).
        lo_class->main( ).
    endcase.
  endmethod.
ENDCLASS.
