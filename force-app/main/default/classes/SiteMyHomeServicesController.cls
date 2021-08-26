/**
 *
 * Diaco
 * Project: Site Home Service Flow      
 * Description: Lightning Out
 * Apex class: SiteMyHomeServicesTest
 * Changes (Version)
 * _________________________________________
 *
 *          No.     Date            Author                  Description
 *          ____    __________      __________________      _____________________________________
 * @version 1.0     09-23-2020      Jull Quintero Daza      Initial implementation  of the class.
 */
public without sharing class SiteMyHomeServicesController {
    
 /**
*@Description
* This method is responsible to get user Address By Confimation number
* 
* This method is used in:
* SiteMyHomeServicesCmp.cmp
* 
* @param String Confirmation number
* @return User_Address__c
**/
    @AuraEnabled
    public static User_Address__c getUserAddress(String confirmationNumber) {

        list<User_Address__c> uAddress = [SELECT Confirmation_Number__c FROM User_Address__c WHERE Confirmation_Number__c=:confirmationNumber LIMIT 1];
        if( !uAddress.isEmpty() ) {

            return uAddress[0];
        }

        throw new AuraHandledException('User Address could not be found');
    }
    
 /**
*@Description
* This method is responsible to get: 
* Object Account, Object Personnel, List Countries, 
* Account Picklist values.
* 
* This method is used in:
* SiteHomeServiceTabs.cmp
*
* @param String recordId
* @param List picklistFields (list apiNames)
* @param String kunnectID (KunnectProfile - UserName)
* @return WrappedResponseAccount
**/
    @AuraEnabled
    public static WrappedResponseAccount getDataAccount(string recordId,List<String> picklistFields, string kunnectID) {
        
        try {

            // Get Account
            string accountId = recordId;
            String sObjName = !String.isEmpty(recordId) ? Id.valueOf(recordId).getSObjectType().getDescribe().getName() : null;

            if( sObjName == 'User_Address__c') {

                User_Address__c[] uAddress =  [SELECT Id,UserAccount__c FROM User_Address__c WHERE Id=:recordId LIMIT 1];
                if(!uAddress.isEmpty()) accountId=uAddress[0].UserAccount__c;
            }
            List<Account> accounts = 
            [
                SELECT 
                    FirstName,
                    LastName,
                    Phone,
                    PersonEmail,
                    Cross_Streets__c,
                    Street__c,
                    Zip__c,
                    State__c,
                    City__c,
                    Year_Built__c,
                    Pool__c,
                    Number_of_AC_Units__c,
                    Number_of_Stories__c,
                    Homeowner_2_First_Name__c,
                    Homeowner_2_Last_Name__c,
                    Homeowner_2_Email__c,
                    Homeowner_2_Phone_Number__c,
                    Homeowner_2_Mobile__c,County__c 
                FROM Account 
                WHERE Id=:accountId 
                LIMIT 1
            ];

            // Get Personnel
            List<Personnel__c> personnels = [SELECT Name FROM Personnel__c WHERE Kunnect_ID__c=:kunnectID LIMIT 1];

            // Get Countries.
            List<String> countries = new List<String>();
            List<County__c> counties = [SELECT County_Name__c FROM County__c ORDER BY County_Name__c];
            integer countiesLength = counties.size();
            for (Integer i = 0; i < countiesLength; i++) {
                countries.add(counties[i].County_Name__c);
            } 

            // Get PicklistValues Appointment__c
            List<Map<String, String>> picklistValues = diacoKnifeFunc.getPicklistValues('Account', picklistFields);
            
            WrappedResponseAccount response = new WrappedResponseAccount();
            response.account = !accounts.isEmpty() ? accounts[0] : null;
            response.personnel = !personnels.isEmpty() ? personnels[0] : null;
            response.counties = countries;
            response.picklistValues = picklistValues;

            return response;
        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }

 /**
*@Description
* This method is responsible to Insert Account or create Update Order
* 
* This method is used in:
* SiteAccount.cmp
*
* @param Object Account
* @return Object Account
**/
    @AuraEnabled
    public static Account setAccount(Account account) {
        try {

            if(account.id == null) {

                insert account;
            }else {

                // create order
                List<String> apiNames = new List<String>
                {
                    'Phone',
                    'Year_Built__c',
                    'Pool__c',
                    'Number_of_AC_Units__c',
                    'Number_of_Stories__c',
                    'Cross_Streets__c',
                    'Homeowner_2_First_Name__c',
                    'Homeowner_2_Last_Name__c',
                    'Homeowner_2_Email__c',
                    'Homeowner_2_Phone_Number__c',
                    'Homeowner_2_Mobile__c'
                };
                List<String> values = new List<String>();
                List<String> fields = new List<String>();

                integer apiNamesLength = apiNames.size();
                for (Integer i = 0; i < apiNamesLength; i++) {
                    if(account.get(apiNames[i]) != null){
                        string value = string.valueOf(account.get(apiNames[i]));
                        values.add(value); fields.add(apiNames[i]);
                    }
                }
                Update_Order__c order = new Update_Order__c();
                order.Guest_User__c = true;
                order.Object_Api_Name__c ='Account';
                order.List_of_Fields__c =  String.join(fields, '/,/');
                order.List_of_Values__c = string.join(values, '/,/');
                order.Parent_Id__c = account.Id;
                insert order;
            }
            return account;   
        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }

/**
*@Description
* This method is responsible to get:Object Account, Id personnel, 
* DiacoInterestToAppointmentDTO, Appointments Picklist values. 
* 
* This method is used in:
* SiteInterestWebForm.cmp
*
* @param Id recordId
* @param List hideInterests (Hide  list account Interests)
* @param List picklistFields (list Fields Appointment ApiNames)
* @param String kunnectID (KunnectProfile - UserName)
* @return WrappedResponseAppoint
**/
    @AuraEnabled
    public static WrappedResponseAppoint getDataInterests(Id recordId, list<String> hideInterests, List<String> picklistFields, String kunnectID) {
        
        try {
            
            Id AccountId = getAccountId(recordId);
            List<Account> accounts = [ SELECT Name,Interests__c FROM Account WHERE Id=:AccountId];

            if( !accounts.isEmpty() ) {

                Account account = accounts[0];
                //Get Appoitment Setter
                Id personnelId;
                if( kunnectID  == '' || kunnectID == null ) {

                    User[] user = [SELECT Id, Personnel__c FROM User WHERE Id = :UserInfo.getUserId()];
                    personnelId = !user.isEmpty() ? user[0].Personnel__C : null;

                }else {

                    Personnel__c[] personnels= [SELECT Id, Kunnect_ID__c FROM Personnel__c WHERE Kunnect_ID__c = :kunnectID LIMIT 1];
                    personnelId = !personnels.isEmpty() ? personnels[0].Id : null;
                }
                
                // Get Interests Setting 
                List<String> accountInterests = new List<String>();
                accountInterests =  account.Interests__c != null ? account.Interests__c.split(';') : accountInterests;
                DiacoInterestToAppointmentDTO.Interests interests =  DiacoInterestToAppointmentDTO.getInterests(accountInterests,hideInterests);
                
                // Get PicklistValues Appointment__c
                List<Map<String, String>> picklistValues = diacoKnifeFunc.getPicklistValues('Appointment__c', picklistFields);
                WrappedResponseAppoint response = new WrappedResponseAppoint();
                response.account = account;
                response.appointmentSetter = personnelId;
                response.interests = interests;
                response.picklistValues = picklistValues;
                return response;
            }
            throw new AuraHandledException('Account could not be found');
            
        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    } 
    
/**
*@Description
* This method is responsible to get or generate Appointments 
* 
* This method is used in:
* SiteInterestWebForm.cmp
*
* @param Id recordId
* @param List Interests (Values Interest account)
* @return WrappedResponseAppoint
**/
    @AuraEnabled
    public static WrappedResponseAppoint getAppointment(Id recordId, List<String> interests) {

        try {
            
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

            WrappedResponseAppoint response = new WrappedResponseAppoint();
            response.appointments = resultAppointments;
            return response;

        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }
/**
*@Description
* This method is responsible to Create or update Appointment,
* Update Webform,
* Update Interest Account with an update order 
* 
* This method is used in:
* SiteInterestWebForm_PutAppointment.cmp
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
    public static Appointment__c setAppointment(Appointment__c appointment,List<string> strStartDate,Integer endHour,Account account, String interest) {
        
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

            upsert appointment;

            // update account instests with update order
            List<String> insterests = new  List<String>();
            List<Account> objAccount = 
            [
                SELECT 
                    Interests__c,
                    Carpet_Tile_Cleaning_Status__c,
                    Garage_Doors_Status__c,
                    Home_Automation_Status__c,
                    HVAC_Status__c,
                    Internet_Cable_Satellite_Status__c,
                    Lock_Smith_Status__c,
                    Maid_Service_Status__c,
                    Pest_Control_Status__c,
                    Pool_Maintenance_Status__c,
                    Remodel_Status__c,
                    Solar_Status__c,
                    Water_Status__c,
                    DNC_Carpet_Tile_Cleaning__c,
                    DNC_Garage_Doors__c,
                    DNC_Home_Automation__c,
                    DNC_HVAC__c,
                    DNC_Internet_Cable_Satellite__c,
                    DNC_Lock_Smith__c,
                    DNC_Maid_Service__c,
                    DNC_Pest_Control__c,
                    DNC_Pool_Maintenance__c,
                    DNC_Remodel__c,
                    DNC_Solar__c,
                    DNC_Water__c
                FROM Account 
                WHERE Id=:account.Id
            ];

            Appointment__c objAppointment = getAppointment(appointment.Id);
            if( !objAccount.isEmpty() ) {

                if ( UserInfo.getUserType() == 'Guest' || Test.isRunningTest() ) {

                    Account acc =   objAccount[0];
                    Update_Order__c accountOrder = new Update_Order__c();
                    accountOrder.Guest_User__c = true;
                    accountOrder.Object_Api_Name__c ='Account';
                    accountOrder.Parent_Id__c = acc.Id;

                    String listOfFiles;
                    String ListofValues;
                    if( acc.Interests__c != null ) {
                    
                        insterests = acc.Interests__c.split(';');
                        if( !insterests.contains(interest) ) {
    
                            insterests.add(interest);
                            listOfFiles = 'Interests__c/,/';
                            ListofValues = string.join(insterests,';') + '/,/';
                        }
                    }else {

                        insterests.add(interest);
                        listOfFiles = 'Interests__c/,/';
                        ListofValues = string.join(insterests,';') + '/,/';
                    } 
    
                    //DNC field
                    Appointment_RecordType_mtd__c appointmentRtype = Appointment_RecordType_mtd__c.getValues(objAppointment.recordTypeId);
                    if((appointmentRtype != null && objAppointment.assigned__c) || test.isRunningTest())  {
                        String hsRTname = diacoKnifeFunc.getRecordTypeNameById('Home_Services__c',appointmentRtype.RT_Home_Service_Id__c);
                        string DNCfield = AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountDNCField(hsRTname);
                        string statusFIeld = AccountHSStatusUpdateHelper.homeServiceRecordTypeToAccountStatusField(hsRTname);
                        if(acc.get(statusFIeld) != 'Appointment') {
                            if( string.isNotEmpty(DNCfield) ) {
                                listOfFiles = String.isNotEmpty(listOfFiles) ? listOfFiles + DNCfield + '/,/' : DNCfield + '/,/';
                                ListofValues =  String.isNotEmpty(ListofValues) ? ListofValues + true + '/,/' : true + '/,/';
                            }
                            if( string.isNotEmpty(statusFIeld) ) {
                                listOfFiles = String.isNotEmpty(listOfFiles) ? listOfFiles + statusFIeld + '/,/' : statusFIeld + '/,/';
                                ListofValues =  String.isNotEmpty(ListofValues) ? ListofValues + 'Appointment' + '/,/' : 'Appointment' + '/,/';
                            }
                        }
                    }
                    if(string.isNotEmpty(listOfFiles) && string.isNotEmpty(ListofValues)) {
                        accountOrder.List_of_Fields__c = listOfFiles;
                        accountOrder.List_of_Values__c = ListofValues;
                        insert accountOrder;
                    }
                }
                if (UserInfo.getUserType() != 'Guest' ) {
                    // no guest user
                    Account acc =   objAccount[0];
                    if( acc.Interests__c != null ) {
                    
                        insterests = acc.Interests__c.split(';');
                        //system.debug('>>insterests' + insterests);
                        if( !insterests.contains(interest) ) {
            
                            insterests.add(interest);
                            acc.Interests__c = string.join(insterests,';');
                            update acc;
                        }
                    }else {
                        insterests.add(interest);
                        acc.Interests__c = string.join(insterests,';');
                        update acc;
                    } 
                }
            }
            return objAppointment;

        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }



/**
*@Description
* This method is responsible to get: 
* list Home_Services__c, List Appointment__c
* Object account, List appointment recordtypes
* 
* This method is used in:
* SiteHomeServicesFlow.cmp
*
* @param Id recordId
* @param Boolean assigned(for to get list appointments assigned)
* @return WrappedResponseHomeS
**/
    @AuraEnabled
    public static WrappedResponseHomeS getDataHomeService(Id recordId, Boolean assigned) { 

        try {

            Id accountId;
            Account account = new Account();

            String sObjName = recordId.getSObjectType().getDescribe().getName();
            
            if( sObjName == 'Home_Services__c' ) {

                List<Home_Services__c> homeS = [ SELECT Account__c, Account__r.Name FROM Home_Services__c WHERE Id = :recordId ];

                if( !homeS.isEmpty() ) {

                    accountId = (homeS[0].Account__c != null) ? homeS[0].Account__c : null;
                    account = homeS[0].Account__r;
                }

            }else if(sObjName == 'Account' ) {

                accountId = recordId;
                account = [SELECT Id,Name FROM Account WHERE Id = :accountId ];
            }

            if( accountId != null ) {

                List<Appointment__c> appointments =
                [
                    SELECT
                        Name,  
                        recordType.Name,
                        assigned__c,Status__c
                    FROM Appointment__c 
                    WHERE Person_Account__c = :accountId AND assigned__c = :assigned 
                    ORDER BY LastModifiedDate 
                    DESC
                ];

                List<Home_Services__c> homeservices = 
                [
                    SELECT 
                        Name, 
                        Event__c, 
                        recordType.Name,
                        Home_Services_Status__c
                    FROM Home_Services__c 
                    WHERE  Account__c = :accountId 
                    ORDER BY LastModifiedDate 
                    DESC
                ];

                List<RecordType> appointmentRecordtypes =  diacoKnifeFunc.getDataRecordType('Appointment__c');
                WrappedResponseHomeS response = new WrappedResponseHomeS();
                response.homeServices = homeservices;
                response.appointments = appointments;
                response.account = account;
                response.recordTypes = appointmentRecordtypes;
                return response;

            }

            throw new AuraHandledException('Account could not be found');
        } catch(Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }
    
/**
*@Description
* This method is responsible to get: 
* Appointment__c And Appointments Picklist values
* 
* This method is used in:
* SiteHomeServicesFlow_EditApptmt.cmp
*
* @param Id recordId
* @param List picklistFields (list Fields Appointment ApiNames)
* @return WrappedResponseHomeS
**/
    @AuraEnabled
    public static WrappedResponseHomeS getHomeServiceAppointment(Id recordId, List<String> picklistFields) {
        
        try {
            WrappedResponseHomeS response = new WrappedResponseHomeS();
            response.appointment = getAppointment(recordId);
            response.picklistValues = diacoKnifeFunc.getPicklistValues('Appointment__c', picklistFields);
            return response;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
/**
*@Description
* This method is responsible to get: Create And Update Appointment__c
* 
* This method is used in:
* SiteHomeServicesFlow_EditApptmt.cmp
*
* @param Id recordId
* @param String strStartDate(Appointment start dateTime)
* @return Appointment__c
**/
    @AuraEnabled
    public static Appointment__c setDataAppointment(Appointment__c appointment,List<string> strStartDate,Integer endHour) {
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

  /**
*@Description
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
        Appointment__c appointment = Database.query( query );
        
        return appointment;
    }

    private static Id getAccountId(Id recordId) {
        
        String objectName = recordId.getSobjectType().getDescribe().getName();
        id currentId;
        if ( objectName == 'Account' ) {
            currentId = recordId;

        }else if ( objectName == 'Delivery_Object__c' ) {
            currentId  = [SELECT Id,Person_Account__c FROM Delivery_Object__c WHERE Id = :recordId ]?.Person_Account__c;
        }

        return currentId;
    }

    public class WrappedResponseAccount{
        @AuraEnabled
        public Account account{get;set;}
        @AuraEnabled
        public personnel__c personnel{get;set;}
        @AuraEnabled
        public List<String> counties{get;set;}
        @AuraEnabled
        public List<Map<String, String>> picklistValues{get;set;}
    }

    public class WrappedResponseAppoint {
        @AuraEnabled
        public Account account {get;set;}
        @AuraEnabled 
        public Id appointmentSetter{get;set;}
        @AuraEnabled
        public DiacoInterestToAppointmentDTO.Interests interests{get;set;}
        @AuraEnabled
        public List<Map<String, String>> picklistValues {get;set;}
        @AuraEnabled 
        public list<WrappedAppointment> appointments{get;set;}
    }

    public class WrappedAppointment {
        @AuraEnabled 
        public SObject appointment{get;set;}
        @AuraEnabled 
        public DiacoInterestToAppointmentDTO.AppointmentType appoinmType{get;set;}
        public WrappedAppointment(){}
        public WrappedAppointment(SObject appointment, DiacoInterestToAppointmentDTO.AppointmentType appoinmType) {
            this.appointment = appointment;
            this.appoinmType = appoinmType;
        }
    }      

    public class WrappedResponseHomeS {
        @AuraEnabled
        public List<Home_Services__c> homeServices {get;set;}
        @AuraEnabled
        public List<Appointment__c> appointments {get;set;}
        @AuraEnabled
        public Account account {get;set;}
        @AuraEnabled
        public List<RecordType>  recordTypes{get;set;}
        @AuraEnabled
        public Appointment__c appointment {get;set;}
        @AuraEnabled
        public List<Map<String, String>> picklistValues{get;set;}
    }

}