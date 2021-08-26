/**
* Diaco
* @author 			Kevin Vega Hernandez href=<kevin.vega.h@hotmail.com>
* Project:			Account Triggers
* Description:		Trigger to Account.  
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						 Description
*			-----	----------		--------------------		 ---------------
* @version	1.0		23/06/2020		Kevin Vega Hernandez (KVH)	 Unification and Optimization of all Event Triggers.
**/

public class DiacoAccountTriggerUnifiedClass {
    
    public static void beforeTriggersToExecute(List<Account> accountList){
        
        for(Account accts:accountList){
            
            AddDoNotCallDateStamp(accts); 
            AddVerbalConsentDateStamp(accts);       
        } 
    }
    
    private static void AddDoNotCallDateStamp(Account accts){
        
        //if Do Not Call is checked, set the Do Not Call Date Stamp to todays date and time, else keep blank
        //As per latest requirement from cody, if donotcall is true and timestamp is empty then only fill the current day
        if(accts.PersonDoNotCall == True && accts.Do_Not_Call_Date_Stamp__c == Null){
            
            accts.Do_Not_Call_Date_Stamp__c = system.Now();
        }
        else if(accts.PersonDoNotCall == False){
            
            accts.Do_Not_Call_Date_Stamp__c = Null;
        }                     
    }
    
    public static void setPhoneForUserAddress(Map<Id,Account> newMap,Map<Id,Account> oldMap){
        
        boolean thereIsAChange = false;
        
        for(Account accNew: newMap.values()){
            
            Account accOld = oldMap.get(accNew.Id);
            
            if(accNew.Phone != accOld.Phone){
                thereIsAChange = true;
                break;
            }
        }
        
        if(thereIsAChange){
            
            List<User_Address__c> userAddressList = [SELECT Id,UserAccount__c,Phone__c FROM User_Address__c WHERE UserAccount__c IN :newMap.keyset()];
            
            list<User_Address__c> userAddressListToUpdate = new list<User_Address__c>();
            
            for(User_Address__c userAddress: userAddressList){
                
                Account ac = newMap.get(userAddress.UserAccount__c);
                
                if(userAddress.Phone__c != ac.Phone){
                    
                    userAddress.Phone__c = ac.Phone;
                    
                    userAddressListToUpdate.add(userAddress);
                    
                }     
            }
            
            update userAddressListToUpdate;  
        }
    }
    
    private static void AddVerbalConsentDateStamp(Account accts){
        
        //if Verbal Consent Flag Date Stamp is checked, set the Verbal Consent Date Stamp to today's date and time, else keep blank
        if(accts.Verbal_Consent_Date_Stamp_Flag__c == True){
            
            accts.Verbal_Consent_Date_Stamp__c = system.Now();
        }
        else if(accts.Verbal_Consent_Date_Stamp_Flag__c == False){
            
            accts.Verbal_Consent_Date_Stamp__c = Null;
        } 
        
    }
    
    public static void AccountMain(List<Account> accountList,Map<Id,Account> oldMap, Boolean isInsert, Boolean isUpdate){
        String currUserId = UserInfo.getUserId();
        currUserId = currUserId.subString(0,15);
        
        String integrationUserId = label.Middleware_User_Id;
        
        for(Account acc : accountList){
            if(acc.IsPersonAccount){
                //if the account get inserted with phone or mobilephone then populate respondate 
                if((isInsert && (acc.phone != Null || acc.personmobilephone != Null)) && currUserId != integrationUserId ){
                    acc.Respond_Date__c = System.today(); 
                }
                //if the account get update(null to not null) with phone or mobilephone then populate respondate at very first time 
                else if((isUpdate && acc.Respond_Date__c == null && 
                         ((oldMap.get(acc.id).phone == null && acc.phone != null) ||
                          (oldMap.get(acc.id).personmobilephone == null && acc.personmobilephone != null)))  && 
                        currUserId != integrationUserId){
                            
                            acc.Respond_Date__c = System.today();
                            
                        }           
            }
        }
        
    } 
    
    public static void Account_OwnerChange(Map<Id,Account> newMap, Map<Id,Account> oldMap){
        
        // Opportunity list update based on account id and StageName diferent to 'Closed Lost'.
        List<Opportunity> optyList=new List<Opportunity>(); 
        for(Opportunity opty: [select id,Ownerid,Accountid,StageName from Opportunity where Accountid in :newMap.keyset()])
        {
            if(opty.StageName != 'Closed Lost'){
                if(newMap.get(opty.Accountid).Ownerid != oldMap.get(opty.Accountid).Ownerid){
                    System.debug('Done in this part!');
                    opty.Ownerid=newMap.get(opty.Accountid).Ownerid;
                    optyList.add(opty);
                }
            }
        }
        if(optyList.size()>0) update optyList;
        
    }
    
}