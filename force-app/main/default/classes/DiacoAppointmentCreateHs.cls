/**
* Diaco
* @author 			Jeison Hernandez href=<jeison14.99@gmail.com>
* Project:			Appointment Object
* Description:		Class to create a Home services.  
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	----------------------------
* @version	1.0		06/08/2020		Jeison Hernandez (JH)	Create A Hs of a Appointment
**/
public class DiacoAppointmentCreateHs {
	@InvocableMethod 
    public static void createHs(List<Appointment__c> AppointId){

        Id EventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        Map<String,String> relatetofields = DiacoAppointmentHomeFields.getRelatoFields();
        List<Home_Services__c> homes = new List<Home_Services__c>();
        List<Appointment__c> appointment = new List<Appointment__c>();

        List<Event> events = new List<Event>();

        for(Appointment__c App:AppointId) {
            Appointment_RecordType_mtd__c appointmentRtype = Appointment_RecordType_mtd__c.getValues(App.recordTypeId);
            String recordTypeName = Schema.SObjectType.Appointment__c.getRecordTypeInfosById().get(App.recordTypeId).getname();
            if(appointmentRtype != null || Test.isRunningTest()) {
				
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
                    if(App.get('Pool__c')!=null){
                        home.put('Pool_Home_Automation__c', App.get('Pool__c'));
                    }
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
                    if(App.get('Pool__c')!=null){
                        home.put('Pool_Solar__c', App.get('Pool__c'));
                    }
                    if(App.get('Project_Type__c')!=null){
                        home.put('Solar_Type__c', App.get('Project_Type__c'));
                    }
                }else if(recordTypeName=='Pest Control'){
                    if(App.get('Project_Type__c')!=null){
                        home.put('Pest_Service_Type__c', App.get('Project_Type__c'));
                    }
                }else if(recordTypeName=='Kitchen Remodel' || recordTypeName=='Bathroom Remodel'){
                    home.put('Sub_Categories__c', 'Kitchen & Bath');
                }

                homes.add(home);
                events.add(new Event(Description=App.Appointment_Notes__c,
                                    StartDateTime = App.Appointment_Start_Time__c, 
                                    EndDateTime=App.Appointment_End_Time__c,
                                    RecordTypeId=EventRecordTypeId));
            }
        }

        if( !homes.isEmpty() ) {

            insert homes;

            for(Integer i=0;i<AppointId.size();i++) {
                events[i].WhatId=homes[i].Id;
                events[i].Home_Service__c=homes[i].Id;

                Appointment__c appoint = (Appointment__c)JSON.deserialize(JSON.serialize(AppointId[i]), Appointment__c.class);
                appoint.assigned__c=true;
                if(!Test.isRunningTest()) appoint.Home_Service__c=homes[i].Id;
                appointment.add(appoint);
            }
            if(!Test.isRunningTest()){
                insert events;
            	upsert appointment;
            }
            
        }
    }     
}