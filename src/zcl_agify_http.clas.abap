class ZCL_AGIFY_HTTP definition
  public
  final
  create private .

public section.

  types:
    begin of TS_AGIFY ,
         name type AD_NAMEFIR,
         country_id type land1,
         age type agex,
        count type i,
    end of TS_AGIFY .
  types:
    tt_agify type STANDARD TABLE OF ts_agify
      with key name country_id .

  data MT_RESULT type TT_AGIFY read-only .

  class-methods GET_INSTANCE
    returning
      value(RO_CLASS) type ref to ZCL_AGIFY_HTTP .
  methods MAIN
    importing
      !IV_COUNTRY_ID type LAND1 optional
      !IT_FIRSTNAME type GHO_TT_FC_SEL_NAME
    returning
      value(RT_DATA) type TT_AGIFY .
protected section.
private section.

  constants C_URL_BASE type STRING value 'api.agify.io' ##NO_TEXT.
  data MO_CLIENT type ref to IF_HTTP_CLIENT .
  data MV_QUERY type STRING .

  methods CONSTRUCTOR .
  methods SET_COUNTRY
    importing
      !IV_COUNTRY_ID type LAND1
    returning
      value(RV_STRING) type STRING .
  methods SEND_REQUEST .
  methods GET_RESPONSE .
  methods JSON2ABAP
    importing
      !IV_JSON type STRING .
ENDCLASS.



CLASS ZCL_AGIFY_HTTP IMPLEMENTATION.


  METHOD constructor.

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


  METHOD get_response.
    DATA(lv_json) = me->mo_client->response->get_cdata( ).

     me->json2abap( lv_json ).
  ENDMETHOD.


  method JSON2ABAP.
    data : ls_table type Ts_AGIFY.
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
       data             = ls_table
   ).

   append  ls_table to me->mt_result.
  endmethod.


  METHOD main.
    DATA : lv_country TYPE string.
    CLEAR mt_result..
    LOOP AT it_firstname INTO DATA(ls_firstname).
      DATA(lv_parameter) = |name={ ls_firstname-low }|.

      IF iv_country_id IS NOT INITIAL.
        lv_country = me->set_country( iv_country_id ).
        lv_parameter = |{ lv_parameter }&{ lv_country }|.
      ENDIF.

      me->mv_query = |/?{ lv_parameter }|.

      TRY.
          me->send_request( ).
          me->get_response( ).

      ENDTRY.
    ENDLOOP.
    rt_data = mt_result.
  ENDMETHOD.


  METHOD send_request.
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


  METHOD set_country.
    rv_string = |country_id={ iv_country_id }|.
  ENDMETHOD.
ENDCLASS.
