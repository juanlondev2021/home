/**
 *
 * Diaco
 * Project:			Appointment Recordtype Set Up
 * Description:		This class is setting to custom setting Appointment_RecordType_mtd__c and helper for class DiacoInterestWebformController
 * TestClass        DiacoAppointmentRecordSetUp_tst
 *
 * Changes (Version)
 * _________________________________________
 *
 * 			No.		Date			Author					Description
 * 			____	__________      __________________ 		_____________________________________
 * @version	1.0		08-12-2020		Jull Quintero Daza	    Initial implementation  of the class.
 */

public with sharing class DiacoInterestToAppointmentDTO {
    private static final list<Appointment_RecordType_mtd__c> APPOINTMENTS_MTD = 
    [
        SELECT 
            RT_Appointment_Id__c, 
            Interest_Name__c,
            Interest_Activate__c 
        FROM Appointment_RecordType_mtd__c
        /*WITH SECURITY_ENFORCED*/  
        WHERE  Type__c = 'Interest' AND Interest_Activate__c = true ORDER BY Interest_Index__c
    ];

/**
 * This method is responsible to relate insterest with AppointmentType
 * 
 * This method is used in:
 * DiacoInterestWebformController: method getAppointment
 * 
 * @return 
 * Map key:Interest Name, Value;AppointmentType,
 **/
public static Map<String,AppointmentType> getRecordTypeRelateToInterest() {
    Map<String,AppointmentType> relate = new Map<String,AppointmentType>();
    for (Appointment_RecordType_mtd__c apptMtd : APPOINTMENTS_MTD) {
        relate.put(apptMtd.Interest_Name__c, 
            new AppointmentType(
                (Id)apptMtd.RT_Appointment_Id__c,
                Schema.getGlobalDescribe().get('Appointment__C').getDescribe().getRecordTypeInfosById().get(apptMtd.RT_Appointment_Id__c).getName(),
                apptMtd.Interest_Name__c
        ));
    }
    return relate;
}

/**
* This method is responsible to relate insterest with AppointmentType
* 
* This method is used in:
* DiacoInterestWebformController: method getAppointment
* 
* @return 
* Map key:Interest Name, Value;AppointmentType,
**/
    public static Map<Id,AppointmentType> getRecordTypeRelateToInterest(List<String> interests) {
        Map<Id,AppointmentType> relate = new Map<Id,AppointmentType>();
        list<Appointment_RecordType_mtd__c> apptsMtd = 
        [
            SELECT 
                RT_Appointment_Id__c, 
                Interest_Name__c,
                Interest_Activate__c 
            FROM Appointment_RecordType_mtd__c 
            WHERE  Type__c = 'Interest' AND Interest_Activate__c = true AND Interest_Name__c IN :interests 
            /*WITH SECURITY_ENFORCED*/ 
            ORDER BY Interest_Index__c 
        ];
        
        for (Appointment_RecordType_mtd__c apptMtd : apptsMtd) {
            relate.put((Id)apptMtd.RT_Appointment_Id__c, 
                new AppointmentType(
                    (Id)apptMtd.RT_Appointment_Id__c,
                    Schema.getGlobalDescribe().get('Appointment__C').getDescribe().getRecordTypeInfosById().get(apptMtd.RT_Appointment_Id__c).getName(),
                    apptMtd.Interest_Name__c
            ));
        }
        return relate;
    } 

/**
 * This method is responsible to get Interests
 * 
 * This method is used in:
 * DiacoInterestWebformController: method getData
 * SiteMyHomeServicesController: method getDataInterests

 * 
 * @return 
 * List Interests
 **/
    public static Interests getInterests(list<String> accountInterests, list<String> hideInterests) {
        List<Interest> interests = new List<Interest>();
        List<Id> apptRecordTypeIds = new List<Id>();
        for (Appointment_RecordType_mtd__c apptMtd : APPOINTMENTS_MTD) {
                string interestName = apptMtd.Interest_Name__c;
                if( !hideInterests.contains(interestName) ) {
                    Boolean checked = accountInterests.contains(interestName);
                    interests.add( 
                        new Interest(
                            interestName,
                            checked
                        )
                    );
                    apptRecordTypeIds.add(apptMtd.RT_Appointment_Id__c);

                }else{
                    integer index = accountInterests.indexOf(interestName);
                    if(index != -1) { accountInterests.remove(index); }
                }
        }
        return new Interests(
                interests,
                accountInterests,
                apptRecordTypeIds
            );
    }

    public class AppointmentType {
        @AuraEnabled
        public ID id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String interest;

        public AppointmentType(Id id, string name,String interest) {
            this.id = id;
            this.name = name;
            this.interest = interest;
        }
    }

    public class Interests {
        @AuraEnabled
        public List<Interest> activatedInterests;
        @AuraEnabled
        public List<String> interestSelected;
        @AuraEnabled
        public List<Id> apptRecordTypeIds;

        public Interests(List<Interest> activatedInterests,  List<String> interestSelected, List<Id> apptRecordTypeIds) {
            this.activatedInterests = activatedInterests;
            this.interestSelected = interestSelected;
            this.apptRecordTypeIds = apptRecordTypeIds;
        }
    }

    public class Interest {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Boolean checked;

        public Interest(String name,Boolean checked) {
            this.name = name;
            this.checked = checked;
        }
    }
}