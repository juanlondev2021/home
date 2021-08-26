//Test class for: DiacoSolarUtilityInformationController
@isTest
public class DiacoSolarUtilityInformationControllerT {
	@testSetup
    public static void setup() {
        Account installationCompany = new Account(
            Name='Test Installation Company',
            Installation_Company__c= true
        );
        insert installationCompany;
        
        Home_Services__c homeService = new Home_Services__c(
            Utility_Company__c = null,
            Username__c = 'Test username',
            Password__c = 'Test password',
            Property_Owner__c = true,
            Electric_Behind_Fence__c = true,
            Existing_Generating_Solar_System__c = true,
            Pets__c = null,
            House_Square_Footage__c = 500,
            APS_Account__c = null,
            Installation_Company__c = installationCompany.Id
        );
        insert homeService;
    }
    
    @isTest
    public static void getUtilityContractsPicklistValuesTest() {
        Map<String, String> result = DiacoSolarUtilityInformationController.getUtilityContractsPicklistValues();
        
        System.assertNotEquals(result, null);
        System.assert(result.size() > 0);
    }
    
    @isTest
    public static void getTypeOfApplicationPicklistValuesTest() {
        Map<String, Map<String, Object>> result = DiacoSolarUtilityInformationController.getTypeOfApplicationPicklistValues();
        
        System.assertNotEquals(result, null);
        System.assert(result.size() > 0);
    }
    
    @isTest
    public static void getHomeServiceTest() {
        Home_Services__c homeService = [SELECT Id FROM Home_Services__c LIMIT 1];
        System.assertNotEquals(homeService, null);

        Home_Services__c result = DiacoSolarUtilityInformationController.getHomeService(homeService.Id);
        System.assertNotEquals(result, null);
        System.assertEquals(homeService.Id, result.Id);
    }
    
    @isTest
    public static void getInstallationCompany() {
        Home_Services__c homeService = [SELECT Id, Installation_Company__c FROM Home_Services__c LIMIT 1];
        System.assertNotEquals(homeService, null);
        
        Account result = DiacoSolarUtilityInformationController.getInstallationCompany(homeService.Installation_Company__c);
        System.assertNotEquals(result, null);
        System.assertEquals(homeService.Installation_Company__c, result.Id);
    }
    
    @isTest
    public static void updateHomeServiceTest() {
        Home_Services__c homeService = [SELECT Id, Username__c, Type_of_Application__c FROM Home_Services__c LIMIT 1];
        System.assertNotEquals(homeService, null);
        
        homeService.Username__c = 'New test username';
        homeService.Type_of_Application__c = null;
        DiacoSolarUtilityInformationController.updateHomeService(homeService);
        homeService.Type_of_Application__c = '';
        DiacoSolarUtilityInformationController.updateHomeService(homeService);
        
        homeService = [SELECT Id, Username__c, Type_of_Application__c FROM Home_Services__c LIMIT 1];
        System.assertNotEquals(homeService, null);
        System.assertEquals(homeService.Username__c, 'New test username');
        System.assertEquals(homeService.Type_of_Application__c, 'None Selected');
    }
}