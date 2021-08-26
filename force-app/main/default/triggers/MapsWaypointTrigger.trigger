/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Maps Waypoint Trigger
 * TestClass:          MapsWaypointTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08/02/2021         Jull Quintero D         Initial implementation of the class.
 **/

trigger MapsWaypointTrigger on maps__Waypoint__c (after insert, before insert, before delete, after update) {
    new MapsWaypointTriggerHandler().run('MapsWaypointTrigger');
}