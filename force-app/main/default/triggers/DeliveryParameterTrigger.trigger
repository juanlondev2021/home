/******************************************************************************
Created By : Sankar Marappan
Created Date : 2/9/2016
Author : MST Developer
Description : Inactive the old delivery parameters and make the recent delivery parameter
as active.
*******************************************************************************/
trigger DeliveryParameterTrigger on Delivery_Parameter__c (before insert) {
    List<Delivery_Parameter__c> toUpdateDeliveryParamList = new List<Delivery_Parameter__c>();
    for(Delivery_Parameter__c param : Trigger.new){                        
        //Get list of Delivery parameter to inactive old delivery parameters,since an Branch can
        // have only one Delivery parameter as Active at a time.
        if(param.Active__c){
            toUpdateDeliveryParamList.add(param); 
        }
    }
    if(!toUpdateDeliveryParamList.isEmpty()){
        DeliveryParameterTriggerHandler.updateDeliveryParameter(toUpdateDeliveryParamList);
    }
}