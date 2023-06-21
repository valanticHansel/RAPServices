CLASS lhc_ZRAP_root_Customers DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZRAP_root_Customers RESULT result.
    METHODS customaction FOR MODIFY
      IMPORTING keys FOR ACTION zrap_root_customers~customaction RESULT result.
    METHODS customaction2 FOR MODIFY
      IMPORTING keys FOR ACTION zrap_root_customers~customaction2 RESULT result.

ENDCLASS.


CLASS lhc_ZRAP_root_Customers IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD customAction.
*    IF lines( keys ) > 1.
*      APPEND VALUE #( %cid = keys[ 1 ]-cid
*                      ) TO reported-zrap_root_customers.
*    ELSE.)
    IF lines( keys ) > 0.
      DATA(ls_customer_in) = CORRESPONDING ZRAP_root_Customers( keys[ 1 ] ).
    ENDIF.

    SELECT SINGLE FROM ZRAP_root_Customers
    FIELDS *
    WHERE CustomerId = @ls_customer_in-CustomerId
    INTO CORRESPONDING FIELDS OF @ls_customer_in.

    APPEND CORRESPONDING #( ls_customer_in ) TO result ASSIGNING FIELD-SYMBOL(<customer>).
    <customer>-%param = CORRESPONDING #( ls_customer_in ).
*    ENDIF.
  ENDMETHOD.

  METHOD customAction2.
  ENDMETHOD.

ENDCLASS.
