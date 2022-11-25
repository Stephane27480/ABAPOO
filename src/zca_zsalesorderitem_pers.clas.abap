class ZCA_ZSALESORDERITEM_PERS definition
  public
  inheriting from ZCB_ZSALESORDERITEM_PERS
  final
  create private .

public section.

  class-data AGENT type ref to ZCA_ZSALESORDERITEM_PERS read-only .

  class-methods CLASS_CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCA_ZSALESORDERITEM_PERS IMPLEMENTATION.


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
      I_CLASS_NAME          = 'ZCL_ZSALESORDERITEM_PERS'
      I_CLASS_AGENT_NAME    = 'ZCA_ZSALESORDERITEM_PERS'
      I_CLASS_GUID          = '005056BCA7EA1EDD99CC19552559DA05'
      I_CLASS_AGENT_GUID    = '005056BCA7EA1EDD99CC1955255A9A05'
      I_AGENT               = AGENT
      I_STORAGE_LOCATION    = 'ZSALESORDERITEM'
      I_CLASS_AGENT_VERSION = '2.0'.

           "CLASS_CONSTRUCTOR
  endmethod.
ENDCLASS.
