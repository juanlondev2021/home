/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-18-2020
 * @last modified by  : Fabian Pineda
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-17-2020   William Aldana   Initial Version
 * 1.0   09-18-2020	  Fabian Pineda	   Added back working code from the older Home Services triger.
 * 1.0   09-25-2020	  Jull Quintero D  Appointment Sale Approved
 * 1.0   11-05-2020   Fabian Pineda    Added call to "HomeServicesTriggerHelper.HomeServiceUpdateFinanceTaxHandler" after updates.

**/
public class HomeServicesTriggerHandler extends TriggerHandler{
    public override void beforeUpdate() {
        HomeServicesTriggerHelper.HomeServiceUpdateAccountHandler((List<Home_Services__c>)Trigger.new, (Map<Id, Home_Services__c>)Trigger.oldMap, Trigger.operationType);
    	HomeServicesTriggerHelper.HomeServiceSaleApprovedHandler((List<Home_Services__c>)Trigger.new, (Map<Id, Home_Services__c>)Trigger.oldMap, Trigger.operationType);
    }
    public override void afterInsert() {
        HomeServicesTriggerHelper.AppointmentSaleApproved((List<Home_Services__c>)Trigger.new,null, Trigger.isInsert);
        HomeServicesTriggerHelper.createSMS((List<Home_Services__c>)Trigger.new,null,Trigger.isInsert,Trigger.isUpdate);
    }
    public override void afterUpdate() {
        HomeServicesTriggerHelper.HomeServiceSaleApprovedHandler((List<Home_Services__c>)Trigger.new, (Map<Id, Home_Services__c>)Trigger.oldMap, Trigger.operationType);
        HomeServicesTriggerHelper.HomeServiceUpdateAccountHandler((List<Home_Services__c>)Trigger.new, (Map<Id, Home_Services__c>)Trigger.oldMap, Trigger.operationType);
        HomeServicesTriggerHelper.AppointmentSaleApproved((List<Home_Services__c>)Trigger.new, (Map<Id, Home_Services__c>)Trigger.oldMap, Trigger.isInsert);
        HomeServicesTriggerHelper.HomeServiceUpdateFinanceTaxHandler((List<Home_Services__c>)Trigger.new, (Map<Id, Home_Services__c>)Trigger.oldMap);
        HomeServicesTriggerHelper.createSMS((List<Home_Services__c>)Trigger.new,(Map<Id, Home_Services__c>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);
    }
}