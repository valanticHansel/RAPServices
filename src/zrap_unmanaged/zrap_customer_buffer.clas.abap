CLASS zrap_customer_buffer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      gty_t_customers  TYPE STANDARD TABLE OF zrap_customers WITH DEFAULT KEY,
      gty_t_cust_shops TYPE STANDARD TABLE OF zrap_cust_shops WITH DEFAULT KEY,
      tt_create        TYPE TABLE FOR CREATE ZRAP_root_CustomersUM,
      tt_failed        TYPE TABLE FOR FAILED ZRAP_root_CustomersUM,
      tt_mapped        TYPE TABLE FOR MAPPED ZRAP_root_CustomersUM,
      tt_reported      TYPE TABLE FOR REPORTED ZRAP_root_CustomersUM.

    CLASS-METHODS:
      get_instance
        RETURNING
          VALUE(ro_inst) TYPE REF TO zrap_customer_buffer.

    METHODS:
      create_customer
        IMPORTING
          it_create   TYPE tt_create
        CHANGING
          et_failed   TYPE tt_failed
          et_mapped   TYPE tt_mapped
          et_reported TYPE tt_reported,
      create_cust_shops
        IMPORTING
          it_create   TYPE tt_create
        CHANGING
          et_failed   TYPE tt_failed
          et_mapped   TYPE tt_mapped
          et_reported TYPE tt_reported,
      check_fields
        IMPORTING
          iv_entity   TYPE ZRAP_root_CustomersUM
          iv_cid      TYPE abp_behv_cid
        CHANGING
          ct_failed   TYPE tt_failed
          ct_reported TYPE tt_reported,
      get_customer_from_buffer
        RETURNING
          VALUE(rt_customer) TYPE gty_t_customers,
      save_customer,
      save_cust_shops.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: go_instance TYPE REF TO zrap_customer_buffer.
    DATA:
      mt_create_cust_buffer      TYPE gty_t_customers,
      mt_create_cust_shop_buffer TYPE gty_t_cust_shops.
ENDCLASS.



CLASS zrap_customer_buffer IMPLEMENTATION.


  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    ro_inst = go_instance.
  ENDMETHOD.


  METHOD create_customer.
    DATA: ls_insert TYPE zrap_customers. "Zeile, die in Instanztabelle hinzugefügt wird

    LOOP AT it_create ASSIGNING FIELD-SYMBOL(<entity>).
      "Macht man bei managed über gesonderte validations:
      check_fields( EXPORTING
                        iv_entity       = <entity>-%data
                        iv_cid          = <entity>-%cid
                    CHANGING
                        ct_failed   = et_failed
                        ct_reported = et_reported ).


      IF et_failed IS INITIAL.
        "Mapping Entitätsfelder -> DB-Tabellenfelder
        ls_insert = CORRESPONDING #( <entity> MAPPING FROM ENTITY ).

*        "freie ID holen
        TRY.
            ls_insert-cust_id = cl_system_uuid=>create_uuid_x16_static( ).

            IF NOT line_exists( mt_create_cust_buffer[ cust_id = ls_insert-cust_id ] ).
              "Schreiben auf Instanztabelle
              APPEND ls_insert TO mt_create_cust_buffer.
              "MAPPED-Tabelle befüllen
              APPEND VALUE #( %cid = <entity>-%cid customerid = <entity>-CustomerId ) TO et_mapped.
            ELSE.
              APPEND VALUE #( %cid = <entity>-%cid
                              %create = if_abap_behv=>mk-on ) TO et_failed.
            ENDIF.
          CATCH cx_uuid_error.
            APPEND VALUE #( %cid = <entity>-%cid
                            %create = if_abap_behv=>mk-on ) TO et_failed.
        ENDTRY.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_cust_shops.
  ENDMETHOD.


  METHOD check_fields.

  ENDMETHOD.


  METHOD get_customer_from_buffer.
    rt_customer = mt_create_cust_buffer.
  ENDMETHOD.


  METHOD save_customer.
    IF mt_create_cust_buffer IS NOT INITIAL.
      INSERT zrap_customers FROM TABLE @mt_create_cust_buffer.
    ENDIF.
  ENDMETHOD.


  METHOD save_cust_shops.
  ENDMETHOD.


ENDCLASS.
