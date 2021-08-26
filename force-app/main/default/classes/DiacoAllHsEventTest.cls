@isTest
public class DiacoAllHsEventTest {
   @isTest static void testAll(){
        String accountRT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String eventSalesRt = Schema.getGlobalDescribe().get('Event').getDescribe().getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        String eventInstallationRt = Schema.getGlobalDescribe().get('Event').getDescribe().getRecordTypeInfosByName().get('Installation').getRecordTypeId();
        String eventServicesRt = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Service Technician').getRecordTypeId();
        String hsWaterSalesRt = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Water Treatment Installation').getRecordTypeId();
        String installationWaterRt = Schema.SObjectType.Installation__c.getRecordTypeInfosByName().get('Water').getRecordTypeId();
		String serviceWaterRt = Schema.SObjectType.Service__c.getRecordTypeInfosByName().get('Water').getRecordTypeId();
       	List<DiacoAppoiment2__AppoinmentType__c> appType= new  List<DiacoAppoiment2__AppoinmentType__c>();
       appType.add(new DiacoAppoiment2__AppoinmentType__c(
       	   Name = 'Installation',
           DiacoAppoiment2__active__c = true
       ));
		appType.add(new DiacoAppoiment2__AppoinmentType__c(
       	   Name = 'Sales',
           DiacoAppoiment2__active__c = true
       ));
       appType.add(new DiacoAppoiment2__AppoinmentType__c(
       	   Name = 'Services',
           DiacoAppoiment2__active__c = true
       ));
       insert appType;
       DiacoAppoiment2__Industry__c ind = new DiacoAppoiment2__Industry__c();
       ind.Name='Hs';
       insert ind;
       list<DiacoAppoiment2__Sub_Industry__c> subIndustries = new list<DiacoAppoiment2__Sub_Industry__c>();
       subIndustries.add(new DiacoAppoiment2__Sub_Industry__c(
       		Name='Water',
           DiacoAppoiment2__Industry__c = ind.Id
       ));
       insert subIndustries;
       Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel',
            Kunnect_ID__c = 'test'

        );
        insert person;
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            RecordTypeId = accountRT,
            Street__c = 'test',
            City__c = 'test',
            Zip__c = '12345',
            State__c = 'AZ'

        );
        insert acc;


        Home_Services__c hs = new Home_Services__c(
            Name = 'test',
            Account__c = acc.Id,
            ApptSetter__c = person.Id,
            Home_services_Status__c = '',
            Event_Count__c = 0,
            Installation__c = null,
            Service__c = null
         
        );
        insert hs;

        /*Installation__c install = new Installation__c(
            Name='test',
            RecordTypeId = installationWaterRt,
            Home_Service__c = hs.Id
        );
        insert install;*/
       
       Service__c service = new Service__c (
       		NAme = 'Test',
            RecordTypeID = serviceWaterRt,
            Home_Service__c = hs.Id
       );

        Event event = new Event(
            WhatId = hs.Id,
            RecordTypeId = eventSalesRt,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = null,
            IsPublic__c = false
        );
        insert event;

        Event event2 = new Event(
            //WhatId = install.Id,
            WhatId = hs.Id,
            //RecordTypeId = eventInstallationRt,
            RecordTypeId = eventSalesRt,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = null,
            IsPublic__c = false
        );
        insert event2;
       /*List<Event> events =new List<Event>();
       events.add(event);
       events.add(event2);
       insert events;*/
       /*Event event3 = new Event(
            WhatId = install.Id,
            RecordTypeId = eventSalesRt,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = hs.id,
            IsPublic__c = false
        );*/
        

      /*  Event event3 = new Event(
            WhatId = hs.Id,
            RecordTypeId = eventServicesRt,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = hs.Id,
            IsPublic__c = false,
            Current_Appointment__c = False,
            Service__C = null,
            confirmation_Installation__c = null,
            Appt_result_IS__c = null,
            User_Rep__c = null,
            Dispatched_By__c = null,
            Service_Status__c = null,
            OwnerID = UserInfo.getUserId()
        );
        insert event3; */


       // String param = event.Id+','+event.RecordTypeId+','+'Sales'+','+event.WhatId;
       // String param1 = event2.Id+','+event.RecordTypeId+','+'Installation'+','+event2.WhatId;
       // String param2 = event.Id+','+event.RecordTypeId+','+'Service Technician'+','+event.WhatId; 
        
       
       List<String> params = new List<String>();
       List<String> params1 = new List<String>();
       // List<String> params2 = new List<String>();
       // 
        params.add(event.Id);
       	params1.add(event2.Id);
       // params2.add(param2);
       
        test.startTest();
       //insert event3;
        DiacoAllHsEvent.CurrentEvent(params);
        DiacoAllHsEvent.CurrentEvent(params1);
       // DiacoAllHsEvent.CurrentEvent(params2);

        test.stopTest(); 
 
    }
}