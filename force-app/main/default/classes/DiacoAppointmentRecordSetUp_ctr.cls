/**
 *
 * Diaco
 * Project:			Appointment Recordtype Set Up
 * Description:		Class reponsible provide method to DiacoAppointmentRecordtype_SetUp
 * Testclass        DiacoAppointmentRecordSetUp_tst
 * Changes (Version)
 * _________________________________________
 *
 * 			No.		Date			Author					Description
 * 			____	__________      __________________ 		_____________________________________
 * @version	1.0		12/08/2020		Jull Quintero Daza	    Initial implementation  of the class.
 * @version	2.0		24/09/2020		Jull Quintero Daza	    Initial implementation  of the class.

 */

public with sharing class DiacoAppointmentRecordSetUp_ctr {

/**
 * This method is responsible to get setting type HomeService
 * 
 * This method is used in:
 * DiacoAppointmentRecordType_HomeServiceSetUp.cmp
 * 
 * @return 
 * List setting type HomeService, 
 * List recordtype object Home_Services__c and Appointment__c
 **/
    @AuraEnabled
    public static WrappedResponse getHomesviceSetting() {
        List<Appointment_RecordType_mtd__c> appointment_mtd = [SELECT Id,Type__c,Name,RT_Home_Service_Id__c, PartnerId__c 
                                                                FROM Appointment_RecordType_mtd__c 
                                                                WHERE Type__c = 'HomeService'];
                                                                
        List<RecordType> homeservice_recordtypes = diacoKnifeFunc.getDataRecordType('Home_Services__c');
        List<RecordType> appointment_recordtypes = diacoKnifeFunc.getDataRecordType('Appointment__c');

        return new WrappedResponse(
            appointment_mtd,
            homeservice_recordtypes,
            appointment_recordtypes
        );
    }

/**
 * This method is responsible to get setting type Appointment
 * 
 * This method is used in:
 * DiacoAppointmentRecordType_HomeServiceSetUp
 * 
 * @return 
 * List setting type Appointment,
 * List recordtype object Home_Services__c and Appointment__c
 **/
    @AuraEnabled
    public static WrappedResponse getAppointmentSetting() {
        List<Appointment_RecordType_mtd__c> appointment_mtd = [SELECT Id,Type__c,Name,RT_Appointment_Id__c, PartnerId__c 
                                                                FROM Appointment_RecordType_mtd__c 
                                                                WHERE Type__c = 'Appointment'];
                                                                
        List<RecordType> homeservice_recordtypes = diacoKnifeFunc.getDataRecordType('Home_Services__c');
        List<RecordType> appointment_recordtypes = diacoKnifeFunc.getDataRecordType('Appointment__c');

        return new WrappedResponse(
            appointment_mtd,
            homeservice_recordtypes,
            appointment_recordtypes
        );
    }

/**
 * This method is responsible to get setting type Interest
 * 
 * This method is used in:
 * DiacoAppointmentRecordType_InterestSetUp
 * 
 * @return 
 * List setting type Interest, 
 * List Picklistvalues for field Interests__c in object Account 
 * List recordtype object Appointment__c
 **/
    @AuraEnabled
    public static WrappedResponse getInterestSetting() {
        List<Appointment_RecordType_mtd__c> appointment_mtd = [SELECT   Id, Type__c, Name, RT_Appointment_Id__c, Interest_Name__c, 
                                                                        Interest_Index__c,Interest_Activate__c 
                                                                FROM Appointment_RecordType_mtd__c 
                                                                WHERE Type__c = 'Interest' ORDER BY Interest_Index__c];

        Map<String, String>  account_interests = diacoKnifeFunc.getPicklistValues('Account', new list<String>{'Interests__c'})[0];

        List<RecordType> appointment_recordtypes = diacoKnifeFunc.getDataRecordType('Appointment__c');

        return new WrappedResponse(
            appointment_mtd,
            account_interests,
            appointment_recordtypes
        );
    }

/**
 * This method is responsible to inser and update custom setting Appointment_RecordType_mtd__c
 * 
 * This method is used in:
 * DiacoAppointmentRecordType_HomeServiceSetUp
 * 
 * @return 
 * List custom setting Appointment_RecordType_mtd__c
 **/
    @AuraEnabled
    public static List<Appointment_RecordType_mtd__c> setAppointmentRt(List<Appointment_RecordType_mtd__c> appointments_mtd) {

        try {
            upsert appointments_mtd;
            return appointments_mtd;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

/**
 * This method is responsible to delete custom setting Appointment_RecordType_mtd__c
 * 
 * This method is used in:
 * DiacoAppointmentRecordType_HomeServiceSetUp
 *
 **/
    @AuraEnabled
    public static void delAppointmentRt(List<Appointment_RecordType_mtd__c> appointments_mtd) {
        try {
            delete appointments_mtd;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    public class WrappedResponse {        
        @AuraEnabled
        public List<Appointment_RecordType_mtd__c> appointment_mtd {get;set;}
        @AuraEnabled
        public List<RecordType> homeservice_recordtypes{get;set;}
        @AuraEnabled
        public List<RecordType> appointment_recordtypes{get;set;}
        @AuraEnabled
        public Map<String, String>  account_interests{get;set;}
        
        public WrappedResponse(List<Appointment_RecordType_mtd__c> appointment_mtd, List<RecordType> homeservice_recordtypes, List<RecordType> appointment_recordtypes) {
            this.appointment_mtd = appointment_mtd;
            this.homeservice_recordtypes = homeservice_recordtypes;
            this.appointment_recordtypes = appointment_recordtypes;
        }

        public WrappedResponse(List<Appointment_RecordType_mtd__c> appointment_mtd,Map<String, String>  account_interests, List<RecordType> appointment_recordtypes) {
            this.appointment_mtd = appointment_mtd;
            this.account_interests = account_interests;
            this.appointment_recordtypes = appointment_recordtypes;
        }
	}

}