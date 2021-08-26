@isTest
public class AccountHSStatusUpdateHelperTest {
    @testSetup
    public static void testSetup() {
        Account testAccount = new Account(FirstName = 'Test', LastName = 'Account');
        insert testAccount;
    }
    
    @isTest
    public static void testHomeServiceRecordTypeToAccountStatusField() {
        System.assertEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField(null), null);
        
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Carpet & Tile Cleaning'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Garage Doors'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Home Automation'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('HVAC'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Internet-'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Lock Smith'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Maid Service'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Pest Control'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Pool Maintenance'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Remodel'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Solar'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField('Water Treatment'), null);
    }
    
    @isTest
    public static void testGetAccountStatus() {
        Account testAccount = [SELECT Carpet_Tile_Cleaning_Status__c, Garage_Doors_Status__c, Home_Automation_Status__c, HVAC_Status__c, Internet_Cable_Satellite_Status__c, Lock_Smith_Status__c, Maid_Service_Status__c, Pest_Control_Status__c, Pool_Maintenance_Status__c, Remodel_Status__c, Solar_Status__c, Water_Status__c FROM Account WHERE (FirstName = 'Test' AND LastName = 'Account') LIMIT 1];
        System.assertNotEquals(testAccount, null);
        
        System.assertEquals(AccountHSStatusUpdateHelper.getAccountStatus(testAccount, 'Invalid Record Type'), null);
        
        testAccount.Garage_Doors_Status__c = 'CXL';
        System.assertEquals(AccountHSStatusUpdateHelper.getAccountStatus(testAccount, 'Garage Doors'), 'CXL');
    }
    
    @isTest
    public static void testUpdateAccountStatus() {
        Account testAccount = [SELECT Carpet_Tile_Cleaning_Status__c, Garage_Doors_Status__c, Home_Automation_Status__c, HVAC_Status__c, Internet_Cable_Satellite_Status__c, Lock_Smith_Status__c, Maid_Service_Status__c, Pest_Control_Status__c, Pool_Maintenance_Status__c, Remodel_Status__c, Solar_Status__c, Water_Status__c FROM Account WHERE (FirstName = 'Test' AND LastName = 'Account') LIMIT 1];
        System.assertNotEquals(testAccount, null);
        
        System.assertEquals(AccountHSStatusUpdateHelper.updateAccountStatus(testAccount, 'Invalid Record Type', 'STD'), false);
        
        testAccount.Garage_Doors_Status__c = 'Sold';
        System.assertEquals(AccountHSStatusUpdateHelper.updateAccountStatus(testAccount, 'Garage Doors', 'STD'), true);
    }
    
    @isTest
    public static void testHomeServiceRecordTypeToAccountDNCField() {
        System.assertEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField(null), null);
        
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Carpet & Tile Cleaning'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Garage Doors'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Home Automation'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('HVAC'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Internet-'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Lock Smith'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Maid Service'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Pest Control'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Pool Maintenance'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Remodel'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Solar'), null);
        System.assertNotEquals(AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField('Water Treatment'), null);
    }
    
    @isTest
    public static void testGetAccountDNC() {
        Account testAccount = [SELECT DNC_Carpet_Tile_Cleaning__c, DNC_Garage_Doors__c, DNC_Home_Automation__c, DNC_HVAC__c, DNC_Internet_Cable_Satellite__c, DNC_Lock_Smith__c, DNC_Maid_Service__c, DNC_Pest_Control__c, DNC_Pool_Maintenance__c, DNC_Remodel__c, DNC_Solar__c, DNC_Water__c FROM Account WHERE (FirstName = 'Test' AND LastName = 'Account') LIMIT 1];
        System.assertNotEquals(testAccount, null);

        System.assertEquals(AccountHSStatusUpdateHelper.getAccountDNC(testAccount, 'Invalid Record Type'), null);
        
        testAccount.DNC_Garage_Doors__c = true;
        System.assertEquals(AccountHSStatusUpdateHelper.getAccountDNC(testAccount, 'Garage Doors'), true);
    }
    
    @isTest
    public static void testUpdateAccountDNC() {
        Account testAccount = [SELECT DNC_Carpet_Tile_Cleaning__c, DNC_Garage_Doors__c, DNC_Home_Automation__c, DNC_HVAC__c, DNC_Internet_Cable_Satellite__c, DNC_Lock_Smith__c, DNC_Maid_Service__c, DNC_Pest_Control__c, DNC_Pool_Maintenance__c, DNC_Remodel__c, DNC_Solar__c, DNC_Water__c FROM Account WHERE (FirstName = 'Test' AND LastName = 'Account') LIMIT 1];
        System.assertNotEquals(testAccount, null);
        
        System.assertEquals(AccountHSStatusUpdateHelper.updateAccountDNC(testAccount, 'Invalid Record Type', true), false);
        
        testAccount.Garage_Doors_Status__c = 'Sold';
        System.assertEquals(AccountHSStatusUpdateHelper.updateAccountDNC(testAccount, 'Garage Doors', true), true);
    }
}