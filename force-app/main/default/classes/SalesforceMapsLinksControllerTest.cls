@isTest
public class SalesforceMapsLinksControllerTest {
    @testSetup public static void setupTests() {
        Account a = new Account(LastName = 'Test Account');
        insert a;
    }
 
    @isTest public static void testConstructor() {
        Account a = [SELECT Id FROM Account LIMIT 1];
        SalesforceMapsLinksController controller;
        
        controller = new SalesforceMapsLinksController();

        ApexPages.currentPage().getParameters().put('RecordId', '');
        controller = new SalesforceMapsLinksController();
        
        ApexPages.currentPage().getParameters().put('RecordId', 'invalid-id');
        controller = new SalesforceMapsLinksController();

        ApexPages.currentPage().getParameters().put('RecordId', '00103000006Bp7jAAC');
        controller = new SalesforceMapsLinksController();

        ApexPages.currentPage().getParameters().put('RecordId', a.Id);
        controller = new SalesforceMapsLinksController();

        a.BillingLatitude = 1;
        a.BillingLongitude = -1;
        a.BillingStreet = 'Street';
        a.BillingCity = 'City';
        a.BillingState = 'State';
        a.BillingPostalCode = '12345';
        update a;

        ApexPages.currentPage().getParameters().put('RecordId', a.Id);
        controller = new SalesforceMapsLinksController();
    }
}