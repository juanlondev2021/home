@isTest
public class diacoAlarmComControllerTest {
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
        
        DiacoAlarm__DiacoSiteContact__c dsc = new DiacoAlarm__DiacoSiteContact__c();
        dsc.Name = 'test';
        dsc.DiacoAlarm__DiacoCustomerAlarm__c = ca.Id;
        dsc.DiacoAlarm__DiacoKeyType__c = 'Site';
        dsc.DiacoAlarm__DiacoPhone__c = '7586645';
        insert dsc;   
        
        DiacoAlarm__Diaco_Customer_Alarm__c customerAlarm =  new DiacoAlarm__Diaco_Customer_Alarm__c();
        customerAlarm.DiacoAlarm__DiacoFirstNameAddress__c='test';
        customerAlarm.DiacoAlarm__DiacoLastnameAddress__c='test';
        customerAlarm.DiacoAlarm__DiacoCustomerAccountEmail__c='test@test.test';
        customerAlarm.DiacoAlarm__DiacoDesiredLoginName__c='test';
        customerAlarm.Name='test';
        customerAlarm.DiacoAlarm__DiacoCountryIdAddressWithName__c='USA';
        customerAlarm.DiacoAlarm__DiacoCityAddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoStateAddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoZipCodeAddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoStreet1AddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoInstallationTimeZone__c='Norte';
        customerAlarm.DiacoAlarm__DiacoSameContactAddress__c=true;
        customerAlarm.DiacoAlarm__DiacoPanelType__c='NX';
        customerAlarm.DiacoAlarm__DiacoModemSerialNumber__c='12345678910111213';
        customerAlarm.DiacoAlarm__DiacoCentralStationForwardingOption__c='Never';
        customerAlarm.DiacoAlarm__DiacoCustomerAccountPhone__c='12345678';
        customerAlarm.DiacoAlarm__DiacoPhoneAddress__c = '12345678';
        customerAlarm.DiacoAlarm__DiacoCentralStationReceiverNumber__c='123456789101112';
        customerAlarm.DiacoAlarm__DiacoInstanceWebserviceCutomer__c=di.Id;
        
        test.startTest();
        
        diacoAlarmComController.saveHomeService(hs.Id, customerAlarm, 'insert');
        diacoAlarmComController.saveHomeService(hs.Id, ca, 'update');
        diacoAlarmComController.getSiteContacts(ca.Id);
        diacoAlarmComController.getSite(ca.Id);
        diacoAlarmComController.deleteSiteContact(dsc.Id);
        diacoAlarmComController.getDataCustomerOne(hs.Id);
        diacoAlarmComController.getRecordTypeFromHS(hs.Id);
        diacoAlarmComController.getObjectType(hs.Id);
        diacoAlarmComController.getAccount(hs.Id);
        diacoAlarmComController.getLastInstance();
        diacoAlarmComController.getInstances();
        diacoAlarmComController.getPickListValues('DiacoAlarm__Diaco_Customer_Alarm__c', new List<String>{'DiacoAlarm__DiacoCsEventGroupsToForward__c','DiacoAlarm__DiacoPropertyType__c'} );
        
        test.stopTest();
        
    }

}