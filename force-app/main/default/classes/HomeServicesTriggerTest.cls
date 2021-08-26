/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-21-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-21-2020   William Aldana   Initial Version
 * 1.0   11-06-2020   Fabian Pineda    Added tests for new method 'HomeServicesTriggerHelper.HomeServiceUpdateFinanceTaxHandler'
**/
@isTest(seeAllData = false)
private class HomeServicesTriggerTest {
 
    @isTest public static void test() {
        dsms.diacoSmsExternalTest.setSetup();
        Process_Bypass_Flags__c processBypassSettings = new Process_Bypass_Flags__c(
            Appointment__c = true,
            Home_Services__c = true
        );
        insert processBypassSettings;

        Id accRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id hsRecordTypeId  = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Home Automation Sales').getRecordTypeId();
        Id eventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
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

        Finance_Package__c fp = new Finance_Package__c(
            Name = 'Test Name',
            Activation_Emergency_Video_LEASE__c = 0,
            Activation_Emergency_Video_PURCHASE__c = 0,
            Equipment_Min_Payment__c = 0,
            Monitoring__c = 0,
            Monthly_Payment_LEASE__c = 0,
            Monthly_Payment_PURCHASE__c = 0,
            Monthly_Renewal_LEASE__c = 0,
            Monthly_Renewal_PURCHASE__c = 0,
            Monthly_Term_LEASE__c = 0,
            Monthly_Term_PURCHASE__c = 0,
            Payment_Factor__c = 0,
            Purchase__c = 0,
            Total_Min_Payments__c = 0,

            Tax__c = true
        );
        insert fp;

        List<Home_Services__c> hs = new List<Home_Services__c>();
        hs.add(new Home_Services__c(
            Name                          = '',
            Account__c                    = acc.Id,
            Recordtypeid                  = hsRecordTypeId,
            Home_Services_Status__c       = '',
            Sales_Event_Current_Status__c = '',
            Event__c                      = '',
            Tax__c                        = 'Yes',
            FinanceId__c                  = fp.Id
        ));
        insert hs;

        Line_Item__c lItem = new Line_Item__c(
            Name = '',
            Product__c = product.Id,
            Home_Service__c = hs[0].Id
        );
        insert lItem;

        Installation__c ins = new Installation__c(
            Name = '',
            Home_Service__c = hs[0].Id,
            Sub_Categories__c = ''
        );
        List<Installation__c> insList = new List<Installation__c>();
        insList.add(ins);
        map<id, Installation__c> oldins = new map<id, Installation__c>();
        oldins.put(insList[0].id,insList[0]);
        map<id, Home_Services__c> oldHS = new map<id, Home_Services__c>();
        oldHS.put(hs[0].id,hs[0]);

        hs[0].Appt_Sale_Status__c = 'Sale Approved'; //Slack - HS Payment Process Builder
        
        Appointment_RecordType_mtd__c appointmentSettgn = new Appointment_RecordType_mtd__c(
            Name = hsRecordTypeId, 
            RT_Appointment_Id__c = apptRecordTypeId,
            Type__c = 'Appointment');
        upsert appointmentSettgn; //SMS Message - Appointment Main Process Builder

        insert insList;

        hs[0].Tax__c = 'No';

        test.startTest();
        update hs;
        
        HomeServicesTriggerHelper.beforeUpdate(hs, oldHS);
        HomeServicesTriggerHelper.afterUpdate(hs, oldHS);
        
        HomeServicesTriggerHelper.beforeUpdate2(hs, oldHS);
        HomeServicesTriggerHelper.afterUpdate2(hs, oldHS);
        HomeServicesTriggerHelper.afterUpdate2(hs, oldHS);

        HomeServicesTriggerHelper.AppointmentSaleApproved(hs, oldHS,true);
        test.stopTest();
    }
}