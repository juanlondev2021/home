/**
* Diaco
* @author 			Fabian Pineda href=<fpineda@diaco.us>
* Project:			Contracts
* Description:		Handles actions by component diacoSolarUtilityInformation.cmp
* Test Class :      DiacoSolarUtilityInformationControllerT
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		15/06/2020		Fabian Pineda (FP)		Initial version.
* @version  1.0     29/06/2020		Fabian Pineda (FP)		Added Type of Application picklist values retrieval method.
* @version  1.0     01/07/2020		Fabian Pineda (FP)		Added getInstallationCompany(String).
* @version	1.0		11/07/2020		Esnayder Morales (EM)   Add System_Size__c field in soql getHomeService method
* @version	1.0		19/09/2020		John Hernandez (JH)     Change Account recordType validation for checkbox "Installation_company" validation.
**/
public class DiacoSolarUtilityInformationController {
    // Important: test class is DiacoSolarUtilityInformationControllerT, not DiacoSolarUtilityInformationControllerTest

    @AuraEnabled
    public static Map<String, String> getUtilityContractsPicklistValues() {
        Map<String, String> output = new Map<String, String>();
        
        Schema.DescribeFieldResult picklist = Home_Services__c.Utility_Company__c.getDescribe();
		List<Schema.PicklistEntry> picklistValues = picklist.getPicklistValues();
        
        for (Schema.PicklistEntry e: picklistValues) {
            if (e.isActive()) {
            	output.put(e.getLabel(), e.getValue());
            }
        }
        
        return output;
    }
    
    @AuraEnabled
    public static Map<String, Map<String, Object>> getTypeOfApplicationPicklistValues() {
        Map<String, Map<String, Object>> output = new Map<String, Map<String, Object>>();
        Map<String, Object> item;
        
        Schema.DescribeFieldResult picklist = Home_Services__c.Type_of_Application__c.getDescribe();
		List<Schema.PicklistEntry> picklistValues = picklist.getPicklistValues();
        
        for (Schema.PicklistEntry e: picklistValues) {
            if (e.isActive()) {
                item = new Map<String, Object>();
                
                item.put('label', e.getLabel());
                item.put('value', e.getValue());
                item.put('isDefault', e.isDefaultValue());
                
            	output.put(e.getLabel(), item);
            }
        }
        
        return output;
    }
    
	@AuraEnabled
    public static Home_Services__c getHomeService(String recordId) {
        Home_Services__c homeService = [
            SELECT
            Utility_Company__c,
            Username__c,
            Password__c,
            Property_Owner__c,
            Electric_Behind_Fence__c,
            Existing_Generating_Solar_System__c,
            Pets__c,
            House_Square_Footage__c,
            APS_Account__c,
            System_Size__c,
            way_restricted_or_impeded__c,
            Explain_SRP__c,
            Type_of_Application__c,
            Installation_Company__c,
			Battery_Use_Backup_Power__c,
            Battery_Use_Energy_Demand_Reduction__c,
            Battery_Use_Solar_Self_consumption__c,
            Battery_Location_Garage__c,
            Battery_Location_Inside__c,
            Battery_Location_Outside__c,
            Requested_Install_Date__c,
            Annual_Estimated_Generation__c
            FROM
            Home_Services__c
            WHERE
            Id = :recordId
            LIMIT 1
        ];
        
        return homeService;
    }
    
    @AuraEnabled
    public static Account getInstallationCompany(String recordId) {
        Account account = [
            SELECT
            Id,
            Name
            FROM
            Account
            WHERE
            (Id = :recordId AND Installation_Company__c= true)
            LIMIT 1
        ];
        
        return account;
    }
    
    @AuraEnabled
    public static Home_Services__c updateHomeService(Home_Services__c homeService) {
        if (homeService.Type_of_Application__c == null) {
            homeService.Type_of_Application__c = 'None Selected';
        } else if (homeService.Type_of_Application__c.trim().length() < 1) {
            homeService.Type_of_Application__c = 'None Selected';
        }
        
        update homeService;
        return homeService;
    }
}