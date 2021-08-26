/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Maps Waypoint Trigger
 * TestClass:          MapsWaypointTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08/02/2021         Jull Quintero D         Initial implementation of the class.
 **/

public without sharing class MapsWaypointTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {
        List<maps__Waypoint__c> newWaypoints = (List<maps__Waypoint__c>) Trigger.new;
        MapsWaypointTriggerHelper.setFields(newWaypoints);
    }

    public override void afterInsert() {
        List<maps__Waypoint__c> newWaypoints = (List<maps__Waypoint__c>) Trigger.new;
        MapsWaypointTriggerHelper.deliveryAssignRoute(newWaypoints);
    }

    public override void beforeDelete() {
        Map<Id,maps__Waypoint__c> oldWaypoints = (Map<Id,maps__Waypoint__c>) Trigger.oldMap;
        MapsWaypointTriggerHelper.deliveryUnAssignRoute(oldWaypoints);
    }
    

    public override void afterUpdate(){
        Map<Id,maps__Waypoint__c> oldWaypoints = (Map<Id,maps__Waypoint__c>) Trigger.oldMap;
        Map<Id,maps__Waypoint__c> newWaypoints = (Map<Id,maps__Waypoint__c>) Trigger.newMap;
        MapsWaypointTriggerHelper.driverCmpDeliveryUpdates(oldWaypoints,newWaypoints);
    }
    
}