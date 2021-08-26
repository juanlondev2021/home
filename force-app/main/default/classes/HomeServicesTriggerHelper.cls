/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-18-2020
 * @last modified by  : Fabian Pineda
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-17-2020   William Aldana   Initial Version
 * 1.0   09-18-2020   Fabian Pineda    Added back working code from the older Home Services trigger.
 * 1.0   09-25-2020	  Jull Quintero D  Appointment Sale Approved
 * 1.0   11-06-2020   Fabian Pineda    Created 'HomeServiceUpdateFinanceTaxHandler' method.
 **/
public class HomeServicesTriggerHelper {

    /**
    * @description 
    * @author William Aldana | 09-17-2020 
    * @param homeServices 
    * @param oldHS 
    * @param op 
    **/
    public static void HomeServiceSaleApprovedHandler(Home_Services__c[] homeServices, Map<Id, Home_Services__c> oldHS, TriggerOperation op) {
        switch on op {
            when BEFORE_UPDATE {
                beforeUpdate(homeServices, oldHS);
            }
            when AFTER_UPDATE {
                afterUpdate(homeServices, oldHS);
                //new ConfirmationCallSms(homeServices,oldHS);
            }
        }
    }

    /*
    *@Author: Jull Q Daza - 22/12/2020
     * This method is responsible to create SMS
     * 
     * This method is used in:
     * HomeServiceTriggerHelper.cls
     * 
     * @param List Home_Services__c newHS, 
     * Map Home_Services__c oldHS
     */
    public static void createSMS(Home_Services__c[] homeServices, Map<Id, Home_Services__c> oldHsMap,Boolean isInsert,Boolean isUpdate ) {
        new CreateSMS(homeServices,oldHsMap,isInsert,isUpdate);
    }


    /**
    * @description 
    * @author William Aldana | 09-17-2020 
    * @param homeServices 
    * @param oldHS 
    **/
    public static void beforeUpdate(Home_Services__c[] homeServices, Map<Id, Home_Services__c> oldHS){
        List<Home_Services__c> hsTask = new List<Home_Services__c>();

        for(Home_Services__c hs : homeServices){
            System.debug('Before - HS - IN for');
            if(hs.Appt_Sale_Status__c == 'Sale Approved' && oldHs.get(hs.Id).Appt_Sale_Status__c != hs.Appt_Sale_Status__c ){
                System.debug('Before - HS - IN if');
                String rtName = hs.Industry_Formula__c == 'HVAC'? hs.Industry_Formula__c + ' Sales': hs.Industry_Formula__c + ' Installation';
                system.debug('HS Record Type: '+rtName);
                Id hsRecordTypeId  = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
                system.debug('HS Record Type ID: '+hsRecordTypeId);
                System.debug(hsRecordTypeId);
                String insName = hs.first_name__c +' '+ hs.Last_Name__c +' - '+ hs.Industry_Formula__c + ' Installation';
                String hsName  = hs.Name != insName && hs.Industry_Formula__c != 'HVAC'? insName : hs.Name;

                    hs.RecordtypeId                  = hsRecordTypeId;
                    hs.Home_Services_Status__c       = 'Closed Won';
                    hs.Sales_Event_Current_Status__c = 'Closed Won';
                    hs.Name                          = hsName;

            }
        }
    }


    /**
    * @description 
    * @author William Aldana | 09-17-2020 
    * @param homeServices 
    * @param oldHS 
    **/
    public static void afterUpdate(Home_Services__c[] homeServices, Map<Id, Home_Services__c> oldHS){


        List<Service__c> sTask = new List<Service__c>();
        List<Installation__c> iTask = new List<Installation__c>();
        List<Event> tEvent = new List<Event>();

        for(Home_Services__c hs : homeServices){
            if(hs.Appt_Sale_Status__c != oldHS.get(hs.id).Appt_Sale_Status__c){
                Id insRecordTypeId = Schema.SObjectType.Installation__c.getRecordTypeInfosByName().get(hs.Industry_Formula__c).getRecordTypeId();
                system.debug('Installation Record Type ID: '+insRecordTypeId);
                Id serRecordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByName().get(hs.Industry_Formula__c).getRecordTypeId();
                system.debug('Service Record Type ID: '+serRecordTypeId);
                //Service Object
                if(hs.Appt_Sale_Status__c == 'Sale Approved' && oldHs.get(hs.Id).Appt_Sale_Status__c != hs.Appt_Sale_Status__c && hs.Industry_Formula__c != 'HVAC'){
                    if(hs.Service__c == null){
                        sTask.add(new Service__c(
                            Home_Service__c   = hs.Id,
                            RecordtypeId      = serRecordTypeId,
                            Sub_Categories__c = hs.Sub_Categories__c
                        ));
                    }
                    //Installation Object
                    if(hs.Installation__c == null){
                        iTask.add(new Installation__c(
                            Home_Service__c = hs.Id,
                            RecordtypeId    = insRecordTypeId,
                            Sub_Categories__c = hs.Sub_Categories__c
                        ));  
                    }
                }
    
                if(hs.Event__c != null){
                    tEvent.add(new Event (
                    Id = hs.Event__c,
                    Appointment_results__c = hs.Appt_Sale_Status__c
                    ));
                }
            }
        }
        insert sTask;
        insert iTask;
        update tEvent;
    } 
    
    /** Home_Services__c record type information map. Used by beforeUpdate2. */
    private static Map<Id, Schema.RecordTypeInfo> recordTypeMap;

    /** Set of accounts modified in beforeUpdate2. These accounts will be DML-updated in afterUpdate2. */
    private static Set<Account> modifiedAccounts;
    
   /**
    * @description Transfers flow of execution to either beforeUpdate2 or afterUpdate2 depending on the trigger's operation.
    * @author Fabian Pineda | 09-18-2020 
    * @param newHS This Home_Services__c trigger's Trigger.New
    * @param oldHS This Home_Services__c trigger's Trigger.oldMap
    * @param operation This Home_Services__c trigger's Trigger.operationType
    **/
    public static void HomeServiceUpdateAccountHandler(List<Home_Services__c> newHS, Map<Id, Home_Services__c> oldHS, TriggerOperation operation) {
        switch on operation {
            when BEFORE_UPDATE {
                beforeUpdate2(newHS, oldHS);
            }
            when AFTER_UPDATE {
                afterUpdate2(newHS, oldHS);
            }
        }
    }
    
   /**
    * @description Runs before Home_Services__c updates. Checks and updates this Home_Services__c's Appt_Sale_Status__c and keeps this Home_Services__c's Account's relevant Home Service sale and DNC status fields updated.
    * @author Fabian Pineda | 09-18-2020 
    * @param newHS This Home_Services__c trigger's Trigger.New
    * @param oldHS This Home_Services__c trigger's Trigger.oldMap
    **/
    public static void beforeUpdate2(List<Home_Services__c> newHS, Map<Id, Home_Services__c> oldHS) {        
        System.debug('RUNNING BEFORE TRIGGER'); // TODO: remove this line.
        
        // Initialize the Home_Services__c record type map if it hasn't been initialized already.
        if (recordTypeMap == null) {
            recordTypeMap = Home_Services__c.sObjectType.getDescribe().getRecordTypeInfosById();
        }

        // Make a set of all Home_Services__c's related Accounts.
        Set<Id> hsAccountIds = new Set<Id>();
        
        // Also make a set of all Home_Services__c's related Installation__c.
        Set<Id> hsInstallationIds = new Set<Id>();
        
        // Populate the Home_Services__c Account and Installation__c ID sets.
        for(Home_Services__c hs: newHS) {
            if (hs.Account__c != null) {
                hsAccountIds.add(hs.Account__c);
            }
            
            if (hs.Installation__c != null) {
                hsInstallationIds.add(hs.Installation__c);
            }
        }
        
        System.debug(hsAccountIds); // TODO: remove this line.
        System.debug(hsInstallationIds); // TODO: remove this line.
        
        // Fetch all accounts with IDs matching the ones in the above set in a single query.
        List<Account> hsAccounts = [
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
            Water_Status__c,
            
            // DNC fields
            DNC_Carpet_Tile_Cleaning__c,
            DNC_Garage_Doors__c,
            DNC_Home_Automation__c,
            DNC_HVAC__c,
            DNC_Internet_Cable_Satellite__c,
            DNC_Lock_Smith__c,
            DNC_Maid_Service__c,
            DNC_Pest_Control__c,
            DNC_Pool_Maintenance__c,
            DNC_Remodel__c,
            DNC_Solar__c,
            DNC_Water__c
            
            FROM
            Account
            
            WHERE
            Id IN :hsAccountIds
        ];
        
        // Fetch all Installation__c matching the IDs in the Installation__c ID set in a single query.
		List<Installation__c> hsInstallations = [SELECT Installation_Status__c FROM Installation__c WHERE Id in :hsInstallationIds];
        
        System.debug(hsAccounts); // TODO: remove this line.
        System.debug(hsInstallations); // TODO: remove this line.
        
        // Build a map of Home_Services__c IDs --> Accounts' indices in the hsAccounts list.
        Map<Id, Integer> hsToAccountMap = new Map<Id, Integer>();
        
        // Also build a map of Home_Services__c IDs --> Installation__c's indices in the hsInstallations list.
        Map<Id, Integer> hsToInstallationMap = new Map<Id, Integer>();
        
        // Populate both the HS ID --> Account index map and the HS ID --> Installation__c index map.
        for(Home_Services__c hs: newHS) {
            for (Integer i = 0; i < hsAccounts.size(); i++) {
                if (hs.Account__c == hsAccounts[i].Id) {
                    hsToAccountMap.put(hs.Id, i);
                }
                
                break;
            }
            
            for (Integer i = 0; i < hsInstallations.size(); i++) {
                if (hs.Installation__c == hsInstallations[i].Id) {
                    hsToInstallationMap.put(hs.Id, i);
                }
                
                break;
            }
        }
        
        System.debug(hsToAccountMap); // TODO: remove this line.
        System.debug(hsToInstallationMap); // TODO: remove this line.
        
        // Process each Home_Services__c and their respective Accounts individually, adding Acconts' indices to a "modified Accounts" indices set as needed.
        Set<Integer> modifiedAccountIndices = new Set<Integer>();
        
        // Temporary variables used when iterating through all Home_Services__c
        Home_Services__c o; // Old Home_Services__c. Read-only!
        String r; // The current Home_Services__c's record type name.
        Integer aIndex; // Index of Account related to the "new HS" Home_Services__c.
        Account a; // Account related to the "newHS" Home_Services__c.
        Integer iIndex; // Index of Installation__c related to the "new HS" Home_Services__c.
        Installation__c ins; // The current Home_Services__c's Installation__c.
        String s; // The current status set in the Account.
        Boolean modified; // true only if the current Home_Services__c's Acount needs to be updated.
        
        for (Home_Services__c hs: newHS) {
            System.debug(hs.Id); // TODO: remove this line.
            
            // Ignore this Home_Services__c if it's not associated to an Account.
            if (!hsToAccountMap.containsKey(hs.Id)) {
                System.debug('Warning: Home_Services__c not associated to an Account: ' + hs.Id); // TODO: remove this line.
                continue;
            }
            
            r = recordTypeMap.get(hs.RecordTypeId).getName();
            o = oldHS.get(hs.Id);
            aIndex = hsToAccountMap.get(hs.Id);
            a = hsAccounts[aIndex];
            s = AccountHSStatusUpdateHelper.getAccountStatus(a, r);
            iIndex = -1;
            ins = null;
            
            if (hsToInstallationMap.containsKey(hs.Id)) {
				iIndex = hsToInstallationMap.get(hs.Id);
            	ins = hsInstallations[iIndex];
            }
            
            modified = false;
            
            System.debug(hs.Appt_Sale_Status__c); // TODO: remove this line.
            System.debug(r); // TODO: remove this line.
            System.debug(o); // TODO: remove this line.
            System.debug(aIndex); // TODO: remove this line.
            System.debug(a); // TODO: remove this line.
            System.debug(iIndex); // TODO: remove this line.
            System.debug(ins); // TODO: remove this line.
			System.debug(s); // TODO: remove this line.
            
            if (o.Appt_Sale_Status__c == 'Sale Turn Down' || o.Appt_Sale_Status__c == 'Sale Cancelled') {
	            // CASE 1: Attempting to change from Sale Turn Down or Sale Cancelled to any other
	            //         value while the Account's status is currently not 'CXL' and not 'STD'.
            
    	        // If the old status is either 'Sale Turned Down' or 'Sale Cancelled'
                // If the old status does not match the new status and the new status is either 'Sale Turned Down' or 'Sale Cancelled':
                if (o.Appt_Sale_Status__c != hs.Appt_Sale_Status__c && (hs.Appt_Sale_Status__c == 'Sale Turn Down' || hs.Appt_Sale_Status__c == 'Sale Cancelled')) {
					// Allow this change and update the Account's status based on the Home_Services__c's record type, flag it as modified if the status was successfully changed.
					System.debug('Case 1, result 1'); // TODO: remove this line.
                } else {
                    // Else, do nothing; keep the old value and don't allow changes. The value will continue to be either "Sale Turned Down" or "Sale Cancelled".
                    // The account's status will only be updated if the values don't match.
                    
                    // IMPORTANT: requirements have changed, changing from 'Sale Turn Down' or 'Sale Cancelled' should be allowed in Home Services.
                    //hs.Appt_Sale_Status__c = o.Appt_Sale_Status__c;
                    System.debug('Case 1, result 2'); // TODO: remove this line.
                }
                
                modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, hs.Appt_Sale_Status__c == 'Sale Turn Down' ? 'STD' : 'CXL');
                System.debug(modified); // TODO: remove this line.
                
                // Case 1 handled. No need to check this Home_Services__c's status further.
            } else if (hs.Appt_Sale_Status__c == 'Sale Turn Down' || hs.Appt_Sale_Status__c == 'Sale Cancelled') {
                // CASE 2: Attempting to change from any status to either Sale Turn Down or Sale Cancelled
                //         while the Account's status is currently not 'CXL' and not 'STD'.
                
                // Else, if the new status is either 'Sale Turned Down' or 'Sale Cancelled' and the old value was not one of those two values,
                // then allow the status change and update the account's status.
                modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, hs.Appt_Sale_Status__c == 'Sale Turn Down' ? 'STD' : 'CXL');
                
                System.debug('Case 2'); // TODO: remove this line.
                System.debug(modified); // TODO: remove this line.
                 
                // Case 2 handled. No need to check this Home_Services__c's status further.
            } else if (hs.Appt_Sale_Status__c == 'Sale Approved') {
                // CASE 3:
                // 1) The Account's status is not set to either 'CXL' or 'STD'.
                // 2) Sale status is not and was not 'Sale Turn Down' or 'Sale Cancelled', and isn't being changed to either of those two values.
                // 3) The sale status is, or is being set to 'Sale Aproved'
                // 4) The Home_Service__c may or may not have an Installation__c, depending on when exactly this trigger is being run.
                //    This Installation__c is assigned to this object as a result of external triggers, so this trigger may need to run more than once.
                //    It may be possible that the old Installation__c is being replaced with a new, different one. If this happens, the Account's status might need to be recalculated based on the Installation__c's status.
                // Expected results:
                // 1) Allow the status change to 'Sale Approved' in this Home Service if it wasn't set to this status already.
                // 2) If the Installation__c was null and is being set to a non-null value, update the Account's status to 'Sold' by default, or set it to the Installation__c's status, as applicable.
                // 3) If the Installation__c was not null and is being set to non-null, leave the current Account's status as-is; Accounts' status will be handled by the Installation__c's triggers.
                
                // Even though the change is accepted by default, it might be a good idea to log a message if the status is being changed.
                if (o.Appt_Sale_Status__c != hs.Appt_Sale_Status__c) {
                    // Log debug messages here if needed.
                    System.debug(o.Appt_Sale_Status__c); // TODO: Remove this line.
                    System.debug(hs.Appt_Sale_Status__c); // TODO: Remove this line.
                }
                
                // If the new value for Installation__c is null:
                if (hs.Installation__c == null) {
                    // If the old value was NOT null, this means an attempt to remove the Installation__c is being made.
                    // The expected behavior for this specific sub-case hasn't been specified to me but this should not happen.
                    // It's probably a good idea to log debug/warning messages here if this happens!
                    if (o.Installation__c != null) {
                        // This shouldn't happen! Do nothing for now.
                         
                        System.debug('Case 3 result 1.'); // TODO: Remove this line.
                    }
                    
                    System.debug('Case 3 result 2'); // TODO: Remove this line.
                    // No further actions required. If the old value was null, and so is the new one, nothing needs to be updated.
                } else if (ins == null) {
                    // If for whatever reason the query to fetch this Home_Services__c's Instllation__c returned a null object,
                    // abort the operation and do not perform further checking. Consider issuing debug/warning messages here!
                    
                    // This shouldn't happen! Do nothing for now.
                     
                    System.debug('Case 3 result 3'); // TODO: Remove this line.
                } else {
                    // Else, if the new value for Installation__c is NOT null (and neither is 'ins')
                    // 
                    // Note: if we're here, then logically the status is NOT currently 'Sale Turn Down' or 'Sale Cancelled',
                    // so no need to explicitly check for those values!

                    // If the Installation__c's status is either 'Installed' or 'Completed'
                    if (ins.Installation_Status__c == 'Installed' || ins.Installation_Status__c == 'Completed') {
                        // Set the Account's status to 'Installed' if not already set to it, and flag the Account as modified if its status changed.
                        modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Installed');
                        
                        System.debug('Case 3 result 4'); // TODO: Remove this line.
                    } else if (ins.Installation_Status__c != null && ins.Installation_Status__c.trim() != '' && ins.Installation_Status__c != 'Sale') {
                        // Else, if the Installation's status is not null, an empty string, 'Installed', 'Completed', or 'Sale',
                        // Then set the Account's status to 'Install'.
                        modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Install');
                        
                        System.debug('Case 3 result 5'); // TODO: Remove this line.
                    } else {
                        // If we're here, then logically the Installation__c's status is NOT 'Installed' or 'Completed', but
                        // it is any of the following values: null, an empty string, or the string 'Sale'. These 3 values will
                        // be interpreted as a 'Sold' value and the Account's status will be set to it.
                        modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Sold');
                        
                        System.debug('Case 3 result 6'); // TODO: Remove this line.
                    }
                    
                    // If the Installation__c is null, OR if it's not and the old and new values are the same, no further changes are required.
                    System.debug('Case 3 handled'); // TODO: Remove this line.
                }
                
                // Case 3 handled. No need to check this Home_Services__c's or Installation__c's status further.
            } else if (hs.Event__c != null && hs.Event__c.trim() != '') {
                // If the status is not, and will not be either 'Sale Turn Down' or 'Sale Cancelled' and this Home Service
                // has a null or blank Installation, then it's safe to update this Home Service's status to null if it isn't so already.
                if (hs.Appt_Sale_Status__c != null) {
                    hs.Appt_Sale_Status__c = null;
                    
                    System.debug('Status was not null; changed to null'); // TODO: remove this line.
                }
                
                // CASE 4:
                // 1) The Account's status is not set to either 'CXL' or 'STD'.
                // 2) Sale status is not and was not 'Sale Turn Down' or 'Sale Cancelled', and isn't being changed to either of those two values.
                // 3) The sale status in this appointment is NOT set to 'Sale Approved' (is null or a blank string).
                // 4) An Event__c exists; the field is not null or blank.
                // Expected result: set the Account's status to 'Appointment' and its DNC field to true only if its previous status was either null or blank.
                if (s == 'Appointment') {
                    // If the Account's status was already set to 'Appointment', there's nothing to update.
                    
                    System.debug('Case 4, result 1'); // TODO: remove this line.
                } else if (s == null || s.trim() == '') {
                    // If the Account's status was either null or a blank string, then update its value to Appointment.
                    modified = AccountHSStatusUpdateHelper.updateAccountStatus(a, r, 'Appointment');
                    
                    System.debug('Case 4, result 2'); // TODO: remove this line.
                    System.debug(modified); // TODO: remove this line.
                } else {
                    // Else, leave the Account's status as-is.
                    
                    System.debug('Case 4, result 3'); // TODO: remove this line.
                }
                
                // Set the proper DNC field to true, flag this Home Service's Account as modified if values changed.
                modified = modified ? modified : AccountHSStatusUpdateHelper.updateAccountDNC(a, r, true);
                
                System.debug(modified); // TODO: remove this line.
                
                // Case 4 handled. No need to check this Home_Services__c's status further.
            }
            
            System.debug(modified); // TODO: remove this line.
            
            // If due to the above checks this Home Service's Account was flagged as modified, then add its index in the
            // Accounts list to the set of modified Account indices.
            if (modified) {
				modifiedAccountIndices.add(aIndex);                
            }
        }
        
        // Populate the static set of modified Accounts using the set of modified Account indices,
        // then DML-update them all (if any) in the AFTER part of this trigger.
        modifiedAccounts = new Set<Account>();

        System.debug(modifiedAccountIndices); // TODO: remove this line.
        
        if (!modifiedAccountIndices.isEmpty()) {
            for (Integer i: modifiedAccountIndices) {
                modifiedAccounts.add(hsAccounts[i]);
            }
        }
        
        System.debug(modifiedAccounts); // TODO: remove this line.
    }
    
    /**
    * @description Runs after Home_Services__c updates. Commits all Account changes made in beforeUpdate2 into the database with a mass DML-update.
    * @author Fabian Pineda | 09-18-2020 
    * @param newHS This Home_Services__c trigger's Trigger.New
    * @param oldHS This Home_Services__c trigger's Trigger.oldMap
    **/
    public static void afterUpdate2(List<Home_Services__c> newHS, Map<Id, Home_Services__c> oldHS) {
		System.debug('RUNNING AFTER TRIGGER'); // TODO: remove this line.
        
        System.debug(modifiedAccounts); // TODO: remove this line.
        
        if (modifiedAccounts != null && !modifiedAccounts.isEmpty()) {
            if(userInfo.getUserType() != 'Guest') update new List<Account>(modifiedAccounts);
        }
    }  
    
    /**
     * @author Jull Quintero D | 09-25-2020
     * @Description
     * Is responsible to Create or update Appointment when a HS is on Sale Approved
     * Is run After Insert And After Update
     * Is used in: HomeServicesTrigger
     *@param List New homeServices
     *@param List Old homeServices 
     *@param Boolean isInsert 
     **/
    public static void AppointmentSaleApproved(List<Home_Services__c> newHS, Map<Id, Home_Services__c> oldHS, Boolean isInsert) {
        List<Appointment__c> appomts = new List<Appointment__c>();
        List<Home_Services__c> homeServices = new List<Home_Services__c>();
        integer newHSLength = newHS.size();
        for (Integer i = 0; i < newHSLength; i++) 
        {
            Home_Services__c hs = newHS[i];
            Boolean isChangeSaleStatus = isInsert ? true : oldHs.get(hs.Id).Appt_Sale_Status__c != hs.Appt_Sale_Status__c; 
            if( isChangeSaleStatus ) {
                if( hs.Appt_Sale_Status__c == 'Sale Approved' ) {
                    if( hs.Appointment_Lookup__c != null ) {
                        appomts.add( 
                            new Appointment__c(
                                id = hs.Appointment_Lookup__c,
                                Status__c = 'Sale Approved'
                        ));
                    }else {
                        Appointment_RecordType_mtd__c homeServiceRtype = Appointment_RecordType_mtd__c.getValues(hs.RecordTypeId);
                        if( homeServiceRtype != null ) {
                            appomts.add(
                                new Appointment__c(
                                    RecordTypeId = homeServiceRtype.RT_Appointment_Id__c,
                                    assigned__c = true,
                                    Person_Account__c = hs.Account__c,
                                    Home_Service__c = hs.Id,
                                    Status__c = 'Sale Approved',
                                    Lead_Source__c = 'Automation'
                                )
                            );
                        }
                    }
                }
            }
        }
        if ( !appomts.isEmpty() ) {
            upsert appomts;

            integer appomtsLength = appomts.size();
            for (Integer i = 0; i < appomtsLength; i++) 
            {
                Appointment__c appmt = appomts[i];
                if( appmt.Lead_Source__c == 'Automation' ) {
                    homeServices.add(
                        new Home_Services__c(
                            Id = appmt.Home_Service__c,
                            Appointment_Lookup__c = appmt.Id
                        )
                    );
                }
            }

            TriggerHandler.bypass('HomeServicesTrigger');
                update homeServices;
            TriggerHandler.clearBypass('HomeServicesTrigger');
        }
    }

    /**
     * @description Updates this Home Service's Finance Custom Setting's Tax__c when the HS's Tax__c changes.
     * @author Fabian Pineda | 11-05-2020 
     * @param newHS This Home_Services__c trigger's Trigger.New
     * @param oldHS This Home_Services__c trigger's Trigger.oldMap
     **/
    public static void HomeServiceUpdateFinanceTaxHandler(List<Home_Services__c> newHS, Map<Id, Home_Services__c> oldHS) {
        // Make a set of all Home_Services__c's Finance_Package__c custom settings.
        Set<Id> hsFinancePackageIds = new Set<Id>();
        
        // Populate the Home_Services__c Finance_Package__c ID set.
        for(Home_Services__c hs: newHS) {
            if (hs.FinanceId__c != null) {
                hsFinancePackageIds.add(hs.FinanceId__c);
            }
        }
        
        // Fetch all Finance_Package__c with IDs matching the ones in the above set in a single query.
        List<Finance_Package__c> hsFinancePackages = [SELECT Tax__c FROM Finance_Package__c WHERE Id IN :hsFinancePackageIds];
        
        // Build a map of Home_Services__c IDs --> Finance_Package__c indices in the hsFinancePackages list.
        Map<Id, Integer> hsToFinancePackageMap = new Map<Id, Integer>();
        
        // Populate the Home_Services__c ID --> Finance_Package__c index map.
        for(Home_Services__c hs: newHS) {
            for (Integer i = 0; i < hsFinancePackages.size(); i++) {
                if (hs.FinanceId__c == hsFinancePackages[i].Id) {
                    hsToFinancePackageMap.put(hs.Id, i);
                }
                
                break;
            }
        }

        // Process all Home_Services__c and their respective Finance_Package__c individually, storing the indices of all modified Finance_Package__c.
        Set<Integer> modifiedFinancePackageIndices = new Set<Integer>();

        Integer currentFPIndex;
        Finance_Package__c currentFP;
        Boolean currentHSTaxValue;

        for (Home_Services__c hs: newHS) {
            // Ignore this Home_Services__c if its Tax__c is not being updated.
            if (hs.Tax__c == oldHS.get(hs.Id).Tax__c) {
                continue;
            }

            // Ignore this Home_Services__c if it's not associated to a Finance_Package__c.
            if (!hsToFinancePackageMap.containsKey(hs.Id)) {
                continue;
            }

            currentFPIndex = hsToFinancePackageMap.get(hs.Id);
            currentFP =  hsFinancePackages[currentFPIndex];
            currentHSTaxValue = hs.Tax__c == 'Yes';

            // Compare the Home_Services__c Tax__c value to the Finance_Package__c Tax__c value. Ignore this HS if they match.
            if (currentHSTaxValue == currentFP.Tax__c) {
                continue;
            }
            
            // Update Finance_Package__c, and flag it as modified.
            currentFP.Tax__c = currentHSTaxValue;
            modifiedFinancePackageIndices.add(currentFPIndex);
        }

        // Populate a set of modified Finance_Package__c using the set of modified Finance_Package__c indices,
        // then DML-update them all (if any) in a single DML statement.
        Set<Finance_Package__c> modifiedFinancePackages = new Set<Finance_Package__c>();

        if (!modifiedFinancePackageIndices.isEmpty()) {
            for (Integer i: modifiedFinancePackageIndices) {
                modifiedFinancePackages.add(hsFinancePackages[i]);
            }
        }

        if (!modifiedFinancePackages.isEmpty()) {
            update new List<Finance_Package__c>(modifiedFinancePackages);
        }
    }
}