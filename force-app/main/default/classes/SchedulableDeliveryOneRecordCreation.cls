/*********************************************************************************************
CreatedBy : Priyanka S
CreatedDate : 02-22-2016 
Description:Every day at 12 a.m PST the job runs to invoke CreateDeliveryOneRecordsForPA 
            class logic to insert the delivery one records.           
**********************************************************************************************/

global class SchedulableDeliveryOneRecordCreation implements Schedulable {
   global void execute(SchedulableContext sc) {
    	String query = 'SELECT Id,Address__r.Branch__c,Address__r.Zip_code__c,CreatedDate,UserAccount__r.CreatedDate,Sales_Price__c,Recording_Date__c,Sale_Date__c,Assessed_Value__c FROM User_Address__c WHERE User_Address_Type__c = \'Primary Owner\' AND Active__c = true AND UserAccount__r.IsPersonAccount = true AND Address__r.Branch__r.name NOT IN (null,\'Invalid Zip Code\',\'ZZ-Not Mapped\',\'ZZ-No_Delivery\') AND (Sale_Date__c != null OR Recording_Date__c != null) AND (Address__r.Home_Type__c = \'SF\' OR Address__r.Home_Type__c = \'Sfr\') AND Id NOT IN (SELECT User_Address__c FROM Delivery_object__c WHERE Name = \'1\') ORDER BY CreatedDate DESC LIMIT 50000';
        Database.Executebatch(new CreateDeliveryOneRecordsForPA(query),Integer.valueOf(Label.Batch_Size)); //Maximum batch size is 200. 
   }
}