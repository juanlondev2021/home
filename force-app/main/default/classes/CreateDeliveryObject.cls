/*********************************************************************************************************************************
* Class Name : CreateDeliveryObject
* Created By : Sailappa Vignesh P G
* Created Date : 2/18/2016
* Author: MST
* Description : This Batch class will get excuted daily and create new Delivery Object record based on the condition provided in the 'Hang Status' Custom Setting.
******************************************************************************************************************************/
global class CreateDeliveryObject implements Database.Batchable<sObject>{
    /*The methods will query the list of Devlivery Object that are recently created and status not equals to null*/
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Name,Hung_Status__c,Parent_Gift_Card_Order__c,Driver__c,No_of_Attempts__c,user_Address__r.createddate,User_Address__r.Address__r.Branch__c,Delivery_Parameter__r.Days_Until_Next_Delivery__c,Delivery_Date__c,Person_Account__c,Branch_Object__c,User_Address__r.Sales_Price__c,User_Address__r.Assessed_Value__c,User_Address__r.Address__r.Zip_Code__c,User_Address__r.Recording_Date__c,User_Address__r.Sale_Date__c,Person_Account__r.createddate,lastmodifieddate,User_Address__r.Respond_Date__c FROM Delivery_Object__c WHERE Branch_Object__r.Branch_stage__c = \'Delivering\' AND isRecent__c = true AND Hung_Status__c != Null AND Delivery_Date__c != Null AND Hung_Status__c != \'Hung\' AND User_Address__r.userAccount__r.isPersonAccount = true AND user_address__r.Address__r.Zip_Code__c != null';
        return Database.getQueryLocator(query);    
    }
    /*This method will process the list of Delivery Object records and will check with rules stored in 'Hung Status'Custom Object for new Devlivery Object record creation. */
    global void execute(Database.BatchableContext BC, List<Delivery_Object__c> deliveryObjectLst){
        List<Delivery_Object__c> deliveryObjectRecordLst = new List<Delivery_Object__c>();
        Map<Id,List<Delivery_Parameter__c>> deliveryParameterMap = new Map<Id,List<Delivery_Parameter__c>>();                    
        Set<Id> branchIdSet = new Set<Id>();
        Map<string,map<String,Hung_Status__c>> hangStatus = new Map<string,map<String,Hung_Status__c>>();        
        for(Hung_Status__c currHungStatus : [SELECT Delivery_Product__r.name,Hung_Status_Salesforce__c,Maximum_number_of_attempts_per_status__c,Name,Days_until_next_attempt__c FROM Hung_Status__c]){
            if(hangStatus.get(currHungStatus.Delivery_Product__r.name) == null){
                hangStatus.put(currHungStatus.Delivery_Product__r.name, new map<String,Hung_Status__c>{currHungStatus.Hung_Status_Salesforce__c => currHungStatus});
            }
            else{
                hangStatus.get(currHungStatus.Delivery_Product__r.name).put(currHungStatus.Hung_Status_Salesforce__c,currHungStatus);
            }            
        }
        System.Debug('The size of the Delivery Object is +'+deliveryObjectLst.size());
        System.Debug('The size of the hangStatus +'+hangStatus);
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){
            branchIdSet.add(currDeliveryObject.Branch_Object__c);
        }   
        for(Delivery_Parameter__c currDeliveryParameter : [SELECT ID,Delivery_Number__c,Allow_Multiple_Attempts__c,Branch__c,Selected_Products__c,Branch__r.Name,Included_ZipCodes__c,Min_Sales_Price__c,
                                             Max_Sales_Price__c,Create_Date_in_SFDC__c,Close_Date__c FROM Delivery_Parameter__c WHERE Branch__r.Branch_stage__c = 'Delivering' And Branch__c IN : branchIdSet and Active__c = True]){
            if(deliveryParameterMap.get((ID)currDeliveryParameter.Branch__c) == null){
                deliveryParameterMap.put((ID)currDeliveryParameter.Branch__c, new List<Delivery_Parameter__c>{currDeliveryParameter});
            }
            else{
                deliveryParameterMap.get((ID)currDeliveryParameter.Branch__c).add(currDeliveryParameter);
            } 
        }
        System.Debug('The size of the deliveryParameterMap +'+deliveryParameterMap);
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){             
            Boolean allowMultipleAttempt = false;
            String productName;     
            Delivery_Parameter__c deliveryParameter = new Delivery_Parameter__c();            
            if(deliveryParameterMap.containsKey(currDeliveryObject.Branch_Object__c)){
                for(Delivery_Parameter__c currDeliveryParameter : deliveryParameterMap.get(currDeliveryObject.Branch_Object__c) ){                     
                    if(String.valueOf(currDeliveryParameter.Delivery_Number__c) == currDeliveryObject.Name && currDeliveryParameter.Allow_Multiple_Attempts__c && currDeliveryParameter.Included_ZipCodes__c != NULL && currDeliveryParameter.Included_ZipCodes__c.contains(currDeliveryObject.user_address__r.Address__r.Zip_Code__c) ){
                        allowMultipleAttempt = true;
                        deliveryParameter = currDeliveryParameter;
                        if(currDeliveryParameter.Selected_Products__c != Null){
                            productName = currDeliveryParameter.Selected_Products__c;    
                        }
                        break;
                    }
                }
            }
            if(allowMultipleAttempt){
                Hung_Status__c  currHangStatus = hangStatus.containsKey(productName.split(',')[0]) ? hangStatus.get(productName.split(',')[0]).get(currDeliveryObject.Hung_Status__c) : Null;
                Integer intervalDays =  currDeliveryObject.Delivery_Date__c.Date().daysBetween(System.today());                 
                Decimal price = currDeliveryObject.User_Address__r.Sales_Price__c != Null ? currDeliveryObject.User_Address__r.Sales_Price__c : (currDeliveryObject.User_Address__r.Assessed_Value__c != NULL ? currDeliveryObject.User_Address__r.Assessed_Value__c : 0.0);
                //Date tempDate = currDeliveryObject.Person_Account__r.Sale_Date__c != null ? currDeliveryObject.Person_Account__r.Sale_Date__c : currDeliveryObject.Person_Account__r.Recording_Date__c ;
                Date tempDate;
                //Either of sale date or Recording date must have value, because we have add this initial query condition
                if(currDeliveryObject.User_Address__r.Sale_Date__c  != Null && currDeliveryObject.User_Address__r.Recording_Date__c  != Null ){
                    tempDate = currDeliveryObject.User_Address__r.Sale_Date__c  > currDeliveryObject.User_Address__r.Recording_Date__c ? currDeliveryObject.User_Address__r.Sale_Date__c : currDeliveryObject.User_Address__r.Recording_Date__c;
                }else{
                    tempDate = currDeliveryObject.User_Address__r.Sale_Date__c != null ? currDeliveryObject.User_Address__r.Sale_Date__c : currDeliveryObject.User_Address__r.Recording_Date__c;      
                }
                System.debug('Higher Date ============================>'+tempDate);
                if(currHangStatus != Null && ((price != 0.0 ? price <= deliveryParameter.Max_Sales_Price__c && price >= deliveryParameter.Min_Sales_Price__c : price == 0.0)
                   && currDeliveryObject.User_Address__r.CreatedDate >= deliveryParameter.Create_Date_in_SFDC__c && tempDate != null && tempDate >= deliveryParameter.Close_Date__c)){
                    if(currDeliveryObject.Hung_Status__c != 'Hung' && currDeliveryObject.Hung_Status__c == currHangStatus.Hung_Status_Salesforce__c && intervalDays == currHangStatus.Days_until_next_attempt__c && currDeliveryObject.No_of_Attempts__c < currHangStatus.Maximum_number_of_attempts_per_status__c ){
                        Delivery_Object__c   deliveryObjectRecord = new  Delivery_Object__c();
                        deliveryObjectRecord.Name = currDeliveryObject.Name;
                        deliveryObjectRecord.Parent_Gift_Card_Order__c = currDeliveryObject.Parent_Gift_Card_Order__c;
                        deliveryObjectRecord.Driver__c = currDeliveryObject.Driver__c;
                        deliveryObjectRecord.person_account__c = currDeliveryObject.person_account__c;
                        deliveryObjectRecord.User_Address__c = currDeliveryObject.User_Address__c;
                        deliveryObjectRecord.Branch_Object__c = currDeliveryObject.Branch_Object__c;
                        deliveryObjectRecord.Delivery_Parameter__c = deliveryParameter.id;
                        deliveryObjectRecord.Product_Details__c = UtilClass.genarateJson(productName);                        
                        deliveryObjectRecordLst.add(deliveryObjectRecord);
                    }
                }
            }
        }    
        if(deliveryObjectRecordLst.size() > 0){
            try{
                insert deliveryObjectRecordLst;    
            }catch(Exception ex){
                System.debug('DML Exception'+ex.getMessage());
            }
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