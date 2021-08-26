global  class DeliveryAssigned implements Schedulable {
    global void execute(SchedulableContext ctx)  {
        List<maps__Waypoint__c> waysPoint = [select Id, maps__LinkId__c, maps__Route__c,maps__Route__r.Stop__c, maps__BaseObject__c 
                                            from maps__Waypoint__c where maps__Route__r.maps__Date__c = Today and maps__BaseObject__c='Deliveries' and Hung_Status__c=null];
        System.debug('Waypoints');
        System.debug(wayspoint);
        unassignedDeliveries(waysPoint);        
    }

    public static List<maps__Route__c> unassignedDeliveries(List<maps__Waypoint__c> waysPoint){
        List<Delivery_Object__c> deliveries = new List<Delivery_Object__c>();
        List<maps__Route__c> mapsRoute = new List<maps__Route__c>();
        String ids = '', deliveriesId='';
        for (maps__Waypoint__c wp : waysPoint) {
            if(!ids.contains(wp.maps__Route__c)){
                mapsRoute.add(new maps__Route__c(Id = wp.maps__Route__c,
                Stop__c = wp.maps__Route__r.Stop__c != null ? wp.maps__Route__r.Stop__c : DateTime.now()
                ));
            }
            ids += wp.maps__Route__c+',';
            if(wp.maps__LinkId__c != null && !deliveriesId.contains(wp.maps__LinkId__c)){
                deliveries.add(new Delivery_Object__c(
                Id = wp.maps__LinkId__c,
                Assigned_Route__c = false
                ));
            }
            deliveriesId += wp.maps__LinkId__c+',';
        }
        if (!deliveries.isEmpty()) update deliveries;
        if (!mapsRoute.isEmpty()) update mapsRoute;
        return mapsRoute;
    }

}