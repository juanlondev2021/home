@isTest
public class DiaAlarmComCodeWordTest {
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
        
        DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c s= new DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c();
        s.Name='test';
        s.DiacoAlarm__DiacoUsername__c='test';
        s.DiacoAlarm__DiacoPassword__c='test';
        insert s;
        
        DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c di=new DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c();
        di.Name='Test';
        di.DiacoAlarm__DiacoPassword__c='test';
        di.DiacoAlarm__DiacoUsername__c='test';
        insert di;
        
        
        DiacoAlarm__Diaco_Customer_Alarm__c ca =  new DiacoAlarm__Diaco_Customer_Alarm__c();
        ca.DiacoAlarm__DiacoFirstNameAddress__c='test';
        ca.DiacoAlarm__DiacoLastnameAddress__c='test';
        ca.DiacoAlarm__DiacoCustomerAccountEmail__c='test@test.test';
        ca.DiacoAlarm__DiacoDesiredLoginName__c='test';
        ca.Name='test';
        ca.DiacoAlarm__DiacoCountryIdAddressWithName__c='USA';
        ca.DiacoAlarm__DiacoCityAddressWithName__c='test';
        ca.DiacoAlarm__DiacoStateAddressWithName__c='test';
        ca.DiacoAlarm__DiacoZipCodeAddressWithName__c='test';
        ca.DiacoAlarm__DiacoStreet1AddressWithName__c='test';
        ca.DiacoAlarm__DiacoInstallationTimeZone__c='Norte';
        ca.DiacoAlarm__DiacoSameContactAddress__c=true;
        ca.DiacoAlarm__DiacoPanelType__c='NX';
        ca.DiacoAlarm__DiacoModemSerialNumber__c='12345678910111213';
        ca.DiacoAlarm__DiacoCentralStationForwardingOption__c='Never';
        ca.DiacoAlarm__DiacoCustomerAccountPhone__c='12345678';
        ca.DiacoAlarm__DiacoCentralStationReceiverNumber__c='123456789101112';
        ca.DiacoAlarm__DiacoInstanceWebserviceCutomer__c=di.Id;
        insert ca;
        
        Home_Services__c hs = new Home_Services__c(
        	Name = 'test',
            Account__c = acc.Id,
            ApptSetter__c = person.Id,
            Customer_Alarm__c=ca.Id
        );
        insert hs;
        
        
        
        DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c iwa = new DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c(
            Name='test',
            DiacoAlarm__DiacoUsername__c='test',
            DiacoAlarm__DiacoPassword__c='test'
        );
        insert iwa;
        
        DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c iA = new DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c(
        	Name='Test',
            DiacoAlarm__DiacoPassword__c = '123456', 
            DiacoAlarm__DiacoUsername__c = 'test'
        );
        insert iA;
        DiacoAlarm__DiacoSiteAvantguard__c site = new DiacoAlarm__DiacoSiteAvantguard__c(
        	DiacoAlarm__Diaco_Customer_Alarm__c = ca.Id,
            DiacoAlarm__DiacoInstanceSecurityAvantguard__c = s.Id,
            DiacoAlarm__DiacoSiteName__c = 'Test'
        );
        insert site;
        
        DiacoAlarm__DiacoCodeWord__c cw =new DiacoAlarm__DiacoCodeWord__c(
        	Name = 'TEst',
            DiacoAlarm__DIacoSiteAvantguard__c = site.Id
        );
      	insert cw;
        test.startTest();
        DiaAlarmComCodeWord.getSite(ca.Id);
        DiaAlarmComCodeWord.getCodeWords(site.Id);
        DiaAlarmComCodeWord.deleteCodeWord(cw.Id);
        test.stopTest();
        
    }
}