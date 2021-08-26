/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Installation Trigger
 * TestClass:          InstallationTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0    11/09/2020         Jull Quintero D         Initial implementation of the class.
 * @version   1.0    18/09/2020         Fabian Pineda (FP)      Added beforeUpdate and afterUpdate methods.
 **/
public class InstallationTriggerHandler extends TriggerHandler{
    public override void afterInsert() {
        list<Installation__c> newIns = (List<Installation__c>) Trigger.new;
        InstallationTriggerHelper.installItems(newIns);
    }
    
    public override void beforeUpdate() {
        InstallationTriggerHelper.updateAccountStatus(
        	(List<Installation__c>) Trigger.new,
            (Map<Id, Installation__c>) Trigger.oldMap,
            false
        );
    }
    
    public override void afterUpdate() {
        InstallationTriggerHelper.updateAccountStatus(
        	(List<Installation__c>) Trigger.new,
            (Map<Id, Installation__c>) Trigger.oldMap,
            true
        );
    }
}