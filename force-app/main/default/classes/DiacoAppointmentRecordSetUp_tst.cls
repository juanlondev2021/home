@isTest
private class DiacoAppointmentRecordSetUp_tst {
    @TestSetup
    static void makeData() {
        DiacoAppointmentRecordSetUp_ctr.WrappedResponse homeService = DiacoAppointmentRecordSetUp_ctr.getHomesviceSetting();
        DiacoAppointmentRecordSetUp_ctr.WrappedResponse appointment = DiacoAppointmentRecordSetUp_ctr.getAppointmentSetting();
        DiacoAppointmentRecordSetUp_ctr.WrappedResponse interest = DiacoAppointmentRecordSetUp_ctr.getInterestSetting();

        list<String> interests = new List<String>();
        Map<String, String>  accountInterests = interest.account_interests;
        for (String intrest : accountInterests.keySet()) {
            interests.add(intrest);
        }

        Appointment_RecordType_mtd__c homeServiceSettgn = new Appointment_RecordType_mtd__c(
            Name = homeService.appointment_recordtypes[0].Id, 
            RT_Home_Service_Id__c = homeService.homeservice_recordtypes[0].Id,
            Type__c = 'HomeService');

        Appointment_RecordType_mtd__c appointmentSettgn = new Appointment_RecordType_mtd__c(
            Name = appointment.homeservice_recordtypes[0].Id, 
            RT_Appointment_Id__c = appointment.appointment_recordtypes[0].Id,
            Type__c = 'Appointment');

        Appointment_RecordType_mtd__c interestSettgn = new Appointment_RecordType_mtd__c(
            Name = interests[0], 
            Interest_Name__c =  interests[0],
            RT_Appointment_Id__c = interest.appointment_recordtypes[0].Id,
            Type__c = 'Interest');
        
        upsert new list<Appointment_RecordType_mtd__c>{homeServiceSettgn,appointmentSettgn,interestSettgn};
    }

    @IsTest
    static void appointmentRecordSetUpTest() {
        list<Appointment_RecordType_mtd__c> appointmentsMtd = [SELECT Id FROM Appointment_RecordType_mtd__c];
        Test.startTest();

            System.assertEquals(appointmentsMtd.isEmpty(), false, 'Appointment setup is empty');
            DiacoAppointmentRecordSetUp_ctr.setAppointmentRt(appointmentsMtd);
            DiacoAppointmentRecordSetUp_ctr.delAppointmentRt(appointmentsMtd);

        Test.stopTest();
    }

    @IsTest
    static void interestToAppointmentDTOTest() {
        Test.startTest();
        
        DiacoInterestToAppointmentDTO.Interests intetests = DiacoInterestToAppointmentDTO.getInterests(new List<String>(),new List<String>());
        Map<String,DiacoInterestToAppointmentDTO.AppointmentType> recordTypeByIntrsName = DiacoInterestToAppointmentDTO.getRecordTypeRelateToInterest();
        Map<Id,DiacoInterestToAppointmentDTO.AppointmentType> recordTypeByApptId = DiacoInterestToAppointmentDTO.getRecordTypeRelateToInterest(new List<String>());
        System.assertEquals(intetests.activatedInterests.isEmpty(), false, 'Interest Setup is empty');
        System.assertEquals(recordTypeByIntrsName.isEmpty(), false, 'AppointmentType by insterests Name is empty');
        System.assertEquals(recordTypeByIntrsName.isEmpty(), false, 'Get recortType AppointmentType by Appointment Id is empty');
        
        Test.stopTest();
        
    }
}