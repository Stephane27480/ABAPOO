class ZCA_ZSALESORDER_PERS definition
  public
  inheriting from ZCB_ZSALESORDER_PERS
  final
  create private .

public section.

  class-data AGENT type ref to ZCA_ZSALESORDER_PERS read-only .

  class-methods CLASS_CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCA_ZSALESORDER_PERS IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
***BUILD 090501
************************************************************************
* Purpose        : Initialize the 'class'.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Singleton is created.
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 1999-09-20   : (OS) Initial Version
* - 2000-03-06   : (BGR) 2.0 modified REGISTER_CLASS_AGENT
************************************************************************
* GENERATED: Do not modify
************************************************************************

  create object AGENT.

  call method AGENT->REGISTER_CLASS_AGENT
    exporting
      I_CLASS_NAME          = 'ZCL_ZSALESORDER_PERS'
      I_CLASS_AGENT_NAME    = 'ZCA_ZSALESORDER_PERS'
      I_CLASS_GUID          = '005056BCA7EA1EED99D0B2F17F0FA082'
      I_CLASS_AGENT_GUID    = '005056BCA7EA1EED99D0B2F17F106082'
      I_AGENT               = AGENT
      I_STORAGE_LOCATION    = 'ZSALESORDER'
      I_CLASS_AGENT_VERSION = '2.0'.

           "CLASS_CONSTRUCTOR
  endmethod.
ENDCLASS.
