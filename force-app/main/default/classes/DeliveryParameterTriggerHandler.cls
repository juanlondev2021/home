/******************************************************************************
Created By : Sankar Marappan
Created Date : 2/9/2016
Author : MST Developer
Description : Inactive the old delivery parameters and make the recent delivery parameter
as active.
*******************************************************************************/
public class DeliveryParameterTriggerHandler {
    public static void updateDeliveryParameter(List<Delivery_Parameter__c> paramList){
        
        Set<Id> branchIds = new Set<Id>();
        Set<Id> deliveryParamIds = new Set<Id>();
        Set<Integer> deliveryNumbers = new Set<Integer>();
        
        for(Delivery_Parameter__c param : paramList){
            if(param.Branch__c != null){
                branchIds.add(param.Branch__c);
            }
            deliveryParamIds.add(param.id);
            deliveryNumbers.add((Integer)param.delivery_number__c);
        }
        List<Delivery_Parameter__c> activeParamList = [SELECT id,Active__c FROM Delivery_Parameter__c WHERE Active__c = true AND Branch__c IN: branchIds AND Id NOT IN: deliveryParamIds AND Delivery_Number__c IN: deliveryNumbers ];
        System.debug('@@activeParamList: '+activeParamList);
        if(activeParamList.size() > 0){
            for(Delivery_Parameter__c param : activeParamList){
                param.Active__c = false;
            }            
            update activeParamList;
        }
    }
}