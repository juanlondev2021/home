/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Address Trigger
 * TestClass:          AddressTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    12/10/2020         Jull Quintero D         Initial implementation of the class.
 **/

public class AddressTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        List<Address__c> address = (List<Address__c>) Trigger.new;
        new AddressTriggerHelper().setFieldsAddress(address,null,Trigger.isInsert,Trigger.isUpdate);
    }

    public override void beforeUpdate() {
        List<Address__c> address = (List<Address__c>) Trigger.new;
        Map<Id,Address__c> oldAddressMap = (Map<Id,Address__c>) Trigger.oldMap;
        new AddressTriggerHelper().setFieldsAddress(address,oldAddressMap,Trigger.isInsert, Trigger.isUpdate);
    }

    public override void afterUpdate() {
        List<Address__c> address = (List<Address__c>) Trigger.new;
        Map<Id,Address__c> oldAddressMap = (Map<Id,Address__c>) Trigger.oldMap;
        AddressTriggerHelper.updatePropertyName(address,oldAddressMap);
    }
}