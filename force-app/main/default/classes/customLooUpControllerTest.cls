@isTest
public class customLooUpControllerTest {
	    @isTest static void testAll(){
	        Test.startTest();
			customLookUpController.fetchLookUpValues('Cody', 'User', null);
			customLookUpController.fetchLookUpValuesForInstallationAccounts('test', 'Account', null);
	        Test.stopTest();
    }
}