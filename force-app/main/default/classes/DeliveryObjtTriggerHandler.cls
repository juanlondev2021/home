/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Delivery Object Trigger unifications
 * TestClass:          DeliveryObjtTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    01-29-2021         Jull Quintero D         Initial implementation of the class.
 **/

public class DeliveryObjtTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        List<Delivery_Object__c> deliveries = (List<Delivery_Object__c>) Trigger.new;
        DeliveryObjtTriggerHelper.setDeliveryFields(deliveries, null, Trigger.isInsert, Trigger.isUpdate);
    }

    public override void beforeUpdate() {
        List<Delivery_Object__c> deliveries = (List<Delivery_Object__c>) Trigger.new;
        Map<Id,Delivery_Object__c> deliveiesMap = (Map<Id,Delivery_Object__c>) Trigger.newMap;
        Map<Id,Delivery_Object__c> oldMapDeliveries = (Map<Id,Delivery_Object__c>) Trigger.oldMap;
        DeliveryObjtTriggerHelper.setDeliveryFields(deliveries, oldMapDeliveries, Trigger.isInsert, Trigger.isUpdate);
    }

    public override void afterInsert() {
        List<Delivery_Object__c> deliveries = (List<Delivery_Object__c>) Trigger.new;
        DeliveryObjtTriggerHelper.setUserAddresScanCode(deliveries, null, Trigger.isInsert, Trigger.isUpdate);
        DeliveryObjtTriggerHelper.setDeliveryIsRecent(deliveries);
    }

    public override void afterUpdate() {
        List<Delivery_Object__c> deliveries = (List<Delivery_Object__c>) Trigger.new;
        Map<Id,Delivery_Object__c> oldMapDeliveries = (Map<Id,Delivery_Object__c>) Trigger.oldMap;
        DeliveryObjtTriggerHelper.setUserAddresScanCode(deliveries, oldMapDeliveries, Trigger.isInsert, Trigger.isUpdate);
        DeliveryObjtTriggerHelper.setDriverLeadStatus(deliveries, oldMapDeliveries);
        DeliveryObjtTriggerHelper.getAccountGeoLocation(deliveries, oldMapDeliveries);
    }
}