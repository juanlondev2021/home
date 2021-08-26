/**
 * Diaco LLC
 * @author 			Fabian Pineda href = <fpineda@diaco.us>
 * Project:			Account Status Process Improvements
 * Class            AccountHSStatusUpdateHelper   
 * Test:            AccountHSStatusUpdateHelperTest
 * Description:		Contains utility methods used by Account- and Installation__c-related Apex triggers.
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		15/09/2020		Fabian Pineda (FP)		Initial version
 **/
public class AccountHSStatusUpdateHelper {
    /** Returns the appropriate Home Service "status" field in Account by a given Home Service record type name. **/
    public static String homeServiceRecordTypeToAccountStatusField(String recordTypeName) {
        if (recordTypeName == null) {
            return null;
        }
        
        if (recordTypeName.startsWith('Carpet & Tile Cleaning')) {
            return 'Carpet_Tile_Cleaning_Status__c';
        } else if (recordTypeName.startsWith('Garage Doors')) {
            return 'Garage_Doors_Status__c';
        } else if (recordTypeName.startsWith('Home Automation')) {
            return 'Home_Automation_Status__c';
        } else if (recordTypeName.startsWith('HVAC')) {
            return 'HVAC_Status__c';
        } else if (recordTypeName.startsWith('Internet-')) {
            return 'Internet_Cable_Satellite_Status__c';
        } else if (recordTypeName.startsWith('Lock Smith')) {
            return 'Lock_Smith_Status__c';
        } else if (recordTypeName.startsWith('Maid Service')) {
            return 'Maid_Service_Status__c';
        } else if (recordTypeName.startsWith('Pest Control')) {
            return 'Pest_Control_Status__c';
        } else if (recordTypeName.startsWith('Pool Maintenance')) {
            return 'Pool_Maintenance_Status__c';
        } else if (recordTypeName.startsWith('Remodel')) {
            return 'Remodel_Status__c';
        } else if (recordTypeName.startsWith('Solar')) {
            return 'Solar_Status__c';
        } else if (recordTypeName.startsWith('Water Treatment')) {
            return 'Water_Status__c';
        }
        
        // None of the above conditions matched.
        return null;
    }
    
    /**
     * Returns an Account's Home Service 'status' field's value.
     * The Account field accessed depends on the provided Home Service record type name.
     * Returns null on error (such as when an invalid record type name is provided.)
     */
    public static String getAccountStatus(Account account, String hsRecordTypeName) {
        String field = homeServiceRecordTypeToAccountStatusField(hsRecordTypeName);
        
        if (field == null) {
            // Shouldn't happen. Issue debug/warning messages here as needed.
            return null;
        }
        
        return (String) account.get(field);
    }
    
    /**
     * Updates an Account's Home Service "status" field to a specified value. The status field to be updated
     * depends on the provided Home Service record type name.
     * 
     * Returns true if Account's value changed as a result of this method.
     * Returns false if the field's value was already the provided value, or if an error happened (such as
     * an invalid Home Service record type name.)
     */
    public static Boolean updateAccountStatus(Account account, String hsRecordTypeName, String value) {
        String field = homeServiceRecordTypeToAccountStatusField(hsRecordTypeName);
        
        if (field == null) {
            return false;
        }
        
        return account.put(field, value) != value;
    }
    
    /** Returns the appropriate Home Service "DNC" field in Account by a given Home Service record type name. **/
    public static String homeServiceRecordTypeToAccountDNCField(String recordTypeName) {
        if (recordTypeName == null) {
            return null;
        }
        
        if (recordTypeName.startsWith('Carpet & Tile Cleaning')) {
            return 'DNC_Carpet_Tile_Cleaning__c';
        } else if (recordTypeName.startsWith('Garage Doors')) {
            return 'DNC_Garage_Doors__c';
        } else if (recordTypeName.startsWith('Home Automation')) {
            return 'DNC_Home_Automation__c';
        } else if (recordTypeName.startsWith('HVAC')) {
            return 'DNC_HVAC__c';
        } else if (recordTypeName.startsWith('Internet-')) {
            return 'DNC_Internet_Cable_Satellite__c';
        } else if (recordTypeName.startsWith('Lock Smith')) {
            return 'DNC_Lock_Smith__c';
        } else if (recordTypeName.startsWith('Maid Service')) {
            return 'DNC_Maid_Service__c';
        } else if (recordTypeName.startsWith('Pest Control')) {
            return 'DNC_Pest_Control__c';
        } else if (recordTypeName.startsWith('Pool Maintenance')) {
            return 'DNC_Pool_Maintenance__c';
        } else if (recordTypeName.startsWith('Remodel')) {
            return 'DNC_Remodel__c';
        } else if (recordTypeName.startsWith('Solar')) {
            return 'DNC_Solar__c';
        } else if (recordTypeName.startsWith('Water Treatment')) {
            return 'DNC_Water__c';
        }
        
        // None of the above conditions matched.
        return null;
    }
    
    /**
     * Returns an Account's Home Service 'DNC' field's value.
     * The Account field accessed depends on the provided Home Service record type name.
     * Returns null on error (such as when an invalid record type name is provided.)
     */
    public static Boolean getAccountDNC(Account account, String hsRecordTypeName) {
        String field = homeServiceRecordTypeToAccountDNCField(hsRecordTypeName);
        
        if (field == null) {
            // Shouldn't happen. Issue debug/warning messages here as needed.
            return null;
        }
        
        return (Boolean) account.get(field);
    }
    
    /**
     * Updates an Account's Home Service "DNC" field to a specified value. The status field to be updated
     * depends on the provided Home Service record type name.
     * 
     * Returns true if Account's value changed as a result of this method.
     * Returns false if the field's value was already the provided value, or if an error happened (such as
     * an invalid Home Service record type name.)
     */
    public static Boolean updateAccountDNC(Account account, String hsRecordTypeName, Boolean value) {
        String field = homeServiceRecordTypeToAccountDNCField(hsRecordTypeName);
        
        if (field == null) {
            return false;
        }
        
        return account.put(field, value) != value;
    }
}