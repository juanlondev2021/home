/***************************************************************************************************
 *Created by  : MST
 *Description : This Schedule class is to auto creation of Billing and the Billing Line records for OB Campaign weekly,
 *so that billing person can generate the Invoices for the Business Accounts correctly.
 
 Criteria: Inventory Record Type should be 'nuhome OB Campaign'.
   1. If there are multiple Inventory for which the Person Account and the Business Account is the same, 
      then just one Billing record and the Billing Line record needs to be created. 
   2. If there are multiple Person Accounts associated to the same business account, 
      then one billing record should be created and multiple billing line record needs to be created under the same billing record. 
   3. Single Invoice needs to be generated for each Business Account every week.    
 *************************************************************************************************/

global class ScheduleOBCInventoriesBatch_AC implements Schedulable{

    global void execute(SchedulableContext SC){
    
           Database.executeBatch(new BatchBillingCreation_AC('nuHome OB Campaign'),25);
       
    }
}