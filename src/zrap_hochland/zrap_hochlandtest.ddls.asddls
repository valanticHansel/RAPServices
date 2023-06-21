@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test für Hochland'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZRAP_HochlandTest
  as select from ZRAP_root_Customers
{
  key CustomerId,
      CustomerName,
      Country,

      /* Associations */
      _CustShops
}
