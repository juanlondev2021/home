/*********************************************************************************************
Author : Priyanka S
CreatedDate : 02-22-2016 
Description:Every day at 12 a.m PST the job runs to invoke CreateDeliveryTwoRecordsForPA 
            class logic to insert the delivery two records.           
**********************************************************************************************/

global class SchedulableDeliveryTwoRecordCreation implements Schedulable {
   global void execute(SchedulableContext sc) {
      String query = 'SELECT Id,Name,fbranch__c,Hung_Status__c,Branch_Object__c,User_address__r.createddate,User_Address__r.Address__r.Branch__c,Delivery_Parameter__r.Days_Until_Next_Delivery__c,Delivery_Date__c,Person_Account__c,User_Address__r.Sales_Price__c,User_Address__r.Assessed_Value__c,User_Address__r.Address__r.Zip_Code__c,User_Address__r.Sale_Date__c,User_Address__r.Recording_Date__c,Person_Account__r.createddate,lastmodifieddate,User_Address__r.Respond_Date__c FROM Delivery_Object__c WHERE Hung_Status__c = \'Hung\' AND Delivery_Date__c != null AND Person_Account__r.isPersonAccount = true AND User_Address__r.Address__r.Branch__c != null AND (User_Address__r.Sale_Date__c != null OR User_Address__r.Recording_Date__c != null) AND User_Address__r.Respond_Date__c = null AND IsRecent__c = true';
      database.executebatch(new CreateDeliveryTwoRecordsForPA(query),200); //Maximum batch size is 200.
   }
}