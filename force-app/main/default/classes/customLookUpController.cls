/*
* Diaco
* @author 			
* Project:			UtilityClass
* Description:		Retrieve data for customLookup.cmp
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version  1.0		21/09/2020		John Hernandez (JH)		Added Event for tab completion.
*/



public class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String recordType) {
        //System.debug('ObjectName-->' + ObjectName);
        //System.debug('Record Type-->' + recordType);
        String searchKey = searchKeyWord + '%';
        
        List <sObject> returnList = new List <sObject> ();
      
        // Create a Dynamic SOQL Query To Fetch Record List with LIMIT 5   
        String sQuery;
        
        if (recordType == null || recordType.trim().length() < 1) {
        	sQuery = 'SELECT Id, Name FROM ' + ObjectName + ' WHERE Name LIKE :searchKey ORDER BY createdDate DESC LIMIT 5';
        } else {
            sQuery = 'SELECT Id, Name FROM ' + ObjectName + ' WHERE (Name LIKE :searchKey AND RecordType.Name = :recordType) ORDER BY createdDate DESC LIMIT 5';
        }
        
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled
    public static List < sObject > fetchLookUpValuesForInstallationAccounts(String searchKeyWord, String ObjectName, String recordType) {
        String searchKey = searchKeyWord + '%';
        
        List <sObject> returnList = new List <sObject> ();
      
        // Create a Dynamic SOQL Query To Fetch Record List with LIMIT 5   
        String sQuery;
        
        if (recordType == null || recordType.trim().length() < 1) {
        	sQuery = 'SELECT Id, Name FROM ' + ObjectName + ' WHERE (Name LIKE :searchKey AND Installation_Company__c = true) ORDER BY createdDate DESC LIMIT 5';
        } else {
            sQuery = 'SELECT Id, Name FROM ' + ObjectName + ' WHERE (Name LIKE :searchKey AND Installation_Company__c = true) ORDER BY createdDate DESC LIMIT 5';
        }
        
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}