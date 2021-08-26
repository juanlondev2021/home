@isTest
public class DiacoWalkThruFormTest {
    @testSetup public static void setup() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Username, LastName, Email, Alias, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey
        User user = new User(
            Username = 'email@domain.tld',
            LastName = 'LastName',
            Email = 'email@domain.tld',
            Alias = 'Alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert user;
        
        Home_Services__c hs = new Home_Services__c();
        insert hs;
        
        Event event = new Event(
            Home_Service__c = hs.Id,
            OwnerId = user.Id,
            DurationInMinutes = 60,
            ActivityDateTime = Date.today()
        );
        insert event;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Walk-Through Form',
            VersionData = Blob.valueOf('Test Data'),
            IsMajorVersion = true,
            PathOnClient = 'Test.png'
        );
        insert contentVersion;
        
        // A ContentDocument is created automatically after the above insert
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :contentVersion.Id LIMIT 1];
        contentDocument.Title = 'Walk-Through Form';
        update contentDocument;
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            ContentDocumentId=contentDocument.Id,
            LinkedEntityId=hs.Id
        );
        insert contentDocumentLink;
    }
    
    @isTest public static void getDataTest() {
        Event event = [SELECT Id, Home_Service__c FROM Event LIMIT 1];
        System.assert(event != null);
        
        Home_Services__c homeService = [SELECT Id FROM Home_Services__c LIMIT 1];
        System.assert(homeService != null);
        
        Map<String, sObject> result = DiacoWalkThruForm.getData(homeService.Id);
        System.assert(result != null);
        System.assert(result.get('event') == null);
        System.assert(result.get('assignedTo') == null);
        System.assert(result.get('homeService') != null);
        System.assert(result.get('formContentDocumentLink') != null);
        System.assert(result.get('formContentDocument') != null);
        System.assert(result.get('formContentVersion') != null);
        
        result = DiacoWalkThruForm.getData(event.Id);
        System.assert(result != null);
        System.assert(result.get('event') != null);
        System.assert(result.get('assignedTo') != null);
        System.assert(result.get('homeService') != null);
        System.assert(result.get('formContentDocumentLink') != null);
        System.assert(result.get('formContentDocument') != null);
        System.assert(result.get('formContentVersion') != null);
    }
    
    @isTest public static void updateAllTest() {
        Event event = [SELECT Home_Service__c FROM Event LIMIT 1];
        System.assert(event != null);
        
        Home_Services__c hs = [SELECT Id FROM Home_Services__c WHERE Id = :event.Home_Service__c LIMIT 1];
        System.assert(hs != null);
        
        Map<String, sObject> result = DiacoWalkThruForm.updateAll(event.Id, hs);
        System.assert(result != null);
        System.assert(result.get('event') != null);
        System.assert(result.get('homeService') != null);
        System.assert(result.get('assignedTo') != null);
        System.assert(result.get('formContentDocumentLink') != null);
        System.assert(result.get('formContentDocument') != null);
        System.assert(result.get('formContentVersion') != null);
    }
    
    @isTest public static void replaceFormTest() {
        Event event = [SELECT Home_Service__c FROM Event LIMIT 1];
        System.assert(event != null);
        
        Home_Services__c hs = [SELECT Id FROM Home_Services__c WHERE Id = :event.Home_Service__c LIMIT 1];
        System.assert(hs != null);
        
        ContentDocumentLink contentDocumentLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :hs.Id LIMIT 1];
        ContentDocument contentDocument = [SELECT Title, LatestPublishedVersionId FROM ContentDocument WHERE Id = :contentDocumentLink.ContentDocumentId LIMIT 1];
        ContentVersion contentVersion = [SELECT Id FROM ContentVersion WHERE Id = :contentDocument.LatestPublishedVersionId LIMIT 1];
        System.assertNotEquals(contentDocumentLink, null);
        System.assertNotEquals(contentDocument, null);
        System.assertNotEquals(contentVersion, null);
        
        ContentVersion newCV = new ContentVersion(
            Title = 'Walk-Through Form',
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
            LinkedEntityId=event.Id
        );
        insert newCDL;
        
        Map<String, sObject> result = DiacoWalkThruForm.replaceForm(contentDocumentLink, contentDocument, contentVersion, newCD.Id, hs.Id, event.Id);
        System.assert(result != null);
        System.assert(result.get('formContentDocumentLink') != null);
        System.assert(result.get('formContentDocument') != null);
        System.assert(result.get('formContentVersion') != null);
    }
}