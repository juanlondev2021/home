/*********************************************************************************
     *Created by  : MST
     *Description : This Schedule class is to auto creation of Billing and the Billing Line records for nuHome nuCard CPL weekly,
     *so that billing person can generate the Invoices for the Business Accounts correctly.
     If there are multiple Inventory for which the Person Account and the Business Account is the same, 
     then just one Billing record and the Billing Line record needs to be created.
     If there are multiple Person Accounts associated to the same business account, then one billing record should be created and 
     multiple billing line record needs to be created under the same billing record.
*************************************************************************************/

global class ScheduleCPLInventories_AC implements Schedulable{
    
    global void execute(SchedulableContext SC){
    
           Database.executeBatch(new BatchBillingCreation_AC('nuHome nuCard CPL'),25);
       
    }
}