/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-01-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Test Class:          UserAddressTriggerTest 
 * Ver   Date         Author           Modification
 * 1.0   09-22-2020   William Aldana   Initial Version
 * 2.0   09-24-2020   William Aldana   Moved Process Builder Functions to trigger
 * 2.1   10-01-2020   William Aldana   Added Respond_Date__c value at phone update on updateRecordsOnAccount method
**/
public class UserAddressTriggerHelper {

    /**
    * @description 
    * @author William Aldana | 09-22-2020 
    * @param userAddresIds 
    **/
    public static void updateDriverLeadStatus(Set<Id> userAddresIds){   
        Map<Id,Delivery_Object__c> toUpdateDeliveries = new Map<Id,Delivery_Object__c>();        
        Date respondDate;
        for(Delivery_Object__c currDelivery : [SELECT id,Driver_Lead_Status__c,Hung_Status__c,User_Address__r.Household_respond_date__c,User_Address__c,Delivery_Date__c,Person_Account__c,User_Address__r.Respond_date__c FROM Delivery_Object__c WHERE User_Address__c IN: userAddresIds AND Delivery_Date__c != null AND Hung_Status__c = 'Hung' ORDER BY createdDate DESC]){           
            if(!toUpdateDeliveries.containsKey(currDelivery.User_Address__c)){
                //Here we can make sure that, respond date always greater then or equal the delivery date or not
                //System.debug('@@@DeliveryDate: '+currDelivery.Delivery_Date__c.date() +' <= '+ currDelivery.User_Address__r.Respond_date__c+'RespondDate');
                respondDate = currDelivery.User_Address__r.Respond_date__c != null ? currDelivery.User_Address__r.Respond_date__c : currDelivery.User_Address__r.Household_respond_date__c;
                
                if(respondDate != null && currDelivery.Delivery_Date__c.Date() <= respondDate){
                    toUpdateDeliveries.put(currDelivery.User_Address__c,new Delivery_Object__c(id = currDelivery.id,Driver_Lead_Status__c = 'Data'));
                }
            }
        }
       // System.debug('deliveriesWithDriverLeadStatus+++++++'+toUpdateDeliveries);
        try{
            if(!toUpdateDeliveries.isEmpty()){
                update toUpdateDeliveries.values();
            }
        }
        Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }
    }

    /**
    * @description 
    * @author William Aldana | 09-22-2020 
    * @param userAddressMap 
    **/
    public static void updateHouseholdDate(Map<Id,Id> userAddressMap){
        System.debug('House Hold Respond Date Population');
        Map<Id,User_Address__c> updatePrimaryUserAddress = new Map<Id,User_Address__c>(); 
        Set<Id> addressIds = new Set<Id>();
        for(User_Address__c userAddress : [SELECT id,User_address_Type__c,Household_respond_date__c,Address__c,(SELECT id FROM Deliveries_Object__r) FROM User_Address__c WHERE Address__c IN: userAddressMap.values() AND Id NOT IN : userAddressMap.keyset() AND Respond_Date__c = null 
                                           AND Active__c = true AND Household_respond_date__c = null ORDER BY Createddate DESC]){
            if(!userAddress.Deliveries_Object__r.isEmpty() && userAddress.User_Address_Type__c == 'Primary Owner'){
                if(!updatePrimaryUserAddress.containsKey(userAddress.id)){
                    //primary household respond date population when one of relative members calls in                                                  
                    updatePrimaryUserAddress.put(userAddress.id,new User_Address__c(Id = userAddress.id,Household_respond_date__c = System.Today()));
                }
            }
            else if(userAddress.User_Address_Type__c != 'Primary Owner'){//secondary owner with same address
                updatePrimaryUserAddress.put(userAddress.Id,new User_Address__c(Id = userAddress.Id,Household_respond_date__c = System.Today()));
            }
        }
        try{
            if(!updatePrimaryUserAddress.isEmpty()){
                System.debug('&&&&&&&&&&&&&'+updatePrimaryUserAddress.values());
                TriggerHandler.bypass('UserAddressTrigger');
                    update updatePrimaryUserAddress.values();
                TriggerHandler.clearBypass('UserAddressTrigger');
            }
        }
        Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }
    } 
    
    /**
    * @description 
    * @author William Aldana | 09-22-2020 
    * @param accountWithUserAddress 
    **/
    public static void updateAccountWithUserAddressPhoneDetails(Map<Id,User_Address__c> accountWithUserAddress){
        Map<Id,Account> accountMap = new  Map<Id,Account>([SELECT ID,phone,personMobilePhone FROM Account where id in : accountWithUserAddress.keySet()]);
        List<Account> accountList = new List<Account>();
        if(!accountMap.isEmpty()){       
            for(Account currAccount : accountMap.values()){
                if(currAccount.phone != accountWithUserAddress.get(currAccount.id).phone__c && currAccount.personMobilePhone != accountWithUserAddress.get(currAccount.id).personMobilePhone__c ){
                    accountList.add(new Account(id = currAccount.id,phone = accountWithUserAddress.get(currAccount.id).phone__c,personMobilePhone = accountWithUserAddress.get(currAccount.id).personMobilePhone__c));    
                }else if(currAccount.phone != accountWithUserAddress.get(currAccount.id).phone__c){
                    accountList.add(new Account(id = currAccount.id,phone = accountWithUserAddress.get(currAccount.id).phone__c));       
                }else if(currAccount.personMobilePhone != accountWithUserAddress.get(currAccount.id).personMobilePhone__c ){
                    accountList.add(new Account(id = currAccount.id,personMobilePhone = accountWithUserAddress.get(currAccount.id).personMobilePhone__c));    
                }
            }
        } 
        if(!accountList.isEmpty()){
            try{
                upsert accountList;
            }Catch(Exception ex){
                System.debug('Exception +++'+ex.getMessage());
            }
        }
    }
    
    //Create obc members records based on the active industries.
    public static void createObcMembers(Set<Id> userAddressIds){
        Map<String, OB_Campaign_Member__c> listObc = New Map<String, OB_Campaign_Member__c>();
        Map<Id,Industry__c> industryMap = New Map<Id,Industry__c>([SELECT ID FROM Industry__c WHERE OBC_Active__c = True AND Active__c = True]);
        Map<Id,User_Address__c> userAddresses = New Map<Id,User_Address__c>([SELECT Id,UserAccount__c,Address__r.Unique_Key__c FROM User_Address__c WHERE Id IN :userAddressIds]); 
        if(!industryMap.isEmpty()){
            for(User_Address__c usrAdr:userAddresses.values()){
                for(Industry__c industryIns:industryMap.values()){
                    OB_Campaign_Member__c obmem = New OB_Campaign_Member__c();
                    obmem.DupCatcher__c = '('+usrAdr.UserAccount__c+')_'+industryIns.Id+'_'+usrAdr.Address__r.Unique_Key__c;
                    if(listObc.get(obmem.DupCatcher__c) == null){
                        obmem.User_Address__c = usrAdr.Id;
                        obmem.AccountName__c = usrAdr.UserAccount__c;
                        obmem.Industry__c = industryIns.Id;
                        listObc.put(obmem.DupCatcher__c, obmem);
                    }
                }
            }
        }
        
        if(!listObc.isEmpty())
            Insert listObc.values();
    }
    
    //Delete obc members records when the respond date, phone and mobile cleared in user address.
    public static void deleteObcMembers(Set<Id> userAddressIds){
        List<OB_Campaign_Member__c> listObcDelete = New List<OB_Campaign_Member__c>([SELECT Id FROM OB_Campaign_Member__c WHERE User_Address__c IN :userAddressIds]);
        if(!listObcDelete.isEmpty())
            Delete listObcDelete;
    }
    
    //MST added for Delivery 2 object update 02/11
    public static void DeliveryUpdate(Set<Id> setUseraddress){
        List<Delivery_Object__c> DeliveryList = new List<Delivery_Object__c>();
        for(Delivery_Object__c Delivery : [SELECT Id,Name,Parent_Gift_Card_Order__c,Hung_Status__c FROM Delivery_Object__c WHERE
                                           User_Address__c IN :setUseraddress AND Parent_Gift_Card_Order__r.Name ='Cheetah Gift Card Order' AND Hung_Status__c ='Sent To Cheetah' AND Name = '2']){
            Delivery_Object__c deliveryIns = New Delivery_Object__c();
            deliveryIns.Id = Delivery.Id;
            deliveryIns.Hung_Status__c = 'Remove: Responded';
            DeliveryList.add(deliveryIns);
        }

        if(!DeliveryList.isEmpty())
            update DeliveryList;
    }

    /**
    * @description moved from User Address PB
    * Email, Phone, County
    * @author William Aldana | 09-24-2020 
    * @param newMap 
    * @param newMap 
    * @param isCreate 
    * @param isUpdate 
    **/
    public static void updateRecordsOnAccount(Map<Id,User_Address__c> newMap, Map<Id,User_Address__c> oldMap, Boolean isCreate, Boolean isUpdate){
        Integer newMapSize = newMap.size();
        List<User_Address__c> newAddList = newMap.values();
        Set<id> relatedAccountsId = new Set<id>();
        Set<id> relatedAddressIds = new Set<id>();
        for (Integer i = 0; i < newMapSize; i++) {
            if(newAddList[i].UserAccount__c != null){ relatedAccountsId.add(newAddList[i].UserAccount__c); }
            if(newAddList[i].Address__c != null){ relatedAddressIds.add(newAddList[i].Address__c); }
        }
        Map<Id, Account> relatedAccounts = new Map<Id, Account>([Select Id, Validate_Email__c, Phone,PersonMobilePhone, County__c, PersonEmail, Respond_Date__c from Account where id in :relatedAccountsId]);
        Map<Id, Address__c> relatedAddressList = new Map<Id, Address__c>([Select id, County__c from Address__c where id in :relatedAddressIds]);
        Map<Id, Account> updatedAccounts = new Map<Id, Account>();
        for (Integer i = 0; i < newMapSize; i++) {
            User_Address__c newAdd = newAddList[i]; 
            //email Reviews 
            // if is new or email was changed
            if(newAdd.UserAccount__c != null && (isCreate || newAdd.Email__c != oldMap.get(newAdd.id).Email__c) && newAdd.UserAccount__c != null && newAdd.Email__c != null 
                && (relatedAccounts.get(newAdd.UserAccount__c).Validate_Email__c == null || relatedAccounts.get(newAdd.UserAccount__c).Validate_Email__c == 'Valid') 
                && (newAdd.fEmail__c == null || newAdd.fEmail__c != newAdd.Email__c)
                && (newAdd.Email__c != relatedAccounts.get(newAdd.UserAccount__c).PersonEmail)){
                
                // create update record if not exists
                if(updatedAccounts.get(newAdd.UserAccount__c) == null) { Account acc = new Account(); acc.Id = newAdd.UserAccount__c; updatedAccounts.put(newAdd.UserAccount__c, acc); }
                updatedAccounts.get(newAdd.UserAccount__c).PersonEmail = newAdd.Email__c;
            }

            //Phone Reviews
            // if is new or phone was changed
            if(newAdd.UserAccount__c != null && (isCreate || newAdd.Phone__c != oldMap.get(newAdd.id).Phone__c) && newAdd.Phone__c != relatedAccounts.get(newAdd.UserAccount__c).Phone){
                // create update record if not exists
                if(updatedAccounts.get(newAdd.UserAccount__c) == null) { Account acc = new Account(); acc.Id = newAdd.UserAccount__c; updatedAccounts.put(newAdd.UserAccount__c, acc); }
                updatedAccounts.get(newAdd.UserAccount__c).Phone = newAdd.Phone__c;
                if(isCreate || newAdd.Respond_Date__c == System.today()) updatedAccounts.get(newAdd.UserAccount__c).Respond_Date__c = newAdd.Respond_Date__c;
            }

            // if is new or PersonMobilePhone was changed
            if(newAdd.UserAccount__c != null && (isCreate || newAdd.PersonMobilePhone__c != oldMap.get(newAdd.id).PersonMobilePhone__c) && newAdd.PersonMobilePhone__c != relatedAccounts.get(newAdd.UserAccount__c).PersonMobilePhone){
                // create update record if not exists
                if(updatedAccounts.get(newAdd.UserAccount__c) == null) { Account acc = new Account(); acc.Id = newAdd.UserAccount__c; updatedAccounts.put(newAdd.UserAccount__c, acc); }
                updatedAccounts.get(newAdd.UserAccount__c).PersonMobilePhone = newAdd.PersonMobilePhone__c;
                if(isCreate || newAdd.Respond_Date__c == System.today()) updatedAccounts.get(newAdd.UserAccount__c).Respond_Date__c = newAdd.Respond_Date__c;
            }

            //County Review
            if(newAdd.UserAccount__c != null && newAdd.Address__c != null && relatedAddressList.get(newAdd.Address__c).County__c != null && (relatedAccounts.get(newAdd.UserAccount__c).County__c == null || relatedAccounts.get(newAdd.UserAccount__c).County__c != relatedAddressList.get(newAdd.Address__c).County__c)){
                // create update record if not exists
                if(updatedAccounts.get(newAdd.UserAccount__c) == null) { Account acc = new Account(); acc.Id = newAdd.UserAccount__c; updatedAccounts.put(newAdd.UserAccount__c, acc); }
                updatedAccounts.get(newAdd.UserAccount__c).County__c = relatedAddressList.get(newAdd.Address__c).County__c;
            }

        }

        if(!updatedAccounts.isEmpty()){
            TriggerHandler.bypass('AccountTrigger');
            update updatedAccounts.values();
            TriggerHandler.clearBypass('AccountTrigger');
        }
    }

    /**
    * @description trigger responsible to Create a lead in SalesRabbit after to create a User Address in SalesForce.
    * @author jorge Martinez | 10/08/2018
    **/
    public static void createSalesRabbitLeads(List<User_Address__c> newValues){
        List<salesRabbitSchedule__c> settingList = new List<salesRabbitSchedule__c>();
        settingList = [select Id,
                                minSalePrice__c,
                                maxSalePrice__c,
                                token__c
                        from salesRabbitSchedule__c];
        //salesRabbitSchedule = settingList[0];
        for(User_Address__c use : newValues){

            String [] sObjectFields = new String[]{'fFirstName__c','fLastName__c','Phone__c','PersonMobilePhone__c','fAddress__c','fCity__c','fState__c','fzipCode__c','status__c','fEmail__c'};
            String [] apiFields = new String[]{'firstName','lastName','phonePrimary','phoneAlternate','street1','city','state','zip','status','email' };
            Personnel__c[] per =[select Id,salesRabbitUserId__c, SF_User__c from Personnel__c where SF_User__c = :use.CreatedById limit 1];
            if(!per.isEmpty()) {
                Integer i = 0;
                Map<String, String> mapFields = new Map<String, String>();
                
                for(String field : sObjectFields){
                    if(String.valueOf(use.get(field)) != null){
                        mapFields.put(apiFields[i], String.valueOf(use.get(field)));
                    }
                    i++;
                }
                String json = '{"data": {"userId":'+per[0].salesRabbitUserId__c+',';
                for(String key : mapFields.keySet()){
                    json += '"'+key+'":"' +mapFields.get(key)+'",';
                }
                json +='"customFields": {'+
                    '"salesForceId": "'+use.Id+'",'+
                    '"confirmationNumber": "'+use.Confirmation_Number__c+'"'+
                    '}'+
                    '}'+
                    '}';

                if(!settingList.isEmpty() && !System.isBatch()) {
                    salesRabbitSchedule__c salesRabbitSchedule = settingList[0];
                        if(use.Sales_Price__c > salesRabbitSchedule.minSalePrice__c && use.Sales_Price__c < salesRabbitSchedule.maxSalePrice__c){
                        DiacoSalesRabbitIntegration.createLeadSR(salesRabbitSchedule.token__c, json, use.Id);
                    } 
                }
            }
        }
    }

    /**
    * @description trigger responsible of put the value of field Status__C before insert.
    * @author Jorge Martinez (JM) | 17/08/2018  
    * @param newValues 
    **/
    public static void createUserAddressBI(List<User_Address__c> newValues){
        for(User_Address__c newUser : newValues) {
            newUser.status__C = 'New Lead';
        } 
    }

    /**
    * @description create configured sms
    * @author Jull Quintero | 03-10-2021 
    * @param AppointIds 
    **/
    public static void createSMS(User_Address__c[] userAddress, Map<Id, User_Address__c> oldMap, Boolean isInsert, Boolean isUpdate) {
        new CreateSMS(userAddress, oldMap, isInsert, isUpdate);
    }
}