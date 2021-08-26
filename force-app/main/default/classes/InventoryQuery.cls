/*********************************************************************
 Createdby: MST
 Description: When DID updates the POC number, it will search the POC value matching Inventory records and updating its Did_name field
              on Inventory records.

*********************************************************************/


public class InventoryQuery
{
  static List<Inventory__c> invList = new List<Inventory__c>();
  static list<Inventory__c> inventoryList =  new list<Inventory__c>();
  
  @future
  public static void queryFac(map<string,id> didMap)
  {
  
     System.debug('Record IN+++++++++++++++++++++++++++++++ ' + didMap);
  
   // Querying Inventory record for matching POC values.
   
   for(Inventory__c inv: [select id, DID__c from Inventory__c where DID__c IN: didMap.keySet() OR DID_Name__c IN: didMap.Values()]){
       
       
       
        if(didMap.containsKey(inv.DID__c))
        {
            inv.DID_Name__c = didMap.get(inv.DID__c);
        }
        else 
        {
            inv.DID_Name__c = NULL;
        }
         inventoryList.add(inv);
    }
    if(inventoryList.size() > 0)
    {
        System.debug('inventoryList+++++++++++++++++++++++++++++ ' + inventoryList);
        update inventoryList;
    }
  }
}