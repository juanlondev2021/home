/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Commission Trigger
 * TestClass:          CommissionTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    06/10/2020         Jull Quintero D         Initial implementation of the class.
 **/

public class CommissionTriggerHandler extends TriggerHandler{

    public override void afterInsert() {
        List<Commission__c> newCommss = (List<Commission__c>) Trigger.new;
        Set<Id> newCommssIds = (Set<Id>) Trigger.newMap.keySet();

        CommissionTriggerHelper.homeServiceCommissionPaid(false, newCommss, null);
        CommissionTriggerHelper.assignCommissionNameAndUser(newCommssIds);
    }

    public override void afterUpdate() {
        List<Commission__c> newCommss = (List<Commission__c>) Trigger.new;
        Map<Id,Commission__c> oldCommssMap = (Map<Id,Commission__c>) Trigger.oldMap;

        CommissionTriggerHelper.homeServiceCommissionPaid(true, newCommss, oldCommssMap);

    }

    public override void afterDelete() {
        List<Commission__c> commissions = (List<Commission__c>) Trigger.old;

        CommissionTriggerHelper.homeServiceCommissionPaid(false, commissions, null);
    }
}