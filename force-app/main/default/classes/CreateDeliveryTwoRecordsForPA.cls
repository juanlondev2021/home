/*************************************************************************************************************************************************************************************************************************************************************************************
* Class Name : CreateDeliveryTwoRecordsForPA
* Created By : Sankar Marappan
* Created Date : 2/19/2016
* Description : This Batch class will get executed daily and create next Delivery Object record, if the delivery one record have status 'Hung' and its account respond date is null and meet days interval specified in the associated delivery parameter.
***************************************************************************************************************************************************************************************************************************************************************************************/
global class CreateDeliveryTwoRecordsForPA implements Database.Batchable<sObject>{
    global string query;
    public final integer BUFFER_DAYS;
    public CreateDeliveryTwoRecordsForPA(String q){
        query = q;
        BUFFER_DAYS = (Integer)Hung_Status_Setting__c.getInstance('Hung').Buffer_Days__c;
    }
    
    // Get all the accounts has delivery one records associated to it with HungStatus as 'Hung'
    global Database.QueryLocator start(Database.BatchableContext BC) { 
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Delivery_Object__c> deliveryList) {
        
        List<Delivery_Object__c> deliveriesToInsert = new List<Delivery_Object__c>();
        Map<String,Delivery_Parameter__c> branchWithNextDeliveryParam = new Map<String,Delivery_Parameter__c>();
        Map<String,Delivery_Parameter__c> branchWithCurrDeliveryParam = new Map<String,Delivery_Parameter__c>();
        Map<ID,Integer> accWithDeliveryNoMap = new Map<ID,Integer>();
        Map<String,Id> branchNameWithIds = new Map<String,Id>();
        Set<String> branches = new Set<String>();
        Map<String,List<Delivery_Parameter__c>> deliveryParameterMap = new Map<String,List<Delivery_Parameter__c>>();  
        
        for(Delivery_Object__c delivery : deliveryList){
            if(delivery.fBranch__c != null){
                //branchWithDeliveryNoMap.put(delivery.fBranch__c,Integer.valueOf(delivery.Name));
                branches.add(delivery.fBranch__c);
            }
        }
       System.debug('@@@: '+branches);
        // Get the active delivery parameter records based on the branch of the Delivery.
        if(branches.size() > 0){
            //get branch id by giving branch name for populating on delivery records
            for(Branch__c branch : [SELECT id,name FROM Branch__c WHERE name IN: branches AND branch_stage__c = 'Delivering']){
                branchNameWithIds.put(branch.name,branch.id);
            }
            System.debug('@@@: '+branchNameWithIds);
            if(branchNameWithIds.size() > 0){
            for(Delivery_Parameter__c currDeliveryParameter : [SELECT Id,Branch__c,Branch__r.Name,Included_ZipCodes__c,Min_Sales_Price__c,Days_Until_Next_Delivery__c,
                                                       Max_Sales_Price__c,Create_Date_in_SFDC__c,Close_Date__c,Delivery_Number__c ,Selected_Products__c FROM Delivery_Parameter__c
                                                       WHERE Active__c = true AND Branch__r.Branch_stage__c = 'Delivering' AND Branch__r.name IN: branchNameWithIds.keySet() order by Delivery_Number__c ASC 
                                                      ]){ 
                                                          if(deliveryParameterMap.get(currDeliveryParameter.Branch__r.Name) == null){
                                                                deliveryParameterMap.put(currDeliveryParameter.Branch__r.Name, new List<Delivery_Parameter__c>{currDeliveryParameter});
                                                            }
                                                            else{
                                                                deliveryParameterMap.get(currDeliveryParameter.Branch__r.Name).add(currDeliveryParameter);
                                                            } 
                                                      } 
            }//branches size check
        }
        System.Debug('The size of the deliveryParameterMap +'+deliveryParameterMap);
        for(Delivery_Object__c currDeliveryObject : deliveryList){ 
            Boolean createNextDelivery = false;
            Delivery_Parameter__c nextDeliveryParam = new Delivery_Parameter__c(); 
                if(deliveryParameterMap.containskey(currDeliveryObject.fbranch__c)){
                    Integer daysInterval = currDeliveryObject.Delivery_Date__c.Date().daysBetween(Date.today());
                    for(Delivery_Parameter__c deliveryParams : deliveryParameterMap.get(currDeliveryObject.fbranch__c) ){  
                        //Delivery no match corresponding delivery parameter
                        if(String.valueOf(deliveryParams.Delivery_Number__c) == currDeliveryObject.Name){
                            //Calculate days interval to create next delivery for that person
                            if(daysInterval >= Integer.valueOf(deliveryParams.Days_Until_Next_Delivery__c) && daysInterval <= Integer.valueOf(deliveryParams.Days_Until_Next_Delivery__c) + BUFFER_DAYS){
                                createNextDelivery = true;
                            }
                            else{
                                break;
                            }
                        }
                        if(createNextDelivery){
                            //find next delivery parameter for the current delivery no
                            if(String.valueOf(deliveryParams.Delivery_Number__c) > currDeliveryObject.Name){
                                nextDeliveryParam = deliveryParams;
                                break;
                            }
                        }
                    }//delivery param for loop end
                    if(nextDeliveryParam != null){
                        // Check if the Zip code of the account is included in the Delivery parameter or not. 
                           if(nextDeliveryParam.Included_ZipCodes__c != null && nextDeliveryParam.Included_ZipCodes__c.contains(currDeliveryObject.User_Address__r.Address__r.Zip_Code__c)){
                               system.debug('#########################');
                               // Check the sales price/Assessed value of the account is in the minimum and maximum price range of
                               // the delivery parameter if price values are available. 
                               Decimal price = currDeliveryObject.User_Address__r.Sales_Price__c != null ? currDeliveryObject.User_Address__r.Sales_Price__c : (currDeliveryObject.User_Address__r.Assessed_Value__c != NULL ? currDeliveryObject.User_Address__r.Assessed_Value__c : 0.0); 
                               //Date tempDate = currDeliveryObject.Person_Account__r.Sale_Date__c != null ? currDeliveryObject.Person_Account__r.Sale_Date__c : currDeliveryObject.Person_Account__r.Recording_Date__c ;
                               Date tempDate;
                               //Either of sale date or Recording date must have value, because we have add this initial query condition
                               if(currDeliveryObject.User_Address__r.Sale_Date__c  != Null && currDeliveryObject.User_Address__r.Recording_Date__c  != Null ){
                                   tempDate = currDeliveryObject.User_Address__r.Sale_Date__c  > currDeliveryObject.User_Address__r.Recording_Date__c ? currDeliveryObject.User_Address__r.Sale_Date__c : currDeliveryObject.User_Address__r.Recording_Date__c;
                               }else{
                                   tempDate = currDeliveryObject.User_Address__r.Sale_Date__c != null ? currDeliveryObject.User_Address__r.Sale_Date__c : currDeliveryObject.User_Address__r.Recording_Date__c ;      
                               }
                               
                                System.debug('Higher Date ============================>'+tempDate +'^^^^^^^^^'+currDeliveryObject.User_Address__r.CreatedDate +'((((((((((('+ nextDeliveryParam.Create_Date_in_SFDC__c +'<<<<<<<<<close'+nextDeliveryParam.Close_Date__c);
                               //Check the created date and the recording date of the account that falls on the future date when compared to the 'Close date' and 'Create Date in SFDC'
                                   // field values in the related delivery parameter record. 
                                   if((price != 0.0 ? price <= nextDeliveryParam.Max_Sales_Price__c && price >= nextDeliveryParam.Min_Sales_Price__c : price == 0.0)
                                      && currDeliveryObject.User_Address__r.CreatedDate >= nextDeliveryParam.Create_Date_in_SFDC__c && tempDate != Null && tempDate >= nextDeliveryParam.Close_Date__c){
                                         system.debug('&&&&&&&&&&&&&&&& Delivery condition');
                                          deliveriesToInsert.add(new Delivery_Object__c(Person_Account__c = currDeliveryObject.Person_Account__c,User_Address__c = currDeliveryObject.User_Address__c,Name = String.valueOf((Integer)nextDeliveryParam.Delivery_Number__c),Delivery_Parameter__c = nextDeliveryParam.id, Product_Details__c = UtilClass.genarateJson(nextDeliveryParam.Selected_Products__c),Branch_Object__c = branchNameWithIds.get(currDeliveryObject.fBranch__c),
                                                                                        Parent_Gift_Card_Order__c = UtilClass.getCheetahGiftCardOrderId(),Driver__c = UtilClass.getDriverId('Cheetah','Driver')));
                                      } 
                           }
                    }
                }
        }//current deliverylist for loop end 
        try{
            if(deliveriesToInsert.size() > 0){
                System.debug('**************Deliveriesss'+deliveriesToInsert.size());
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
            String[] toAddresses = new String[] {asynchronousJob.CreatedBy.Email};
            //String[] toAddresses = new String[] {'priyanka@mstsolutions.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Delivery 1 Batch Process: ' + asynchronousJob.Status);
            mail.setPlainTextBody('The current job is processed with ' + asynchronousJob.TotalJobItems +
                                  ' batches with '+ asynchronousJob.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }  
    }
}