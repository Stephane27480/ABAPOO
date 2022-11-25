class ZCL_ZSALESORDERITEM_PERS definition
  public
  final
  create protected

  global friends ZCB_ZSALESORDERITEM_PERS .

public section.

  interfaces IF_OS_STATE .

  methods GET_CREATEDBY
    returning
      value(RESULT) type ERNAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CREATIONDATE
    returning
      value(RESULT) type ERDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CURRENCYT
    returning
      value(RESULT) type WAERS
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_NETAMOUNT
    returning
      value(RESULT) type NETWR_AP
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_ORDERQUANTITY
    returning
      value(RESULT) type KWMENG
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_ORDERQUANTITYUNIT
    returning
      value(RESULT) type VRKME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_PRODUCT
    returning
      value(RESULT) type MATNR
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_SALESORDER
    returning
      value(RESULT) type VBELN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_SALESORDERITEM
    returning
      value(RESULT) type POSNR
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CREATEDBY
    importing
      !I_CREATEDBY type ERNAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CREATIONDATE
    importing
      !I_CREATIONDATE type ERDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CURRENCYT
    importing
      !I_CURRENCYT type WAERS
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_NETAMOUNT
    importing
      !I_NETAMOUNT type NETWR_AP
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_ORDERQUANTITY
    importing
      !I_ORDERQUANTITY type KWMENG
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_ORDERQUANTITYUNIT
    importing
      !I_ORDERQUANTITYUNIT type VRKME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_PRODUCT
    importing
      !I_PRODUCT type MATNR
    raising
      CX_OS_OBJECT_NOT_FOUND .
protected section.

  data SALESORDER type VBELN .
  data SALESORDERITEM type POSNR .
  data PRODUCT type MATNR .
  data ORDERQUANTITY type KWMENG .
  data ORDERQUANTITYUNIT type VRKME .
  data NETAMOUNT type NETWR_AP .
  data CURRENCYT type WAERS .
  data CREATIONDATE type ERDAT .
  data CREATEDBY type ERNAM .
private section.
ENDCLASS.



CLASS ZCL_ZSALESORDERITEM_PERS IMPLEMENTATION.


  method GET_CREATEDBY.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CREATEDBY
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CREATEDBY.

           " GET_CREATEDBY
  endmethod.


  method GET_CREATIONDATE.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CREATIONDATE
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CREATIONDATE.

           " GET_CREATIONDATE
  endmethod.


  method GET_CURRENCYT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CURRENCYT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CURRENCYT.

           " GET_CURRENCYT
  endmethod.


  method GET_NETAMOUNT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute NETAMOUNT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = NETAMOUNT.

           " GET_NETAMOUNT
  endmethod.


  method GET_ORDERQUANTITY.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute ORDERQUANTITY
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = ORDERQUANTITY.

           " GET_ORDERQUANTITY
  endmethod.


  method GET_ORDERQUANTITYUNIT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute ORDERQUANTITYUNIT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = ORDERQUANTITYUNIT.

           " GET_ORDERQUANTITYUNIT
  endmethod.


  method GET_PRODUCT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute PRODUCT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = PRODUCT.

           " GET_PRODUCT
  endmethod.


  method GET_SALESORDER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute SALESORDER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = SALESORDER.

           " GET_SALESORDER
  endmethod.


  method GET_SALESORDERITEM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute SALESORDERITEM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = SALESORDERITEM.

           " GET_SALESORDERITEM
  endmethod.


  method IF_OS_STATE~GET.
***BUILD 090501
     " returning result type ref to object
************************************************************************
* Purpose        : Get state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  create object STATE_OBJECT.
  call method STATE_OBJECT->SET_STATE_FROM_OBJECT( ME ).
  result = STATE_OBJECT.

  endmethod.


  method IF_OS_STATE~HANDLE_EXCEPTION.
***BUILD 090501
     " importing I_EXCEPTION type ref to IF_OS_EXCEPTION_INFO optional
     " importing I_EX_OS type ref to CX_OS_OBJECT_NOT_FOUND optional
************************************************************************
* Purpose        : Handles exceptions during attribute access.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : If an exception is raised during attribut access,
*                  this method is called and the exception is passed
*                  as a paramater. The default is to raise the exception
*                  again, so that the caller can handle the exception.
*                  But it is also possible to handle the exception
*                  here in the callee.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
************************************************************************
* Modify if you like
************************************************************************

  if i_ex_os is not initial.
    raise exception i_ex_os.
  endif.

  endmethod.


  method IF_OS_STATE~INIT.
***BUILD 090501
"#EC NEEDED
************************************************************************
* Purpose        : Initialisation of the transient state partition.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Transient state is initial.
*
* OO Exceptions  : -
*
* Implementation : Caution!: Avoid Throwing ACCESS Events.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

  endmethod.


  method IF_OS_STATE~INVALIDATE.
***BUILD 090501
"#EC NEEDED
************************************************************************
* Purpose        : Do something before all persistent attributes are
*                  cleared.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : Whatever you like to do.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

  endmethod.


  method IF_OS_STATE~SET.
***BUILD 090501
     " importing I_STATE type ref to object
************************************************************************
* Purpose        : Set state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  STATE_OBJECT ?= I_STATE.
  call method STATE_OBJECT->SET_OBJECT_FROM_STATE( ME ).

  endmethod.


  method SET_CREATEDBY.
***BUILD 090501
     " importing I_CREATEDBY
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CREATEDBY
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CREATEDBY <> CREATEDBY ).

    CREATEDBY = I_CREATEDBY.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CREATEDBY <> CREATEDBY )

           " GET_CREATEDBY
  endmethod.


  method SET_CREATIONDATE.
***BUILD 090501
     " importing I_CREATIONDATE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CREATIONDATE
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CREATIONDATE <> CREATIONDATE ).

    CREATIONDATE = I_CREATIONDATE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CREATIONDATE <> CREATIONDATE )

           " GET_CREATIONDATE
  endmethod.


  method SET_CURRENCYT.
***BUILD 090501
     " importing I_CURRENCYT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CURRENCYT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CURRENCYT <> CURRENCYT ).

    CURRENCYT = I_CURRENCYT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CURRENCYT <> CURRENCYT )

           " GET_CURRENCYT
  endmethod.


  method SET_NETAMOUNT.
***BUILD 090501
     " importing I_NETAMOUNT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute NETAMOUNT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_NETAMOUNT <> NETAMOUNT ).

    NETAMOUNT = I_NETAMOUNT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_NETAMOUNT <> NETAMOUNT )

           " GET_NETAMOUNT
  endmethod.


  method SET_ORDERQUANTITY.
***BUILD 090501
     " importing I_ORDERQUANTITY
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute ORDERQUANTITY
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_ORDERQUANTITY <> ORDERQUANTITY ).

    ORDERQUANTITY = I_ORDERQUANTITY.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_ORDERQUANTITY <> ORDERQUANTITY )

           " GET_ORDERQUANTITY
  endmethod.


  method SET_ORDERQUANTITYUNIT.
***BUILD 090501
     " importing I_ORDERQUANTITYUNIT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute ORDERQUANTITYUNIT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_ORDERQUANTITYUNIT <> ORDERQUANTITYUNIT ).

    ORDERQUANTITYUNIT = I_ORDERQUANTITYUNIT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_ORDERQUANTITYUNIT <> ORDERQUANTITYUNIT )

           " GET_ORDERQUANTITYUNIT
  endmethod.


  method SET_PRODUCT.
***BUILD 090501
     " importing I_PRODUCT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute PRODUCT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_PRODUCT <> PRODUCT ).

    PRODUCT = I_PRODUCT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_PRODUCT <> PRODUCT )

           " GET_PRODUCT
  endmethod.
ENDCLASS.
