/** 
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Account Trigger
 * TestClass:          AccountTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    09-11-2020         Jull Quintero D         Initial implementation of the class.
 * @version    1.1    11-03-2020         Jull Quintero D         Implementation of the method geoAccuracy

 **/

public  class AccountTriggerHelper {
    private static Boolean UpdateDelivety = true;

    /*
     * This method is responsible update account.Respond_Date__c
     * This method is run before Insert and before Update.
     * 
     * This method is used in:
     * AccountTrigger
     * 
     * @param List account, map account
     */
    public static void responseDate(List<Account> accounts, Map<Id,Account> oldMap, Boolean isInsert, Boolean isUpdate){        
        integer accountsLength = accounts.size();
        for (Integer i = 0; i < accountsLength; i++) {
            Account acc = accounts[i];        
            if(acc.IsPersonAccount){
                if( isInsert && (acc.phone != null || acc.personmobilephone != null)){
                    acc.Respond_Date__c = System.today(); 
                }
                else if( (isUpdate && acc.Respond_Date__c == null && 
                        ( (acc.phone != null && acc.phone != oldMap.get(acc.id).phone) ||
                        (acc.personmobilephone != null &&  acc.personmobilephone != oldMap.get(acc.id).personmobilephone)) ) )
                        {                            
                            acc.Respond_Date__c = System.today();                            
                        }           
            }
        }
    } 

    /**
     * @author: Jull Quintero D - 11-03-2020
     * This method is responsible create a contract for Data Integration Rule (Geocodes for Account Billing Address) 
        updating account field Geocode_Accuracy_c
     * This method is run After Insert After Update 
     * This method is used in:
     * AccountTrigger
     * 
     * @param Map account
     * @param Map Account
     * @param Boolean isInsert
     * @param Boolean isUpdate      
     **/
    public static void geoAccuracy(List<Account> accounts, Map<Id,Account> accountsMap, Map<Id,Account> oldAcctMap, Boolean isInsert, Boolean isUpdate) {
        List<Contact> contacts = new List<Contact>();
        integer accountsLength = accounts.size();
        for (Integer i = 0; i < accountsLength; i++) {
            Account acc = accounts[i];            
            if( diacoKnifeFunc.getRecordTypeNameById('Account', acc.RecordTypeId) == 'Person Account' ) {
                Boolean isChanged = false;
                if( isInsert ) {
                    isChanged = AccountEval.addressNoNull(acc);
                }else if( isUpdate ) {
                    Account oldAcct = oldAcctMap.get(acc.Id);
                    isChanged = AccountEval.addressChange(acc, oldAcct);
                }
                if( isChanged ) {
                        Contact contact = new Contact();
                        contact.FirstName = acc.FirstName;
                        contact.LastName = acc.LastName;
                        contact.Person_Account__c = acc.Id;
                        contact.MailingCity = acc.City__c;
                        contact.MailingState = acc.State__c;
                        contact.MailingStreet = acc.Street__c;
                        contact.MailingPostalCode = acc.Zip__c;
                        contact.MailingCountry = acc.County__c;
                        contact.Geo_Accuracy__c = true;
                        contacts.add(contact);
                    }
                }   
        }
        if( !contacts.isEmpty() ) {
            System.debug('>> Geo contact Data.com');
            insert contacts;
        }
    }  

    /** 
    @author: Jull Quintero D - 07-06-2021 
    * This method is responsible to update Deliveries Geolocation when Address is change
    * This method is run and after Update.    
    * This method is used in:
    * AccountTrigger
    * 
    * @param Map NewAccount
    * @param Map oldAccount      
    **/
    public static void getDeliveryGeoLocation(Map<Id,Account> newAccounts, Map<Id,Account> oldAcctMap) {
        if ( AccountTriggerHelper.UpdateDelivety ) {
            set<Id> personAccIds = new set<Id>();
            List<Account> accts = newAccounts.values();
            integer accountSize = newAccounts.size();
            for (Integer i = 0; i < accountSize; i++) {
                Account current = accts[i];
                Account oldAcct = oldAcctMap.get(current.Id);
                if( !personAccIds.contains(current.Id) && AccountEval.geoCodeChange(current, oldAcct) ) {
                    personAccIds.add(current.Id);
                }
            }
            
            if( !personAccIds.isEmpty() ) {
                System.debug('>> Account geoCodeChange');
                List<Delivery_Object__c> deliveries = [
                    SELECT 
                        Id,
                        Person_Account__c,
                        bypass_PB__c 
                    FROM Delivery_Object__c 
                    WHERE Person_Account__c IN :personAccIds AND CreatedDate = THIS_MONTH AND Hung_Status__c != 'Hung' 
                    LIMIT 50000 
                    FOR UPDATE ];
    
                integer deliverySize = deliveries.size();
                List<Delivery_Object__c> updateDeliveries = new List<Delivery_Object__c>();
                for (Integer i = 0; i < deliverySize; i++) {
                    Delivery_Object__c current = deliveries[i];
                    Account acct = newAccounts.get(current.Person_Account__c);                                 
                    current.Street__c = acct.Street__c;
                    current.City__c  = acct.City__c;
                    current.State__c = acct.State__c;
                    current.Zip__c = acct.Zip__c;
                    current.County__c = acct.County__c;                
                    current.Geocode_Accuracy__c = acct.Geocode_Accuracy__c;
                    current.Maps_latitude__c = acct.BillingLatitude;
                    current.Maps_longitude__c = acct.BillingLongitude;
                    current.bypass_PB__c = !current.bypass_PB__c;
                    updateDeliveries.add(current);
                }
                
                TriggerHandler.bypass('DeliveryObjectTrigger');
                    if( !updateDeliveries.isEmpty() ) {
                        System.debug('>> update deliveries ' + updateDeliveries.size() );
                        update updateDeliveries;
                        AccountTriggerHelper.UpdateDelivety = false;
                    } 
                TriggerHandler.clearBypass('DeliveryObjectTrigger');
            }
        }
    }

    /*
     * This method is responsible to update  User_Address__c.Phone__c with Account.Phone
     * 
     * This method is run after Update.
     * 
     * This method is used in:
     * AccountTrigger
     * 
     * @param Map New Accounts, Map Old Accounts
     **/
    public static void setPhoneForUserAddress(Map<Id,Account> newMap, Map<Id,Account> oldMap) {
        
        boolean thereIsAChange = false;
        List<Account> acctsNew = newMap.values();
        integer acctsLength = acctsNew.size();
        for (Integer i = 0; i < acctsLength; i++) {
            Account accNew = acctsNew[i];            
            Account accOld = oldMap.get(accNew.Id);
            
            if(accNew.Phone != accOld.Phone || accNew.PersonMobilePhone != accOld.PersonMobilePhone){
                thereIsAChange = true;
                break;
            }
        }
        
        if(thereIsAChange){ 
            list<User_Address__c> userAddressListToUpdate = new list<User_Address__c>();           

            List<User_Address__c> userAddress = [SELECT Id,UserAccount__c,Phone__c,PersonMobilePhone__c,Respond_Date__c 
                                                FROM User_Address__c 
                                                WHERE UserAccount__c IN :newMap.keyset()];   
            integer userAddressLength = userAddress.size();
            for (Integer i = 0; i < userAddressLength; i++) {
                User_Address__c  usAddress = userAddress[i];
                Account currentAcct = newMap.get(usAddress.UserAccount__c);
                Account oldAcct = oldMap.get(currentAcct.Id);  

                Boolean ischangePhone = (currentAcct.Phone != null && currentAcct.Phone != oldAcct.Phone && currentAcct.Phone != usAddress.Phone__c);
                Boolean ischangePersonPhone = (currentAcct.PersonMobilePhone != null && currentAcct.PersonMobilePhone != oldAcct.PersonMobilePhone && 
                                                currentAcct.PersonMobilePhone != usAddress.PersonMobilePhone__c);

                if( currentAcct.Respond_Date__c == System.today() ) usAddress.Respond_Date__c =  currentAcct.Respond_Date__c;
                if( ischangePhone && ischangePersonPhone ) {

                    usAddress.Phone__c = currentAcct.Phone;    
                    usAddress.PersonMobilePhone__c = currentAcct.PersonMobilePhone;
                    userAddressListToUpdate.add(usAddress);  
                }else if( ischangePhone ) {

                    usAddress.Phone__c = currentAcct.Phone;    
                    userAddressListToUpdate.add(usAddress); 
                }else if( ischangePersonPhone ) {

                    usAddress.PersonMobilePhone__c = currentAcct.PersonMobilePhone;
                    userAddressListToUpdate.add(usAddress); 
                }                  
            }
            if(!userAddressListToUpdate.isEmpty()) {
                TriggerHandler.bypass('UserAddressTrigger');
                    update userAddressListToUpdate; 
                TriggerHandler.clearBypass('UserAddressTrigger');
            }
        }
    }

    /*
     * This method is responsible to update  Opportunity.Ownerid
     * 
     * This method is run after Update.
     * 
     * This method is used in:
     * AccountTrigger
     * 
     * @param Map New Accounts, Map Old Accounts
     **/
    public static void opportunityonChangeOWner(Map<Id,Account> newMap, Map<Id,Account> oldMap) {
        List<Opportunity> opportunities = [ SELECT id,Ownerid,Accountid,StageName 
                                            FROM Opportunity 
                                            WHERE Accountid in :newMap.keyset()];
        List<Opportunity> opports = new List<Opportunity>(); 

        integer opportunitiesLength = opportunities.size();
        for (Integer i = 0; i < opportunitiesLength; i++) 
        {
            Opportunity opty = opportunities[i];
            if(opty.StageName <> 'Closed Lost'){
                if(newMap.get(opty.Accountid).Ownerid <> oldMap.get(opty.Accountid).Ownerid){
                    opty.Ownerid=newMap.get(opty.Accountid).Ownerid;
                    opports.add(opty);
                }
            }
        }
        if(!opports.isEmpty()){
            update opports;
        }
    }

    /*
     * This method is responsible to change values account fields
     * 
     * This method is run before Update.
     * 
     * This method is used in:
     * AccountTrigger
     * 
     * @param Account List
     **/
    public static void setAccounts(List<Account> accounts,Map<Id,Account> oldAccMap) {
        
        integer accountsLength = accounts.size();
        for (Integer i = 0; i < accountsLength; i++) {
            Account acct = accounts[i];
            Account oldAcct = oldAccMap.get(acct.id);

            AddDoNotCallDateStamp(acct);
            
            // consent Info
            if( acct.Verbal_Consent__c != oldAcct.Verbal_Consent__c ) setConsentInfo(acct);

            // Canvasser Info
            if( acct.Canvasser_Disposition__c != oldAcct.Canvasser_Disposition__c ) setCanvasserInfo(acct);

            // location changes manually in salesforce map    
            if( AccountEval.mapLayerChangeLocation(acct, oldAcct) ) setMapLocationInfo(acct);
            
        } 
    }

    /*
     * This method is responsible to change Accouunt.Do_Not_Call_Date_Stamp__c 
     *  
     * This method is used in:
     * setAccounts - This class
     * 
     * @param Account record
     **/
    private static void AddDoNotCallDateStamp(Account accts) {
        
        //if Do Not Call is checked, set the Do Not Call Date Stamp to todays date and time, else keep blank
        //As per latest requirement from cody, if donotcall is true and timestamp is empty then only fill the current day
        if(accts.PersonDoNotCall == True && accts.Do_Not_Call_Date_Stamp__c == null) {
            
            accts.Do_Not_Call_Date_Stamp__c = System.Now();
        }
        else if(accts.PersonDoNotCall == False) {
            
            accts.Do_Not_Call_Date_Stamp__c = null;
        }       
    }

    /**
     * @author Jull Quintero D - 06-09-2021
     * This method is responsible to set consent info 
     *  
     * This method is used in:
     * setAccounts - This class
     * 
     * @param Account(Account)
     **/
    private static void setConsentInfo(Account account) {
        account.User_Who_Captured_Verbal_Consent__c = userInfo.getUserId();
        account.Verbal_Consent_Date_Stamp__c = Datetime.now();
        account.Consent_Captured_Date__c = Date.today();
    }

    /**
     * @author Jull Quintero D - 06-24-2021
     * This method is responsible to set canvasser info 
     *  
     * This method is used in:
     * setAccounts - This class
     * 
     * @param Account(Account)
     **/
    private static void setCanvasserInfo(Account account) {
        account.Last_Canvasser_Attempt__c = Datetime.now();
        account.Dispositioned_By__c = userInfo.getUserId();
    }

    /**
     * @author Jull Quintero D - 07-08-2021
     * This method is responsible to set location info of changend latitude and longitude in salesforce map
     *  
     * This method is used in:
     * setAccounts - This class
     * 
     * @param Account(Account)
     **/
    private static void setMapLocationInfo(Account account) {
        System.debug('>> Account locationChange is Manual ');
        account.Geocode_Accuracy__c = 'Manual';
        account.Location_Updated__c = System.Now();
        account.Location_updated_by__c = UserInfo.getUserId();
    }
}