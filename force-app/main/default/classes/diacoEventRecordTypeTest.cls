@isTest
public class diacoEventRecordTypeTest {
    @isTest static void testAll(){
        Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel'
        );
        insert person;
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test'
        );
        insert acc;
        Home_Services__c hs = new Home_Services__c(
            Name = 'test',
            Account__c = acc.Id,
            ApptSetter__c = person.Id
        );
        insert hs;
        Installation__c install = new Installation__c(
        	Name='test',
            Home_Service__c =hs.Id
        );
        insert install;
        User u = new user();
        u.LastName = 'Test Event';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'TestEvent@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = '00e41000001hNuFAAU';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        User u2 = new user();
        u2.LastName = 'Test Public Calendar';
        u2.Email = 'test2@test.com';
        u2.Alias = 'PubliCa';
        u2.Username = 'TestEvent2@test.com';
        u2.CommunityNickname = 'test122';
        u2.LocaleSidKey = 'en_US';
        u2.TimeZoneSidKey = 'GMT';
        u2.ProfileID = '00e41000001hNuFAAU';
        u2.LanguageLocaleKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        insert u2;
        // user = [Select Id, ProfileID, Name from User where Id='005410000028YIRAA2'];
        Event event = new Event(
            Home_Service__c = hs.Id,
            RecordTypeId = '012410000013G9CAAU',
            DurationInMinutes=1,
            ActivityDateTime= Date.Today(),
            OwnerId = u.Id
        );
        insert event;
        
        Event event2 = new Event(
            //Home_Service__c = null,
            RecordTypeId = '012410000013G9AAAU',
            DurationInMinutes=1,
            ActivityDateTime= Date.Today(),
            OwnerId =u2.Id,
            Installation__c=install.Id
        );
        insert event2;
        System.debug('-------------Test Evenet----------------');
        System.debug(event2.Home_Service__c);
        /*Event event3 = new Event(
            Home_Service__c = hs.Id,
            RecordTypeId = '012410000013G9DAAU',
            DurationInMinutes=1,
            ActivityDateTime= Date.Today(),
            OwnerId =u2.Id
        );
        insert event3;*/
        test.startTest();
        String param = event.Id+',Sales';
        List<String> params = new List<String>();
        params.add(param);
        String param2 = event2.Id+',Installation';
        List<String> params2 = new List<String>();
        params2.add(param2);
        //String param3 = event3.Id+',Service Technician';
        //List<String> params3 = new List<String>();
        //params3.add(param3);
        diacoEventRecordType.REcordTypeEvent(params);
        diacoEventRecordType.REcordTypeEvent(params2);
        diacoEventRecordType rt = new diacoEventRecordType();
        rt.EventsRT(event2.Id,'Installation', false);
        rt.EventsRT(event.Id,'Sales', false);
        diacoEventPublic.Ispublic(params2);
        //diacoEventRecordType.REcordTypeEvent(params3);
        test.stopTest();
    }
}