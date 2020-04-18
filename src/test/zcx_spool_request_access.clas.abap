class ZCX_SPOOL_REQUEST_ACCESS definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  constants ZCX_SPOOL_REQUEST_ACCESS type SOTR_CONC value 'C14BCCB760631EEAA0AB1FB0E9DF933D' ##NO_TEXT.
  data SPOOL_REQUEST_ID type RSPOID .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !SPOOL_REQUEST_ID type RSPOID optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_SPOOL_REQUEST_ACCESS IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = ZCX_SPOOL_REQUEST_ACCESS .
 ENDIF.
me->SPOOL_REQUEST_ID = SPOOL_REQUEST_ID .
  endmethod.
ENDCLASS.
