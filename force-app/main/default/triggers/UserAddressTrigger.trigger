/***********************************************************************************
* Trigger Name : UserAddressTrigger
* Created By   : Sailappa Vignesh P G  
* Created Date : 3/17/2016 
* Author       : MST
* Description  : This Trigger populates value for respond date when phone or mobilePhone change from null to not null. 
* And when respond date got value then set driver lead status to data for the corresponding delivery with status as Hung. 
* modification:
* William Aldana - 09-22-2020 - Aplying new trigger frameworks
****************************************************************************************/
Trigger UserAddressTrigger on User_Address__c (before insert,after insert,after update,before update) {
    new UserAddressTriggerHandler().run('UserAddressTrigger');
}