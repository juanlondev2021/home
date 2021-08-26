global class ScheduleSubInventoriesBatch_AC implements Schedulable{
/*******************
 *Created by  : MST
 *Description : This Schedule class is to auto creation of Billing and the Billing Line records for nuHome nuCard SUB weekly,
 *so that billing person can generate the Invoices for the Business Accounts correctly.
 **************************/
    global void execute(SchedulableContext SC){
    
           Database.executeBatch(new BatchBillingCreation_AC('nuHome nuCard SUB'),25);
       
    }
}