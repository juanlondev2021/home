/**
 *
 * Diaco
 * Project:			Interests Manager
 * Description:		Class reponsible provide method to DiacoInterestWebform.cmp
 * Apex class: DiacoInterestWebformControllerTest

 *
 * Changes (Version)
 * _________________________________________
 *
 * 			No.		Date			Author					Description
 * 			____	__________      __________________ 		_____________________________________
 * @version	1.0		08-12-2020		Jull Quintero Daza	    Initial implementation  of the class.
 **/
public with sharing class DiacoInterestWebformController {

/**
* @description
* This method is responsible to get:Object Account, Id personnel, 
* DiacoInterestToAppointmentDTO, Appointments Picklist values. 
* 
* This method is used in:
* DiacoInterestWebForm.cmp
*
* @param Id recordId
* @param List picklistFields (list Fields Appointment ApiNames)
* @param String kunnectID (KunnectProfile - UserName)
* @return WrappedResponseData
**/
    @AuraEnabled
    public static WrappedResponseData getData(Id recordId, List<String> picklistFields, String kunnectID) {
        WrappedResponseData response = new WrappedResponseData();
        List<Account> accounts = [SELECT Name,Interests__c FROM Account WHERE Id=:recordId];

        if( !accounts.isEmpty() ) {
            Account account = accounts[0];
            //Get Appoitment Setter
            Id personnelId;
            if( kunnectID  == '' || kunnectID == null ) {
                List<User> user = [SELECT Personnel__c FROM User WHERE Id = :UserInfo.getUserId()];
                //personnelId = !user.isEmpty() ? user[0].Personnel__C : null;
            }else {
                List<Personnel__c> personnels = [SELECT Kunnect_ID__c FROM Personnel__c WHERE Kunnect_ID__c = :kunnectID LIMIT 1];
                personnelId = !personnels.isEmpty() ? personnels[0].Id : null;
            }
            
            // Get Interests Setting 
            List<String> accountInterests = account.Interests__c != null ? account.Interests__c.split(';') : new List<String>();
            DiacoInterestToAppointmentDTO.Interests interests =  DiacoInterestToAppointmentDTO.getInterests(accountInterests,new List<String>());
            
            // Get PicklistValues Appointment__c
            List<Map<String, String>> picklistValues = diacoKnifeFunc.getPicklistValues('Appointment__c', picklistFields);
            
            //Response
            response.success = true;
            response.account = account;
            response.appointmentSetter = personnelId;
            response.interests = interests;
            response.picklistValues = picklistValues;
        }else {
            response.success = false;
            response.message = 'account could not be found';
        }
        return response;
    }

    @AuraEnabled
    public static List<diacoKnifeFunc.PicklistByRecordTypeDTO> getPicklistValueByRecordtype(String objectType, String fieldName, List<Id> apptRecordTypeIds) {        
        return diacoKnifeFunc.getPicklistValueByRecordtype(objectType,fieldName,apptRecordTypeIds);
    }

/**
*@Description
* This method is responsible to get or generate Appointments 
* 
* This method is used in:
* DiacoInterestWebForm.cmp
*
* @param Id recordId
* @param List Interests (Values Interest account)
* @return WrappedResponseData
**/
    @AuraEnabled
    public static WrappedResponseData getAppointment(Id recordId, List<String> interests) {
        WrappedResponseData response = new WrappedResponseData();
        list<WrappedAppointment> resultAppointments = new list<WrappedAppointment>();
        Map<String,DiacoInterestToAppointmentDTO.AppointmentType> recordTypeByIntrsName = DiacoInterestToAppointmentDTO.getRecordTypeRelateToInterest();
        Map<Id,DiacoInterestToAppointmentDTO.AppointmentType> recordTypeByApptId = DiacoInterestToAppointmentDTO.getRecordTypeRelateToInterest(interests);

        DescribeSObjectResult describeResult = Appointment__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        Set<Id> apptRtypeIds = recordTypeByApptId.keySet();
        String query =
        ' SELECT ' +
        String.join( fieldNames, ',' ) +
        ' FROM Appointment__c' + 
        ' WHERE Person_Account__c = :recordId AND RecordTypeId IN :apptRtypeIds ORDER BY createdDate DESC';        

        List<Appointment__c> appointments = Database.query(query);
        if( !appointments.isEmpty() ) {
            for (Appointment__c appointment : appointments) {
                DiacoInterestToAppointmentDTO.AppointmentType appoinmType = recordTypeByApptId.get(appointment.recordTypeId);
                if( appoinmType != null ) {
                    if( interests.contains( appoinmType.Interest ) ) {
                        WrappedAppointment wAppointment = new WrappedAppointment();
                        wAppointment.appointment = appointment;
                        wAppointment.appoinmType = appoinmType;
                        resultAppointments.add(wAppointment); 
                    }
                    Integer index = interests.indexOf( appoinmType.Interest );
                    if( index != -1 ) { interests.remove(index); }
                } 
            }
        }

        // New Appointmets
        for (String interest : interests) {
            DiacoInterestToAppointmentDTO.AppointmentType appoinmType = recordTypeByIntrsName.get(interest);
            if(appoinmType != null ) {
                WrappedAppointment wAppointment = new WrappedAppointment();
                wAppointment.appointment = new Appointment__c( recordTypeId = appoinmType.Id );
                wAppointment.appoinmType = appoinmType;
                resultAppointments.add(wAppointment);
            } 
        }
        response.appointments = resultAppointments;
        return response;
    }

    /**
    * @description
    * This method is responsible to get Appointment Object
    * 
    * This method is used in:
    * method setAppointment (This class)
    *
    * @param Id recordId
    * @return Appointment__c
    **/
    private static Appointment__c getAppointment(Id recordId) {
        DescribeSObjectResult describeResult = Appointment__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String query =
        ' SELECT ' +
        String.join( fieldNames, ',' ) +
        ' FROM Appointment__c' + 
        ' WHERE Id = :recordId';
        return Database.query( query );
    }    

/**
*@Description
* This method is responsible to Create or update Appointment,
* Update Webform,
* Update Interest Account with an update order 
* 
* This method is used in:
* DiacoInterestWebForm_PutAppointment.cmp
*
* @param Appointment__c
* @param String strStartDate(Appointment start dateTime)
* @param List Interests (Values Interest account)
* @param webForm__c
* @param Account
* @param List Interests (Values Interest account)
* @return Appointment__c 
*/   
    @AuraEnabled
    public static Appointment__c setAppointment(Appointment__c appointment,List<String> strStartDate,Integer endHour, Account account, String interest) {
        if( !strStartDate.isEmpty() ) {

            integer year = integer.valueOf(strStartDate[0]);
            integer month =integer.valueOf(strStartDate[1]);
            integer day = integer.valueOf(strStartDate[2]);
            integer hours = integer.valueOf(strStartDate[3]);
            integer minutes = integer.valueOf(strStartDate[4]);
            Datetime startTime = Datetime.newInstanceGmt(year, month, day, hours,minutes,0);
            Datetime utcTime = startTime.addHours(7);
            appointment.Appointment_Start_Time__c = uTCTime;
            Datetime endTime = uTCTime.addHours(endHour);
            appointment.Appointment_End_Time__c = endTime;
        }
        upsert appointment;

        // update account instests 
        List<Account> accts = [SELECT Id, Interests__c FROM Account WHERE Id=:account.Id];

        if( !accts.isEmpty() ) {
            Account acct =  accts[0];
            List<String> insterests = acct.Interests__c != null ? acct.Interests__c.split(';') : new List<String>();
            if( !insterests.contains(interest) ) {
                insterests.add(interest);
                acct.Interests__c = string.join(insterests,';');
                update acct;
            }
        }
        return getAppointment(appointment.Id);
    }

    public class WrappedResponseData {
        @AuraEnabled
        public Boolean success{get;set;}
        @AuraEnabled
        public String message{get;set;}
        @AuraEnabled
        public Account account{get;set;}
        @AuraEnabled 
        public Id appointmentSetter{get;set;}
        @AuraEnabled
        public DiacoInterestToAppointmentDTO.Interests interests{get;set;}
        @AuraEnabled
        public List<Map<String, String>> picklistValues{get;set;}
        @AuraEnabled 
        public list<WrappedAppointment> appointments{get;set;}
    }

    public class WrappedAppointment {
        @AuraEnabled 
        public SObject appointment{get;set;}
        @AuraEnabled 
        public DiacoInterestToAppointmentDTO.AppointmentType appoinmType{get;set;}
    }
}