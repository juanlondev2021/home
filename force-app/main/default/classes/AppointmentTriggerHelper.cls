/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Appointemnt Trigger
 * TestClass:          AppointmentTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    12/09/2020         Jull Quintero D         Initial implementation of the class.
 **/

public class AppointmentTriggerHelper {
    /*
     * This method is responsible to change values appointment fields
     * 
     * This method is run before insert, before Update
     * 
     * This method is used in:
     * AppointmentTrigger
     * 
     * @param Appointment List
     **/
    public static void settingAppointments(list<Appointment__c> appointments, Boolean isInsert) {
        integer appsLength = appointments.size();
        for (Integer i = 0; i < appsLength; i++) {
            assignStatus(appointments[i],isInsert);
            automaticAssignPartner(appointments[i]);
        }
    }

    /*
     * This method is responsible to Automatic assign Appointment.PartnerId__c 
     * 
     * This method is run before insert, before Update
     * 
     * This method is used in:
     * settingAppointments - this class
     * 
     * @param Appointment
     **/
    private static void automaticAssignPartner(Appointment__c appint) {
        if( String.isEmpty(appint.Partner__c) ) {

            Appointment_RecordType_mtd__c appointmentRtype = Appointment_RecordType_mtd__c.getValues(appint.recordTypeId);
            if( appointmentRtype!=null ) {
                
                if(!String.isEmpty(appointmentRtype.PartnerId__c)) appint.Partner__c = appointmentRtype.PartnerId__c;
            } 
        }  
    }

    /*
     * This method is responsible to change Appointment.Status__c
     * 
     * This method is run before insert, before Update
     * 
     * This method is used in:
     * settingAppointments - this class
     * 
     * @param Appointment, boolean isInsert 
     **/
    private static void assignStatus(Appointment__c appint, Boolean isInsert) {
        if (appint.Status__c != 'Assigned' && appint.Status__c != 'Sale Approved' ) {
            
            if( isInsert && appint.Appointment_Start_Time__c == null ) {

                appint.Status__c = 'Interested';
    
            }else if( appint.Appointment_Start_Time__c != null && string.isEmpty(appint.Home_Service__c) ) {
    
                appint.Status__c = 'Appointment Set';
    
            }else {
                appint.Status__c = 'Qualifying';
            }
        }
    }
    
    /*
     * This method is responsible to Create HomeService
     * 
     * This method is run after insert, after Update
     * 
     * This method is used in:
     * AppointmentTrigger
     * 
     * @param set Appointments Id 
     **/
    public static void createHs(Set<Id> AppointIds) {

        DescribeSObjectResult describeResult = Appointment__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        
        String query =
            ' SELECT Partner__r.Parent.Name,' +
            String.join( fieldNames, ',' ) +
            ' FROM Appointment__c' + 
            ' WHERE Id in :AppointIds';        
            List<Appointment__c> appointments = Database.query(query);
            //system.debug('>> appointments' + appointments);

        Id EventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        Map<String,String> relatetofields = DiacoAppointmentHomeFields.getRelatoFields();
        List<Home_Services__c> homes = new List<Home_Services__c>();
        List<Appointment__c> objAppointment = new List<Appointment__c>();

        List<Event> events = new List<Event>();
        integer appointmentsLength = appointments.size();

        for(Integer i = 0; i < appointmentsLength; i++) {
            Appointment__c App = appointments[i];

            if( !App.assigned__c && !String.isEmpty(App.Partner__c) ) {

                String ParentId = App.Partner__r.Parent.Name;
                //System.debug('>>Parentname ' + ParentId);
                Appointment_RecordType_mtd__c appointmentRtype = Appointment_RecordType_mtd__c.getValues(App.recordTypeId);
                String recordTypeName = Schema.SObjectType.Appointment__c.getRecordTypeInfosById().get(App.recordTypeId).getname();
                if( appointmentRtype != null ) {
    
                    if( String.isEmpty(appointmentRtype.PartnerId__c) || String.isEmpty(ParentId) ) continue;
                    else if( ParentId != 'My Home Services LLC' ) continue;
                    
                    Home_Services__c home = new Home_Services__c(Account__c=App.Person_Account__c,Appointment_Lookup__c=App.Id);
                    if(!Test.isRunningTest()){
                        home.RecordTypeId = appointmentRtype.RT_Home_Service_Id__c;
                    }
    
                    for (String appointmentField : relatetofields.keySet()) {
                        
                        if( App.get(appointmentField) != null) {
                            String homeServiceFields = relatetofields.get(appointmentField);
                            home.put(homeServiceFields, App.get(appointmentField));
                        }
                    }
                    
                    if(App.get('Number_of_Stories_Picklist__c')!=null){
                        home.put('X2_Story__c', (App.get('Number_of_Stories_Picklist__c')!='2'?false:true));
                    }
                    
                    if(recordTypeName=='Home Automation'){
                        if(App.get('Number_of_People_in_the_home__c')!=null){
                            home.put('of_people_in_the_home_Home_Automation__c', App.get('Number_of_People_in_the_home__c'));
                        }  
                    }else if(recordTypeName=='Water Filtration'){
                        if(App.get('Number_of_People_in_the_home__c')!=null){
                            home.put('People_in_the_home_water__c', App.get('Number_of_People_in_the_home__c'));
                        }
                    }else if(recordTypeName=='Solar'){
                        if(App.get('Number_of_People_in_the_home__c')!=null){
                            home.put('People_in_the_home_solar__c', App.get('Number_of_People_in_the_home__c'));
                        }
                        if(App.get('Project_Type__c')!=null){
                            home.put('Solar_Type__c', App.get('Project_Type__c'));
                        }
                    }else if(recordTypeName=='Pest Control'){
                        if(App.get('Project_Type__c')!=null){
                            home.put('Pest_Service_Type__c', App.get('Project_Type__c'));
                        }
                    }

                    if(App.Appointment_Start_Time__c!=null && App.Appointment_End_Time__c!=null){
                        homes.add(home);
                        events.add(new Event(Description=App.Appointment_Notes__c,
                                        StartDateTime=App.Appointment_Start_Time__c, 
                                        EndDateTime=App.Appointment_End_Time__c,
                                        RecordTypeId=EventRecordTypeId));
                        objAppointment.add(App);
                    }
                    
                }
            }
        }

        if( !homes.isEmpty() ) {

            insert homes;
            integer objAppointmentLength = objAppointment.size(); 
            for(Integer i=0;i<objAppointmentLength;i++) {
                Appointment__c appointment = objAppointment[i];
                events[i].WhatId=homes[i].Id;
                events[i].Home_Service__c=homes[i].Id;
                appointment.assigned__c=true;
                appointment.Status__c = 'Assigned';
                if(!Test.isRunningTest()) appointment.Home_Service__c=homes[i].Id;
                
            }
            if(!Test.isRunningTest()){
                insert events;
                TriggerHandler.bypass('AppointmentTrigger');
                upsert objAppointment;
                TriggerHandler.clearBypass('AppointmentTrigger');
            }
            
        }
    } 

    /**
    * @description create configured sms
    * @author William Aldana | 12-29-2020 
    * @param AppointIds 
    **/
    public static void createSMS(Appointment__c[] appointments, Map<Id, Appointment__c> oldAppMap, Boolean isInsert, Boolean isUpdate) {
        new CreateSMS(appointments, oldAppMap, isInsert, isUpdate);
    }

    /**
     * @description Send Slack/Email Notification to Partner
     * @author Giovanni Ulloque | 01-04-2020
     *
    public static void partnerNotification(Appointment__c[] appointments, Map<Id, Appointment__c> oldAppMap){
        List<Id> Appt = new List<Id>();
        for(Integer i = 0; i < appointments.size(); i++){
        
            if(oldAppMap.get(appointments[i].Id).Partner__c == NULL && appointments[i].Partner__c != NULL){
                appt.add(appointments[i].Id);
            }
        }

        if(!appt.isEmpty()){
            List<Appointment__c> ApptSOQL = [SELECT Id, 
                                                    Partner__c, 
                                                    Partner__r.Lead_Distribution_Method__c, 
                                                    Partner__r.Lead_Distribution_Slack_Channel__c, 
                                                    Partner__r.Lead_Distribution_Email__c,
                                                    Appointment_Start_Time__c,
                                                    First_Name__c,
                                                    Last_Name__c,
                                                    Appt_Window_Time__c
                                            FROM    Appointment__c 
                                            WHERE Id IN : appt];
            partnerNotificationData(ApptSOQL);
        }
    }

    public static void partnerNotificationData(Appointment__c[] appointments){

        for(Integer i = 0; i < appointments.size(); i++){

            // Verify Method of comunication
            String DistributionMethod = appointments[i].Partner__r.Lead_Distribution_Method__c;
            String Channel = appointments[i].Partner__r.Lead_Distribution_Slack_Channel__c;
            String Email = appointments[i].Partner__r.Lead_Distribution_Email__c;
            DateTime ApptDateTime = appointments[i].Appointment_Start_Time__c;
            String dateValue = ApptDateTime.format('yyyy-MM-dd');
            String Message = 'You have New Appointment with '+ appointments[i].First_Name__c + ' '+ appointments[i].Last_Name__c+' on '+ dateValue + ' at '+ appointments[i].Appt_Window_Time__c +' \n Click on the link to view your Appointment https://' + System.URL.getSalesforceBaseUrl().getHost() + '/'+ appointments[i].Id; 
            system.debug('Method: '+ DistributionMethod +' Channel: '+ Channel + ' Email: ' + Email + ' Message: ' + Message);

            if(DistributionMethod == 'Email'){
                //Send Email
                partnerNotificationOperation(true, false, Channel, Email, Message);
                appointments[i].Post_Assignment_Status__c = 'Appointment Sent';
                }

            if(DistributionMethod == 'Slack'){
                //Send Slack
                partnerNotificationOperation(false, true, Channel, Email, Message);
                appointments[i].Post_Assignment_Status__c = 'Appointment Sent';
                }

            if(DistributionMethod == 'Both'){
                //Both
                partnerNotificationOperation(true, true, Channel, Email, Message);
                appointments[i].Post_Assignment_Status__c = 'Appointment Sent';
                }

        }   
        update appointments;
    }
    public static void partnerNotificationOperation(Boolean IsEmail, Boolean IsSlack, String Channel, String Email, String Message){
        
        if(IsEmail && !Test.isRunningTest()){

            // Send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {Email};
            //String[] toAddresses = new String[] {'testEmail@diaco.us'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('New Appointment');
            mail.setPlainTextBody(Message);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        if(IsSlack && !Test.isRunningTest()){

            diaco__slackMessages__c Slack = new diaco__slackMessages__c(
                diaco__message__c = Message,
                diaco__mentionToEveryBody__c = true,
                diaco__slackChannel__c = Channel,
                diaco__Batch_Or_Future__c = true
            ); 

            insert Slack;

        }
    }*/

}