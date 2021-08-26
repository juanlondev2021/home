/**
 *
 * Diaco
 * @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 * Project:			diacoCmpTask
 * Description:		Class reponsible provide method to diacocmpflow
 *
 * Changes (Version)
 * _________________________________________
 *
 * 			No.		Date			Author					Description
 * 			____	__________      __________________ 		_____________________________________
 * @version	1.0		21/10/2019		Esnayder Morales (ES)	Initial implementation of the class.
 * @version 1.0		19/06/2020		Fabian Pineda (FP)		Allowing fetching and saving of Account County (County__c) data.
 * @version 1.0     04/11/2020      Fabian Pineda (FP)      Modified getAccount so that it now also accepts Home_Services__c IDs.
 */
public class DiacoCmpFlowController {

    @AuraEnabled
    public static WrappedResponseData getData(Id recordId, Boolean assigned) { 

        try {
            Id accountId;
            Account account = new Account();

            String sObjName = recordId.getSObjectType().getDescribe().getName();
            
            if( sObjName == 'Home_Services__c' ) {

                List<Home_Services__c> homeS = [ SELECT Id, Account__c, Account__r.Name
                                                FROM Home_Services__c 
                                                WHERE Id = :recordId ];

                if( !homeS.isEmpty() ) {

                    accountId = (homeS[0].Account__c != null) ? homeS[0].Account__c : null;
                    account = homeS[0].Account__r;
                }

            }else if(sObjName == 'Account' ) {

                accountId = recordId;
                account = [SELECT Id,Name FROM Account WHERE Id = :accountId ];
            }

            if( accountId != null ) {

                List<Appointment__c> appointments   =   [SELECT  Name, recordType.Name, assigned__c,Status__c
                                                        FROM Appointment__c 
                                                        WHERE Person_Account__c = :accountId AND assigned__c = :assigned ORDER BY LastModifiedDate DESC];

                List<Home_Services__c> homeservices =   [SELECT Name, Event__c, recordType.Name, Home_Services_Status__c
                                                        FROM Home_Services__c 
                                                        WHERE  Account__c = :accountId ORDER BY LastModifiedDate DESC];

                List<RecordType> appointmentRecordtypes =  diacoKnifeFunc.getDataRecordType('Appointment__c');
                
                return new WrappedResponseData( homeservices,
                                                appointments,
                                                account,
                                                appointmentRecordtypes);
            }
            return null;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static WrappedResponseData getAppointment(Id recordId, String objectType, Id recordTypeId, List<String> fieldNames,List<String> picklistFields) {
        
        try {
            DescribeSObjectResult describeResult = Appointment__c.getSObjectType().getDescribe();
            List<String> fieldApiNames = new List<String>(describeResult.fields.getMap().keySet());
    
            String query =
            ' SELECT ' +
            String.join( fieldApiNames, ',' ) +
            ' FROM Appointment__c' + 
            ' WHERE Id = :recordId';
            Appointment__c appointment = Database.query( query );
            return new WrappedResponseData(
                appointment,
                diacoKnifeFunc.getPicklistValues(objectType, picklistFields),
                diacoKnifeFunc.getPicklistValueByRecordtype(objectType, recordTypeId, fieldNames)
            );

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Appointment__c setAppointment(Appointment__c appointment,List<String> strStartDate, Integer endHour) {
        try {
            
            if( !strStartDate.isEmpty() ) {

                integer year = integer.valueOf(strStartDate[0]);
                integer month =integer.valueOf(strStartDate[1]);
                integer day = integer.valueOf(strStartDate[2]);
                integer hours = integer.valueOf(strStartDate[3]);
                integer minutes = integer.valueOf(strStartDate[4]);
                Datetime startTime = Datetime.newInstanceGmt(year, month, day, hours,minutes,0);
                Datetime UTCTime = startTime.addHours(7);
                appointment.Appointment_Start_Time__c = UTCTime;
                Datetime endTime = UTCTime.addHours(endHour); appointment.Appointment_End_Time__c = endTime;
            }
            update appointment;
            return appointment;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, String> getAccount(String RecordId) {
        String typeObj =DiacoCmpFlowController.typeObject(RecordId);
        Object obj;
        Map<String, String> m = new Map<String, String>();
        if(typeObj == 'User_Address__c'){
            List<User_Address__c> userAddress = [select UserAccount__c, UserAccount__r.Web_Form__c 
                                                    from User_Address__c where Id =:RecordId limit 1];
            m.put('accountId', userAddress[0].UserAccount__c);
            m.put('webFormId', userAddress[0].UserAccount__r.Web_Form__c);  
            m.put('isAccount', null);
        }else{
            if(typeObj == 'Account'){
                List<Account> a = [select Id,Web_Form__c from Account where Id =:RecordId limit 1];
                m.put('accountId', a[0].Id);
                m.put('webFormId', a[0].Web_Form__c);
                m.put('isAccount', 'true');
            }
            else if (typeObj == 'Home_Services__c') {
                List<Home_Services__c> hs = [SELECT Account__c, Account__r.Web_Form__c FROM Home_Services__c WHERE Id = :RecordId LIMIT 1];
                m.put('accountId', hs[0].Account__c);
                m.put('webFormId', hs[0].Account__r.Web_Form__c);
                m.put('isAccount', null);

            }else{
                List<Event> event = [select Home_Service__r.Account__c, Home_Service__r.Account__r.Web_Form__c
                                     from Event where Id=:RecordId];
                m.put('accountId', event[0].Home_Service__r.Account__c);
                m.put('webFormId', event[0].Home_Service__r.Account__r.Web_Form__c); 
                m.put('isAccount', null);
            }
        }
        return m;
    }

    @AuraEnabled
    public static String getObjectType(String recordId){
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        for(Schema.SObjectType obj : Schema.getGlobalDescribe().Values()){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        return objectAPIName;
    }

    @AuraEnabled
    public static String getAccountId(String recordId,Boolean isUserAddress){
        String accountId='';
        if(isUserAddress){
            User_Address__c u =  [select Id,UserAccount__c from User_Address__c where Id=:recordId];
            accountId=u.UserAccount__c;
        }else{
            Event e =  [select Id,Home_Service__c from Event where Id=:recordId];
            Home_Services__c h =  [select Id,Account__c from Home_Services__c where Id=:e.Home_Service__c] ;
            accountId=h.Account__c;
        }
        return accountId;
    }

    @AuraEnabled
    public static Account getDataCustomerOne(String recordId){
        Account a = [select Id,FirstName,LastName,Phone,PersonEmail,Street__c,Zip__c,State__c,City__c,Homeowner_2_First_Name__c,Homeowner_2_Last_Name__c,Homeowner_2_Email__c,Homeowner_2_Phone_Number__c,Homeowner_2_Mobile__c,County__c from Account where Id=:recordId];
        return a;
    }

    @AuraEnabled
    public static User_Address__c getUserAddress(String confirmationNumber){
        list<User_Address__c> u = [select Id,Confirmation_Number__c from User_Address__c where Confirmation_Number__c=:confirmationNumber];
        if(u.size()<1){
            return null;
        }
        return u[0];
        
    }

    @AuraEnabled
    public static String typeObject(String recordId){
        Id idToProccess = recordId;              	
        return String.valueOf(idToProccess.getSObjectType());
    }
    
    @AuraEnabled
    public static Event getDataEvent(String eventId){
        List<Event> event =[select Confirmation_Status__c, Call_Status__c,Appointment_results__c from Event where Id=:eventId];
        return event[0];
    }

    @AuraEnabled
    public static List<Personnel__c> getPersonnel(){
        List<Personnel__c> p =  [select Id,Name from Personnel__c where Appt_Setter__c=true];
        return p;
    }
    
    @AuraEnabled
    public static Personnel__c getPersonnelOne(String recordId){
        Personnel__c p = [select Id,Name from Personnel__c where Kunnect_ID__c=:recordId limit 1];
        return p;
    }
    
    @AuraEnabled
    public static webForm__c getWebform(String recordId){
        List<webForm__c> wf = [Select Id, Start_DateTime__c, End_DateTime__c from webForm__c 
                where Account__c = :RecordId limit 1];
        
        return wf[0];
    }
    
    @AuraEnabled
    public static Map<String, String> getCountyData() {
        return DiacoWaterContractController.getCountyData();
    }

    public class WrappedResponseData {
        @AuraEnabled
        public List<Home_Services__c> home_Services {get;set;}
        @AuraEnabled
        public List<Appointment__c> appointments {get;set;}
        @AuraEnabled
        public Account account {get;set;}
        @AuraEnabled
        public List<RecordType>  record_types{get;set;}

        @AuraEnabled
        public Appointment__c appointment {get;set;}
        @AuraEnabled
        public List<Map<String, String>> picklist_values{get;set;}
        @AuraEnabled
        public List<diacoKnifeFunc.PicklistByRecordTypeDTO> picklist_values_by_recordtype {get;set;}
                
        public WrappedResponseData(List<Home_Services__c> home_Services, List<Appointment__c> appointments ,Account account, List<RecordType> record_types) {

            this.home_Services      = home_Services;
            this.appointments       = appointments;
            this.account            = account;
            this.record_types       = record_types;
        }

        public WrappedResponseData(Appointment__c appointment, List<Map<String, String>> picklist_values, List<diacoKnifeFunc.PicklistByRecordTypeDTO> picklist_values_by_recordtype) {
            this.appointment = appointment;
            this.picklist_values = picklist_values;
            this.picklist_values_by_recordtype = picklist_values_by_recordtype;
        }

	}
}