/*******************************************************************************************
 *Created by  : MST
 *Description : This Schedule class is to auto creation of Billing and the Billing Line records for Door Tag Script weekly,
 *              so that billing person can generate the Invoices for the Business Accounts correctly.
 * Criteria : The Door Tag Script inventory record would need to have a matching Billing opportunity based 
              on the Product and a survey response equals to a “Y” or a positive response value such as Blinds and Shutters.
*******************************************************************************************/
 
global class ScheduleDTSInventories_AC implements Schedulable{

    global void execute(SchedulableContext SC){
        
        Database.executeBatch(new BatchBillingCreation_AC('nuHome Door Tag Script'),25);
        
    }
}