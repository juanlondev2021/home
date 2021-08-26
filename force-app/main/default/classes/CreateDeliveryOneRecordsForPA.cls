/*************************************************************************************************************************************************************************************************************************************************************************************
* Class Name : CreateDeliveryOneRecordsForPA
* Created By : Priyanka Shanmugam
* Created Date : 2/12/2016
* Description : This Batch class will get executed daily and create a Delivery Object record, if the account don't have delivery already and meet specified values in the delivery parameter.
***************************************************************************************************************************************************************************************************************************************************************************************/
global class CreateDeliveryOneRecordsForPA implements Database.Batchable<sObject>{    
    global string query;
    
    public CreateDeliveryOneRecordsForPA(String q){
        query = q;
    }
    
    // Get the list of accounts that has no delivery records associated to it.
    global Database.QueryLocator start(Database.BatchableContext BC) {               
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User_Address__c> userAddressList) {
        
        List<Delivery_Object__c> deliveriesToInsert = new List<Delivery_Object__c>();
        Map<Id,User_Address__c> userAddressMap = new Map<Id,User_Address__c>();
        Map<String,Delivery_Parameter__c> branchWithDeliveryParam = new Map<String,Delivery_Parameter__c>();
        Set<Id> branchIds = new Set<Id>();
        
        // Get all the accounts has no delivery records associated to it. Also get the branch of the account
        for(User_Address__c userAddress : userAddressList){                          
                userAddressMap.put(userAddress.Id,userAddress);
                branchIds.add(userAddress.Address__r.Branch__c);
         }
        
        // Get the delivery parameter record based on the branch of the account.
        if(branchIds.size() > 0){
            List<Delivery_Parameter__c> deliveryParamList = [SELECT Id,Branch__c,Branch__r.Name,Included_ZipCodes__c,Min_Sales_Price__c,
                                                             Max_Sales_Price__c,Create_Date_in_SFDC__c,Close_Date__c,Delivery_Number__c ,Selected_Products__c FROM 
                                                             Delivery_Parameter__c WHERE Active__c = true AND Branch__r.Branch_stage__c = 'Delivering' AND Branch__c IN: branchIds order by Delivery_Number__c ASC ];
            if(deliveryParamList.size() > 0){
                for(Delivery_Parameter__c deliveryParam : deliveryParamList){                                                     
                    if(!branchWithDeliveryParam.containsKey(deliveryParam.Branch__c)){
                        branchWithDeliveryParam.put(deliveryParam.Branch__c,deliveryParam);
                    }                                                
                } 
            }
        }
        // Create the delivery records based on the appropriate account values 
        if(userAddressMap.size() > 0 && branchWithDeliveryParam.size() > 0 ){  
            //System.debug('##accountMap: '+accountMap.keyset());
            for(Id userAddressId : userAddressMap.keyset()){
                User_Address__c userAddress = userAddressMap.get(userAddressId);
                //System.debug('##UtilClass.validateAccAddress(account): '+UtilClass.validateAccAddress(account));
                
                if(branchWithDeliveryParam.containskey(userAddress.Address__r.Branch__c)){
                    Delivery_Parameter__c deliveryParam = branchWithDeliveryParam.get(userAddress.Address__r.Branch__c);                    
                        // Check if the Zip code of the account is included in the Delivery parameter or not.
                        if(deliveryParam.Included_ZipCodes__c != null && deliveryParam.Included_ZipCodes__c.contains(userAddress.Address__r.Zip_Code__c)){
                            //Check the sales price/Assessed value of the account is in the minimum and maximum price range of the delivery parameter.  
                            Decimal price = userAddress.Sales_Price__c != null ? userAddress.Sales_Price__c : (userAddress.Assessed_Value__c != null ? userAddress.Assessed_Value__c : 0.0);                        
                           // Date tempDate = userAddress.Sale_Date__c != null ? userAddress.Sale_Date__c : userAddress.Recording_Date__c ;
                             Date tempDate;
                            //Either of sale date or Recording date must have value, because we have add this initial query condition
                            if(userAddress.Sale_Date__c != Null && userAddress.Recording_Date__c != Null ){
                                tempDate = (userAddress.Sale_Date__c > userAddress.Recording_Date__c ? userAddress.Sale_Date__c : userAddress.Recording_Date__c);
                            }else{
                                tempDate = userAddress.Sale_Date__c != null ? userAddress.Sale_Date__c : userAddress.Recording_Date__c;      
                            }  
                                //Check the created date and the recording date of the account falls on the future date when compared to the 'Close date'
                            // and 'Create Date in SFDC' field values in the related delivery parameter record.  
                                if((price != 0.0 ?  price <= deliveryParam.Max_Sales_Price__c && price >= deliveryParam.Min_Sales_Price__c : price == 0.0)
                               && userAddress.CreatedDate >= deliveryParam.Create_Date_in_SFDC__c && tempDate!= Null && tempDate >= deliveryParam.Close_Date__c){
                                   deliveriesToInsert.add(new Delivery_Object__c(Person_Account__c = userAddress.UserAccount__c, User_Address__c = userAddress.Id,Name = String.valueOf((Integer)deliveryParam.Delivery_Number__c),Delivery_Parameter__c = deliveryParam.id, Product_Details__c = UtilClass.genarateJson(deliveryParam.Selected_Products__c),Branch_Object__c = deliveryParam.Branch__c,
                                                                                 Parent_Gift_Card_Order__c = UtilClass.getCheetahGiftCardOrderId(),Driver__c = UtilClass.getDriverId('Cheetah','Driver')));
                               } 
                        }
                }
            }
        }  
        // Create delivery record
        try{
            if(deliveriesToInsert.size() > 0){
            system.debug('Delivery will be inserted');
                insert deliveriesToInsert;                
            }
        }
        catch(DMLException e){
            System.debug('Error inserting the delivery records'+ e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job  
        // from Database.BatchableContext.Query the AsyncApexJob object to retrieve the current job's information.  
        
        AsyncApexJob asynchronousJob = [SELECT Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                                        TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];       
        if(asynchronousJob.NumberOfErrors > 0){
            // Send an email to the Apex job's submitter to notify the job completion.  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {asynchronousJob.CreatedBy.Email};
            String[] toAddresses = new String[] {Label.Batch_Failure_Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Delivery 1 Batch Process: ' + asynchronousJob.Status);
            mail.setPlainTextBody('The current job is processed with ' + asynchronousJob.TotalJobItems +
                                  ' batches with '+ asynchronousJob.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
}