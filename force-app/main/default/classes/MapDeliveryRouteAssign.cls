/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Maps Waypoint - Salesforce Map
 * TestClass:          MapDeliveryRouteAssignTest
 * Description:        Map Delivery Route Assign (invocable)
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08/02/2021         Jull Quintero D         Initial implementation of the class.
 **/


public class MapDeliveryRouteAssign {
    @InvocableMethod(label='MapDeliveryRouteAssign')
    public static void assignDelivery(List<param> requests) {
        List<Delivery_Object__c> deliveries = new List<Delivery_Object__c>();
        Integer requestSize = requests.size();
        for (Integer i = 0; i < requestSize; i++) {
            param current = requests[i];
            if( current.linkId != null ) {
                Id deliveryId =  Id.valueOf(current.linkId);
                String objectName = deliveryId.getSobjectType().getDescribe().getName();
                if( objectName == 'Delivery_Object__c' ) {
                    deliveries.add(
                        new Delivery_Object__c(
                            Id = deliveryId,
                            Assigned_Route__c = true
                        )
                    );
                }
            }
        }
        if ( !deliveries.isEmpty() ) {
            update deliveries;
        }
    }

    public class param {
        @invocableVariable(required=true label='maps__LinkId__c')
        public string linkId;
    }
}