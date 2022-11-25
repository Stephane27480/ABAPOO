class ZCX_ZSALESORDER_MSG definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of CREATE,
      msgid type symsgid value 'ZABAP100',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'SALESORDER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CREATE .
  constants:
    begin of UPDATE,
      msgid type symsgid value 'ZABAP100',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'SALESORDER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of UPDATE .
  constants:
    begin of READ,
      msgid type symsgid value 'ZABAP100',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'SALESORDER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of READ .
  constants:
    begin of DELETE,
      msgid type symsgid value 'ZABAP100',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'SALESORDER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DELETE .
  data SALESORDER type SSTRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !SALESORDER type SSTRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ZSALESORDER_MSG IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->SALESORDER = SALESORDER .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
