/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            UpdateOrder Trigger
 * TestClass:          UpdateOrderTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    11/09/2020         Jull Quintero D         Initial implementation of the class.
 **/
public class UpdateOrderTriggerHelper {
/*
 * This method is responsible to Create update_order__c And Update Sobject
 * 
 * This method is run after Insert.
 * 
 * This method is used in:
 * UpdateOrderTrigger
 * 
 * @param List update_order__c
 *
 **/
    public static void UpdateOrderData(List<update_order__c> uOrders) {
        List<SObject> tObject = new List<sobject>();
        List<Update_Order__c> tOrder = new List<Update_Order__c>();

        integer uOrdersLength = uOrders.size();
        for (Integer i = 0; i < uOrdersLength; i++) 
        {
            update_order__c uOrder = uOrders[i];

            if( !uOrder.Guest_User__c ) {

                Id recordId = uOrder.Parent_Id__c;

                if ( !String.isEmpty(recordId) ) {

                    //Update Update Order Status
                    tOrder.add(
                        new update_order__c(
                            Id=uOrder.Id,
                            Status__c='Updated'
                            )
                    );

                    //Split Data From fields/Values
                    list<String> fields = String.isBlank(uOrder.List_of_Fields__c) ? new list<String>() : uOrder.List_of_Fields__c.Split('/,/');
                    list<String> values = String.isBlank(uOrder.List_of_Values__c) ? new list<String>() : uOrder.List_of_Values__c.Split('/,/'); 
                
                    //Getting API Object Name
                    SObject actObj = recordId.getSObjectType().newSObject();
                    actObj.Id = recordId;

                    Integer valuesLength = values.size(); Integer fieldsLength = fields.size();
                    for(integer j = 0;j < valuesLength; j++) 
                    {
                        if( j == fieldsLength ) continue;     
                        
                        if( !string.isEmpty(fields[j]) ) {

                            try {
                                actObj.put(fields[j],values[j]);
                            } catch (Exception e) {
                                uOrder.adderror(e.getMessage());
                                break;
                            }
                        }                        
                    }
                    tObject.add(actObj);
                }
            }
        }
        
        map<Id, SObject> accmap = new map<Id, SObject>();
        accmap.putall(tObject);
        if( !accmap.isEmpty() ) {

            Database.update(accmap.values(), false); 
        }
        
        map<Id, Update_Order__c> ordermap = new map<Id, Update_Order__c>();
        ordermap.putall(tOrder);
        if(! ordermap.isEmpty() ) { 

            TriggerHandler.bypass('UpdateOrderTrigger');
                Database.update(ordermap.values(),false); 
            TriggerHandler.clearBypass('UpdateOrderTrigger');
        }
    }
}