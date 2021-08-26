@isTest
public class diacoEventCurrentTest {
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
        Event event = new Event(
            Home_Service__c = hs.Id,
            RecordTypeId = '012410000013G9CAAU',
            DurationInMinutes=1,
            ActivityDateTime= Date.Today()
        );
        insert event;
        test.startTest();
        String param = event.Id+','+event.RecordTypeId+','+event.Home_Service__c;
        List<String> params = new List<String>();
        params.add(param);
		diacoEventCurrent.CurrentEvent(params);		
        test.stopTest();
    }
}