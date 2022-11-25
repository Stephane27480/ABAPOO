CLASS zcl_nationalize_http DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ts_nationalize ,
        "3name        TYPE ad_namefir,
        country_id  TYPE land1,
        landx       TYPE landx,
        probability TYPE string,
      END OF ts_nationalize .
    TYPES:
      tt_nationalize TYPE STANDARD TABLE OF ts_nationalize
        WITH KEY  country_id .
    TYPES : BEGIN OF ts_result ,
              country TYPE tt_nationalize,
              name    TYPE ad_namefir,
            END OF ts_result.

    DATA mt_result TYPE tt_nationalize READ-ONLY .

    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_class) TYPE REF TO zcl_nationalize_http .
    METHODS main
      IMPORTING
        !iv_firstname  TYPE ad_namefir
      RETURNING
        VALUE(rt_data) TYPE tt_nationalize .
protected section.
private section.

  constants C_URL_BASE type STRING value 'api.nationalize.io' ##NO_TEXT.
  data MO_CLIENT type ref to IF_HTTP_CLIENT .
  data MV_QUERY type STRING .

  methods CONSTRUCTOR .
  methods SEND_REQUEST .
  methods GET_RESPONSE .
  methods JSON2ABAP
    importing
      !IV_JSON type STRING .
  methods GET_LANDX .
ENDCLASS.



CLASS ZCL_NATIONALIZE_HTTP IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    cl_http_client=>create(
     EXPORTING
       host               = me->c_url_base
*    service            =
*    proxy_host         =
*    proxy_service      =
   scheme             = cl_http_client=>schemetype_https
*    ssl_id             =
*    sap_username       =
*    sap_client         =
     IMPORTING
       client             = me->mo_client
     EXCEPTIONS
       argument_not_found = 1
       plugin_not_active  = 2
       internal_error     = 3
       OTHERS             = 4
          ).
  ENDMETHOD.


  method GET_INSTANCE.

    CREATE OBJECT ro_class.

  endmethod.


  method GET_LANDX.
    FIELD-SYMBOLS : <fs_data> type TS_NATIONALIZE.

    loop at me->mt_result ASSIGNING <fs_data>.
      select SINGLE landx from  T005T
                          into <fs_data>-landx
                          Where SPRAS = sy-langu
                          and land1 = <fs_data>-country_id
                          .
    endloop.
  endmethod.


  METHOD GET_RESPONSE.
    DATA(lv_json_temp) = me->mo_client->response->get_cdata( ).
    data(lv_temp) = me->mo_client->response->GET_RAW_MESSAGE( ).
    data(lv_json) = me->mo_client->response->get_data( ).

    data(lv_string) = /ui2/CL_json=>RAW_TO_STRING( lv_temp ).
     me->json2abap( lv_json_temp ).
  ENDMETHOD.


  METHOD json2abap.
    DATA : lt_table TYPE tt_nationalize.
    DATA : ls_result TYPE ts_result.
    /ui2/cl_json=>deserialize(
      EXPORTING
         json             = iv_json
*       jsonx            = iv_json
         pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
*       assoc_arrays     =
*       assoc_arrays_opt =
*       name_mappings    =
*       conversion_exits =
      CHANGING
        data             = ls_result
    ).

    APPEND  LINES OF ls_result-country TO me->mt_result.
    me->get_landx( ).
  ENDMETHOD.


  METHOD MAIN.
    DATA : lv_country TYPE string.
    CLEAR mt_result..

      DATA(lv_parameter) = |name={ iv_firstname }|.

      me->mv_query = |/?{ lv_parameter }|.

      TRY.
          me->send_request( ).
          me->get_response( ).

      ENDTRY.

    rt_data = mt_result.
  ENDMETHOD.


  METHOD SEND_REQUEST.
    " Set the query
    cl_http_utility=>set_request_uri(
      request = me->mo_client->request
      uri     = me->mv_query ).


* Send the request and catch the error
    TRY.
        me->mo_client->request->set_method( 'GET' ).

        me->mo_client->send(
*  EXPORTING
*    timeout                    = CO_TIMEOUT_DEFAULT
          EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2
            http_processing_failed     = 3
            http_invalid_timeout       = 4
            OTHERS                     = 5
               ).

    ENDTRY.
* Get the response
    TRY.
        me->mo_client->receive(
          EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2
            http_processing_failed     = 3
            OTHERS                     = 4
               ).

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
