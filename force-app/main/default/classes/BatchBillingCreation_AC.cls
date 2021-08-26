/*********************************************************************************
*Created by  : MST
*Description : This Schedule class is to auto creation of Billing and the Billing Line records for CPL,SPEC,SUB,Hot lead and DTS weekly,
*so that billing person can generate the Invoices for the Business Accounts correctly.
If there are multiple Inventory for which the Person Account and the Business Account is the same, 
then just one Billing record and the Billing Line record needs to be created.
If there are multiple Person Accounts associated to the same business account, then one billing record should be created and 
multiple billing line record needs to be created under the same billing record.
*************************************************************************************/

global class BatchBillingCreation_AC implements Database.Batchable<Aggregateresult> {
    Public String recordTypeName;
    Public Id accRecordTypeId;
    Public Id devRecordTypeId;
    Public Id oppRecordTypeId;
    // Getting Record type Id.
    Public BatchBillingCreation_AC(String recordTypeNameValue){
        recordTypeName = recordTypeNameValue;
        accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Accounts').getRecordTypeId();
        devRecordTypeId = Schema.SObjectType.Inventory__C.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        if(recordTypeName.equalsIgnoreCase('nuHome Hot Lead'))
            oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    
    global iterable<Aggregateresult> start(Database.BatchableContext BC){ 
        list<AggregateResult> batchAggregationlist = NEW list<AggregateResult>();
        // Querying records to process for each record type.
        if(recordTypeName.equalsIgnorecase('nuHome OB Campaign'))
        {
            batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__r.AccountID acc FROM Inventory__C WHERE ANI__c != NULL  
                                     AND isProcessed__c = false AND  fHome_Sale_Price__c != NULL AND Name != NULL AND OB_Call_Center_Appointment_Date__c != NULL 
                                     AND User_Address__r.Address__r.City__c != NULL AND User_Address__r.Address__r.State__c != NULL AND User_Address__r.Address__r.Street__c != NULL 
                                     AND Billing_Stage__c = 'Billable'  AND  User_Address__r.Address__r.zip_code__c != NULL AND recordtypeid =: devRecordTypeId AND Account__c != NULL AND fBilling_Opp_Account__c != NULL 
                                     AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId 
                                     GROUP BY idCPL_Billing_Opportunity__r.AccountID];
        }
        else if(recordTypeName.equalsIgnorecase('nuHome nuCard CPL'))
        {
            batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__r.AccountID acc FROM Inventory__C WHERE recordtypeid =: devRecordTypeId  
                                     AND isProcessed__c = false and  Account__c != NULL AND Billing_Stage__c = 'Billable' AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL 
                                     AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId 
                                     GROUP BY idCPL_Billing_Opportunity__r.AccountID];
        }
        else if(recordTypeName.equalsIgnorecase('nuHome nuCard SUB'))
        {
            batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__r.AccountID acc FROM Inventory__C WHERE recordtypeid =: devRecordTypeId 
                                     AND isProcessed__c = false and Account__c != NULL  AND Billing_Stage__c = 'Billable' AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL 
                                     AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId 
                                     GROUP BY idCPL_Billing_Opportunity__r.AccountID];
        }
        else if(recordTypeName.equalsIgnorecase('nuHome nuCard SPEC')){
            batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__r.AccountID acc FROM Inventory__C WHERE recordtypeid =: devRecordTypeId  
                                     AND isProcessed__c = false and Account__c != NULL AND Billing_Stage__c = 'Billable' AND fBilling_Opp_Account__c != NULL 
                                     AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL 
                                     AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId 
                                     GROUP BY idCPL_Billing_Opportunity__r.AccountID];
        }
        else if(recordTypeName.equalsIgnorecase('nuHome Door Tag Script')){
            batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__r.AccountID acc FROM Inventory__C WHERE UnMatching_Invetnory__c = FALSE 
                                     AND isProcessed__c = false AND Billing_Stage__c = 'Billable' AND (Survey_Response__c ='Yes' OR Survey_Response__c ='Blinds' OR Survey_Response__c ='Shutters' OR Survey_Response__c ='Blinds and Shutters') AND  
                                     recordtypeid =: devRecordTypeId and  Account__c != NULL AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL 
                                     AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId 
                                     GROUP BY idCPL_Billing_Opportunity__r.AccountID];
        }
        else if(recordTypeName.equalsIgnorecase('nuHome Hot Lead')){
            batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__r.AccountID acc FROM Inventory__C WHERE (((idCPL_Billing_Opportunity__r.Pricebook2.Name = 'nuHome Hot Leads - Tier 1' OR idCPL_Billing_Opportunity__r.Pricebook2.Name = 'Hot Leads Price Book') 
                                                                                                                 AND (User_Address__r.Hot_Leads_Tier_1_Date__c <: Date.Today() AND User_Address__r.Hot_Leads_Tier_1_Date__c >: Date.Today()-8) AND Operational_Stage_Hot_Leads__c = 'Active Tier 1') 
                                                                                                                OR ((idCPL_Billing_Opportunity__r.Pricebook2.Name = 'nuHome Hot Leads - Tier 2' OR idCPL_Billing_Opportunity__r.Pricebook2.Name = 'Hot Leads Price Book') AND (User_Address__r.Hot_Leads_Tier_2_Date__c <: Date.Today() AND User_Address__r.Hot_Leads_Tier_2_Date__c >: Date.Today()-8) AND Operational_Stage_Hot_Leads__c = 'Active Tier 2') 
                                                                                                                OR ((idCPL_Billing_Opportunity__r.Pricebook2.Name = 'nuHome Hot Leads - Tier 3' OR idCPL_Billing_Opportunity__r.Pricebook2.Name = 'Hot Leads Price Book') AND (User_Address__r.Hot_Leads_Tier_3_Date__c <: Date.Today() AND User_Address__r.Hot_Leads_Tier_3_Date__c >: Date.Today()-8) AND Operational_Stage_Hot_Leads__c = 'Active Tier 3'))  AND  recordtypeid =: devRecordTypeId 
                                     AND isProcessed__c = false  and  idCPL_Billing_Opportunity__r.recordtypeid =:oppRecordTypeId and  Account__c != NULL AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL  AND Billing_Stage__c = 'Billable' AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId GROUP BY idCPL_Billing_Opportunity__r.AccountID];
        }
        return batchAggregationlist;
    }
    
    global void execute(Database.BatchableContext BC, List<AggregateResult> scope) {
        Set<id> businessAccountIDSet = NEW Set<id>();
        Map<id,Set<ID>> unMatchingAccountMap = NEW Map<id,Set<ID>>();
        Map<id,Inventory__C> inventoryMap = NEW Map<id,Inventory__C>();
        Map<String,inventory__C> personAccountMap = NEW Map<string,inventory__C>();
        Map<String,inventory__C> personAccountMap1 = NEW Map<String,inventory__C>();
        Map<id,List<Inventory__c>> unMatchingDoorTagMap = NEW Map<id,List<Inventory__c>>();
        List<inventory__C> inventoryList = NEW  List<inventory__C>();
        Map<Id,Inventory__c> inventoryToUpdateMap = new Map<Id,Inventory__c>();
        // parsing the aggregate ids.
        For(AggregateResult INv:scope){
            String accIds = String.valueof(inv.get('acc'));
            businessAccountIDSet.add(accIds);
        }
        
        // Querying inventory records based on the acceptance criteria and record types.
        if(recordTypeName.equalsIgnorecase('nuHome OB Campaign')){
            inventoryList =  [SELECT Name,Survey_Question__c,Survey_Response__c,Account__r.MSA__c,Phone_Mobile__c,createdDate,fHome_Sale_Price__c,OB_Call_Center_Appointment_Date__c,ANI__c,User_Address__r.Address__r.City__c,
                              User_Address__r.Address__r.State__c,User_Address__r.Address__r.Street__c,fAccount_Email__c,User_Address__r.Address__r.zip_code__c,Account__c,Account__r.Name,fBilling_Opp_Account_ID__c,fBilling_Opp_Account__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c,User_Address__r.Address__r.Country__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c,idCPL_Billing_Opportunity__r.Account.Phone,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Country__c,user_address__r.address__r.Branch__r.Name,fBilling_Opp_Industry__c,Account__r.phone, Account__r.personmobilephone,
                              account__r.Primary_Shipping_Country__c,Product_Name__c,Product_Price__c,Quantity__c,List_Price__c,user_Address__r.Address__r.MSA__c
                              FROM Inventory__C WHERE idCPL_Billing_Opportunity__r.AccountID IN:businessAccountIDSet   AND Billing_Stage__c = 'Billable' AND 
                              ANI__c != NULL AND isProcessed__c = false AND fHome_Sale_Price__c != NULL AND Name != NULL AND OB_Call_Center_Appointment_Date__c != NULL AND User_Address__r.Address__r.City__c != NULL AND User_Address__r.Address__r.State__c != NULL AND fAccount_Street__c != NULL AND User_Address__r.Address__r.zip_code__c != NULL AND recordtypeid =: devRecordTypeId and  Account__c != NULL AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId];
        }
        
        else if(recordTypeName.equalsIgnorecase('nuHome nuCard CPL') || recordTypeName.equalsIgnorecase('nuHome nuCard SUB')){
            inventoryList =  [SELECT Name,Survey_Question__c,Survey_Response__c,Account__r.MSA__c,Phone_Mobile__c,createdDate,fHome_Sale_Price__c,OB_Call_Center_Appointment_Date__c,ANI__c,User_Address__r.Address__r.City__c,
                              User_Address__r.Address__r.State__c,User_Address__r.Address__r.Street__c,fAccount_Email__c,User_Address__r.Address__r.zip_code__c,Account__c,Account__r.Name,fBilling_Opp_Account_ID__c,fBilling_Opp_Account__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c,User_Address__r.Address__r.Country__c,
                              user_address__r.address__r.Branch__r.Name,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Country__c,fBilling_Opp_Industry__c,idCPL_Billing_Opportunity__r.Account.Phone,Account__r.phone, Account__r.personmobilephone,
                              account__r.Primary_Shipping_Country__c,Product_Name__c,Product_Price__c,Quantity__c,List_Price__c,user_Address__r.Address__r.MSA__c
                              FROM Inventory__C WHERE idCPL_Billing_Opportunity__r.AccountID IN:businessAccountIDSet  AND Billing_Stage__c = 'Billable' AND
                              recordtypeid =: devRecordTypeId AND isProcessed__c = false AND Account__c != NULL AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId];
        }
        
        else if(recordTypeName.equalsIgnorecase('nuHome nuCard SPEC')){
            inventoryList =  [SELECT Name,Survey_Question__c,Survey_Response__c,Account__r.MSA__c,Phone_Mobile__c,createdDate,fHome_Sale_Price__c,OB_Call_Center_Appointment_Date__c,ANI__c,User_Address__r.Address__r.City__c,
                              User_Address__r.Address__r.State__c,User_Address__r.Address__r.Street__c,fAccount_Email__c,User_Address__r.Address__r.zip_code__c,Account__c,Account__r.Name,fBilling_Opp_Account_ID__c,fBilling_Opp_Account__c, 
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c,
                              user_address__r.address__r.Branch__r.Name,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c,
                              account__r.Primary_Shipping_Country__c,Product_Name__c,Product_Price__c,Quantity__c,List_Price__c,User_Address__r.Address__r.Country__c,user_Address__r.Address__r.MSA__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Country__c,fBilling_Opp_Industry__c,idCPL_Billing_Opportunity__r.Account.Phone,Account__r.phone, Account__r.personmobilephone
                              FROM Inventory__C WHERE idCPL_Billing_Opportunity__r.AccountID IN:businessAccountIDSet  AND 
                              recordtypeid =: devRecordTypeId and isProcessed__c = false AND Billing_Stage__c = 'Billable' AND Account__c != NULL AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId];
        }
        
        else if(recordTypeName.equalsIgnorecase('nuHome Door Tag Script')){
            inventoryList =  [SELECT Name,Product_Name__c,Product_Price__c,Quantity__c,List_Price__c,Survey_Question__c,Survey_Response__c,user_address__r.address__r.Branch__r.Name,
                              Account__r.MSA__c,Phone_Mobile__c,createdDate,fHome_Sale_Price__c,OB_Call_Center_Appointment_Date__c,ANI__c,User_Address__r.Address__r.City__c,
                              User_Address__r.Address__r.State__c,User_Address__r.Address__r.Street__c,fAccount_Email__c,User_Address__r.Address__r.zip_code__c,Account__c,Account__r.Name,fBilling_Opp_Account_ID__c,fBilling_Opp_Account__c, 
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Country__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c,
                              account__r.Primary_Shipping_Country__c,User_Address__r.Address__r.Country__c,user_Address__r.Address__r.MSA__c,
                              fBilling_Opp_Industry__c,idCPL_Billing_Opportunity__r.Account.Phone,Account__r.phone, Account__r.personmobilephone
                              FROM Inventory__C WHERE idCPL_Billing_Opportunity__r.AccountID IN:businessAccountIDSet  AND
                              UnMatching_Invetnory__c = FALSE  AND Billing_Stage__c = 'Billable' AND isProcessed__c = false AND (Survey_Response__c ='Yes' OR Survey_Response__c ='Blinds' OR Survey_Response__c ='Shutters' OR Survey_Response__c ='Blinds and Shutters') AND  recordtypeid =: devRecordTypeId and  Account__c != NULL AND fBilling_Opp_Account__c != NULL AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId];
        }
        
        else if(recordTypeName.equalsIgnorecase('nuHome Hot Lead')){
            inventoryList =  [SELECT Name,Survey_Question__c,Survey_Response__c,Account__r.MSA__c,user_address__r.address__r.Branch__r.Name,Phone_Mobile__c,createdDate,fHome_Sale_Price__c,OB_Call_Center_Appointment_Date__c,ANI__c,User_Address__r.Address__r.City__c,
                              User_Address__r.Address__r.State__c,User_Address__r.Address__r.Street__c,User_Address__r.Address__r.Country__c,fAccount_Email__c,User_Address__r.Address__r.zip_code__c,Account__c,Account__r.Name,fBilling_Opp_Account_ID__c,fBilling_Opp_Account__c ,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c,idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c,
                              idCPL_Billing_Opportunity__r.Account.Primary_Billing_Country__c,fBilling_Opp_Industry__c,idCPL_Billing_Opportunity__r.Account.Phone,Account__r.phone, Account__r.personmobilephone,
                              account__r.Primary_Shipping_Country__c,Product_Name__c,Product_Price__c,Quantity__c,List_Price__c,user_Address__r.Address__r.MSA__c
                              FROM Inventory__C WHERE idCPL_Billing_Opportunity__r.AccountID IN:businessAccountIDSet AND Billing_Stage__c = 'Billable'
                              AND (((idCPL_Billing_Opportunity__r.Pricebook2.Name = 'nuHome Hot Leads - Tier 1' OR idCPL_Billing_Opportunity__r.Pricebook2.Name = 'Hot Leads Price Book') AND (User_Address__r.Hot_Leads_Tier_1_Date__c <: Date.Today() AND User_Address__r.Hot_Leads_Tier_1_Date__c >: Date.Today()-8) AND Operational_Stage_Hot_Leads__c = 'Active Tier 1') 
                                   OR ((idCPL_Billing_Opportunity__r.Pricebook2.Name = 'nuHome Hot Leads - Tier 2' OR idCPL_Billing_Opportunity__r.Pricebook2.Name = 'Hot Leads Price Book') AND (User_Address__r.Hot_Leads_Tier_2_Date__c <: Date.Today() AND User_Address__r.Hot_Leads_Tier_1_Date__c >: Date.Today()-8) AND Operational_Stage_Hot_Leads__c = 'Active Tier 2') 
                                   OR ((idCPL_Billing_Opportunity__r.Pricebook2.Name = 'nuHome Hot Leads - Tier 3' OR idCPL_Billing_Opportunity__r.Pricebook2.Name = 'Hot Leads Price Book') AND (User_Address__r.Hot_Leads_Tier_3_Date__c <: Date.Today() AND User_Address__r.Hot_Leads_Tier_1_Date__c >: Date.Today()-8) AND Operational_Stage_Hot_Leads__c = 'Active Tier 3')) 
                              AND recordtypeid =: devRecordTypeId and idCPL_Billing_Opportunity__r.recordtypeid =:OppRecordTypeId AND  Account__c != NULL AND fBilling_Opp_Account__c != NULL 
                              AND isProcessed__c = false AND idCPL_Billing_Opportunity__c != NULL AND idCPL_Billing_Opportunity__r.AccountID != NULL AND idCPL_Billing_Opportunity__r.Account.recordtypeid =: accRecordTypeId];
        }
        
        Set<String> surveyQuestionsSet = new Set<String>(); 
        Map<Id,List<Inventory__c>> businessAccountMap = new Map<Id,List<Inventory__c>>(); 
        Map<Id,List<Inventory__c>> billingOppIdMap = new  Map<Id,List<Inventory__c>>();
        String Industry;
        Map<String,String> industryCustomSettingMap = new Map<String,String>();
        Set<String> productNamesSet = new Set<String>();
        Set<Id> opportunityIds = new Set<Id>();
        
        Map<Id,Set<Id>> cplOppMap = new Map<Id,Set<Id>>();
        
        Set<String> zipCodesSet = new Set<String>();
        
        For(Inventory__C inv : inventoryList){
            inv.isProcessed__c = True;
            inventoryToUpdateMap.put(inv.id, inv);
            productNamesSet.add(inv.user_address__r.address__r.branch__r.name+'-'+inv.fBilling_Opp_Industry__c);
            
            opportunityIds.add(inv.idCPL_Billing_Opportunity__c);
            zipCodesSet.add(inv.User_Address__r.Address__r.zip_code__c);
            
            if(!recordTypeName.equalsIgnorecase('nuHome Door Tag Script')){
                
                if(!unMatchingAccountMap.containsKey(inv.fBilling_Opp_Account_ID__c))
                {
                    unMatchingAccountMap.put(inv.fBilling_Opp_Account_ID__c,new set<ID>{inv.Account__c}); 
                    cplOppMap.put(inv.fBilling_Opp_Account_ID__c,new Set<ID>{inv.idCPL_Billing_Opportunity__c});
                }
                
                else if(unMatchingAccountMap.containsKey(inv.fBilling_Opp_Account_ID__c))
                {
                    unMatchingAccountMap.get(inv.fBilling_Opp_Account_ID__c).add(inv.Account__c);
                    cplOppMap.get(inv.fBilling_Opp_Account_ID__c).add(inv.idCPL_Billing_Opportunity__c);
                }
                
                inventoryMap.put(inv.fBilling_Opp_Account_ID__c,inv);
                System.debug('Idvalues+++++++++++++++++++++++++++++++++++++++++++++++++++++= ' + (inv.idCPL_Billing_Opportunity__c+'-'+inv.account__c));
                personAccountMap.put(inv.idCPL_Billing_Opportunity__c+'-'+inv.account__c,inv);
            }
            
            if(recordTypeName.equalsIgnorecase('nuHome Door Tag Script')){
                
                if(!businessAccountMap.containsKey(inv.fBilling_Opp_Account_ID__c))
                    businessAccountMap.put(inv.fBilling_Opp_Account_ID__c,new List<Inventory__c>{inv});
                else if(businessAccountMap.containsKey(inv.fBilling_Opp_Account_ID__c))
                    businessAccountMap.get(inv.fBilling_Opp_Account_ID__c).add(inv);
                inventoryMap.put(inv.fBilling_Opp_Account_ID__c,inv);
                personAccountMap.put(inv.idCPL_Billing_Opportunity__c+'-'+inv.account__c,inv);
            }
        }
        
        Map<String, List<OpportunityLineITem>> productLineItemMap = new Map<String, List<OpportunityLineITem>>();
        for(OpportunityLineITem currItem : [SELECT Id, Name, Product2.Name, OpportunityId, Quantity, ListPrice, UnitPrice FROM OpportunityLineItem
                                            WHERE Product2.Name IN :productNamesSet AND OpportunityId IN :opportunityIds])
        {
            if(!productLineItemMap.containsKey(currItem.OpportunityId+'-'+currItem.product2.Name))
                productLineItemMap.put(currItem.OpportunityId+'-'+currItem.product2.Name, new List<OpportunityLineITem>{currItem});
            else
                productLineItemMap.get(currItem.OpportunityId+'-'+currItem.product2.Name).add(currItem);
        }
      
        if(!recordTypeName.equalsIgnorecase('nuHome Door Tag Script') && !unMatchingAccountMap.isEmpty() && !inventoryMap.isEmpty()){
            BatchBillingHandler.ProcessUnMatchingBillingRecords(unMatchingAccountMap,cplOppMap,inventoryMap,personAccountMap,recordTypeName,inventoryToUpdateMap,productLineItemMap);
        }
        
        if(recordTypeName.equalsIgnorecase('nuHome Door Tag Script') && !businessAccountMap.isEmpty()){
            BatchBillingHandler.ProcessDoorTagScriptBillingRecords(businessAccountMap,recordTypeName,inventoryMap,inventoryToUpdateMap);
        }
    }
    global void finish(Database.BatchableContext BC) {
    }
}