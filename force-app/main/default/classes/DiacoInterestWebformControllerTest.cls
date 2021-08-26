@isTest
private class DiacoInterestWebformControllerTest {
    private static Id appointmentRtConcrete = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Concrete Coating').getRecordTypeId();

    @TestSetup
    static void makeData() {
        List<String> interests = new List<String>{'Concrete Coating','Windows'};
        List<Appointment_RecordType_mtd__c> interestSettgn = new List<Appointment_RecordType_mtd__c>();
        integer interestSize = interests.size();
        for (Integer i = 0; i < interestSize; i++) {
            interestSettgn.add(
                new Appointment_RecordType_mtd__c(
                    Name = interests[i], 
                    Interest_Name__c =  interests[i],
                    Interest_Activate__c = true,
                    RT_Appointment_Id__c = diacoKnifeFunc.getRecordTypeIdbyName('Appointment__c', interests[i]),
                    Type__c = 'Interest'
                )
            );
        }
        insert interestSettgn;

        Account acc   = new Account(); 
        acc.FirstName = 'Test';
        acc.LastName  = 'test';
        acc.Interests__c = 'Windows;Bath;Garage Floor Coating';
        insert acc;

        Personnel__c personel  = new Personnel__c();                                                           
        personel.Kunnect_ID__c = 'test';
        personel.First_Name__c = 'test';
        personel.Last_Name__c  = 'test';
        personel.SF_User__c=UserInfo.getUserId();
        insert personel;
		
        Appointment__c appointment = new Appointment__c();
        appointment.Name='test';
        appointment.RecordTypeId = appointmentRtConcrete;
        appointment.Appointment_Start_Time__c = Datetime.now();
        appointment.Person_Account__c = acc.Id;
        insert appointment;
    }

    @IsTest
    static void test(){
        List<Account> accts = [SELECT Name FROM Account LIMIT 1];
        List<Appointment__c> appointments = [SELECT Name FROM Appointment__c LIMIT 1];
        String kunnectId = [SELECT Kunnect_ID__c FROM Personnel__c LIMIT 1]?.Kunnect_ID__c;

        Test.startTest();

            System.assertEquals(!accts.isEmpty(), true, 'list Account is Empty');
            System.assertEquals(!appointments.isEmpty(), true, 'list Appointments is Empty');
            System.assertEquals(kunnectId != null, true, 'Kunnect_ID__c is null');
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('getPicklistValueByRecordtype');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);

            DiacoInterestWebformController.getData(accts[0].Id, new List<String>{'Project_Type__c','Type_of_Service__c'},kunnectId);
            DiacoInterestWebformController.getData(accts[0].Id, new List<String>{'Project_Type__c','Type_of_Service__c'},null);
            DiacoInterestWebformController.getData(null, new List<String>{'Project_Type__c','Type_of_Service__c'},null);
            DiacoInterestWebformController.getAppointment(accts[0].Id, new List<String>{'Windows','Bath','Concrete Coating'});
            DiacoInterestWebformController.getPicklistValueByRecordtype('Appointment__c', 'Project_Type__c', new List<Id>{appointmentRtConcrete});
            DiacoInterestWebformController.setAppointment(appointments[0],new list<String>{'2020', '10', '7', '20', '0'},2,accts[0],'HVAC');

        Test.stopTest();
        
    }
}