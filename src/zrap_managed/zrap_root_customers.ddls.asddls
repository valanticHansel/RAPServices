@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity for customers'
@Metadata.allowExtensions: true
define root view entity ZRAP_root_Customers
  as select from zrap_customers
  composition [0..*] of ZRAP_I_CustomerShops as _CustShops
{

  key zrap_customers.cust_id       as CustomerId,
      zrap_customers.customer_name as CustomerName,
      country                      as Country,

      _CustShops // Make association public
}
