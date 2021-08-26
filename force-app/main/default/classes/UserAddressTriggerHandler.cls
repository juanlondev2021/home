/* Class Name : UserAddressTriggerHandler
*  Created By : Sankar Marappan
*  Created Date : 18/04/2016
*  Author : MST
*  Description : This handler is used by the UserAddress trigger. Once the user address get respond date/house hold respond date then we need to set driver lead status as date for the corresponding delivery with status as Hung. 
Update the house hold respond date on the user address with address type as primary owner only if the another user
called in from the same address.
modifications
William Aldana - 09/22/2020 - New Trigger framework implementation
William Aldana - 10/11/2020 - Add Address to userAddress Automation
*/
public class UserAddressTriggerHandler extends TriggerHandler{
    
    // String currUserId = UserInfo.getUserId().subString(0,15);
    // String integrationUserId = label.Middleware_User_Id;
    Map<Id,User_Address__c> accountWithUserAddress = new Map<Id,User_Address__c>(); 
    Map<Id,Id> userAddressMap = new Map<Id,Id>();
    Set<Id> userAddressOBCDelete = New Set<Id>();
    Set<Id> userAddressOBC = New Set<Id>();

    public override void beforeinsert() {
        List<User_Address__c> newUsersAdd = (List<User_Address__c>)trigger.new;
        UserAdressImport.execute(newUsersAdd, Trigger.isInsert && Trigger.isBefore);
        for(User_Address__c currUserAddress : newUsersAdd){  
            //if the user address get inserted with phone or mobilephone then populate respondate 
            //And also, if the userAddress phone or mobilePhone is different than the corresponding account on insertion, then update that account
            if((currUserAddress.phone__c != null || currUserAddress.personmobilephone__c != null)){
                currUserAddress.Respond_Date__c = System.today();
                currUserAddress.Household_respond_date__c = System.today();
                currUserAddress.Respond_Date_Created_by__c = userinfo.getuserid();
            } 
        } 

        UserAddressTriggerHelper.createUserAddressBI(Trigger.new);
    }

    public override void afterinsert(){
        List<User_Address__c> newUsersAdd = (List<User_Address__c>)trigger.new;
        for(User_Address__c currUserAddress : newUsersAdd){             
            if(currUserAddress.User_Address_Type__c != 'Primary Owner' && (currUserAddress.phone__c != null || currUserAddress.personmobilephone__c != null)
                && currUserAddress.Active__c) {                   
                   userAddressMap.put(currUserAddress.Id,currUserAddress.Address__c);
               }
            if(currUserAddress.Respond_Date__c != null)
                accountWithUserAddress.put(currUserAddress.UserAccount__c,currUserAddress);
        }
        
        if(!userAddressMap.isEmpty()){
            UserAddressTriggerHelper.updateHouseholdDate(userAddressMap);
        }

        if(!accountWithUserAddress.isEmpty()){
            UserAddressTriggerHelper.updateAccountWithUserAddressPhoneDetails(accountWithUserAddress);
        } 
        
        UserAddressTriggerHelper.updateRecordsOnAccount((Map<Id,User_Address__c>)Trigger.newMap, (Map<Id,User_Address__c>)Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);

        UserAddressTriggerHelper.createSalesRabbitLeads(Trigger.new);
        UserAddressTriggerHelper.createSMS((List<User_Address__c>)Trigger.new, (Map<Id,User_Address__c>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);    
    }

    public override void afterupdate(){
        List<User_Address__c> newUsersAdd = (List<User_Address__c>)Trigger.new;
        Map<id, User_Address__c> oldMap = (Map<id, User_Address__c>)Trigger.oldMap;
        Set<Id> userAddressIds = new Set<Id>();

        UserAddressTriggerHelper.updateRecordsOnAccount((Map<Id,User_Address__c>)Trigger.newMap, (Map<Id,User_Address__c>)Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);

        for(User_Address__c currUserAddress : newUsersAdd){
            //Added on August 2 OBC Project.  MSTSolutions.
            if(oldMap.get(currUserAddress.id).Respond_date__c == null && currUserAddress.Respond_date__c != null){
                userAddressOBC.add(currUserAddress.Id);
            }

            if((oldMap.get(currUserAddress.id).Respond_date__c != null)
               && (currUserAddress.Respond_date__c == null)
               && (currUserAddress.PersonMobilePhone__c == null)
               && (currUserAddress.phone__c == null)){
                   system.debug('Respond Date Deleted');
                   userAddressOBCDelete.add(currUserAddress.Id);
               }else if((oldMap.get(currUserAddress.id).PersonMobilePhone__c != null)
               && (currUserAddress.Respond_date__c == null)
               && (currUserAddress.PersonMobilePhone__c == null)
               && (currUserAddress.phone__c == null)){
                   system.debug('Mobile Deleted');
                   userAddressOBCDelete.add(currUserAddress.Id);
               }else if((oldMap.get(currUserAddress.id).Phone__c != null)
               && (currUserAddress.Respond_date__c == null)
               && (currUserAddress.PersonMobilePhone__c == null)
               && (currUserAddress.phone__c == null)){
                   system.debug('Phone Deleted');
                   userAddressOBCDelete.add(currUserAddress.Id);
               }

            //When userAddress phone or mobilePhone got value first time then update driver lead status on corresponding delivery.
            //And if the userAddress phone or mobilePhone is different than the corresponding account on updation, then update that account
            if(((oldMap.get(currUserAddress.id).phone__c == null && currUserAddress.phone__c != null ) || (oldMap.get(currUserAddress.id).personmobilephone__c == null  && currUserAddress.personmobilephone__c != null )  
                && (oldMap.get(currUserAddress.id).Respond_date__c == null && currUserAddress.Respond_date__c != null)) || (oldMap.get(currUserAddress.id).Household_respond_date__c == null && currUserAddress.Household_respond_date__c != null)){
                    userAddressIds.add(currUserAddress.id);
                }
            // To check the same address is available or not.If so then update the household respond date
            // in the primary user address 
            // if(currUserAddress.User_Address_Type__c != 'Primary Owner' && currUserAddress.Active__c && ((trigger.oldMap.get(currUserAddress.id).phone__c == Null && currUserAddress.phone__c != Null ) || (trigger.oldMap.get(currUserAddress.id).personmobilephone__c == Null && currUserAddress.personmobilephone__c != Null))) {
            if(currUserAddress.User_Address_Type__c != null && currUserAddress.Active__c && ((oldMap.get(currUserAddress.id).phone__c == Null && currUserAddress.phone__c != null ) || (oldMap.get(currUserAddress.id).personmobilephone__c == null && currUserAddress.personmobilephone__c != null))) {
                userAddressMap.put(currUserAddress.Id,currUserAddress.Address__c);
            }  
            if(oldMap.get(currUserAddress.id).Respond_date__c == null && currUserAddress.Respond_date__c != null){
                accountWithUserAddress.put(currUserAddress.UserAccount__c,currUserAddress);
            }
        }
        
        //Hot Lead Inventory creation handler class invoking.
        nuHome_HotleadInventory_Handler.createAllInventory((Map<Id,User_Address__c>)Trigger.NewMap, (Map<Id,User_Address__c>)Trigger.oldMap);

        if(!userAddressIds.isEmpty()){
            UserAddressTriggerHelper.updateDriverLeadStatus(userAddressIds);
        }  
        
        if(!userAddressMap.isEmpty()){
            UserAddressTriggerHelper.updateHouseholdDate(userAddressMap);
        }

        if(!accountWithUserAddress.isEmpty()){
            UserAddressTriggerHelper.updateAccountWithUserAddressPhoneDetails(accountWithUserAddress);
        }

        if(!userAddressOBCDelete.isEmpty()){
            UserAddressTriggerHelper.deleteObcMembers(userAddressOBCDelete);
        }        

        if(!userAddressOBC.isEmpty()){
            UserAddressTriggerHelper.createObcMembers(userAddressOBC);
            UserAddressTriggerHelper.DeliveryUpdate(userAddressOBC);
        }
        UserAddressTriggerHelper.createSMS((List<User_Address__c>)Trigger.new, (Map<Id,User_Address__c>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);    
    }

    public override void beforeupdate(){
        List<User_Address__c> newUsersAdd = (List<User_Address__c>)Trigger.new;
        Map<id, User_Address__c> oldMap = (Map<id, User_Address__c>)Trigger.oldMap;
        for(User_Address__c currUserAddress : newUsersAdd){ 
            if( currUserAddress.Respond_Date__c == null && 
                ( currUserAddress.Phone__c != null &&  currUserAddress.Phone__c != oldMap.get(currUserAddress.id).Phone__c) || 
                ( currUserAddress.personmobilephone__c != null && currUserAddress.personmobilephone__c != oldMap.get(currUserAddress.id).personmobilephone__c) )
                    {
                        currUserAddress.Respond_Date__c = System.today(); 
                        currUserAddress.Household_respond_date__c = System.today();
                        currUserAddress.Respond_Date_Created_by__c = userinfo.getuserid();
                    }

                // COnsent Inbound - generate Verificarion code 
                if(currUserAddress.Inbound_Verification_Code_Date__c != null && currUserAddress.Inbound_Verification_Code_Date__c != oldMap.get(currUserAddress.id).Inbound_Verification_Code_Date__c) 
                {
                    Integer randomNumber = Math.round((Math.random() * (900000) + 100000));
                    currUserAddress.Inbound_Verification_Code__c = String.valueOf(randomNumber);
                }                    
        }
    }
}