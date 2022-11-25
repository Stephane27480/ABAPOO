CLASS zcl_tool_pers_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_tool_pers_helper .
    ALIASES set FOR zif_tool_pers_helper~set .
    ALIASES get FOR zif_tool_pers_helper~get .
    ALIASES gt_fields FOR zif_tool_pers_helper~gt_fields .
    ALIASES gt_mapp FOR zif_tool_pers_helper~gt_mapp .
    ALIASES gt_method FOR zif_tool_pers_helper~gt_method .
    ALIASES go_pers FOR zif_tool_pers_helper~go_pers .
    ALIASES abap_parmbind_tt FOR zif_tool_pers_helper~abap_parmbind_tt.
    ALIASES change_tt FOR zif_tool_pers_helper~change_tt.
    ALIASES change_s FOR zif_tool_pers_helper~change_s.
    "! <h1> constructor</h1>
    "! @parameter iv_name | Name of the structure
    "! @parameter io_pers |Persistent class instanciated
    METHODS constructor
      IMPORTING
        iv_name TYPE tabname16
        io_pers TYPE REF TO object.
  PROTECTED SECTION.

    DATA gv_name TYPE tabname16 .
  PRIVATE SECTION.

    METHODS get_components_without_key
      RETURNING
        VALUE(rt_fields) TYPE ddfields .
    METHODS get_method_name
      IMPORTING
        !iv_field        TYPE name_feld
        !iv_set          TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rv_method) TYPE seocpdname .
    METHODS get_method_parameter
      IMPORTING
        !iv_methname    TYPE abap_methname
      RETURNING
        VALUE(rt_param) TYPE abap_parmbind_tt .
    "! <h1> return the fields changed </h1>
    "! @parameter is_structure | line
    "! @parameter rt_change |fieldname olvalue newvalue
    METHODS changes
      IMPORTING
        !is_structure    TYPE any
      RETURNING
        VALUE(rt_change) TYPE change_tt .
ENDCLASS.



CLASS ZCL_TOOL_PERS_HELPER IMPLEMENTATION.


  METHOD changes.
    DATA : ls_change TYPE change_s.

    FIELD-SYMBOLS : <fs_old>       TYPE any,
                    <fs_new>       TYPE any,
                    <fs_fcat>      TYPE dfies,
                    <fs_structure> TYPE any.
    "provide the good type
    DATA : lr_data TYPE REF TO data.
    CREATE DATA lr_data TYPE (me->gv_name).
    ASSIGN lr_data->* TO <fs_structure>  CASTING TYPE (me->gv_name).
    "get the persisted values
    me->get( CHANGING cs_structure = <fs_structure> ).

    LOOP AT me->gt_fields ASSIGNING <fs_fcat> WHERE fieldname NE 'MANDT'.
      ASSIGN COMPONENT <fs_fcat>-fieldname OF STRUCTURE is_structure TO <fs_new>.
      ASSIGN COMPONENT <fs_fcat>-fieldname OF STRUCTURE <fs_structure> TO <fs_old>.

      IF <fs_new> NE <fs_old>.
        ls_change-fieldname = <fs_fcat>-fieldname.
        ls_change-oldvalue = <fs_old>.
        ls_change-newvalue = <fs_new>.
        APPEND ls_change TO rt_change.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD constructor.
    DATA : lo_struct  TYPE REF TO cl_abap_structdescr,
           lo_mapping TYPE REF TO cl_os_mapping,
           lo_class   TYPE REF TO cl_abap_classdescr,
           lv_class   TYPE seoclskey.
    me->gv_name = iv_name.
    lo_class ?= cl_abap_classdescr=>describe_by_object_ref( io_pers ).
    lv_class = lo_class->get_relative_name(  ).
    lo_struct ?= cl_abap_structdescr=>describe_by_name( iv_name ).
    me->gt_fields = lo_struct->get_ddic_field_list( ).

    lo_mapping = NEW #( ).
    lo_mapping->get_mapping_info(
                  EXPORTING i_class_key = lv_class
                            i_version = 0
                  IMPORTING e_mapp_info = me->gt_mapp )
                    .
    me->go_pers = io_pers.
    me->gt_method = lo_class->methods.

  ENDMETHOD.


  METHOD get_components_without_key.
    APPEND LINES OF me->gt_fields TO rt_fields .
    DELETE rt_fields WHERE keyflag EQ abap_true.
  ENDMETHOD.


  METHOD get_method_name.
    DATA : lv_action TYPE string,
           ls_mapp   TYPE osma_inf.

    lv_action = COND #( WHEN iv_set EQ abap_true THEN 'SET_' ELSE 'GET_').
    READ TABLE gt_mapp  INTO ls_mapp WITH KEY field_name = iv_field .

    rv_method = lv_action && ls_mapp-att_name.

  ENDMETHOD.


  METHOD get_method_parameter.
    DATA:
      ls_parmdescr TYPE  abap_parmdescr,
      ls_parmbind  TYPE abap_parmbind,
      ls_methdescr TYPE abap_methdescr.

    READ TABLE me->gt_method INTO ls_methdescr WITH KEY name = iv_methname.

    LOOP AT ls_methdescr-parameters INTO ls_parmdescr.
      ls_parmbind-name = ls_parmdescr-name.
      ls_parmbind-kind = ls_parmdescr-parm_kind.
      APPEND ls_parmbind TO rt_param.
      CLEAR : ls_parmbind, ls_parmdescr.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_tool_pers_helper~get.
    DATA : lv_string TYPE string.
    DATA : lt_params TYPE abap_parmbind_tt,
           ls_param  TYPE abap_parmbind,
           lt_param  TYPE abap_parmbind_tab.

    FIELD-SYMBOLS : <fs_fcat>  TYPE dfies,
                    <fs_value> TYPE any.

    LOOP AT me->gt_fields ASSIGNING <fs_fcat> WHERE fieldname NE 'MANDT'.
      ASSIGN COMPONENT <fs_fcat>-fieldname OF STRUCTURE cs_structure TO <fs_value>.
      IF sy-subrc IS INITIAL.
        DATA(lv_method) = me->get_method_name( EXPORTING iv_field = <fs_fcat>-fieldname
                                                                  iv_set = abap_false
                                                       ).

        "now do the action
        CALL METHOD me->go_pers->(lv_method) RECEIVING result = <fs_value>.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_tool_pers_helper~set.
    DATA : lt_fields TYPE ddfields,
           lv_string TYPE string.
    DATA : lt_params TYPE abap_parmbind_tt,
           ls_param  TYPE abap_parmbind,
           lt_param  TYPE abap_parmbind_tab.

    FIELD-SYMBOLS : <fs_fcat>  TYPE dfies,
                    <fs_value> TYPE any.
*get the component
    lt_fields = me->get_components_without_key( ).
    rt_change =  me->changes( is_structure ).

    LOOP AT lt_fields ASSIGNING <fs_fcat> WHERE fieldname NE 'MANDT'.
      IF line_exists( rt_change[ fieldname = <fs_fcat>-fieldname ] ) .
        ASSIGN COMPONENT <fs_fcat>-fieldname OF STRUCTURE is_structure TO <fs_value>.
        IF sy-subrc IS INITIAL.
          DATA(lv_method) = me->get_method_name( EXPORTING iv_field = <fs_fcat>-fieldname
                                                                    iv_set = abap_true
                                                         ).
          "get the parameter
          lt_params = me->get_method_parameter( lv_method ).
          LOOP AT lt_params INTO ls_param.
            ls_param-kind = cl_abap_objectdescr=>exporting.
            GET REFERENCE OF <fs_value> INTO  ls_param-value.
            MODIFY lt_params FROM ls_param.
          ENDLOOP.
          lt_param = lt_params.
          "now do the action
          CALL METHOD me->go_pers->(lv_method)
            PARAMETER-TABLE lt_param.

        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
