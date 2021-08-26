/*******************
 *Created by  : MST
 *Description : This Schedule class is to auto creation of Billing and the Billing Line records for Hot Leads weekly,
 *so that billing person can generate the Invoices for the Business Accounts correctly.
 * Criteria for creating billing record is:
   1. The inventory record should match off the product in the opportunity to determine which Hot Lead Tier 
   as well as matching off of the opportunity stage Active 1, Active 2, Active 3.
   2. if(opportunity stage = Active 1) -> Hot Lead T1 Active Date = greater than 3 days (or)
      if(opportunity stage = Active 2)-> Hot Lead T2  Active Date= greater than 7 days 
      if(opportunity stage = Active 3) -> Hot Lead T3  Active Date = greater than 21 days
 **************************/

global class ScheduleHLInventoriesBatch_AC implements Schedulable{

    global void execute(SchedulableContext SC){
    
          // Calling Batch Class for Creating Billing records for Hot leads inventory records. Batch size is 25.
          
           Database.executeBatch(new BatchBillingCreation_AC('nuHome Hot Lead'),25);
        
    }
}