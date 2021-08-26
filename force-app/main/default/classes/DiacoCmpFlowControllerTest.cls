@isTest public class DiacoCmpFlowControllerTest {
    @isTest static void testAll(){
        Account acc   = new Account();
        acc.FirstName = 'Test';
        acc.LastName  = 'test';
        Upsert acc;
        User usr = [Select Id from User where Name='Cody Garrett' limit 1];
        Personnel__c personel  = new Personnel__c();                                                           
        personel.Kunnect_ID__c = 'test';
        personel.First_Name__c = 'test';
        personel.Last_Name__c  = 'test';
        personel.SF_User__c=usr.Id;
        Upsert personel;
        
        Id rtId = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Water Treatment Sales').getRecordTypeId();
        Home_Services__c hs = new Home_Services__c();                                                                          
        hs.Name                             = 'Test Test - Water Treatment Sales';
        hs.RecordTypeId                     = rtId;
        hs.Account__c                       = acc.Id;
        hs.ApptSetter__c                    = personel.Id;
        hs.Confirmation_Call_Count__c       = 5;                                                                                
        hs.Appointment_Date_Time__c         =null;
        Upsert hs;
        
        Address__c add= new Address__c();
        add.Name='test';
        Upsert add;
        salesRabbitSchedule__c sr= new salesRabbitSchedule__c();
        sr.minSalePrice__c=58.2;
        sr.maxSalePrice__c=88.2;
        sr.token__c='alv';
        Upsert sr;
        
        User_Address__c u= new User_Address__c();
        u.UserAccount__c=acc.Id;
        u.Address__c=add.Id;
        Upsert u;
        /*
        Event ev   = new Event();
        ev.Subject = 'Test';
        ev.StartDateTime = System.now();
        ev.EndDateTime=System.now();
        ev.Home_Service__c=hs.Id;
        ev.WhatId=hs.Id;
        Upsert ev;*/

        County__c countyA = new County__c(County_Name__c='County A');
        County__c countyB = new County__c(County_Name__c='County B');
        List<County__c> counties = new List<County__c>{countyA, countyB};
        insert counties;

        Appointment__c appointment = new Appointment__c();
        appointment.Name='test';
        appointment.RecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Concrete Coating').getRecordTypeId();
        insert appointment;

        List<String> fieldNames = new  List<String> {'Project_Type__c','Type_of_Service__c'};
        List<String> picklistFields = new  List<String> {'Existing_Keypad__c','Do_you_have_a_water_filtration_system__c','Pets__c','Types_of_Pets__c',
                                                        'Pest_loose_in_backyard__c', 'Backyard_gate_locked__c','Age_of_Current_AC_System__c',
                                                        'Occupancy_of_House__c','Type_of_Material__c','Leak_Damage__c','Timeline_of_Intent__c',
                                                        'Frequency_Desired__c','Sq_Ft_of_Project_Area__c','Design__c','Included_in_Landscape_Project__c',
                                                        'Chemical_Type__c','Area_of_Concrete_Surface__c','Area_to_be_coated__c','Existing_Coating__c',
                                                        'Existing_Issue_with_current_door__c','Type_of_Material_on_Current_Door__c','Area_of_Concrete__c',
                                                        'Rooms_included_in_project__c','Description_of_closet__c','Frequency_Requested__c','Floorplan__c',
                                                        'Cabinets__c','Bath_Floorplan__c','Main_Area_of_Concern__c','Payment_Type__c',
                                                        'Rooms_to_be_Installed__c','Number_of_Rooms__c','Utility_Provider__c','Number_of_Stories_Picklist__c',
                                                        'Type_of_System_to_be_installed__c','Number_of_Windows__c'};

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('getPicklistValueByRecordtype');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        test.startTest();

            DiacoCmpFlowController.getData(acc.Id, true);
            DiacoCmpFlowController.getData(hs.Id, true);
            DiacoCmpFlowController.getAppointment(appointment.Id, 'Appointment__c', appointment.RecordTypeId, fieldNames, picklistFields);
            DiacoCmpFlowController.setAppointment(appointment,new list<String>{'2020', '10', '7', '20', '0'},2);
            
            //DiacoCmpFlowController.saveDataEventHSId(hs.Id);
            DiacoCmpFlowController.getAccountId(u.Id,True);
            DiacoCmpFlowController.typeObject(acc.Id);
            DiacoCmpFlowController.getDataCustomerOne(acc.Id);
            DiacoCmpFlowController.getObjectType(acc.Id);
            DiacoCmpFlowController.getAccount(u.Id);
            DiacoCmpFlowController.getAccount(acc.Id);
            DiacoCmpFlowController.getAccount(hs.Id);
            //DiacoCmpFlowController.getAccount(ev.Id);
            //DiacoCmpFlowController.saveDataEvent(ev);
            //DiacoCmpFlowController.getDataEvent(ev.Id);
            //DiacoCmpFlowController.saveInformation(ev.Id,acc.Id,'Event');
            //DiacoCmpFlowController.getAccountId(ev.Id,False);
            DiacoCmpFlowController.getPersonnel();
            DiacoCmpFlowController.getPersonnelOne('test');
            DiacoCmpFlowController.getUserAddress('11111111');
            Map<String, String> countyResult = DiacoCmpFlowController.getCountyData();

        test.stopTest();
        System.assertNotEquals(countyResult, null);
        System.assertEquals(countyResult.size(), 2);
    }
}