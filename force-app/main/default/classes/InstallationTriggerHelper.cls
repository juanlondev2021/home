/*
* Diaco
* @author             Jull Quintero Daza
* Project:            Installation Trigger
* TestClass:          InstallationTriggerTest
* Description:        Helper
*
* Changes (Version)
* _________________________________________
*            No.        Date            Author                    Description
*            ____    __________        __________________      _____________________________________
* @version    1.0    11/09/2020        Jull Quintero D         Initial implementation of the class.
* @version	  1.0    18/09/2020        Fabian Pineda (FP)      Added updateAccountStatus method.  
**/
public class InstallationTriggerHelper {
    /** Map of Home_Services__c containing record type information. Used by updateAccountStatus(). Made static for performance reasons. */
    private static Map<Id, Schema.RecordTypeInfo> homeServiceRecordTypeMap;
    
    /** List of accounts modified in the before update trigger. (updateAccountStatus) */
    private static Set<Account> modifiedAccounts;
    
    /**
     * @author Jull Quintero D | 20/09/2020  
     * @Description
     * Is responsible to create Install_Item__c for each Line_item__c
     * Is run after Insert.
     * Is used in: IntallationTrigger
     * @param 
     * List Installation__c
     **/
    public static void installItems(List<Installation__c> installations) {        
        Map<Id,Id> instAndHsMap = new Map<Id,Id>();
        List<Install_Item__c> insItemTask = new List<Install_Item__c>();
        
        Integer installationsLength = installations.size();
        for (Integer i = 0; i < installationsLength; i++) 
        {
            if( !String.isEmpty(installations[i].Home_Service__c) ) {
                
                instAndHsMap.put(installations[i].Id,installations[i].Home_Service__c);
            }
        }
        
        List<Home_Services__c> homeServices = [SELECT Id, 
                                               (SELECT Id, Name, Cost__c, Active__c, Cost_of_Goods__c  
                                                FROM Line_Items__r) 
                                               FROM Home_Services__c 
                                               WHERE Id IN:instAndHsMap.values() AND Id IN (SELECT Home_Service__c FROM Line_Item__c)];
        
        Map<Id,Home_Services__c> homeServicesMap = new Map<Id,Home_Services__c>( homeServices );
        Set<Id> instIds = instAndHsMap.keySet();
        for (Id instId : instIds) 
        {
            Id hsId =  instAndHsMap.get(instId);
            Home_Services__c homeService = homeServicesMap.get(hsId);
            if( homeService != null ) {
                
                List<Line_Item__c> lineItems = homeService.Line_Items__r;                
                Integer lineItemsLength = lineItems.Size();
                for (Integer i = 0; i < lineItemsLength; i++) 
                {
                    Line_Item__c lItem = lineItems[i];
                    if( lItem.Active__c ) {
                        
                        insItemTask.add(new Install_Item__c(
                            Name            = lItem.Name,
                            Installation__c = instId,
                            Bid_Amount__c   = lItem.Cost__c + lItem.Cost_of_Goods__c,
                            Line_Item__c    = lItem.Id
                        ));
                    }
                }
            }
            
        }
        if ( !insItemTask.isEmpty() ) {
            insert insItemTask;
        }
    }
    
    /**
     * Updates the trigger's Home Service's Account's status.
     * 
     * This method is run before and after updates.
     * 
     * The before part of this method modifies Accounts as needed, adding them to a static
     * list of modified Accounts, but doesn't commit changes to the database.
     * 
     * The after part of this method simply uses a DML update on the list of modified Accounts
     * created in the before trigger.
     */
    public static void updateAccountStatus(List<Installation__c> newInstallations, Map<Id, Installation__c> oldInstallations, Boolean isAfterTrigger) {
        // AFTER UPDATE
        // The following code is run only after updates.
        if (isAfterTrigger) {
            System.debug('INSTALLATION AFTER TRIGGER'); // TODO: remove this line.
            System.debug(modifiedAccounts); // TODO: remove this line.
            
            if (modifiedAccounts != null && !modifiedAccounts.isEmpty()) {
                update new List<Account>(modifiedAccounts);
            }
            
            System.debug('END'); // TODO: remove this line.
            
            return; // Done. Exit the AFTER trigger.
        } 
        
        // ==============================================
        // BEFORE UPDATE
        // The following code is only run before updates.
        
        // Initialize the Map containing Home_Services__c's record type information only if it hasn't been initialized yet.
        // The reason it is a static variable is because this trigger may run more than once within the sale Apex transaction
        // and describe operations are generally expensive. Using a static variable avoids several unnecessary describes.
        if (homeServiceRecordTypeMap == null) {
            homeServiceRecordTypeMap = Home_Services__c.sObjectType.getDescribe().getRecordTypeInfosById();
        }
        
        System.debug('INSTALLATION BEFORE TRIGGER'); // TODO: remove this line.
        
        // Make a list of all Home_Services__c associated to the Installations.
        Set<Id> installationHSIds = new Set<Id>();
        
        // Populate the Home_Services__c ID set, specifically ignoring null values.
        for (Installation__c i: newInstallations) {
            if (i.Home_Service__c != null) {
                installationHSIds.add(i.Home_Service__c);
            }
        }
        
        System.debug(installationHSIds); // TODO: remove this line.
        
        // Fetch all Home_Services__c matching the IDs in the Home_Services__c ID set.
        List<Home_Services__c> homeServices = [SELECT Installation__c, Account__c, Appt_Sale_Status__c, Home_Services_Status__c, RecordTypeId FROM Home_Services__c WHERE Id IN :installationHSIds];
        
        System.debug(homeServices); // TODO: remove this line.
        
        // Make a map from Installation__c IDs to their corresponding Home_Services__c's indices in the homeServices list.
        Map<Id, Integer> installationToHSIndexMap = new Map<Id, Integer>();
        
        // Populate the above map, ignoring any Home_Services__c whose Installation__c's IDs don't match the current Installation__c's IDs.
        for (Installation__c i: newInstallations) {
            if (i.Home_Service__c == null) {
                // Home_Service__c is null, ignore this Installation__c.
                continue;
            }
            
            for (Integer j = 0; j < homeServices.size(); j++) {
                // Add this Home_Services__c's index to the map if and only if IDs match, and only if the Home_Services__c's Installation__c's value (ID) matches this Installation__c's ID.
                if (i.Home_Service__c == homeServices[j].Id && i.Id == homeServices[j].Installation__c) {
                    installationToHSIndexMap.put(i.Id, j);
                    break;
                }
            }
        }
        
        System.debug(installationToHSIndexMap); // TODO: remove this line.
        
        // Make a list of Account IDs referenced by Home_Services__c, then fetch all Accounts whose IDs match.
        Set<Id> hsAccountIDs = new Set<Id>();
        
        for (Home_Services__c hs: homeServices) {
            if (hs.Account__c != null) {
                hsAccountIDs.add(hs.Account__c);
            }
        }
        
        System.debug(hsAccountIDs); // TODO: remove this line.
        
        // Fetch all accounts with IDs matching the ones in the above set in a single query.
        List<Account> accounts = [
            SELECT 
            // Home Service status fields
            Carpet_Tile_Cleaning_Status__c,
            Garage_Doors_Status__c,
            Home_Automation_Status__c,
            HVAC_Status__c,
            Internet_Cable_Satellite_Status__c,
            Lock_Smith_Status__c,
            Maid_Service_Status__c,
            Pest_Control_Status__c,
            Pool_Maintenance_Status__c,
            Remodel_Status__c,
            Solar_Status__c,
            Water_Status__c
            
            FROM
            Account
            
            WHERE
            Id IN :hsAccountIDs
        ];
        
        System.debug(accounts); // TODO: remove this line.
        
        // Make a map from Home_Services__c IDs to their corresponding Account's indices in the accounts list.
        Map<Id, Integer> hsToAccountIndexMap = new Map<Id, Integer>();
        
        // Populate the above map, ignoring any Home_Services__c whose Installation__c's IDs don't match the current Installation__c's IDs.
        for (Home_Services__c hs: homeServices) {
            if (hs.Account__c == null) {
                // Account__c is null, ignore this Home_Services__c.
                continue;
            }
            
            for (Integer i = 0; i < accounts.size(); i++) {
                // Add this Account's index to the map if and only if IDs match.
                if (hs.Account__c == accounts[i].Id) {
                    hsToAccountIndexMap.put(hs.Id, i);
                    break;
                }
            }
        }
        
        System.debug(hsToAccountIndexMap); // TODO: remove this line.
        
        // Make a set of modified Account indices.
        // Accounts modified through this trigger must have their indices in the 'accounts' list added to this set.
        Set<Integer> modifiedAccountIndices = new Set<Integer>();
        
        // Temporary variables used while checking all Installation__c, Home_Services__c and Accounts.
        //Installation__c i; // Declared below, the current/new Installation__c.
        Installation__c o; // The old Installation__c.
        Integer hsIndex; // The current Installation__c's Home_Services__c's index in the list 'homeServices', if available.
        Home_Services__c hs; // The current Installation__c's Home_Services__c, if available. May become null.
        String r; // The record type of the current Installation__c's Home_Services__c, if available.
        Integer accountIndex; // The current Installation__c's Home_Services__c's Account's index in the list 'accounts', if available.
        Account a; // The current Installation__c's Home_Services__c's Account, if available. May become null.
        String s; // The Account's Home_Service__c sale status of the current Installation__c.
        Boolean modified; // True only if this Installation__c's Home_Services__c's Account was modified as a result of this trigger.
        
        // Process every Installation__c in this trigger individually.
        for (Installation__c i: newInstallations) {
            System.debug(i.Id); // TODO: remove this line.
            
            o = oldInstallations.get(i.Id);
            
            // Nothing needs to be updated, this Installation__c isn't associated to a Home_Services__c.
            if (!installationToHSIndexMap.containsKey(i.Id)) {
                System.debug('Case 2'); // TODO: remove this line.
                continue;
            }
            
            hsIndex = installationToHSIndexMap.get(i.Id);
            hs = homeServices[hsIndex];
            
            System.debug(o); // TODO: remove this line.
            System.debug(hsIndex); // TODO: remove this line.
            System.debug(hs); // TODO: remove this line.
            
            // If this Home_Services__c's appointment sale status is set to anything other than 'Sale Approved',
            // (which includes null, empty string, 'Sale Turn Down' and 'Sale Cancelled'), then nothing
            // needs to be updated.
            if (hs.Appt_Sale_Status__c != 'Sale Approved') {
                System.debug('Case 3'); // TODO: remove this line.
                continue;
            }
            
            // If this Home_Services__c's sales status is set to anything other than 'Closed Won', nothing needs to be updated.
            if (hs.Home_Services_Status__c != 'Closed Won') {
                System.debug('Case 4'); // TODO: remove this line.
                continue;
            }
            
            // The Home_Services__c's status is currently set to 'Sale Approved'. Attempt to fetch its Account.
            // If no Account is associated to this Home_Services__c, nothing needs to be updated.
            if (!hsToAccountIndexMap.containsKey(hs.Id)) {
                System.debug('Case 5'); // TODO: remove this line.
                continue;
            }
            
            accountIndex = hsToAccountIndexMap.get(hs.Id);
            a = accounts[accountIndex];
            
            // Fetch the Account's current status.
            r = homeServiceRecordTypeMap.get(hs.RecordTypeId).getName();
            s = AccountHSStatusUpdateHelper.getAccountStatus(a, r);
            
            System.debug(accountIndex); // TODO: remove this line.
            System.debug(a); // TODO: remove this line.
            System.debug(r); // TODO: remove this line.
            System.debug(s); // TODO: remove this line.
            
            // If the Account's current status is either 'CXL' or 'STD', nothing needs to be updated.
            if (s == 'CXL' || s == 'STD') {
                System.debug('Case 6'); // TODO: remove this line.
                continue;
            }
            
            modified = false;
            
            // Update the Account's status based on the current Installation__c's status.
            if (i.Installation_Status__c == 'Installed' || i.Installation_Status__c == 'Completed') {
                // If the installation status is either 'Installed' or 'Completed', attempt
                // to set the Account's status to 'Installed' if not already set to that value.
                // Flag it as modified if its value changed.
                modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Installed');
                
                System.debug('Case 7'); // TODO: remove this line.
            } else if (i.Installation_Status__c != null && i.Installation_Status__c.trim() != '' && i.Installation_Status__c != 'Sale') {
                // Else, if the Installation's status is not null, an empty string, 'Installed', 'Completed', or 'Sale',
                // Then set the Account's status to 'Install'.
                modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Install');
                
                System.debug('Case 8'); // TODO: remove this line.
            } else {
                // If we're here, then logically the Installation__c's status is NOT 'Installed' or 'Completed', but
                // it is any of the following values: null, an empty string, or the string 'Sale'. These 3 values will
                // be interpreted as a 'Sold' value and the Account's status will be set to it.
                modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Sold');
                
                System.debug('Case 9'); // TODO: remove this line.
            }
            
            System.debug(modified); // TODO: remove this line.
            
            // If due to the above checks this Installation_c's Home_Services__c's Account was flagged as
            // modified, then add its index in the Accounts list to the set of modified Account indices.
            if (modified) {
                modifiedAccountIndices.add(accountIndex);                
            }
        }
        
        System.debug(modifiedAccountIndices); // TODO: remove this line.
        
        // Populate the static set of modified Accounts using the set of modified Account indices,
        // then DML-update them all (if any) in the AFTER part of this trigger.
        modifiedAccounts = new Set<Account>();
        
        if (!modifiedAccountIndices.isEmpty()) {
            System.debug('Case 10'); // TODO: remove this line.
            
            for (Integer i: modifiedAccountIndices) {
                modifiedAccounts.add(accounts[i]);
            }
        }
        
        System.debug(modifiedAccounts); // TODO: remove this line.
        System.debug('END'); // TODO: remove this line.
        
        // Done with the BEFORE trigger.
    }
}