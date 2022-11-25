*&---------------------------------------------------------------------*
*& Report Z_AGIFY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_agify.

DATA : lv_first     TYPE ad_namefir,
       lt_firstname TYPE  gho_tt_fc_sel_name,
       lo_class     TYPE REF TO zcl_agify_app.

PARAMETERS p_ctry TYPE land1 MATCHCODE OBJECT BS_SEARCH_COUNTRY DEFAULT 'FR'.
SELECT-OPTIONS s_name FOR lv_first.

AT SELECTION-SCREEN OUTPUT.
*-------------------------------------------------------------
START-OF-SELECTION.
*-------------------------------------------------------------
  lt_firstname = s_name[] .

  lo_class = NEW #( iv_country_id = p_ctry
                    it_firstname = lt_firstname
                    ).

  lo_class->main( ).
