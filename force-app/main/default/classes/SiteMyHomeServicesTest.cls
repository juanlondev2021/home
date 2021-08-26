@isTest(seealldata=true)
private class SiteMyHomeServicesTest {
    @IsTest
    static void interests() {


        Account acc   = new Account(); 
        acc.FirstName = 'Test';
        acc.LastName  = 'test';
        acc.Interests__c = 'Windows;Bath;Garage Floor Coating';
        upsert acc;

        // Delivery
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);


        Id giftCardOrderId = [SELECT Id FROM Gift_Card_Orders__c LIMIT 1]?.Id;
        Id driverId =  [SELECT Id FROM Driver__c LIMIT 1]?.Id;
        Id userAddressId = [SELECT ID FROM User_Address__c LIMIT 1]?.Id;

        Delivery_Object__c delivery = new Delivery_Object__c();        
        delivery.Person_Account__c = acc.Id;
        delivery.Driver__c = driverId;
        delivery.name = '1';
        delivery.Parent_Gift_Card_Order__c = giftCardOrderId;
        delivery.User_Address__c = userAddressId;
        delivery.Cheetah_Driver_Code__c = '0';           
        
        insert delivery;
        
        webForm__c webForm = new webForm__c();
        webForm.Name = 'Test';
        webForm.Account__c =  acc.Id;
        webForm.Interests__c = 'Windows';
        upsert webForm;
        
        Personnel__c personel  = new Personnel__c();                                                           
        personel.Kunnect_ID__c = 'test';
        personel.First_Name__c = 'test';
        personel.Last_Name__c  = 'test';
        personel.SF_User__c=UserInfo.getUserId();   
        upsert personel;
        
        Id appointmentRtConcrete = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Solar').getRecordTypeId();
        Appointment__c appointment = new Appointment__c();
        appointment.Name='test';
        appointment.RecordTypeId = appointmentRtConcrete;
        appointment.Appointment_Start_Time__c = Datetime.now();
        appointment.Person_Account__c = acc.Id;
        //upsert appointment;
        
        Test.startTest();

        
        SiteMyHomeServicesController.getDataInterests(acc.Id,new List<String>(), new List<String>{'Project_Type__c','Type_of_Service__c'},personel.Kunnect_ID__c);
        SiteMyHomeServicesController.getDataInterests(delivery.Id,new List<String>(), new List<String>{'Project_Type__c','Type_of_Service__c'},personel.Kunnect_ID__c);

        SiteMyHomeServicesController.getAppointment(acc.Id, new List<String>{'Windows','Bath','Garage Floor Coating'});
        SiteMyHomeServicesController.setAppointment(appointment,new list<String>{'2020', '10', '7', '20', '0'},2,webForm,acc,'HVAC');
        SiteMyHomeServicesController.getAppointment(acc.Id, new List<String>{'Solar'});        
        Test.stopTest();
        
    }
    
    @isTest static void account(){
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
        
        User_Address__c uAddress= new User_Address__c();
        uAddress.UserAccount__c=acc.Id;
        uAddress.Address__c=add.Id;
        Upsert uAddress;
        
        Appointment__c appointment = new Appointment__c();
        appointment.Name='test';
        appointment.RecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Concrete Coating').getRecordTypeId();
        insert appointment;
        
        List<String> picklistFields = new  List<String> {'Pool__c','Number_of_AC_Units__c','Number_of_Stories__c','State__c'};
        
        test.startTest();
            SiteMyHomeServicesController.getDataAccount(acc.Id, picklistFields, '111111');
            SiteMyHomeServicesController.getDataAccount(uAddress.Id, picklistFields, '111111');
            SiteMyHomeServicesController.setAccount(acc);                
        test.stopTest();

    }
        
    @isTest static void homeService(){
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
        
        User_Address__c u= new User_Address__c();
        u.UserAccount__c=acc.Id;
        u.Address__c=add.Id;
        Upsert u;
        
        Appointment__c appointment = new Appointment__c();
        appointment.Name='test';
        appointment.RecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Concrete Coating').getRecordTypeId();
        insert appointment;
       
        List<String> picklistFields = new  List<String> {'Existing_Keypad__c','Do_you_have_a_water_filtration_system__c','Pets__c','Types_of_Pets__c'};
        test.startTest();
        
            SiteMyHomeServicesController.getDataHomeService(acc.Id, true);
            SiteMyHomeServicesController.getDataHomeService(hs.Id, true);
            SiteMyHomeServicesController.getHomeServiceAppointment(appointment.Id, picklistFields);
            SiteMyHomeServicesController.setDataAppointment(appointment,new list<String>{'2020', '10', '7', '20', '0'},2);
            
            SiteMyHomeServicesController.getUserAddress('11111111');
        
        test.stopTest();

    }
}