/**************************************************************************************************************
Created By: MST
Description : This class is to create inventory records based on the respond date change and phone/mobile field value.
***************************************************************************************************************/
public class nuHome_HotleadInventory_Handler{

    /**
    * @description 
    * @author William Aldana | 09-29-2020 
    * @param newUserAddressMap 
    * @param oldAddressMap 
    **/
    public static void createAllInventory(Map<Id,User_Address__c> newUserAddressMap,Map<id,User_Address__c> oldAddressMap){
        if(Test.isRunningTest())
        {
            nuHome_Inventory_Recursive.isExecute = True;
        }
        
        if(nuHome_Inventory_Recursive.isExecute){
            nuHome_Inventory_Recursive.isExecute = False; 

            set<String> branchset = new set<String>();
            List<Inventory__c> invList = new List<Inventory__c>();
            
            Map<Id,Account> accountMap = new Map<Id, Account>();
            Map<Id,Address__c> addressMap= new Map<Id, Address__c>();
            Map<Id,String> operationalStageMap = new Map<Id,String>();
            
            Map<Id,User_Address__c> userAddressMap = new Map<Id,User_Address__c>();
            Map<String,Set<Id>> opportunityWithBranchMap = new Map<String, Set<Id>>();
            
            //Fetching record type id using record type name.
            Id invHotLead = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
            Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Id oppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
            
            Set<Id> accountIds = new Set<Id>();
            Set<Id> addressIds = new Set<Id>();
            
            Set<String> zipCodes = new Set<String>();

            for(User_Address__c currRec : newUserAddressMap.values())
            {
                accountIds.add(currRec.useraccount__c);
                addressIds.add(currRec.address__c);
            }

            if(!accountIds.isEmpty()){
                accountMap.putAll([SELECT Id,recordTypeId,Verbal_Consent__c  FROM Account WHERE Id IN :accountIds ]);
            }
            
            if(!addressIds.isEmpty()){
                addressMap.putAll([SELECT Id,Branch__c, Branch__r.name,Zip_Code__c FROM Address__c WHERE Id IN :addressIds]);
            }


            for(User_Address__c currRec : newUserAddressMap.values()){
                
                //Checking if person account.
                if(accountMap.containsKey(currRec.useraccount__c))
                {
                    if(accountMap.get(currRec.useraccount__c).recordTypeId == personAccRTId)
                    {
                        if((currRec.Respond_Date__c!=null && oldAddressMap.get(currRec.id).Respond_Date__c == Null)&&(currRec.Phone__c!=null||currRec.PersonMobilePhone__c!=null) && currRec.Inventory_Created__c == False)
                        {
                            if(accountMap.get(currRec.useraccount__c).verbal_consent__c == 'Yes' || accountMap.get(currRec.useraccount__c).verbal_consent__c == 'Phone Only')
                            {
                                userAddressMap.put(currRec.id,currRec);
                                if(addressMap.containsKey(currRec.Address__c))
                                {
                                    branchset.add(addressMap.get(currRec.Address__c).Branch__r.name);
                                    zipCodes.add(addressMap.get(currRec.Address__c).Zip_Code__c);
                                    
                                }
                            }
                        }

                        if((currRec.Hot_Lead_Created__c == true) && (oldAddressMap.get(currRec.id).Hot_Lead_Created__c == False)){
                            userAddressMap.put(currRec.id,currRec);
                            if(addressMap.containsKey(currRec.Address__c))
                            {
                                branchset.add(addressMap.get(currRec.Address__c).Branch__r.name);
                                zipCodes.add(addressMap.get(currRec.Address__c).Zip_Code__c);
                            }
                        }
                        
                    }
                }
            } 


            if(!branchset.isEmpty()){
                
                for(OpportunityLineItem oppIns : [SELECT id,Opportunity.Id,Product2.available_zipcodes__c, Opportunity.Branch__c,Opportunity.Operational_Stage_Hot_Leads__c FROM opportunityLineItem WHERE (Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 1' OR Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 2' OR Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 3' ) 
                                                       AND Opportunity.Branch__c IN :branchset AND Opportunity.RecordtypeId=:oppRTId]){
                       
                    Set<String> allZips = new Set<String>();
                    allZips.addAll(zipCodes);
                    Boolean isMatched = false;
                    if(oppIns.Product2.available_zipcodes__c != Null)
                    {
                        for(String zip : oppIns.Product2.available_zipcodes__c.split(';'))
                        {
                            if(allZips.contains(zip))
                            {
                                allZips.remove(zip);
                                isMatched  = true;
                            }
                        }
                    }
                    
                    if(opportunityWithBranchMap.containsKey(oppIns.Opportunity.Branch__c))
                    {
                        if(isMatched  == True && allZips.size() <> zipCodes.size())
                        {
                            opportunityWithBranchMap.get(oppIns.Opportunity.Branch__c).add(oppIns.Opportunity.Id);
                            operationalStageMap.put(oppIns.Opportunity.Id,oppIns.Opportunity.Operational_Stage_Hot_Leads__c);
                        }
                    }
                    else
                    {
                        if(isMatched  == True && allZips.size() <> zipCodes.size() )
                        {
                            opportunityWithBranchMap.put(oppIns.Opportunity.Branch__c, new Set<Id>{oppIns.Opportunity.Id});
                            operationalStageMap.put(oppIns.Opportunity.Id,oppIns.Opportunity.Operational_Stage_Hot_Leads__c);
                        }
                    }
                }
            }

            if(!opportunityWithBranchMap.isEmpty())
            {
                for(user_Address__c curruserAdd : userAddressMap.values())
                {
                    String branch = addressMap.get(curruserAdd.address__c).Branch__r.name;
                    if(opportunityWithBranchMap.containsKey(branch))
                    {
                        
                        Set<Id> oppIds = new Set<Id>();
                        oppIds.addAll(opportunityWithBranchMap.get(branch));
                        
                        for(Id currId : oppIds)
                        {
                            if(accountMap.get(curruserAdd.useraccount__c).Verbal_Consent__c == 'Yes' || accountMap.get(curruserAdd.useraccount__c).Verbal_Consent__c == 'Phone Only')
                            {
                                Inventory__c invIns = new Inventory__c();
                                invIns.Operational_Stage_Hot_Leads__c = operationalStageMap.get(currId);
                                invIns.Account__c = curruserAdd.useraccount__c;
                                invIns.User_Address__c = curruserAdd.id;
                                invIns.idCPL_Billing_Opportunity__c = currId;
                                invIns.RecordTypeId = invHotLead;
                                invIns.user_Address__c = currUserAdd.id;
                                invIns.Billing_Stage__c = 'Billable';
                                if(curruserAdd.InteractionStepId__c != null)
                                    invIns.interactionStepId__c = curruserAdd.InteractionStepId__c;
                                invList.add(invIns);
                            }
                        }
                    }
                }
            }
             
            if(!invList.isEmpty()){
                insert invList;
            }             
        }
    }

    /**
    * @description 
    * @author William Aldana | 09-29-2020 
    * @param newUserAddressMap 
    * @param oldAddressMap 
    * 
    **/
    /*
    public static void createInventory(Map<Id,User_Address__c> newUserAddressMap,Map<id,User_Address__c> oldAddressMap){
        
        if(Test.isRunningTest())
        {
            nuHome_Inventory_Recursive.isExecute = True;
        }
        
        if(nuHome_Inventory_Recursive.isExecute){
            nuHome_Inventory_Recursive.isExecute = False;
            
            set<String> branchset = new set<String>();
            List<Inventory__c> invList = new List<Inventory__c>();
            
            Map<Id,Account> accountMap = new Map<Id, Account>();
            Map<Id,Address__c> addressMap= new Map<Id, Address__c>();
            Map<Id,String> operationalStageMap = new Map<Id,String>();
            
            Map<Id,User_Address__c> userAddressMap = new Map<Id,User_Address__c>();
            Map<String,Set<Id>> opportunityWithBranchMap = new Map<String, Set<Id>>();
            
            //Fetching record type id using record type name.
            Id invHotLead = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
            Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Id oppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
            
            Set<Id> accountIds = new Set<Id>();
            Set<Id> addressIds = new Set<Id>();
            
            Set<String> zipCodes = new Set<String>();
            
            for(User_Address__c currRec : newUserAddressMap.values())
            {
                accountIds.add(currRec.useraccount__c);
                addressIds.add(currRec.address__c);
            }

            if(!accountIds.isEmpty()){
                accountMap.putAll([SELECT Id,recordTypeId,Verbal_Consent__c  FROM Account WHERE Id IN :accountIds ]);
            }
            
            if(!addressIds.isEmpty()){
                addressMap.putAll([SELECT Id,Branch__c, Branch__r.name,Zip_Code__c FROM Address__c WHERE Id IN :addressIds]);
            }
            
           // for(Address__c ad : [SELECT Id,Branch__c, Branch__r.name,Zip_Code__c FROM Address__c WHERE Id IN :addressIds])
            //	system.debug('++++++++' + ad.Branch__c + '--' + ad.Id + '__' + addressIds);
            
            for(User_Address__c currRec : newUserAddressMap.values()){
                
                //Checking if person account.
                if(accountMap.containsKey(currRec.useraccount__c))
                {
                    
                    if(accountMap.get(currRec.useraccount__c).recordTypeId == personAccRTId)
                    {

                        if((currRec.Respond_Date__c!=null && oldAddressMap.get(currRec.id).Respond_Date__c == Null)&&(currRec.Phone__c!=null||currRec.PersonMobilePhone__c!=null) && currRec.Inventory_Created__c == False)
                        {
                            if(accountMap.get(currRec.useraccount__c).verbal_consent__c == 'Yes' || accountMap.get(currRec.useraccount__c).verbal_consent__c == 'Phone Only')
                            {
                                userAddressMap.put(currRec.id,currRec);
                                if(addressMap.containsKey(currRec.Address__c))
                                {
                                    branchset.add(addressMap.get(currRec.Address__c).Branch__r.name);
                                    zipCodes.add(addressMap.get(currRec.Address__c).Zip_Code__c);
                                    
                                }
                            }
                        }
                        
                    }
                }
            } 
            
            
            
            if(!branchset.isEmpty()){
                
               for(OpportunityLineItem oppIns : [SELECT id,Opportunity.Id,Product2.available_zipcodes__c, Opportunity.Branch__c,Opportunity.Operational_Stage_Hot_Leads__c FROM opportunityLineItem WHERE (Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 1' OR Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 2' OR Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 3' ) 
                                                      AND Opportunity.Branch__c IN :branchset AND Opportunity.RecordtypeId=:oppRTId]){
                      
                        Set<String> allZips = new Set<String>();
                        allZips.addAll(zipCodes);
                        Boolean isMatched = false;
                        if(oppIns.Product2.available_zipcodes__c != Null)
                        {
                           for(String zip : oppIns.Product2.available_zipcodes__c.split(';'))
                           {
                                if(allZips.contains(zip))
                                {
                                    allZips.remove(zip);
                                    isMatched  = true;
                                }
                           }
                        }
                      
                       if(opportunityWithBranchMap.containsKey(oppIns.Opportunity.Branch__c))
                       {
                         if(isMatched  == True && allZips.size() <> zipCodes.size() )
                         {
                          
                          opportunityWithBranchMap.get(oppIns.Opportunity.Branch__c).add(oppIns.Opportunity.Id);
                          operationalStageMap.put(oppIns.Opportunity.Id,oppIns.Opportunity.Operational_Stage_Hot_Leads__c);
                         }
                       }
                       else
                       {
                            if(isMatched  == True && allZips.size() <> zipCodes.size() )
                            {
                              opportunityWithBranchMap.put(oppIns.Opportunity.Branch__c, new Set<Id>{oppIns.Opportunity.Id});
                              operationalStageMap.put(oppIns.Opportunity.Id,oppIns.Opportunity.Operational_Stage_Hot_Leads__c);
                            }
                       }
                           
                    }
            }
            
            
            if(!opportunityWithBranchMap.isEmpty())
            {
                
                for(user_Address__c curruserAdd : userAddressMap.values())
                {
                    
                    
                    String branch = addressMap.get(curruserAdd.address__c).Branch__r.name;
                    if(opportunityWithBranchMap.containsKey(branch))
                    {
                        
                        Set<Id> oppIds = new Set<Id>();
                        oppIds.addAll(opportunityWithBranchMap.get(branch));
                        
                        for(Id currId : oppIds)
                        {
                            
                            if(accountMap.get(curruserAdd.useraccount__c).Verbal_Consent__c == 'Yes' || accountMap.get(curruserAdd.useraccount__c).Verbal_Consent__c == 'Phone Only')
                            {
                                Inventory__c invIns = new Inventory__c();
                                invIns.Operational_Stage_Hot_Leads__c = operationalStageMap.get(currId);
                                invIns.Account__c = curruserAdd.useraccount__c;
                                invIns.User_Address__c = curruserAdd.id;
                                invIns.idCPL_Billing_Opportunity__c = currId;
                                invIns.RecordTypeId = invHotLead;
                                invIns.user_Address__c = currUserAdd.id;
                                invIns.Billing_Stage__c = 'Billable';
                                if(curruserAdd.InteractionStepId__c != null)
                                    invIns.interactionStepId__c = curruserAdd.InteractionStepId__c;
                                invList.add(invIns);
                            }
                        }
                    }
                }
            }
            
            if(!invList.isEmpty()){
                insert invList;
            }
        }
    }*/

    /**
    * @description 
    * @author William Aldana | 09-29-2020 
    * @param newUserAddressMap 
    * @param oldAddressMap 
    **/
    /*
    public static void createInventories(Map<Id,User_Address__c> newUserAddressMap,Map<id,User_Address__c> oldAddressMap){
                  
            set<String> branchset = new set<String>();
            List<Inventory__c> invList = new List<Inventory__c>();
            
            Map<Id,Account> accountMap = new Map<Id, Account>();
            Map<Id,Address__c> addressMap= new Map<Id, Address__c>();
            
            
            Map<Id,User_Address__c> userAddressMap = new Map<Id,User_Address__c>();
           
            
            Map<String,Set<Id>> opportunityWithBranchMap = new Map<String, Set<Id>>();
            Map<Id,String> operationalStageMap = new Map<Id,String>();
            
            //Fetching record type id using record type name.
            Id invHotLead = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
            Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Id oppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
            
            Set<Id> accountIds = new Set<Id>();
            Set<Id> addressIds = new Set<Id>();
            
            Set<String> zipCodes = new Set<String>();
            
            for(User_Address__c currRec : newUserAddressMap.values())
            {
                accountIds.add(currRec.useraccount__c);
                addressIds.add(currRec.address__c);
            }
            if(!accountIds.isEmpty())
                accountMap.putAll([SELECT Id,recordTypeId,Verbal_Consent__c  FROM Account WHERE Id IN :accountIds ]);
            
            if(!addressIds.isEmpty())
                addressMap.putAll([SELECT Id,Branch__c, Branch__r.name,Zip_Code__c FROM Address__c WHERE Id IN :addressIds]);
            
            
            for(User_Address__c currRec : newUserAddressMap.values()){
                
                //Checking if person account.
                if(accountMap.containsKey(currRec.useraccount__c))
                {
                    
                    if(accountMap.get(currRec.useraccount__c).recordTypeId == personAccRTId)
                    {
                        if((currRec.Hot_Lead_Created__c == True) && (oldAddressMap.get(currRec.id).Hot_Lead_Created__c == False)){
                            userAddressMap.put(currRec.id,currRec);
                            if(addressMap.containsKey(currRec.Address__c))
                            {
                                branchset.add(addressMap.get(currRec.Address__c).Branch__r.name);
                                zipCodes.add(addressMap.get(currRec.Address__c).Zip_Code__c);
                            }
                        }
                    }
                }
            } 
            
            if(!branchset.isEmpty()){

               for(OpportunityLineItem oppIns : [SELECT id,Opportunity.Id,Product2.available_zipcodes__c, Opportunity.Branch__c,Opportunity.Operational_Stage_Hot_Leads__c FROM opportunityLineItem WHERE (Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 1' OR Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 2' OR Opportunity.Operational_Stage_Hot_Leads__c = 'Active Tier 3' ) 
                                                      AND Opportunity.Branch__c IN :branchset AND Opportunity.RecordtypeId=:oppRTId]){
                      
                     
                        Set<String> allZips = new Set<String>();
                        allZips.addAll(zipCodes);
                        Boolean isMatched = false;
                        if(oppIns.Product2.available_zipcodes__c != Null)
                        {
                           for(String zip : oppIns.Product2.available_zipcodes__c.split(';'))
                           {
                                if(allZips.contains(zip))
                                {
                                    allZips.remove(zip);
                                    isMatched  = true;
                                }
                           }
                        }
                      
                       if(opportunityWithBranchMap.containsKey(oppIns.Opportunity.Branch__c))
                       {
                         if(isMatched  == True && allZips.size() <> zipCodes.size() )
                         {
                           opportunityWithBranchMap.get(oppIns.Opportunity.Branch__c).add(oppIns.Opportunity.Id);
                           operationalStageMap.put(oppIns.Opportunity.Id,oppIns.Opportunity.Operational_Stage_Hot_Leads__c);
                         }
                       }
                       else
                       {
                            if(isMatched  == True && allZips.size() <> zipCodes.size() )
                            {
                               opportunityWithBranchMap.put(oppIns.Opportunity.Branch__c, new Set<Id>{oppIns.Opportunity.Id});
                               operationalStageMap.put(oppIns.Opportunity.Id,oppIns.Opportunity.Operational_Stage_Hot_Leads__c);
                            }
                       }
                           
                    }
            }
            
            
        if(!opportunityWithBranchMap.isEmpty())
        {
            for(user_Address__c curruserAdd : userAddressMap.values())
            {
                String branch = addressMap.get(curruserAdd.address__c).Branch__r.name;
                Date respondDate = curruserAdd.Respond_Date__c;
                Integer days = respondDate.daysBetween(Date.today());
                if(opportunityWithBranchMap.containsKey(branch))
                {
                    
                    Set<Id> oppIds = new Set<Id>();
                    oppIds.addAll(opportunityWithBranchMap.get(branch));
                    
                    for(Id currId : oppIds)
                    {
                        if( days >= 0 && days <= 3 && (operationalStageMap.get(currId) == 'Active Tier 1' || operationalStageMap.get(currId) == 'Active Tier 2' || operationalStageMap.get(currId) == 'Active Tier 3')){
                            Inventory__c invIns = new Inventory__c();
                            invIns.Operational_Stage_Hot_Leads__c = operationalStageMap.get(currId);
                            invIns.Account__c = curruserAdd.useraccount__c;
                            invIns.User_Address__c = curruserAdd.id;
                            invIns.idCPL_Billing_Opportunity__c = currId;
                            invIns.RecordTypeId = invHotLead;
                                invIns.user_Address__c =  curruserAdd.id;
                            if(curruserAdd.interactionStepId__c != null){
                                invIns.interactionStepId__c = curruserAdd.interactionStepId__c;
                            }
                            invIns.Billing_Stage__c = 'Billable';
                            invList.add(invIns);
                            
                        }

                        if( days > 3 && days <= 7 && (operationalStageMap.get(currId)  == 'Active Tier 2' ||operationalStageMap.get(currId) == 'Active Tier 3')){
                            Inventory__c invIns = new Inventory__c();
                            invIns.Operational_Stage_Hot_Leads__c = operationalStageMap.get(currId);
                            invIns.Account__c = curruserAdd.useraccount__c;
                            invIns.User_Address__c = curruserAdd.id;
                            invIns.idCPL_Billing_Opportunity__c = currId;
                            invIns.RecordTypeId = invHotLead;
                            invIns.user_Address__c =  curruserAdd.id;
                            if(curruserAdd.InteractionStepId__c != null){
                                invIns.interactionStepId__c =curruserAdd.InteractionStepId__c;
                            }
                            invIns.Billing_Stage__c = 'Billable';
                            invList.add(invIns);
                        }    

                        if( days > 7 && days <= 21 && operationalStageMap.get(currId) == 'Active Tier 3'){
                            Inventory__c invIns = new Inventory__c();
                            invIns.Operational_Stage_Hot_Leads__c = operationalStageMap.get(currId);
                            invIns.Account__c = curruserAdd.useraccount__c;
                            invIns.User_Address__c = curruserAdd.id;
                            invIns.idCPL_Billing_Opportunity__c = currId;
                            invIns.RecordTypeId = invHotLead;
                            invIns.user_Address__c =  curruserAdd.id;
                                if(curruserAdd.InteractionStepId__c != null){
                                invIns.interactionStepId__c =curruserAdd.InteractionStepId__c;
                            }
                            invIns.Billing_Stage__c = 'Billable';
                            invList.add(invIns);
                            
                        }                                                        
                    }
                }
            }
        }
            
        if(!invList.isEmpty())
        {
            insert invList;
            
        }
    }*/
}