@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface: Customer Shops unmanaged'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZRAP_I_CustomerShopsUM
  as select from zrap_cust_shops
  association to parent ZRAP_root_CustomersUM as _Customer on $projection.CustomerId = _Customer.CustomerId
{
  key cust_id   as CustomerId,
  key shop_id   as ShopId,
      shop_name as ShopName,

      _Customer
}
