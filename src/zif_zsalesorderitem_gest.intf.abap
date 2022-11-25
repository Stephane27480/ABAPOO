interface ZIF_ZSALESORDERITEM_GEST
  public .


  methods CREATE
    changing
      !CS_STRUCTURE type ZSALESORDERITEM
    raising
      CX_OS_ERROR .
  methods UPDATE
    changing
      !CS_STRUCTURE type ZSALESORDERITEM
    raising
      CX_OS_ERROR .
  methods READ
    importing
      !IS_STRUCTURE type ZSALESORDERITEM optional
    returning
      value(RS_STRUCTURE) type ZSALESORDERITEM
    raising
      CX_OS_ERROR .
  methods DELETE
    importing
      !IS_STRUCTURE type ZSALESORDERITEM optional
    raising
      CX_OS_ERROR .
endinterface.
