@EndUserText.label: 'Root entity for employees CUSTOM ENTITY'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_RAP_EMPLOYEE'
define root custom entity ZRAP_root_Employee

{
      @UI.lineItem   : [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
  key employeeID     : abap.char( 10 );
      @UI.lineItem   : [{ position: 20 }]
      @UI.selectionField: [{ position: 20 }]
      employeeName   : text60;
      employeeStatus : text60;

}
