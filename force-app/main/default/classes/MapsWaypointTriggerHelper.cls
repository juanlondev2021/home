/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Maps Waypoint Trigger
 * TestClass:          MapsWaypointTriggerTest
 * Description:        helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08/02/2021         Jull Quintero D         Initial implementation of the class.
 * @version    1.0    04/03/2021         Jeison Hernandez S      Delivery Driver
 **/

public without sharing class MapsWaypointTriggerHelper {

    public static Boolean flagControlExecution = false;
    /**
     * This method is responsible Update Delivery Object Assigned_Route__c
     * This method is run Before Insert
     * 
     * This method is used in:
     * MapsWaypointTrigger
     * 
     * @param List wayPoints
     **/
    public static void setFields(List<maps__Waypoint__c> wayPoints) {
        Set<Id> deliveryIds = new Set<Id>();
        Integer wayPointsSize = wayPoints.size();
        for (Integer i = 0; i < wayPointsSize; i++) {
            maps__Waypoint__c current = wayPoints[i];

            // Assign Delivery Object
            if( current.Delivery_Object__c == null ) {
                if( current.maps__LinkId__c != null ) {
                    Id deliveryId =  Id.valueOf(current.maps__LinkId__c);
                    String objectName = deliveryId.getSobjectType().getDescribe().getName();
                    if( objectName == 'Delivery_Object__c' ) {
                        current.Delivery_Object__c = deliveryId;
                        deliveryIds.add(deliveryId);
                    }
                }
            }
        }
        if ( !deliveryIds.isEmpty() ) setName(wayPoints,deliveryIds);
    }
    
    /**
     * This method is responsible assign format name
     * This method is run Before insert
     * 
     * This method is used in:
     * MapsWaypointTrigger
     * 
     * @param List wayPoints
     **/
    private static void setName(List<maps__Waypoint__c> wayPoints,Set<Id> deliveryIds) {

        Map<Id,Delivery_Object__c> deliveryMap = new  Map<Id,Delivery_Object__c>(
            [SELECT Id,Hung_Status__c,person_Account__r.FirstName,person_Account__r.LastName,
                    person_Account__r.Geocode_Accuracy__c,User_Address__r.Confirmation_Number__c 
            FROM Delivery_Object__c 
            WHERE Id IN :deliveryIds]);
        
        integer wayPointsSize = wayPoints.size();
        for (Integer i = 0; i < wayPointsSize; i++) {
            maps__Waypoint__c current = wayPoints[i];
            if( current.Delivery_Object__c != null ) {
                Delivery_Object__c delivery =  deliveryMap.get(current.Delivery_Object__c);
                Account account = delivery.person_Account__r;
                String geocurracy = account.Geocode_Accuracy__c != 'Address' ? 'Z-' : '';
                String hungStatus = delivery.Hung_Status__c != null && delivery.Hung_Status__c != 'NULL' ? delivery.Hung_Status__c.left(4) + '-' : '';
                String confirmation = delivery.User_Address__r.Confirmation_Number__c;
                String confirNumber = confirmation != null ? confirmation + '-' : '';
                String firstName = account.FirstName != null ? account.FirstName.left(1) + '-' : '';
                String LastName = account.LastName != null ? account.LastName : '';
                String name = geocurracy + hungStatus + confirNumber + firstName + LastName;
                if ( name.length() > 80 ) name = geocurracy + hungStatus + confirNumber + firstName + LastName.left(1);
                current.Name = name;
            }
        }
    }

    /**
     * This method is responsible Update Delivery Object Assigned_Route__c
     * This method is run After Insert
     * 
     * This method is used in:
     * MapsWaypointTrigger
     * 
     * @param List wayPoints
     **/
    public static void deliveryAssignRoute(List<maps__Waypoint__c> wayPoints) {
        Map<Id,Delivery_Object__c> deliveries = new Map<Id,Delivery_Object__c>();
        Integer wayPointsSize = wayPoints.size();
        for (Integer i = 0; i < wayPointsSize; i++) {
            maps__Waypoint__c current = wayPoints[i];
            if( current.Delivery_Object__c != null ) {
                if ( !deliveries.containsKey(current.Delivery_Object__c) ) {
                    deliveries.put(
                        current.Delivery_Object__c,
                        new Delivery_Object__c(
                            Id = current.Delivery_Object__c,
                            Assigned_Route__c = true
                        )
                    );
                }//else{//current.addError('Deliveries cant be duplicated');}
            }
        }
        if ( !deliveries.isEmpty() ) {
            TriggerHandler.bypass('DeliveryObjectTrigger');
                update deliveries.values();
            TriggerHandler.clearBypass('DeliveryObjectTrigger');
        }
    }

        /**
     * This method is responsible Update Delivery Object Assigned_Route__c
     * This method is run Before delete
     * 
     * This method is used in:
     * MapsWaypointTrigger
     * 
     * @param List wayPoints
     **/
    public static void deliveryUnAssignRoute(Map<Id,maps__Waypoint__c> oldWaypointsMap) {
        List<maps__Waypoint__c> wayPoints = [SELECT Id,Delivery_Object__c,maps__Route__r.maps__Date__c,maps__Route__r.Stop__c FROM maps__Waypoint__c WHERE Id IN :oldWaypointsMap.keySet()];
        
        Map<Id,Delivery_Object__c> deliveries = new Map<Id,Delivery_Object__c>();
        Integer wayPointsSize = wayPoints.size();
        for (Integer i = 0; i < wayPointsSize; i++) {
            maps__Waypoint__c current = wayPoints[i];
            Boolean isAllowed = current.maps__Route__r.maps__Date__c >= Date.today() && current.maps__Route__r.Stop__c == null; 
            
            if( current.Delivery_Object__c != null ) {
                if( isAllowed ) {
                    if ( !deliveries.containsKey(current.Delivery_Object__c) ) {
                        deliveries.put(
                            current.Delivery_Object__c,
                            new Delivery_Object__c(
                                Id = current.Delivery_Object__c,
                                Assigned_Route__c = false
                            )
                        );
                    } 
                }else {
                    maps__Waypoint__c wayPoint = oldWaypointsMap.get(current.Id);
                    wayPoint.addError('Route Date Is Overdue, Cannot Make Route Changes');
                }
            }
        }

        if ( !deliveries.isEmpty() ) {
            TriggerHandler.bypass('DeliveryObjectTrigger');
                update deliveries.values();
            TriggerHandler.clearBypass('DeliveryObjectTrigger');
        }
    }

    /**@author Jeison Hernandez S | 05-03-2021
     * 
     * This method is responsible Update Delivery Object Delivery_Date__c, Hung_Status__c, Arrival_GeoLocation__c, Driver__c
     * This method is run After Update
     * 
     * This method is used in:
     * MapsWaypointTrigger
     * 
     * @param List wayPoints
     **/

    public static void driverCmpDeliveryUpdates(Map<Id,maps__Waypoint__c> oldWaypointsMap, Map<Id,maps__Waypoint__c> newWaypointsMap){
        if (flagControlExecution == true) {
            return;
        }
        List<Delivery_Object__c> deliveries = new List<Delivery_Object__c>();
        List<maps__Waypoint__c> waypoints = new List<maps__Waypoint__c>();
        List<Driver__c> driver = new List<Driver__c>();
        driver = [select Id from Driver__c where User__c =: UserInfo.getUserId()];
        for(String currentId: oldWaypointsMap.keySet()){
            maps__Waypoint__c oldWaypoint = oldWaypointsMap.get(currentId);
            maps__Waypoint__c newWaypoint = newWaypointsMap.get(currentId);
            if(newWaypoint.Maps_Delivery_Driver__c ==true && newWaypoint.Delivery_Object__c!=null){
                waypoints.add(new maps__Waypoint__c(Id=newWaypoint.Id,Maps_Delivery_Driver__c=false));
                Delivery_Object__c Delivery = new Delivery_Object__c(Id=newWaypoint.Delivery_Object__c);
                Boolean flat=false;
                if(oldWaypoint.Checkout__c != newWaypoint.Checkout__c){
                    //Delivery.Hung_DateTieme__c = newWaypoint.Checkout__c; flat=true;
                }
                if(oldWaypoint.Hung_Status__c != newWaypoint.Hung_Status__c){
                    Delivery.Hung_Status__c = newWaypoint.Hung_Status__c; flat=true;
                    Delivery.Delivery_Date__c = newWaypoint.Hung_Date_Time__c;
                    Delivery.Hung_DateTieme__c = newWaypoint.Hung_Date_Time__c;
                    if(!driver.isEmpty()){
                        Delivery.Driver__c=driver[0].Id;
                    }
                }
                if( oldWaypoint.Delivery_Driver_Latitude__c != newWaypoint.Delivery_Driver_Latitude__c ||
                    oldWaypoint.Delivery_Driver_Longitude__c != newWaypoint.Delivery_Driver_Longitude__c){
                    Delivery.Arrival_Latitude__c = newWaypoint.Delivery_Driver_Latitude__c;
                    Delivery.Arrival_Longitude__c = newWaypoint.Delivery_Driver_Longitude__c;
                    flat=true;
                }
                if(flat){
                    deliveries.add(Delivery);
                }
           }
        }
        if(!deliveries.isEmpty()){
            flagControlExecution = true;
            update deliveries;
            flagControlExecution = false;
        }
        if(!waypoints.isEmpty()){
            TriggerHandler.bypass('MapsWaypointTrigger');
            update waypoints;
            TriggerHandler.clearBypass('MapsWaypointTrigger');
        }

    }
}