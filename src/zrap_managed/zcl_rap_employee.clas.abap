CLASS zcl_rap_employee DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF gty_s_employee,
        employeeID     TYPE char10,
        employeeName   TYPE text60,
        employeeStatus TYPE text60,
      END OF gty_s_employee,
      gty_t_employee TYPE STANDARD TABLE OF gty_s_employee WITH KEY employeeid.
ENDCLASS.



CLASS zcl_rap_employee IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lt_result) = VALUE gty_t_employee(
                                            ( employeeid = '0000000010' employeename = 'Name1' employeestatus = 'Happy' )
                                            ( employeeid = '0000000020' employeename = 'Name1' employeestatus = 'Happy' )
                                            ( employeeid = '0000000030' employeename = 'Name2' employeestatus = 'Happy' )
                                          ).

    IF io_request->is_data_requested( ).

      TRY.
          DATA(lt_parameters) = io_request->get_parameters( ).
          DATA(lv_searchfield) = io_request->get_search_expression( ).
          DATA(lv_top)     = io_request->get_paging( )->get_page_size( ). "Mandantory
          DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
          DATA(lt_fields)  = io_request->get_requested_elements( ).
          DATA(lt_sort)    = io_request->get_sort_elements( ).
          DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                      ELSE lv_top ).
          DATA(lv_sql_string) = io_request->get_filter( )->get_as_sql_string( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
          "the filter that has been provided cannot be converted into select option
      ENDTRY.
    ENDIF.

    SELECT FROM @lt_result AS result
    FIELDS *
    WHERE (lv_sql_string)
    INTO CORRESPONDING FIELDS OF TABLE @lt_result.

    io_response->set_total_number_of_records( lines( lt_result ) ). "setting the total number of records which will be sent
    io_response->set_data( lt_result ). "returning the data as internal table
  ENDMETHOD.


ENDCLASS.
