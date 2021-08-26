/*
 * Created By: MSTSolutions
 * Description: Trigger for inventory object which will redirect the inventory records to specific handler classes.
 * 
 * */
trigger InventoryTrigger on Inventory__c (before insert,before update,after update,after insert) {

    Map<String,Boberdoo_Project_Value__c> BoberdooProject = New Map<String,Boberdoo_Project_Value__c>();
    Set<Id> accountIds = new Set<Id>();
    Set<Id> oppIds = new Set<Id>();
    Set<id> industryIds = new set<Id>();
    set<id> uaIds = new set<id>();
    Map<id,Boolean> tcpaMap = new Map<id,Boolean>();
    Map<Id,Account> accountMap = new Map<Id, Account>();
    Map<Id,user_address__c> uaMap = new Map<Id, user_address__c>();
    Id obCampaignRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId();
    Id dtsRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
    Id specRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome nuCard SPEC').getRecordTypeId();
    Id cplRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome nuCard CPL').getRecordTypeId();
    Id subRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome nuCard SUB').getRecordTypeId();
    Id hotLeadRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
    Id transferRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Transfer').getRecordTypeId();
    For(inventory__c tmp : Trigger.new)//Filling up common collection variables
    {
        if(tmp.idCPL_Billing_Opportunity__c!=null)
          oppIds.add(tmp.idCPL_Billing_Opportunity__c);
        if(tmp.account__c!=null)
          accountIds.add(tmp.account__c);
        if(tmp.Industry_Lookup__c !=null)
          industryIds.add(tmp.Industry_Lookup__c);
        if(tmp.User_Address__c !=null)
          uaIds.add(tmp.User_Address__c);      
    }
    if(Trigger.IsBefore)
    {        
        for(Boberdoo_Project_Value__c BProject:[SELECT Boberdoo_Project_Value__c,Picklist_Values__c,Industry__c FROM Boberdoo_Project_Value__c]){
            If(!BoberdooProject.containsKey(BProject.Picklist_Values__c))
                BoberdooProject.put(BProject.Industry__c, BProject);
        }
        //added for comparing phone from inventory and did record poc value
        Map<id,string> phoneinDID = new map<id,string>();
        Set<id> didColl = new set<id>();
        for(Inventory__c currInv : Trigger.new)
        {
            if(currInv.DID_Name__c!=null)
                didColl.add(currInv.DID_Name__c);
        }
        for(DID__c t : [select id,POC__c from DID__c where id in : didColl])
            phoneinDID.put(t.id,t.POC__c);
        
        if(!trigger.isinsert){//as in before insert there will be no ids in the map keyset        
            for(TCPA_Compliance__c tt : [select id,Is_Active__c,Inventory__c from TCPA_Compliance__c where Inventory__c in :trigger.newMap.keyset()])
            {
                tcpaMap.put(tt.inventory__c,tt.Is_Active__c);
            }
        }
        for(Inventory__c currInv : Trigger.new)
        {      
              //update the Boberdoo project value based on record type
              currInv.Validation_errors__c = '';//resetting the errors here
              currInv.Missing_info__c = '';
              currInv.Boberdoo_Applicable__c = true;//resetting              
              If(currInv.RecordtypeId == hotLeadRecTypeId && currInv.Boberdoo_Project_Values__c == null)
              {
                  currInv.Boberdoo_Project_Values__c = 'Hot lead';
              }
              else if(currInv.RecordtypeId != hotLeadRecTypeId && currInv.Boberdoo_Project_Values__c == null)
              {
                  currInv.Boberdoo_Project_Values__c = currInv.Industry__c;
              }
              String tmpDID ='';
              if(currInv.DID__c != null)
              {
                   tmpDID = currInv.DID__c;
                   tmpDID = tmpDID.replaceAll('[^0-9]', '');
                    system.debug(tmpDID+'inventory did value after conversion');
              }
                if((currInv.recordtypeid == cplRecTypeId|| currInv.recordtypeid == subRecTypeId|| currInv.recordtypeid == specRecTypeId) && currInv.DID__c != null && tmpDID != phoneinDID.get(currInv.DID_Name__c))
              {
                    currInv.Validation_errors__c =' --Phone Number in inventory and DID record POC are different and not applicable to Boberdoo';
                      currInv.Boberdoo_Applicable__c=false;
              }
              If( currInv.recordtypeid == obCampaignRecTypeId ){//only on ob campaign
                  if(currInv.appt_Verification__c != 'Approved')
                  {
                      currInv.Validation_errors__c =' --OB Report is not approved and not applicable to Boberdoo';
                      currInv.Boberdoo_Applicable__c=false;
                  }
              }
              If(currInv.User_Address__c != null ||(currInv.fAccount_Mobile__c !=null && currInv.fAccount_Phone__c  !=null && currInv.fAccount_City__c !=null
                    && currInv.fAccount_Street__c !=null && currInv.fAccount_State__c !=null && currInv.fAccount_Zip__c  !=null))
              {
                  //nothing
              }
              else
              {
                  currInv.Validation_errors__c =' --Not valid User information exists--Validation 2';
                  currInv.Boberdoo_Applicable__c=false;
              } 
                
        }
          System.debug(oppIds+'print all' +industryIds);
           Map<id,string> mapOFIndustryNames = new map<id,string>();
           if(industryIds != null && industryIds.size()>0)
           {
               for(Industry__c i : [select id,name from Industry__c where id in :industryIds])
                    mapOFIndustryNames.put(i.id,i.name);
           }
             System.debug('print map' +mapOFIndustryNames);
             
           if(accountIds.size() > 0)
           {   
                
              accountMap.putAll([SELECT Id,Name,Is_Test_Account__c,PersonMobilePhone,Phone FROM Account WHERE Id IN:accountIds]);     
           }
           if(uaIds.size() > 0)
           {  
                for(User_Address__c uarec : [SELECT Id,UserAccount__r.PersonContact.DoNotCall,Address__r.Branch__c,UserAccount__r.Verbal_Consent__c FROM User_Address__c WHERE Id IN:uaIds])
                    uamap.put(uarec.id,uarec);          
           }
           Map<id,list<OpportunityLineItem>> mapOLIColl = new Map<id,List<OpportunityLineItem>>();
           Map<id,string> mapOppID_Name =new Map<id,string>();
           if(oppIDs != null && oppIDs.size() > 0)
           {        
              for(Opportunity opp :[Select id,name,(Select Industry__c,branch__c,Hot_Leads_Branch__c, OpportunityId, UnitPrice, ListPrice From OpportunityLineItems) From Opportunity where id in :oppIDs])
              {
                mapOppID_Name.put(opp.id,opp.name);
                 if(opp.OpportunityLineItems !=null){
                    for(OpportunityLineItem oli:opp.OpportunityLineItems){
                        List<OpportunityLineItem> collOLITemp = new List<OpportunityLineItem>(); 
                        If(mapOLIColl.containsKey(oli.OpportunityId)){
                          collOLITemp = mapOLIColl.get(oli.OpportunityId);
                          collOLITemp.add(oli);
                          mapOLIColl.put(oli.OpportunityId, collOLITemp);
                        }
                        else
                        {
                          collOLITemp.add(oli); 
                          mapOLIColl.put(oli.OpportunityId, collOLITemp);
                        }
                    }
                 }
              }
           }   
           for(Inventory__c currInv : Trigger.new)
           {
               System.debug(currInv.user_address__c+' tttttttt '+uamap.get(currInv.user_address__c));
                if(currInv.user_address__c != null && uamap.get(currInv.user_address__c) != null && uamap.get(currInv.user_address__c).UserAccount__r.PersonContact.DoNotCall != false)
                {   
                    currInv.Validation_errors__c += '--do not call is invalid';
                    currInv.Boberdoo_Applicable__c=false;
                }
                if(currInv.user_address__c !=null)
                {
                    currInv.Branch_Lookup__c = uamap.get(currInv.user_address__c).Address__r.Branch__c;
                }
                if(currInv.user_address__c != null && uamap.get(currInv.user_address__c) != null && uamap.get(currInv.user_address__c).UserAccount__r.Verbal_Consent__c != 'Yes' )
                {
                    System.debug('inside verbal'+tcpaMap);                  
                    if ( !tcpaMap.containsKey(currInv.id) || !tcpaMap.get(currInv.id))
                    {   
                        System.debug('eeeeee verbal'+tcpaMap.get(currInv.id));
                        currInv.Validation_errors__c += '--verbal consent is invalid';
                        currInv.Boberdoo_Applicable__c=false;
                    }
                }
               if(accountMap.containsKey(currInv.account__c))
               {
                   if(accountMap.get(currInv.account__c).Phone != Null)
                   {        
                      currInv.phone_mobile__c = accountMap.get(currInv.account__c).Phone;
                      currInv.ANI__c = accountMap.get(currInv.account__c).Phone;
                   }
                      
                   else if(accountMap.get(currInv.account__c).PersonMobilePhone != Null)
                   {
                        currInv.phone_mobile__c = accountMap.get(currInv.account__c).PersonMobilePhone;
                        currInv.ANI__c = accountMap.get(currInv.account__c).PersonMobilePhone;
                   }          
               }
               
               if(currInv.phone_mobile__c  == Null)
               {
                 currInv.Billing_Stage__c = 'Non - Billable';
               }      
                
               if(currInv.idCPL_Billing_Opportunity__c == Null )
               {
                   system.debug('Billing opp is null');
                  currInv.Billing_Stage__c = 'Non-Billable';
                  if(currInv.recordtypeid != dtsRecTypeId){
                    currInv.Validation_Errors__c += '--Idcpl billing opportunity is empty in this record';
                    currInv.Boberdoo_Applicable__c= false;
                  }
               }
               else
               {                    
                    if(mapOppID_Name.get(currInv.idCPL_Billing_Opportunity__c) != null ){
                        if(mapOppID_Name.get(currInv.idCPL_Billing_Opportunity__c).containsignorecase('nuhome')){
                            currInv.Validation_Errors__c+='--Opportunity is not valid for Boberdoo-1st validation';
                            currInv.Boberdoo_Applicable__c=false;
                        }
                    }

                   Boolean flag = false;
                   System.debug(mapOFIndustryNames.get(currInv.Industry_Lookup__c)+'  test Values '+mapOFIndustryNames+'  test map'+currInv.fAccount_Branch__c);
                    if(currInv.fAccount_Branch__c == null || (currInv.recordtypeid != hotLeadRecTypeId && mapOFIndustryNames.get(currInv.Industry_Lookup__c) == null && currInv.Industry__c == null))
                        currInv.Missing_info__c = 'Inventory fAccount branch or industry is empty';
                    else if(mapOLIColl.get(currInv.idCPL_Billing_Opportunity__c) != null ){
                        System.debug('The opportunity has OPP products'+mapOLIColl.get(currInv.idCPL_Billing_Opportunity__c).size());
                      for(OpportunityLineItem tempOli : mapOLIColl.get(currInv.idCPL_Billing_Opportunity__c)){
                          System.debug(tempOli.Industry__c +'  opp prod cy values'+tempOli.branch__c+' from map  '+mapOFIndustryNames.get(currInv.Industry_Lookup__c)+' both '+currInv.fAccount_Branch__c+'          yyy '+tempOli.Hot_Leads_Branch__c);
                        if((tempOli.branch__c != null || tempOli.Hot_Leads_Branch__c != null)){
                            if(((tempOli.Hot_Leads_Branch__c !=null && tempOli.Hot_Leads_Branch__c.equalsignorecase(currInv.fAccount_Branch__c)) || tempOli.Branch__c.equalsignorecase(currInv.fAccount_Branch__c)))
                             {
                                                                 System.debug('line 216');
                                if((tempOli.Industry__c != null) &&(tempOli.Industry__c.equalsignorecase(mapOFIndustryNames.get(currInv.Industry_Lookup__c)) || tempOli.Industry__c.equalsignorecase(currInv.Industry__c))&&(currInv.recordtypeid== hotLeadRecTypeId|| currInv.recordtypeid== obCampaignRecTypeId || currInv.recordtypeid== dtsRecTypeId)&&(tempOli.ListPrice != null && tempOli.UnitPrice != null))
                                {
                                                                        System.debug('line 218');
                                currInv.List_Price__c = tempOli.ListPrice;
                                currInv.Product_Price__c = tempOli.UnitPrice;
                                flag = true;
                                }
                                else if( (currInv.recordtypeid== subRecTypeId|| currInv.recordtypeid== specRecTypeId || currInv.recordtypeid== cplRecTypeId)&&(tempOli.ListPrice != null && tempOli.UnitPrice != null))
                                {
                                    System.debug('line 224');
                                currInv.List_Price__c = tempOli.ListPrice;
                                currInv.Product_Price__c = tempOli.UnitPrice;
                                flag = true;
                                }
                                
                                else
                                    currInv.Missing_info__c ='Opportunity product sales and list price are empty';
                            }                   
                        }
                        else
                            currInv.Missing_info__c ='Opportunity products are not having industry and branch information';
                      }
                      if(flag == false )
                          currInv.Missing_info__c ='None of the opportunity products are matched to branch and industry';
                   }
                   else
                   {
                        currInv.Missing_info__c ='There are no opportunity products exists for the given opportunity';
                   }
               }
               System.debug(currInv.recordtypeid+'try test   '+currInv.Missing_info__c+'  tttt   '+obCampaignRecTypeId );
               //Added by MST on November 24 to resolve inventory creation issue.
               Boolean beforeUpdate = false;
               if(Trigger.IsUpdate){
                   if(currInv.Product_Price__c == trigger.oldMap.get(currInv.id).Product_Price__c)
                       beforeUpdate = True;
                       }
               if(Trigger.IsInsert)
                   beforeUpdate = True;
               //End : Added by MST on November 24 to resolve inventory creation issue.
               if(currInv.recordtypeid != subRecTypeId && currInv.Missing_info__c != null  && currInv.Missing_info__c != '' && beforeUpdate)
               {
                  currInv.Validation_Errors__c+='--Verify missing info ';
                  currInv.Boberdoo_Applicable__c=false;
               }
               system.debug('ppp'+currInv.Validation_Errors__c);
               if(currInv.Validation_Errors__c.length()>0){
                    currInv.IsTriggerExecuted__c = false;                  
               }else{
                    currInv.IsTriggerExecuted__c = true;            
                }
                if((accountMap.containsKey(currInv.account__c))&&(accountMap.get(currInv.account__c).Is_Test_Account__c ||  accountMap.get(currInv.account__c).name.containsIgnoreCase('test')))
                {
                    currInv.Validation_Errors__c+='--This is attached to a test account. ';
                }
               if( (trigger.isinsert && currInv.recordtypeid == transferRecTypeId)||(currInv.Validation_Errors__c != ''  ))      
               {
                   system.debug('babordoo is set'+currInv.Boberdoo_Applicable__c);
                    currInv.Boberdoo_Applicable__c=  false;                    
                   system.debug('babordoo is rrrrrr'+currInv.Boberdoo_Applicable__c);
               }
               system.debug(currInv.Boberdoo_Applicable_Date__c+'value of bab'+currInv.Boberdoo_Applicable__c);
               if(currInv.Boberdoo_Applicable__c && currInv.Boberdoo_Applicable_Date__c == null && currInv.recordtypeid != hotLeadRecTypeId){
                   system.debug('bab value is'+currInv.Boberdoo_Applicable__c);
                  currInv.Boberdoo_Applicable_Date__c = System.now();
                }               
               if(currInv.RecordTypeId == dtsRecTypeId && (currInv.idCPL_Billing_Opportunity__c  == Null && currInv.appointment_outcome__c == 'Network Lead'))
               {
                   currInv.unmatching_Invetnory__C = True;
               }
               
              if(currInv.RecordTypeId == dtsRecTypeId && (currInv.idCPL_Billing_Opportunity__c  == Null))
               {
                   currInv.unmatching_Invetnory__C = True;
               }
               if((currInv.RecordTypeId == dtsRecTypeId || currInv.RecordTypeId == cplRecTypeId || currInv.RecordTypeId == subRecTypeId) && (currInv.Boberdoo_Project_Values__c == Null || currInv.Boberdoo_Project_Values__c ==''))
               {
                   try{
                   currInv.Boberdoo_Project_Values__c = BoberdooProject.get(currInv.Industry__c).Boberdoo_Project_Value__c;
                   }catch(Exception e){
                       
                   }
               }               
           }   
    } 
    If(Trigger.isAfter && Trigger.isUpdate)
    {
        nuHome_Email_Task_AC.createInventoryTask(Trigger.newMap, Trigger.oldMap);
        //babordoo distribution date is empty before and filled now
        List<nuHome_Billing__c> insertnuHomeBillingRecs = new List<nuHome_Billing__c>();
        Map<id,id> mapOpptoAcc = new Map<id,id>();
        For(opportunity opp : [select id,accountid from opportunity where id in :oppIds])
            mapOpptoAcc.put(opp.id,opp.accountid);
        For(inventory__c invRec : trigger.new)
        {
            if(invRec.idCPL_Billing_Opportunity__c != null){            
                //previously empty before update -- now its filled up-- and its final -- no more changes in date once stamped on it
                if(invRec.Boberdoo_Distribution_date__c != null && trigger.oldmap.get(invRec.id).Boberdoo_Distribution_date__c == null)
                {
                    insertnuHomeBillingRecs.add(new nuHome_Billing__c(inventory__c = invRec.id,Rate__c = invRec.Product_Price__c,
                                                    Account__c = mapOpptoAcc.get(invRec.idCPL_Billing_Opportunity__c),
                                                    Opportunity__c=invRec.idCPL_Billing_Opportunity__c));
                }
            }                   
        } 
        Insert insertnuHomeBillingRecs;
    } 
    If(Trigger.isAfter && Trigger.isInsert)
    {
         //Added by MSTSolutions redirecting to inventorytriggerhandler to populate the status post field values
         //based on the inventory is created on OB Campaign page.
         InventoryTriggerHandler.updateOBCMembers(Trigger.new);
            Map<Id, User_Address__c> updateUserAddressMap = new Map<Id, User_Address__c>();         
             for(Inventory__c currInv : Trigger.new)
             {
                if(currInv.RecordtypeId == hotLeadRecTypeId)
                {
                  if(currInv.user_address__c != Null)
                  {
                     User_Address__c updateUserAdd = new User_Address__c();
                     updateUserAdd.id = currInv.user_address__c;
                     updateUserAdd.inventory_created__c = True;
                    
                     updateUserAddressMap.put(updateUserAdd.id, updateUserAdd);               
                  }             
                }
             }   
           if(updateUserAddressMap.size() > 0)
               Update updateUserAddressMap.values(); 
    } 
        
    If(Trigger.isBefore && Trigger.isUpdate){
        for(Inventory__c invSDUpdate:Trigger.New){        
            //Added by Calvin Bates Jr. Whenever inventory is updated, check to see if Sale Disposition is Null.
            //if(invSDUpdate.Sale_Disposition__c != Null;
            //if Sale Disposition is not null, set the Sale Disposition Date Stamp to todays date and time, else keep blank
            if(invSDUpdate.Sale_Disposition__c != Null){
            
            invSDUpdate.Sale_Disposition_Date_Stamp__c = system.Now();
            }
                else{
                if(invSDUpdate.Sale_Disposition__c == Null){
                
                invSDUpdate.Sale_Disposition_Date_Stamp__c = Null;
                }
            
            }
        }
    }
    If(Trigger.isBefore && Trigger.isUpdate){
        for(Inventory__c invConfDUpdate:Trigger.New){           
            //Added by Calvin Bates Jr. Whenever inventory is updated, check to see if Confirmation Status is Null.
            //if(invConfDUpdate.Confirmation_Status__c != Null;
            //if Confirmation Status is not null, set the Confirmation Status Date Stamp to today's date and time, else keep blank
            if(invConfDUpdate.Confirmation_Status__c != Null){
            
            invConfDUpdate.Confirmation_Status_Date_Stamp__c = system.Now();
            }
                else{
                if(invConfDUpdate.Confirmation_Status__c == Null){
                
                invConfDUpdate.Confirmation_Status_Date_Stamp__c = Null;
                }
            
            }
        }
    }
}