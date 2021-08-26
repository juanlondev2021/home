/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Account Trigger
 * TestClass:          AccountTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    09-11-2020         Jull Quintero D         Initial implementation of the class.
 **/
public class AccountTriggerHandler extends TriggerHandler{
    
    public override void beforeInsert() {
        List<Account> newAcc = (List<Account>) Trigger.new;  
        Map<Id,Account> newAccMap = (Map<Id,Account>) Trigger.newMap;
        AccountTriggerHelper.responseDate(newAcc,null,Trigger.isInsert,Trigger.isUpdate);
    }

    public override void beforeUpdate() {
        List<Account> newAcc = (List<Account>) Trigger.new;
        Map<Id,Account> newAccMap = (Map<Id,Account>) Trigger.newMap;
        Map<Id,Account> oldAccMap = (Map<Id,Account>) Trigger.oldMap; 

        AccountTriggerHelper.responseDate(newAcc,oldAccMap,Trigger.isInsert,Trigger.isUpdate);
        AccountTriggerHelper.setAccounts(newAcc,oldAccMap);
    }

    public override void afterInsert() {
        List<Account> newAcc = (List<Account>) Trigger.new;
        Map<Id,Account> newAccMap = (Map<Id,Account>) Trigger.newMap;
        Map<Id,Account> oldAccMap = (Map<Id,Account>) Trigger.oldMap; 
        AccountTriggerHelper.geoAccuracy(newAcc,newAccMap,oldAccMap,Trigger.isInsert,Trigger.isUpdate);
    }

    public override void afterUpdate() {
        List<Account> newAcc = (List<Account>) Trigger.new;
        Map<Id,Account> newAccMap = (Map<Id,Account>) Trigger.newMap; 
        Map<Id,Account> oldAccMap = (Map<Id,Account>) Trigger.oldMap; 

        AccountTriggerHelper.setPhoneForUserAddress(newAccMap, oldAccMap);
        AccountTriggerHelper.opportunityonChangeOWner(newAccMap, oldAccMap);
        AccountTriggerHelper.geoAccuracy(newAcc,newAccMap,oldAccMap,Trigger.isInsert,Trigger.isUpdate);
        AccountTriggerHelper.getDeliveryGeoLocation(newAccMap,oldAccMap);
    }
}