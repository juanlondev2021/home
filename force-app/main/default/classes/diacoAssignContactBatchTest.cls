@isTest
public class diacoAssignContactBatchTest {
	@testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        ID Rt = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount').getRecordTypeId();
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(FirstName= 'Test'+i, LastName='Test'+i,
                billingcity='New York', billingcountry='USA',
                                    Street__c='Test', Zip__c='12345',
                                    State__c='AZ', City__c='City',
                                    RecordTypeId = Rt));
        }
        insert accounts;
    }
    
    static testmethod void test() {        
        Test.startTest();
        diacoAssignContactBatch uca = new diacoAssignContactBatch(10);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
    }


    static testmethod void deleteContact() {      
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = [select Id, FirstName, LastName, PersonEmail, Phone, Street__c, Zip__c, State__c, City__c from Account];
        for(Account acc : accounts) {
            Contact contact = new Contact();
            contact.FirstName = acc.FirstName;
            contact.LastName = acc.LastName;
            contact.MailingCity = acc.City__c;
            contact.MailingState = acc.State__c;
            contact.MailingStreet = acc.Street__c;
            contact.Geo_Accuracy__c = true;
            contact.MailingPostalCode = acc.Zip__c;
            contact.Person_Account__c = acc.Id;
            contacts.add(contact);
        }
        Test.startTest();
        insert contacts;
            DiacoDelateContactGeoAccuracyBatch uca = new DiacoDelateContactGeoAccuracyBatch(10);
            Id batchId = Database.executeBatch(uca);
        Test.stopTest();
    }
}