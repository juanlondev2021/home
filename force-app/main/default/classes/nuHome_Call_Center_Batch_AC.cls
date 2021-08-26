/****************************************************************************
* Created By   : MSTSolutions
* Created Date : 25 December 2016
* Description  : Batch class to check result for the priorities and create call records for the priorities.
* **************************************************************************/
Global class nuHome_Call_Center_Batch_AC Implements Database.Batchable<sObject>{

    Public String priorityInsId;
    Public String batchId;
    Public List<CallCenterPriority__c> prioritiesList;
    Public String futureJobId;
    Public String jobType;
    Public String campaignCenterId;
    Public String campaignIndustry;

    Public nuHome_Call_Center_Batch_AC(String priorityId,String batchTrackerId,String batchJobType){
        prioritiesList  =   New List<CallCenterPriority__c>();
        priorityInsId   =   priorityId;
        futureJobId     =   batchTrackerId;
        jobType         =   batchJobType;
        prioritiesList  =   [SELECT Id,CallCenterCampaign__r.Industry__c,CallCenterCampaign__r.Industry__r.Name,CallCenterCampaign__r.Region__c,CallCenterCampaign__c,
                             ConsiderSurveyResponseinUserAddress__c,DailyCallCount__c,OBCMMatchingInventories__c,OBCMUnMatchingInventories__c,
                             Priorityforrecentresponddate__c,RespondDateMaximumRange__c,RespondDateMinRange__c FROM CallCenterPriority__c
                             WHERE Id = :priorityInsId];
        if(prioritiesList.size() > 0){
            campaignCenterId    =   prioritiesList[0].CallCenterCampaign__c;
            campaignIndustry    =   prioritiesList[0].CallCenterCampaign__r.Industry__c;
        }
        system.debug('priorityInsId value '+priorityInsId+' prioritiesList '+prioritiesList);
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        String doorTagScript   =   Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        String queryIndustry    =   '';
        String queryRegion      =   '';
        Set<Id> OBCMSet             =   New Set<Id>();
        Set<Id> userAddressSet      =   New Set<Id>();
        Set<Id> userAddressmat      =   New Set<Id>();
        Set<Id> userAddressUnmat    =   New Set<Id>();
        Set<Id> userAddressCall     =   New Set<Id>();
        Set<Id> userAddressRespond  =   New Set<Id>();

        if(prioritiesList.size() > 0){
            queryIndustry   =   prioritiesList[0].CallCenterCampaign__r.Industry__c;
            queryRegion     =   prioritiesList[0].CallCenterCampaign__r.Region__c;

            if(queryRegion.length() > 14)
                queryRegion     =   queryRegion.substring(0, 15);
            if(queryIndustry.length() > 14)
                queryIndustry   =   queryIndustry.substring(0, 15);

            system.debug('For region '+queryRegion+' and for industry '+queryIndustry);

            if((queryIndustry != '') && (queryRegion != '')){

                string query = 'SELECT Id,Name,User_Address__c,User_Address__r.fAddress_Branch__c,Industry__r.Name,User_Address__r.fzipCode__c FROM OB_Campaign_Member__c WHERE Industry__c = :queryIndustry AND SOQLRegion__c = :queryRegion';
                return Database.getQueryLocator(query);
            }
        }

        return Null;

    }

    global void execute(Database.BatchableContext BC, List<OB_Campaign_Member__c> scope) {
        String doorTagScript    =   Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        Id oppRecordTypeId      =   Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId();
        String queryIndustry    =   '';
        String queryRegion      =   '';
        Set<Id> OBCMSet             =   New Set<Id>();
        Set<Id> userAddressSet      =   New Set<Id>();
        Set<Id> userAddressmat      =   New Set<Id>();
        Set<Id> userAddressUnmat    =   New Set<Id>();
        Set<Id> userAddressCall     =   New Set<Id>();
        Set<Id> userAddressRespond  =   New Set<Id>();

        Integer OBCMCount       =   0;
        Integer MatchingCount   =   0;
        Integer UnMatchingCount =   0;
        Integer CallCount       =   0;
        Integer RespondDate     =   0;
        Map<String,Id> selectedProductMap   =   New Map<String,Id>();
        Map<String,String> selectedZipCodeMap   =   New Map<String,String>();
        Set<ID> opportunityIDSet = New Set<ID>();

        for(OB_Campaign_Member__c OBC:scope){
            String productName  =   OBC.User_Address__r.fAddress_Branch__c+'-'+OBC.Industry__r.Name;
            if(!selectedProductMap.containsKey(productName)){
                selectedProductMap.put(productName,OBC.User_Address__c);
                selectedZipCodeMap.put(productName,OBC.User_Address__r.fzipCode__c);
                }
        }

        For(OpportunityLineItem oppLine:[SELECT product2.Name,opportunityId,product2.available_zipcodes__c FROM opportunityLineItem
                                         WHERE product2.Name IN:selectedProductMap.keySet() AND Opportunity.RecordTypeId = :oppRecordTypeId
                                         AND Opportunity.StageName = 'Closed Won']){
            system.debug(oppLine.product2.Name+'/'+oppLine.product2.available_zipcodes__c);
            Set<String> zipCodesSet = new Set<String>();

            if(oppLine.product2.available_zipcodes__c != Null && oppLine.product2.available_zipcodes__c != ''){
                for(String currZip : oppLine.product2.available_zipcodes__c.split(';')){
                    zipCodesSet.add(currZip);
                }
            }
            if(zipCodesSet.contains(selectedZipCodeMap.get(oppLine.product2.Name))){
                userAddressSet.add(selectedProductMap.get(oppLine.product2.Name));
            }
        }

        OBCMCount   =   userAddressSet.size();

        system.debug('**user address filter** '+userAddressSet.size());
        system.debug('**OBCMSet filter** '+OBCMSet.size());
        //AND Last_Disposition_Date_Time__c = Today
        if(prioritiesList[0].DailyCallCount__c != Null && userAddressSet.size() > 0){

            for(Door_Tag_Script__c DTS:[SELECT Id,User_Address__c,DailyCallCount__c FROM Door_Tag_Script__c WHERE User_Address__c IN :userAddressSet AND DailyCallCount__c <= :prioritiesList[0].DailyCallCount__c AND Last_Disposition_Date_Time__c = Today]){
                userAddressCall.add(DTS.User_Address__c);
            }
        }

        CallCount   =   userAddressCall.size();

        if(prioritiesList[0].OBCMMatchingInventories__c != Null){
            Date matchingDate = system.today().addDays(Integer.valueof('-'+prioritiesList[0].OBCMMatchingInventories__c));
            system.debug('matchingDate value '+matchingDate);
            for(Inventory__c inv:[SELECT Id,User_Address__c FROM Inventory__c WHERE UnMatching_Invetnory__c = False AND Survey_Response__c = 'Verified Lead' AND CreatedDate >= :matchingDate AND recordTypeId = :doorTagScript AND User_Address__c IN: userAddressCall]){
                userAddressmat.add(inv.User_Address__c);
            }
        }

        MatchingCount   =   userAddressmat.size();

        if(prioritiesList[0].OBCMUnMatchingInventories__c != Null){
            Date matchingDate2 = system.today().addDays(Integer.valueof('-'+prioritiesList[0].OBCMUnMatchingInventories__c));
            for(Inventory__c inv:[SELECT Id,User_Address__c FROM Inventory__c WHERE UnMatching_Invetnory__c = True AND Survey_Response__c = 'Verified Lead' AND CreatedDate >= :matchingDate2 AND recordTypeId = :doorTagScript AND User_Address__c IN: userAddressCall]){
                userAddressUnmat.add(inv.User_Address__c);
            }
        }

        UnMatchingCount =   userAddressUnmat.size();

        Set<Id> tempList = New Set<Id>();
        for(Id Ids:userAddressCall){
            if(!userAddressmat.contains(Ids))
                tempList.add(Ids);
        }
        if(tempList.size() > 0){
            userAddressCall.clear();
            userAddressCall.addAll(tempList);
            tempList.clear();
        }


        userAddressCall.addAll(userAddressUnmat);

        if(prioritiesList[0].RespondDateMinRange__c != Null && prioritiesList[0].RespondDateMaximumRange__c != Null && userAddressCall.size() > 0 && jobType != 'Rollover'){

            Date max = Date.today().addDays(-Integer.valueOf(prioritiesList[0].RespondDateMaximumRange__c));
            Date min = Date.today().addDays(-Integer.valueOf(prioritiesList[0].RespondDateMinRange__c));
            system.debug(max+'/'+min);
            for(Door_Tag_Script__c DTS:[SELECT Id,User_Address__c,DailyCallCount__c,User_Address__r.Respond_Date__c FROM Door_Tag_Script__c
                                        WHERE User_Address__c IN :userAddressCall AND User_Address__r.Respond_Date__c >= :max
                                        AND User_Address__r.Respond_Date__c <= :min]){
                                            userAddressRespond.add(DTS.User_Address__c);
                                        }
        }
        
        if(prioritiesList[0].RespondDateMinRange__c != Null && userAddressCall.size() > 0 && jobType == 'Rollover'){
            Date min = Date.today().addDays(-Integer.valueOf(prioritiesList[0].RespondDateMinRange__c));
            for(Door_Tag_Script__c DTS:[SELECT Id,User_Address__c,DailyCallCount__c,User_Address__r.Respond_Date__c FROM Door_Tag_Script__c
                                        WHERE User_Address__c IN :userAddressCall AND User_Address__r.Respond_Date__c = :min]){
                                            userAddressRespond.add(DTS.User_Address__c);
                                        }
        }

        RespondDate =   userAddressRespond.size();

        system.debug('**Respond date filter** '+userAddressRespond.size());
        system.debug('**Call count filter** '+userAddressCall.size());

        List<CallRecords__c> callLogList   =   New List<CallRecords__c>();
        Integer resultCount = 0;
        if(userAddressRespond.size() > 0)
            resultCount =   userAddressRespond.size();
        else if(userAddressCall.size() > 0)
            resultCount =   userAddressCall.size();
        else
            resultCount =   userAddressSet.size();

        
        set<Id> DNCusers = New set<Id>();
        
        if(jobType != 'Query'){
            for(CallRecords__c callRecords:[SELECT Id,User_Address__c FROM CallRecords__c WHERE (User_Address__c IN:userAddressRespond
                                           OR User_Address__c IN:userAddressCall OR User_Address__c IN:userAddressSet) AND (CallDisposition__c = 'DNC')]){
                DNCusers.add(callRecords.User_Address__c);
            }

            for(CallRecords__c callRecords:[SELECT Id,User_Address__c FROM CallRecords__c WHERE (CallCenterCampaign__r.Industry__c =:campaignIndustry) AND (User_Address__c IN:userAddressRespond
                                           OR User_Address__c IN:userAddressCall OR User_Address__c IN:userAddressSet) AND (CallDisposition__c  =  'Appointment set' OR CallDisposition__c = 'Not interested' OR CallDisposition__c = 'Wrong number' OR CallDisposition__c = 'Has provider' OR CallDisposition__c = 'Call back')]){
                DNCusers.add(callRecords.User_Address__c);
            }
        }
        
        if(jobType == 'Query'){

            CheckResultsJob__c futureJobIns =   [SELECT Id,Job_Result__c,OBCMUserAddress__c,MatchingInventory__c,UnmatchingInventory__c,
                                                 CallCountFiltered__c,RespondDateFiltered__c FROM CheckResultsJob__c WHERE Id = :futureJobId];

            CheckResultsJob__c futureJob    =   New CheckResultsJob__c();
            futureJob.Id                    =   futureJobId;

            if(futureJobIns.Job_Result__c != Null)
                futureJob.Job_Result__c         =   futureJobIns.Job_Result__c + resultCount;
            else
                futureJob.Job_Result__c         =   resultCount;

            if(futureJobIns.OBCMUserAddress__c != Null)
                futureJob.OBCMUserAddress__c         =   futureJobIns.OBCMUserAddress__c + OBCMCount;
            else
                futureJob.OBCMUserAddress__c    =   OBCMCount;

            if(futureJobIns.MatchingInventory__c != Null)
                futureJob.MatchingInventory__c         =   futureJobIns.MatchingInventory__c + MatchingCount;
            else
                futureJob.MatchingInventory__c  =   MatchingCount;

            if(futureJobIns.UnmatchingInventory__c != Null)
                futureJob.UnmatchingInventory__c         =   futureJobIns.UnmatchingInventory__c + UnMatchingCount;
            else
                futureJob.UnmatchingInventory__c=   UnMatchingCount;

            if(futureJobIns.CallCountFiltered__c != Null)
                futureJob.CallCountFiltered__c         =   futureJobIns.CallCountFiltered__c + CallCount;
            else
                futureJob.CallCountFiltered__c  =   CallCount;

            if(futureJobIns.RespondDateFiltered__c != Null)
                futureJob.RespondDateFiltered__c         =   futureJobIns.RespondDateFiltered__c + RespondDate;
            else
                futureJob.RespondDateFiltered__c=   RespondDate;
            Update futureJOb;

            system.debug('futureJOb updated '+futureJOb);
        }else if(jobType == 'Create'){

            if(userAddressRespond.size() > 0){
                for(Id userAddIns:userAddressRespond){
                    if(!DNCusers.contains(userAddIns)){
                        CallRecords__c callLog          =   New CallRecords__c();
                        callLog.User_Address__c         =   userAddIns;
                        callLog.CallCenterCampaign__c   =   campaignCenterId;
                        callLogList.add(callLog);
                    }
                }
            }else if(userAddressCall.size() > 0){
                for(Id userAddIns:userAddressCall){
                    if(!DNCusers.contains(userAddIns)){
                        CallRecords__c callLog          =   New CallRecords__c();
                        callLog.User_Address__c         =   userAddIns;
                        callLog.CallCenterCampaign__c   =   campaignCenterId;
                        callLogList.add(callLog);
                    }
                }
            }else{
                for(Id userAddIns:userAddressSet){
                    if(!DNCusers.contains(userAddIns)){
                        CallRecords__c callLog          =   New CallRecords__c();
                        callLog.User_Address__c         =   userAddIns;
                        callLog.CallCenterCampaign__c   =   campaignCenterId;
                        callLogList.add(callLog);
                    }
                }
            }

        }else if(jobType == 'Rollover'){
            
            if(prioritiesList[0].RespondDateMaximumRange__c != null){
                List<CallRecords__c> DeleteCallRecords = New List<CallRecords__c>();
                Date max = Date.today().addDays(-(Integer.valueOf(prioritiesList[0].RespondDateMaximumRange__c)+1)); 
                for(CallRecords__c callRecordsDelete:[SELECT Id FROM CallRecords__c WHERE User_Address__r.Respond_Date__c =: max AND CallCenterCampaign__c =: campaignCenterId AND IsProcessed__c = False AND CallDisposition__c != 'Call back']){
                    DeleteCallRecords.add(callRecordsDelete);
                }
                if(DeleteCallRecords.size() > 0)
                    Delete DeleteCallRecords;
            }
            
            for(Id userAddIns:userAddressRespond){
                if(!DNCusers.contains(userAddIns)){
                    CallRecords__c callLog          =   New CallRecords__c();
                    callLog.User_Address__c         =   userAddIns;
                    callLog.CallCenterCampaign__c   =   campaignCenterId;
                    callLogList.add(callLog);
                }
            }
        }

        if(callLogList.size() > 0){
            Insert callLogList;
            CheckResultsJob__c futureJobIns =   [SELECT Id,Job_Result__c FROM CheckResultsJob__c WHERE Id = :futureJobId];

            CheckResultsJob__c futureJob    =   New CheckResultsJob__c();
            futureJob.Id                    =   futureJobId;
            if(futureJobIns.Job_Result__c != Null)
                futureJob.Job_Result__c         =   futureJobIns.Job_Result__c + callLogList.size();
            else
                futureJob.Job_Result__c         =   callLogList.size();
            Update futureJOb;
        }


    }

    global void finish(Database.BatchableContext BC) {
        // Check batch status - IF COMPLETED then
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email, ExtendedStatus
                          from AsyncApexJob where Id = :bc.getJobId()];

        CheckResultsJob__c futureJob    =   New CheckResultsJob__c();
        futureJob.Id                    =   futureJobId;
        futureJob.status__c             =   a.Status;
        Update futureJOb;
        
        if(a.Status == 'Completed')
            DELETE [SELECT Id FROM CallRecords__c WHERE CallCenterCampaign__c = :campaignCenterId AND IsProcessed__c = False AND CallBackUser__c = Null];

    }

}