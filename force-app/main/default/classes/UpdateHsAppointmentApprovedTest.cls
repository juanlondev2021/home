@isTest
private class UpdateHsAppointmentApprovedTest {
    @IsTest
    static void test(){
        
        Id accRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id hsRecordTypeId  = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Home Automation Sales').getRecordTypeId();
        Id apptRecordTypeId  = Schema.SObjectType.Appointment__C.getRecordTypeInfosByName().get('Home Automation').getRecordTypeId();

        Account acc = new Account();
        acc.Recordtypeid = accRecordTypeId;
        acc.FirstName       = 'Test acc';
        acc.LastName        = 'last test';
        acc.City__c         =  'City';
        acc.County__c       = 'test';
        insert acc;

        Product__c product = new Product__c(
            Name                 = '',
            Active__c            = true,
            Cost__c              = 12.32,
            Installation_Cost__c = 12.23,
            Product_Type__c      = 'Home Automation'
            
        );
        insert product;

        List<Home_Services__c> hs = new List<Home_Services__c>();
        hs.add(new Home_Services__c(
            Name                          = '',
            Account__c                    = acc.Id,
            Recordtypeid                  = hsRecordTypeId,
            Home_Services_Status__c       = '',
            Sales_Event_Current_Status__c = '',
            Event__c                      = '',
            Appt_Sale_Status__c = 'Sale Approved'
        ));

        Appointment_RecordType_mtd__c appointmentSettgn = new Appointment_RecordType_mtd__c(
            Name = hsRecordTypeId, 
            RT_Appointment_Id__c = apptRecordTypeId,
            Type__c = 'Appointment');
        upsert appointmentSettgn;
        
        test.startTest();

            insert hs;
        
            UpdateHsAppointmentApproved updateJob = new UpdateHsAppointmentApproved(hs);
            ID jobID = System.enqueueJob(updateJob);
            //hs[0].Appt_Sale_Status__c = 'Sale Approved';
            //update hs;
            
        test.stopTest();
    }
}