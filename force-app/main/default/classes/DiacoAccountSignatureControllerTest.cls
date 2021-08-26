@isTest
public class DiacoAccountSignatureControllerTest {
	@testSetup
    public static void setup() {
        Account account = new Account(Name='Test Account');
        insert account;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Account Signature',
            VersionData = Blob.valueOf('Test Data'),
            IsMajorVersion = true,
            PathOnClient = 'Test.png'
        );
        insert contentVersion;
        
        // A ContentDocument is created automatically after the above insert
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument LIMIT 1];
        contentDocument.Title = 'Account Signature';
        update contentDocument;
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            ContentDocumentId=contentDocument.Id,
            LinkedEntityId=account.Id
        );
        insert contentDocumentLink;
    }
    
    @isTest
    public static void testGetSignature() {
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertNotEquals(account, null);
        
        Map<String, sObject> result = DiacoAccountSignatureController.getSignature(account.Id);
        System.assertNotEquals(result, null);
        System.assertNotEquals(result.get('ContentDocumentLink'), null);
        System.assertNotEquals(result.get('ContentDocument'), null);
        System.assertNotEquals(result.get('ContentVersion'), null);
    }
    
    @isTest
    public static void testReplaceSignature() {
        // Getting test Account for its Id
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertNotEquals(account, null);
        
        // Getting existing test file's data
        ContentDocumentLink contentDocumentLink = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :account.Id LIMIT 1];
        ContentDocument contentDocument = [SELECT Title FROM ContentDocument LIMIT 1];
        ContentVersion contentVersion = [SELECT Dealer_Certification_Title__c, Dealer_Certification_Name__c FROM ContentVersion LIMIT 1];
        System.assertNotEquals(contentDocumentLink, null);
        System.assertNotEquals(contentDocument, null);
        System.assertNotEquals(contentVersion, null);
        
        // Create a new file
        ContentVersion newCV = new ContentVersion(
            Title = 'Account Signature',
            VersionData = Blob.valueOf('New Test Data'),
            IsMajorVersion = true,
            PathOnClient = 'New Test.png'
        );
        insert newCV;

        // A ContentDocument is created automatically after the above insert
        ContentDocument newCD = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :newCV.Id LIMIT 1];
        System.assertNotEquals(newCD, null);
        
        ContentDocumentLink newCDL = new ContentDocumentLink(
            ContentDocumentId=newCD.Id,
            LinkedEntityId=account.Id
        );
        insert newCDL;
        
        // Test replacing the old file with the new file
        Map<String, sObject> result = DiacoAccountSignatureController.replaceSignature(
            contentDocumentLink,
            contentDocument,
            contentVersion,
            newCD.Id,
            account.Id
        );
        System.assertNotEquals(result, null);
        System.assertNotEquals(result.get('ContentDocumentLink'), null);
        System.assertNotEquals(result.get('ContentDocument'), null);
        System.assertNotEquals(result.get('ContentVersion'), null);
    }
}