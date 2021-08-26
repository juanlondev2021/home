/********************************************************************************************************
Description : This class creates Inventory Records for all Door Tag Script Industries which are 
marked as "Y or M".
***************************************************************************************************************/


public class nuHomeInventoryHandler
{
    
    // fetching all the industry values that are marked as 'Y or M'.
    
    public static void onAfterInsert(Map<Id, Door_Tag_Script__c> recordsToProcess)
    {
        Set<Id> accountIdsSet = new Set<Id>();
        Set<String> industrySet = new Set<String>();
        Map<String, Industry_Values__c> industryValues = new Map<String, Industry_Values__c>();
        industryValues = Industry_Values__c.getAll();
        
        Map<id, Set<String>> accountIndustryMap = new Map<Id, Set<String>>();
        Map<String,String> industryRepsonseMap = new Map<String, String>();
        Map<String,String> customSettingMap = new Map<String,String>();
        Map<String,String> surveyIndustryMap = new Map<String,String>();
        Map<String,String> surveyQuestionMap = new Map<String,String>();
        Map<String,Door_Tag_Script__c> accountsDTS = new Map<String,Door_Tag_Script__c>();
        // getting all industry field name and Questions from Custom Setting.
        
        for(Industry_Values__c currRec : industryValues.values())
        {
            customSettingMap.put(currRec.Label__c, currRec.Question__c);
            surveyIndustryMap.put(currRec.Question__c,currRec.Label__c);
        }
        
        // checking industry values are 'Y or M'.
        
        for(Door_Tag_Script__c currRec : recordsToProcess.values()){
            for(Industry_Values__c currIndustry : industryValues.values()){
                
                Set<String> additionalIndustry = new Set<String>();
                if(currRec.additional_industry__c != Null && currRec.additional_industry__c !='')
                {
                    for(String industry : currRec.additional_industry__c.split(',') )
                    {
                        additionalIndustry.add(industry);
                    }
                }
                
                String fieldName = currIndustry.Name.trim();
                String Response = String.valueOf(currRec.get(fieldName));
                if((currRec.get(fieldName) != Null) && 
                   (!additionalIndustry.contains(currIndustry.label__c)) &&
                   (currRec.consent__c == 'Yes') &&
                   (currRec.get(fieldName) == 'Yes'  || 
                    currRec.get(fieldName) == 'Maybe'  ||
                    currRec.get(fieldName) == 'Blinds' ||
                    currRec.get(fieldName) == 'Shutters' ||
                    currRec.get(fieldName) == 'Blinds and Shutters')){
                        System.debug('Account value is + + + '+currRec.Account__c);
                        if(currRec.Account__c != Null)
                        {
                            accountIdsSet.add(currRec.Account__c);
                            
                            if(accountIndustryMap.containsKey(currRec.Account__c))
                                accountIndustryMap.get(currRec.Account__c).add(currIndustry.label__c);
                            else
                                accountIndustryMap.put(currRec.Account__c, new Set<String>{currIndustry.label__c});
                            
                            industrySet.add(currIndustry.label__c);
                            
                            if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Wood__c == True) && 
                               (currIndustry.label__c == 'Flooring/Carpeting'))
                                
                                Response = currRec.Flooring__c + ', '+ 'Wood';
                            
                            if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Carpet__c == True) && 
                               (currIndustry.label__c == 'Flooring/Carpeting'))
                                
                                Response = currRec.Flooring__c + ', '+ 'Carpet';
                            
                            if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Tile__c == True) && 
                               (currIndustry.label__c == 'Flooring/Carpeting'))
                                
                                Response = currRec.Flooring__c + ', '+ 'Tile';
                            
                            
                            if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Wood__c == True && currRec.Tile__c == True ) && 
                               (currIndustry.label__c == 'Flooring/Carpeting'))
                                
                                Response = currRec.Flooring__c + ', '+ 'Wood, Tile';
                            
                            
                            if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Wood__c == True && currRec.Carpet__c == True) && 
                               (currIndustry.label__c == 'Flooring/Carpeting'))
                                
                                Response = currRec.Flooring__c + ', '+ 'Wood, Carpet';
                            
                            
                            if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Carpet__c == True && CurrRec.Tile__c == True) && 
                               (currIndustry.label__c == 'Flooring/Carpeting'))
                                
                                Response = currRec.Flooring__c + ', '+ 'Carpet, Tile';
                            
                            accountsDTS.put(currRec.Account__c,currRec);
                            industryRepsonseMap.put(currRec.Account__c+'-'+currIndustry.label__c,Response);
                            surveyQuestionMap.put(currRec.Account__c+'-'+currIndustry.label__c,customSettingMap.get(currIndustry.label__c));
                            
                        }
                        System.Debug('The list of accountIndustryMap industry+++++++++++++'+accountIndustryMap);
                        System.Debug('The list of industrySet+++++++++++++'+industrySet);
                        System.Debug('The list of accountIdsSet+++++++++++++'+accountIdsSet);
                        System.Debug('The list of industryRepsonseMap +++++++++++++'+industryRepsonseMap);
                    }
            }
        }
        if(accountIdsSet.size() > 0 && industrySet.size() > 0)
        {
            nuHomeInventoryHandler.createInventoryRecords(accountIdsSet,industrySet,accountIndustryMap,industryRepsonseMap,surveyQuestionMap,surveyIndustryMap,accountsDTS);
            // nuHomeInventoryHandler.CreateUnMatchingInvRecords(accountIdsSet,industrySet,accountIndustryMap,industryRepsonseMap,surveyQuestionMap);
        }
    }
    
    // fetching all the industry values that are marked as 'Y or M'.
    
    public static void onAfterUpdate(Map<Id, Door_Tag_Script__c> newMapRecordList, Map<Id, Door_Tag_Script__c> oldMapRecordList)
    {
        Set<Id> accountIdsSet = new Set<Id>();
        Set<String> industrySet = new Set<String>();
        Map<String, Industry_Values__c> industryValues = new Map<String, Industry_Values__c>();
        industryValues = Industry_Values__c.getAll();
        Map<id, Set<String>> accountIndustryMap = new Map<Id, Set<String>>();
        Map<String,String> industryRepsonseMap = new Map<String, String>();
        Map<String,Door_Tag_Script__c> accountsDTS = new Map<String,Door_Tag_Script__c>();
        Map<String,String> surveyIndustryMap = new Map<String,String>();
        Map<String,String> customSettingMap = new Map<String,String>();
        Map<String,String> surveyQuestionMap = new Map<String,String>();
        
        // getting all industry field name and Questions from Custom Setting.
        
        for(Industry_Values__c currRec : industryValues.values())
        {
            customSettingMap.put(currRec.Label__c, currRec.Question__c);
            surveyIndustryMap.put(currRec.Question__c,currRec.Label__c);
        }
        
        // checking industry values are 'Y or M'.
        
        for(Door_Tag_Script__c currRec : newMapRecordList.values()){
            System.debug('!!!Door_Tag_Script__c: '+currRec);
            System.debug('##oldDoor tag: '+oldMapRecordList.get(currRec.Id));
            for(Industry_Values__c currIndustry : industryValues.values()){
                
                Set<String> additionalIndustry = new Set<String>();
                if(currRec.additional_industry__c != Null && currRec.additional_industry__c !='')
                {
                    for(String industry : currRec.additional_industry__c.split(',') )
                    {
                        additionalIndustry.add(industry);
                    }
                }
                
                String fieldName = currIndustry.Name.trim();
                String Response = String.valueOf(currRec.get(fieldName));
                if((currRec.get(fieldName) != Null) && 
                   (!additionalIndustry.contains(currIndustry.label__c)) &&
                   (currRec.consent__c == 'Yes') &&
                   (currRec.get(fieldName) == 'Yes'  || 
                    currRec.get(fieldName) == 'Maybe'  ||
                    currRec.get(fieldName) == 'Blinds' ||
                    currRec.get(fieldName) == 'Shutters' ||
                    currRec.get(fieldName) == 'Blinds and Shutters')
                   && oldMapRecordList.get(currRec.Id).get(fieldName) != currRec.get(fieldName)){
                       integer m = 0;
                       system.debug('----' + m);
                       if(currRec.Account__c != Null)
                           
                       {
                           accountIdsSet.add(currRec.Account__c);
                           
                           if(accountIndustryMap.containsKey(currRec.Account__c))
                               accountIndustryMap.get(currRec.Account__c).add(currIndustry.label__c);
                           else
                               accountIndustryMap.put(currRec.Account__c, new Set<String>{currIndustry.label__c});
                           
                           industrySet.add(currIndustry.label__c);
                           
                           
                           if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Wood__c == True) && 
                              (currIndustry.label__c == 'Flooring/Carpeting')){
                                  
                                  Response = currRec.Flooring__c + ', '+ 'Wood';
                                  
                              }else if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Carpet__c == True) && 
                                       (currIndustry.label__c == 'Flooring/Carpeting')){
                                           
                                           Response = currRec.Flooring__c + ', '+ 'Carpet';
                                           
                                       }else if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Tile__c == True) && 
                                                (currIndustry.label__c == 'Flooring/Carpeting')){
                                                    
                                                    Response = currRec.Flooring__c + ', '+ 'Tile';
                                                    
                                                    
                                                }else if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Wood__c == True && currRec.Tile__c == True ) && 
                                                         (currIndustry.label__c == 'Flooring/Carpeting')){
                                                             
                                                             Response = currRec.Flooring__c + ', '+ 'Wood, Tile';
                                                             
                                                             
                                                         }else if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Wood__c == True && currRec.Carpet__c == True) && 
                                                                  (currIndustry.label__c == 'Flooring/Carpeting')){
                                                                      
                                                                      Response = currRec.Flooring__c + ', '+ 'Wood, Carpet';
                                                                      
                                                                      
                                                                  }else if((currRec.Flooring__c == 'Yes' || currRec.Flooring__c == 'Maybe') && (currRec.Carpet__c == True && CurrRec.Tile__c == True) && 
                                                                           (currIndustry.label__c == 'Flooring/Carpeting')){
                                                                               
                                                                               Response = currRec.Flooring__c + ', '+ 'Carpet, Tile';
                                                                               
                                                                           }
                           accountsDTS.put(currRec.Account__c,currRec);
                           industryRepsonseMap.put(currRec.Account__c+'-'+currIndustry.label__c,Response);
                           surveyQuestionMap.put(currRec.Account__c+'-'+currIndustry.label__c,customSettingMap.get(currIndustry.label__c));
                       }
                       
                       
                   } else
                       system.debug('');
            }
        }
        
        if(accountIdsSet.size() > 0 && industrySet.size() > 0)
        {
            nuHomeInventoryHandler.createInventoryRecords(accountIdsSet,industrySet,accountIndustryMap,industryRepsonseMap,surveyQuestionMap,surveyIndustryMap,accountsDTS);
            // nuHomeInventoryHandler.CreateUnMatchingInvRecords(accountIdsSet,industrySet,accountIndustryMap,industryRepsonseMap,surveyQuestionMap);
        }
    }
    
    // Creating Industry records for number of line items available for each industries that are marked as 'Y or M'.
    
    public static void createInventoryRecords(Set<Id> accountIdsSet, Set<String> industrySet,Map<id, Set<String>> accountIndustryMap,Map<String,String> industryRepsonseMap,Map<String,String> surveyQuestionMap,Map<String,String> surveyIndustryMap,Map<String,Door_Tag_Script__c> accountsDTS) 
    {
        Set<String> productNameSet = new Set<String>();
        Map<Id, String> accountBranchMap = new Map<Id, String>();
        Map<String, String> surveyResponse = new Map<String, String>();
        Map<String, String> surveyQuestion = new Map<String, String>();
        Set<String> accountsBranchSet = new Set<String>();
        Map<Id,Account> accountMap = new Map<Id,Account>();
        map<Id,String> accountUserAddressBranchMap = new map<Id,String>(); 
        Map<Id,Opportunity> updateOpportunity = new Map<Id,Opportunity>();       
        Set<String> zipCodes = new Set<String>();
        String verbiage = 'Thanks for activating your nuCards and welcome to nuHome. You are now ready to use all the great offers created just for you from us and the businesses serving your new area. Remember, there are no fees when using our products and services. Now that you are part of our family, we will work hard to help bring you great offers, latest news, tips and more.';
        
        for(Door_Tag_Script__c doorTagScript : [SELECT Account__c,User_Address__r.Address__r.Branch__r.Name,User_Address__r.address__r.zip_code__c FROM Door_Tag_Script__c WHERE ID in : accountsDTS.values()]){
            accountUserAddressBranchMap.put(doorTagScript.Account__c,doorTagScript.User_Address__r.Address__r.Branch__r.Name);
            zipCodes.add(doorTagScript.User_Address__r.address__r.zip_code__c);
        }    
        
        if(accountIdsSet.size() > 0)
        {
            // Counting number of Line items for Door Tag Script opportunity to create inventory records.
            
            for(Account currAcc : [SELECT Branch__c,Id,Name,PersonMobilePhone,Verbal_Consent__c  FROM Account WHERE Id IN :accountIdsSet])
            {
                if(accountUserAddressBranchMap.containsKey(currAcc.id))
                {
                    accountBranchMap.put(currAcc.id,accountUserAddressBranchMap.get(currAcc.id));
                    accountsBranchSet.add(accountUserAddressBranchMap.get(currAcc.id));
                }
                accountMap.put(currAcc.id, currAcc);    
                
                System.debug('accountIndustryMap.containsKey(currAcc.Id)+++'+accountIndustryMap.containsKey(currAcc.Id)+currAcc.Id);
                if(accountIndustryMap.containsKey(currAcc.Id))
                {
                    for(String industry : accountIndustryMap.get(currAcc.Id))
                    {
                        System.debug('industryRepsonseMap.containsKey(currAcc.Id++industry)++++'+currAcc.Id+'-'+industry);
                        if(industryRepsonseMap.containsKey(currAcc.Id+'-'+industry))
                        {
                            
                            surveyResponse.put(currAcc.Id+'-'+accountUserAddressBranchMap.get(currAcc.id)+'-'+industry, industryRepsonseMap.get(currAcc.id+'-'+industry)); 
                            surveyQuestion.put(currAcc.Id+'-'+accountUserAddressBranchMap.get(currAcc.id)+'-'+industry, surveyQuestionMap.get(currAcc.id+'-'+industry)); 
                            
                        }
                    }
                    
                }
                
            }
        }
        System.debug('surveyResponse+++'+surveyResponse);
        System.debug('surveyQuestion+++'+surveyQuestion);
        System.debug('accountBranchMap+++'+accountBranchMap);
        
        for(String branch : accountBranchMap.values())
        {
            for(String industry : industrySet)
            {
                productNameSet.add(branch+'-'+industry);
            }
        }
        System.debug('productNameSet+++'+productNameSet);
        
        Set<String> unMatchingProductNamesSet = new Set<String>();
        unMatchingProductNamesSet.addAll(productNameSet);
        
        Id invRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        
        Map<String,List<OpportunityLineItem>> lineItemMap = new Map<String, List<OpportunityLineItem>>();
        
        if(accountBranchMap.keySet().size() > 0)
        {
            Id oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
            List<Inventory__c> invList = new List<Inventory__c>();
            
            // will create records for matching prodcuts.
            for(opportunityLineItem currItem : [SELECT id, Quantity,listprice,unitprice,name, Product2.Name,Opportunity.Sort_Order__c,
                                                Product2.available_zipcodes__c,
                                                OpportunityId,Opportunity.AccountId,Opportunity.OB_Campaign_Primary_Contact_Email__c FROM 
                                                opportunitylineitem where Opportunity.RecordTypeId = :oppRecTypeId 
                                                AND Opportunity.CPL_Operation_Stages__c = 'Active' AND
                                                Product2.Name IN :productNameSet  Order by Opportunity.Sort_Order__C ASC])
            {
                Set<String> allZips = new Set<String>();
                allZips.addAll(zipCodes);
                Boolean isMatched = false;
                if(currItem.Product2.available_zipcodes__c != Null)
                {
                    for(String zip : currItem.Product2.available_zipcodes__c.split(';'))
                    {
                        if(allZips.contains(zip))
                        {
                            allZips.remove(zip);
                            isMatched  = true;
                        }
                    }
                }
                
                if(lineItemMap.containsKey(currItem.Product2.Name))
                {
                    if(isMatched  == True && allZips.size() <> zipCodes.size() )
                        lineItemMap.get(currItem.Product2.Name).add(currItem);
                }
                else
                {
                    if(isMatched  == True && allZips.size() <> zipCodes.size() )
                        lineItemMap.put(currItem.Product2.Name, new List<OpportunityLineItem>{currItem});
                }
            }
            
            
            for(String currProductName : lineItemMap.keySet())
            {    
                for(String accId : accountIdsSet)
                {
                    if(surveyResponse.containsKey(accId+'-'+currProductName))
                    {
                        Inventory__c inv = new Inventory__c();
                        inv.Account__c = accId;
                        inv.User_Address__c = accountsDTS.get(accId).User_Address__c;
                        //  inv.Opportunity__c = currItem.OpportunityId;
                        inv.Survey_Response__c = surveyResponse.get(accId+'-'+currProductName);
                        inv.Survey_Question__c = surveyQuestion.get(accId+'-'+currProductName);
                        inv.Inventory_Type__c = 'DT Script';
                        inv.Billing_Opp_Email__c =  lineItemMap.get(currProductName)[0].Opportunity.OB_Campaign_Primary_Contact_Email__c;
                        if(surveyIndustryMap.containsKey(inv.Survey_Question__c ))
                            inv.industry__c = surveyIndustryMap.get(inv.Survey_Question__c );
                        inv.RecordTypeId = invRecTypeId;
                        
                        if(inv.industry__c != Null)
                        {
                            if(inv.industry__c == 'Cable/Satellite TV/Internet')
                                inv.Boberdoo_Project_Values__c = 'Cable/Satellite TV/Internet';
                            if(inv.industry__c == 'Handyman')
                                inv.Boberdoo_Project_Values__c = 'Handyman';
                            if(inv.industry__c == 'Security Systems')
                                inv.Boberdoo_Project_Values__c = 'Security Systems';
                            if(inv.industry__c == 'Home Automation')
                                inv.Boberdoo_Project_Values__c = 'Home Automation';
                            if(inv.industry__c == 'Locksmiths')
                                inv.Boberdoo_Project_Values__c = 'Locksmiths';
                            if(inv.industry__c == 'Garage Floor Coating')
                                inv.Boberdoo_Project_Values__c = 'Garage Floor Coating';
                            if(inv.industry__c == 'Solar Power')
                                inv.Boberdoo_Project_Values__c = 'Solar Power';
                            if(inv.industry__c == 'Energy Audit/Radiant Barrier/Insulation')
                                inv.Boberdoo_Project_Values__c = 'Energy Audit/Radiant Barrier/Insulation';
                            if(inv.industry__c == 'Sheds')
                                inv.Boberdoo_Project_Values__c = 'Sheds';
                            if(inv.industry__c == 'Identity Theft')
                                inv.Boberdoo_Project_Values__c = 'Identity Theft';
                            if(inv.industry__c == 'Health Club/CrossFit')
                                inv.Boberdoo_Project_Values__c = 'Health Club/CrossFit';
                            if(inv.industry__c == 'Vehicle Purchase')
                                inv.Boberdoo_Project_Values__c = 'Vehicle Purchase';
                            if(inv.industry__c == 'Home Warranty')
                                inv.Boberdoo_Project_Values__c = 'Home Warranty';
                            if(inv.industry__c == 'Mortgage Protection')
                                inv.Boberdoo_Project_Values__c = 'Mortgage Protection'; 
                        }
                        
                        
                        if(accountMap.get(accId).Verbal_Consent__c == 'Yes' || accountMap.get(accId).Verbal_Consent__c == 'Phone Only')
                        {
                            inv.idCPL_Billing_Opportunity__c =  lineItemMap.get(currProductName)[0].OpportunityId;
                            inv.Product_Name__c =  lineItemMap.get(currProductName)[0].Product2.Name; // mapping product name
                            inv.Product_Price__c =  lineItemMap.get(currProductName)[0].unitprice;  // mapping product price
                            inv.Quantity__c =  lineItemMap.get(currProductName)[0].Quantity; // mapping quantity
                            inv.list_price__c = lineItemMap.get(currProductName)[0].listprice;
                            inv.Billing_Stage__c = 'Billable';
                            
                            Opportunity updateOpp = new Opportunity();
                            updateOpp.id = lineItemMap.get(currProductName)[0].OpportunityId;
                            if(lineItemMap.get(currProductName)[0].Opportunity.sort_order__c == Null)
                                updateOpp.Sort_Order__c = 1;
                            else
                                updateOpp.Sort_Order__c = lineItemMap.get(currProductName)[0].Opportunity.sort_order__c+1;
                            
                            updateOpportunity.put(updateOpp.id, updateOpp);
                        }
                        else
                        {
                            inv.Billing_Stage__c = 'Non-Billable';  
                        }
                        
                        if(accountsDTS.containsKey(accId))
                        {
                            inv.Door_Tag_Script__c = accountsDTS.get(accId).id;
                            inv.Consumer_Summary__c =  'Hi ' + accountMap.get(accId).Name + '<br/><br/>' + verbiage + '<br/><br/>' + '- Your friends at nuHome ' + 
                                '<br/><br/>'+ 'Just a reminder' + '<br/><br/>' + 'Below is a list of your immediate interests for your home. We will forward your requests to our professionals so they can contact you. '+'<br/><br/>' +
                                '<b>'+ 'Summary : ' + '</b>' + inv.industry__c + '<br/>' ;
                        }
                        if(accountMap.get(accId).PersonMobilePhone != Null)
                            inv.ANI__c = accountMap.get(accId).PersonMobilePhone;
                        
                        if(inv.Billing_Opp_Email__c == null)
                            inv.Consumer_Summary__c = 'There is no email'; 
                        invList.add(inv);
                    }
                }
                
                if(unMatchingProductNamesSet.contains(currProductName)) 
                    unMatchingProductNamesSet.remove(currProductName);
            }
            
            for(String pName : unMatchingProductNamesSet)
            {
                for(String accId : accountIdsSet)
                {
                    if(surveyResponse.containsKey(accId+'-'+pName))
                    {
                        System.debug('The Account and user address value is++'+accId+accountsDTS.get(accId).User_Address__c);
                        Inventory__c inv = new Inventory__c();
                        inv.Account__c = accId;
                        inv.User_Address__c = accountsDTS.get(accId).User_Address__c;
                        // inv.idCPL_Billing_Opportunity__c = currItem.OpportunityId;
                        inv.Survey_Response__c = surveyResponse.get(accId+'-'+pName);
                        inv.Survey_Question__c = surveyQuestion.get(accId+'-'+pName);
                        inv.Inventory_Type__c = 'DT Script';
                        inv.RecordTypeId = invRecTypeId;
                        if(accountMap.get(accId).PersonMobilePhone != Null)
                            inv.ANI__c = accountMap.get(accId).PersonMobilePhone;
                        inv.UnMatching_Invetnory__c = true;
                        if(surveyIndustryMap.containsKey(inv.Survey_Question__c))
                            inv.industry__c = surveyIndustryMap.get(inv.Survey_Question__c);
                        
                        inv.Billing_Stage__c = 'Non-Billable';  
                        
                        if(accountsDTS.containsKey(accId))
                        {
                            inv.Door_Tag_Script__c = accountsDTS.get(accId).id;
                            inv.Consumer_Summary__c = 'There is no email';
                        }
                        
                        if(inv.industry__c != Null)
                        {
                            if(inv.industry__c == 'Cable/Satellite TV/Internet')
                                inv.Boberdoo_Project_Values__c = 'Cable/Satellite TV/Internet';
                            if(inv.industry__c == 'Handyman')
                                inv.Boberdoo_Project_Values__c = 'Handyman';
                            if(inv.industry__c == 'Security Systems')
                                inv.Boberdoo_Project_Values__c = 'Security Systems';
                            if(inv.industry__c == 'Home Automation')
                                inv.Boberdoo_Project_Values__c = 'Home Automation';
                            if(inv.industry__c == 'Locksmiths')
                                inv.Boberdoo_Project_Values__c = 'Locksmiths';
                            if(inv.industry__c == 'Garage Floor Coating')
                                inv.Boberdoo_Project_Values__c = 'Garage Floor Coating';
                            if(inv.industry__c == 'Solar Power')
                                inv.Boberdoo_Project_Values__c = 'Solar Power';
                            if(inv.industry__c == 'Energy Audit/Radiant Barrier/Insulation')
                                inv.Boberdoo_Project_Values__c = 'Energy Audit/Radiant Barrier/Insulation';
                            if(inv.industry__c == 'Sheds')
                                inv.Boberdoo_Project_Values__c = 'Sheds';
                            if(inv.industry__c == 'Identity Theft')
                                inv.Boberdoo_Project_Values__c = 'Identity Theft';
                            if(inv.industry__c == 'Health Club/CrossFit')
                                inv.Boberdoo_Project_Values__c = 'Health Club/CrossFit';
                            if(inv.industry__c == 'Vehicle Purchase')
                                inv.Boberdoo_Project_Values__c = 'Vehicle Purchase';
                            if(inv.industry__c == 'Home Warranty')
                                inv.Boberdoo_Project_Values__c = 'Home Warranty';
                            if(inv.industry__c == 'Mortgage Protection')
                                inv.Boberdoo_Project_Values__c = 'Mortgage Protection'; 
                            
                        }
                        invList.add(inv);
                    } 
                }
                
            }
            
            // creating inventory records.
            if(invList.size() > 0)
            {
                insert invList;
                if((updateOpportunity.values()).size() > 0)
                    update updateOpportunity.values();
            }
        } 
    }
}