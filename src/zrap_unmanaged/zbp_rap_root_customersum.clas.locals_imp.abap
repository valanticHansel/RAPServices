CLASS lhc_ZRAP_root_CustomersUM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZRAP_root_CustomersUM RESULT result.

    METHODS create FOR MODIFY
      IMPORTING it_customers_create FOR CREATE ZRAP_root_CustomersUM.

*    METHODS update FOR MODIFY
*      IMPORTING it_customers_update FOR UPDATE ZRAP_root_CustomersUM.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE ZRAP_root_CustomersUM.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZRAP_root_CustomersUM RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZRAP_root_CustomersUM.

    METHODS rba_Custshops FOR READ
      IMPORTING keys_rba FOR READ ZRAP_root_CustomersUM\_Custshops FULL result_requested RESULT result LINK association_links.

    METHODS cba_Custshops FOR MODIFY
      IMPORTING entities_cba FOR CREATE ZRAP_root_CustomersUM\_Custshops.

    METHODS:
      add_message
        IMPORTING
          iv_msgid      TYPE char20
          iv_msgno      TYPE numc3
          iv_msgty      TYPE char1
          iv_msgv1      TYPE char40 OPTIONAL
          iv_msgv2      TYPE char40 OPTIONAL
          iv_msgv3      TYPE char40 OPTIONAL
          iv_msgv4      TYPE char40 OPTIONAL
        RETURNING
          VALUE(ro_msg) TYPE REF TO if_abap_behv_message.

ENDCLASS.

CLASS lhc_ZRAP_root_CustomersUM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    LOOP AT it_customers_create ASSIGNING FIELD-SYMBOL(<customers>).
      SELECT SINGLE FROM zrap_customers
      FIELDS @abap_true
      WHERE customer_name = @<customers>-CustomerName
      INTO @DATA(lv_name_exists).

      IF lv_name_exists = abap_true.
*        APPEND VALUE #( %cid = <customers>-%cid ) TO failed-zrap_root_customersum.
        APPEND VALUE #( %msg = add_message(
                                 iv_msgid = 'ZRAP_MSG_CLASS'
                                 iv_msgno = 002
                                 iv_msgty = CONV #( if_abap_behv_message=>severity-warning )
                               )
                        %cid = <customers>-%cid
                     ) TO reported-zrap_root_customersum.
      ENDIF.
    ENDLOOP.

    zrap_customer_buffer=>get_instance( )->create_customer(
      EXPORTING
        it_create   = it_customers_create
      CHANGING
        et_failed   = failed-zrap_root_customersum
        et_mapped   = mapped-zrap_root_customersum
        et_reported = reported-zrap_root_customersum
    ).
  ENDMETHOD.

*  METHOD update.
*  ENDMETHOD.

*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
    SELECT *
    FROM zrap_customers
    FOR ALL ENTRIES IN @keys WHERE cust_id = @keys-CustomerId
    INTO TABLE @DATA(lt_customers).
    result = CORRESPONDING #( lt_customers ).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Custshops.
  ENDMETHOD.

  METHOD cba_Custshops.
  ENDMETHOD.

  METHOD add_message.
    MESSAGE ID iv_msgid TYPE iv_msgty NUMBER iv_msgno WITH iv_msgv1 iv_msgv2 iv_msgv3 iv_msgv4 INTO DATA(lv_dummy).
    ro_msg = new_message(
                  EXPORTING
                    id       = sy-msgid
                    number   = sy-msgno
                    severity = CONV #( sy-msgty )
                    v1       = sy-msgv1
                    v2       = sy-msgv2
                    v3       = sy-msgv3
                    v4       = sy-msgv4
    ).
  ENDMETHOD.


ENDCLASS.

CLASS lhc_ZRAP_I_CustomerShopsUM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE ZRAP_I_CustomerShopsUM.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE ZRAP_I_CustomerShopsUM.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZRAP_I_CustomerShopsUM RESULT result.

    METHODS rba_Customer FOR READ
      IMPORTING keys_rba FOR READ ZRAP_I_CustomerShopsUM\_Customer FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZRAP_I_CustomerShopsUM IMPLEMENTATION.

*  METHOD update.
*  ENDMETHOD.

*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
    SELECT *
    FROM zrap_cust_shops
    FOR ALL ENTRIES IN @keys WHERE cust_id = @keys-CustomerId
                             AND shop_id = @keys-ShopId
    INTO TABLE @DATA(lt_shops).
    result = CORRESPONDING #( lt_shops ).
  ENDMETHOD.

  METHOD rba_Customer.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZRAP_ROOT_CUSTOMERSUM DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZRAP_ROOT_CUSTOMERSUM IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    zrap_customer_buffer=>get_instance( )->save_customer( ).
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
