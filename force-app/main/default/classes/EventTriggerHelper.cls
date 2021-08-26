/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-22-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-15-2020   William Aldana   Initial Version
 * 1.1   22-10-2020   William Aldana   MY-598 Event Deleted
 * 1.2   17-12-2020   Jull Quintero D  New Appointment SMS
 **/
public class EventTriggerHelper {
   
    /**
    * 
    * This method is responsible to execute all method this class after selecting the Objects 
    * that meet the conditions.
    * This method is used in:
    * EventTrigger trigger
    * 
    * @param List<String> Ids
    * @return String
    **/
        
    public static string execute(List<Event> triggerEvents){
        List <String> eventsId = new List<String>();
        
        //Check if it is a homeservice event and if the DiacoAppoiment2__EventConfig__c field is null.
        Integer triggerEventsSize = triggerEvents.size();    
        for (Integer i = 0; i < triggerEventsSize; i++) {
            Event event = triggerEvents[i];
            if(event.WhatId != null){
                Id idToProccess = event.WhatId; 
                if(String.valueOf(idToProccess.getSObjectType()) == 'Home_Services__c'
                && event.DiacoAppoiment2__EventConfig__c == null
                && event.Home_Service__c != null){
                    eventsId.add(event.Id);
                }
            }else if(event.DiacoAppoiment2__EventConfig__c == null
                    && event.Home_Service__c != null){
                        eventsId.add(event.Id);
            }
        }
        
        //If at least one event meet the criteria it will get the adittional fields required for later processing(using the eventAppt method)
        if(!eventsId.isEmpty()){   
            list<Event> events = [select Location, DiacoAppoiment2__EventConfig__c,Home_Service__r.Street__c,
                                Home_Service__r.State__c,Home_Service__r.Zip__c, Home_Service__r.City__c, RecordType.Name,
                                Home_Service__r.Industry_Formula__c, Name__c, Id,Home_Service__r.RecordType.Name
                                from Event where Id in :eventsId];
            
            eventAppt(events);
        }

        return 'Good';
    }

    /*
    *@Author: Jull Q Daza - 26/12/2020
     * This method is responsible to create SMS
     * 
     * This method is used in:
     * EventTriggerHandler.cls
     * 
     * @param List Event newEvt, 
     * Map Event oldEvt
     */
    public static void createSMS(Event[] events, Map<Id, Event> oldEvtMap,Boolean isInsert,Boolean isUpdate) {
        new CreateSMS(events,oldEvtMap,isInsert,isUpdate);
    }


    /**
    * 
    * This method is responsible to create eventconfig record to event.
    * 
    * This method is used in:
    * DiacoEventConfig execute method 
    * 
    * @param List<Event>
    * @return String
    **/
    public static String eventAppt(list<Event> events){
        //EJ: SOlar installation
        list<DiacoAppoiment2__EventConfig__c> eventsConfig = new list<DiacoAppoiment2__EventConfig__c>();
        list<DiacoAppoiment2__AppoinmentType__c> eventsType = new list<DiacoAppoiment2__AppoinmentType__c>();
        list<DiacoAppoiment2__Sub_Industry__c> subIndustries = new list<DiacoAppoiment2__Sub_Industry__c>();
        
    
        if(!events.isEmpty()){
            eventsType = [select Id, Name from DiacoAppoiment2__AppoinmentType__c];
            subIndustries = [select Id, Name, DiacoAppoiment2__Industry__c from DiacoAppoiment2__Sub_Industry__c];
            
            System.debug(eventsType);
            
            //For each event check Type(Sales,Industry,etc) and Sub Industry(Solar,Water,etc) and create an DiacoAppoiment2__EventConfig__c object
            //with the name of the event+ID  and type,industry,sub industry that matched 
            //THEN pass  the EventConfig Created and normal events to the next method
            Integer eventsSize = events.size();
            for (Integer i = 0; i < eventsSize; i++) {
                Event event = events[i];
                System.debug('###RecordType###> '+event.RecordType.Name);
                DiacoAppoiment2__EventConfig__c eventConfig = new DiacoAppoiment2__EventConfig__c();
                for(DiacoAppoiment2__AppoinmentType__c eventType : eventsType){
                    System.debug('###EventType###> '+eventType.Name);
                    System.debug('###RecordType###> '+event.Home_Service__r.RecordType.Name);
                    if(event.Home_Service__r.RecordType.Name != null){
                        if(event.Home_Service__r.RecordType.Name.contains(eventType.Name)){
                            eventConfig.Name = event.Name__c +' '+ event.Id;
                            eventConfig.DiacoAppoiment2__AppoinmentType__c = eventType.Id; 
                            break;
                        }
                    }
                }

                for(DiacoAppoiment2__Sub_Industry__c subIndustry : subIndustries){
                    if(event.Home_Service__r.Industry_Formula__c == subIndustry.Name){
                        eventConfig.DiacoAppoiment2__Industry__c = subIndustry.DiacoAppoiment2__Industry__c; 
                        eventConfig.DiacoAppoiment2__SubIndustry__c = subIndustry.Id; 
                        break;
                    }
                }
                System.debug(eventConfig);
                if(eventConfig.Name != null){
                    eventsConfig.add(eventConfig);
                }
                
            }
            insert eventsConfig;
            saveEvent(events, eventsConfig);
        }
        return 'Saved';
    }


    /**
    * 
    * This method is responsible to save eventconfig record and update event with eventConfig.
    * 
    * This method is used in:
    * DiacoEventConfig eventAppt method 
    *  
    * 
    * @param List<Event>, list<DiacoAppoiment2__EventConfig__c>
    * @return String
    **/
    public static String saveEvent(list<Event> events, list<DiacoAppoiment2__EventConfig__c> eventsConfig){
        list<Event> events2 = new list<Event>();
        for(Event event : events){
            for(DiacoAppoiment2__EventConfig__c eventConfig : eventsConfig){
                if(eventConfig.Name.contains(event.Id)){
                    event.DiacoAppoiment2__EventConfig__c = eventConfig.Id;
                    break;
                }
            }
            if(event.DiacoAppoiment2__EventConfig__c!=null){
                events2.add(event);
            }
        }
        System.debug('###Events Eventconfig###');
        System.debug(events2);
        if(!events2.isEmpty()){
            TriggerHandler.bypass('EventTrigger');
                update events2;
            TriggerHandler.clearBypass('EventTrigger');
        }
        
        return 'Good';
    }

    /**
    * @description 3. This triggers calculate de sum fields for total of appointment-events in the past 16 weeks for 
    * the user and personnel and the events with closed-won status
    * @author Álvaro Ortega (AO) |	05/04/2019
    * @param oldList 
    * @param newList 
    * @param isDelete 
    * @param isUpdate 
    **/
    public static void executeV2(List<Event> oldList, List<Event> newList, Boolean isDelete, Boolean isUpdate){
        set<ID> usersId = new set<ID>();
        List<Event> olds = oldList;
        List<Event> news = isDelete? oldList : newList;
        Integer oldSize = olds.size();
        for(Integer x=0; x < oldSize; x++) {
            if(isDelete || news[x].OwnerId!=olds[x].OwnerId ||
               news[x].Current_Appointment__c!=olds[x].Current_Appointment__c || 
               news[x].Current_Status__c!=olds[x].Current_Status__c){
                    usersId.add(news[x].OwnerId);
                    if(isUpdate && news[x].OwnerId!=olds[x].OwnerId){
                        usersId.add(olds[x].OwnerId);
                    }
               }
        }
        //After gettin the list of user to process we call the Exeute from DiacoTriggerUserRepCountEvent ontroller
        //DiacoTriggerUserRepCountEvent.executeV2(usersToProcess);      

        system.debug('-----V2----------');
        //New list of users to get personnel field
        Map<ID,User> users = New Map<ID,User>([ Select Id,Personnel__c From User WHERE Id IN :usersId]);
        if(!users.isEmpty()){
            Date actualDate=date.today();
            DateTime toDate=actualDate.toStartOfWeek();
            toDate=toDate.addHours(7); //It's in weeks so it will be updated every week
            DateTime fromDate=toDate.addDays(-84);  //84 days same 12 weeks
            
            list<AggregateResult> totalEventsAggregated=[SELECT COUNT(id) total,OwnerId FROM Event 
                                                         WHERE OwnerId IN :usersId and Current_Appointment__c=True
                                                         and CreatedDate>=:fromDate and CreatedDate<=:toDate 
                                                         GROUP BY OwnerId];//Query for getting all users with the total of appointments       
            
            list<AggregateResult> totalEventsClosedWonAggregated=[SELECT COUNT(id) total,OwnerId FROM Event 
                                                                  WHERE OwnerId IN :usersId and Current_Appointment__c=True
                                                                  and CreatedDate>=:fromDate and CreatedDate<=:toDate 
                                                                  and Current_Status__c='Closed Won'
                                                                  GROUP BY OwnerId];//Query for getting all users with the total of appointments  closed won
            
            Map<ID,Integer> mapUserTotalEvent = getUserEventMap(usersId,totalEventsAggregated);
            Map<ID,Integer> mapUserTotalEventClosedWon = getUserEventMap(usersId,totalEventsClosedWonAggregated);
            List<User> usersToUpdate= NEW List<User>();
            List<Personnel__c> personnelsToUpdate = NEW List<Personnel__c>();
            
            for(ID userI:usersId){
                User currentUser=users.get(userI);
                User newUser= NEW User();
                newUser.Id = userI;
                newUser.Total_Of_Event__c = mapUserTotalEvent.get(userI);
                newUser.Event_Sales_Approved__c = mapUserTotalEventClosedWon.get(userI);
                usersToUpdate.add(newUser);
                //                system.debug(mapUserTotalEvent.get(userI));
                if(String.isNotBlank(currentUser.Personnel__c)){
                    Personnel__c p=new Personnel__c();
                    p.Id = currentUser.Personnel__c;
                    p.Total_Of_Event__c = mapUserTotalEvent.get(userI);
                    p.Event_Sales_Approved__c = mapUserTotalEventClosedWon.get(userI);
                    personnelsToUpdate.add(p); 
                }
            }

            try{
                update personnelsToUpdate;
                update usersToUpdate; 
            }catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
            }
        }        
    }  

   
    /**
    * @description This method will organize for each user his proper total of event and events with 
    *              status closed won. using the Aggregate queries used before, if it's not in the query its 
    *              value will be 0;
    * @author John Hernandez (JH) | 09-09-2020 
    * @param usersId 
    * @param aggregateList 
    * @return Map<ID, Integer> 
    **/
    public static Map<ID,Integer> getUserEventMap (set<ID> usersId, list<AggregateResult> aggregateList){
        Map<ID,Integer> listID_Total=New Map<ID,Integer>();
        for(ID userId:usersId){
            Integer total=0;
            for(AggregateResult result:aggregateList){
                if(String.valueOf(result.get('OwnerId')) ==userId){
                    total= Integer.valueOf(result.get('total'));
                }
            }
            listID_Total.put(userId,total);
        }
        return listID_Total;
    } 

    /**
    * @description 
    * @author Esnayder Morales (ES) | 14/08/2019		
    * @param isUpdate 
    * @param newEventList 
    * @param oldEventMap 
    **/
    public static void sendEmailReviewMain(Boolean isUpdate, List<Event> newEventList, Map<Id, Event> oldEventMap){
        if(isUpdate){       
            Integer newEventListSize = newEventList.size();
            for (Integer i = 0; i < newEventListSize; i++) {
                Event event = newEventList[i];
                Event oldEvent = oldEventMap.get(event.Id);
                if((event.Appointment_results__c == 'PM' ||
                   event.Appointment_results__c == 'Sale Pending')
                  && oldEvent.Appointment_results__c != event.Appointment_results__c){
                       System.debug('Test condition Approved');
                      sendEmailReview(event.Id);
                  }
            }
        }
    }

   /**
    * 
    * This method is responsible to send review email.
    * 
    * This method is used in:
    *  the  DiacoSendEmailReview.apxt trigger
    *  Esnayder Morales (ES) 14/08/2019				
    * 
    * @param RecordId is the Event Id controller
    * @return nothing
    */ 
    @future(callout=true)
    public static void sendEmailReview(String Id){
        Event event = [select Id, Home_Service__r.Account__r.PersonEmail,
                    event.Home_Service__r.Account__c, Home_Service__r.RecordType.Name,
                    Home_Service__r.Account__r.Validate_Email__c     
                    from Event where Id=:Id];
        if(event.Home_Service__r.Account__r.PersonEmail != null
        && event.Home_Service__r.Account__r.Validate_Email__c =='Valid'){
            sendEmail(event);
            System.debug('Email sent');
        }
    }

    /**
    * 
    * This method is responsible to send review email.
    * 
    * This method is used in:
    *  the  DiacoSendEmailReview.apxc apex
    *  
    * 
    * @param Event
    * @return HttpResponse
    */ 
    public static HttpResponse sendEmail(Event event){
        Send_Grid__c config = [select Api_Key__c from Send_Grid__c];
        Map<String, String> template = getTemplate(event.Home_Service__r.RecordType.Name);
        
        String endpoint = 'https://api.sendgrid.com/v3/mail/send';
        String body = '{"personalizations": [{'+
            '"to": ['+
            '{'+
            '"email":"' +event.Home_Service__r.Account__r.PersonEmail+'"'+
            '}'+
            '],'+
            '"dynamic_template_data": {'+
            '"EventId":"'+event.Id+'"'+
            '},'+
            '}],'+
            '"template_id":"'+template.get('template')+'",'+
            '"from": {'+
            '"email":'+ '"'+template.get('email')+'"'+
            '}'+
            '}';
        System.debug(body);
        System.debug(config.Api_Key__c);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', config.Api_Key__c);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        System.debug(request.getHeader('Authorization'));
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                        response.getStatusCode() + ' ' + response.getStatus());
            
        }
        
        return response;
    }

    /**
    * 
    * This method is responsible to get template Id and email.
    * 
    * This method is used in:
    *  the  DiacoSendEmailReview.apxc apex
    *  
    * 
    * @param name recordtype de home services
    * @return Map<String, String>
    */ 
    public static Map<String, String> getTemplate(String name){
        Send_Grid__c templates = [select Home_Automation__c, Solar__c, Water__c, Windows__c,
                                Email_Solar__c, Email_Home_Automation__c, Email_Water__c,
                                Email_Window__c
                                from Send_Grid__c];
        Map<String, String> template = new Map<String, String>();
        template.put('template', '');
        template.put('email', '');
        if(name.contains('Solar')){
            template.put('template', templates.Solar__c);
            template.put('email', templates.Email_Solar__c);
        }else if(name.contains('Water')){
            template.put('template', templates.Water__c);
            template.put('email', templates.Email_Water__c);
        }else if(name.contains('Window')){
            template.put('template', templates.Windows__c);
            template.put('email', templates.Email_Window__c);
        }else if(name.contains('Home Automation')){
            template.put('template', templates.Home_Automation__c);
            template.put('email', templates.Email_Home_Automation__c);
        }
        return template;
    } 
    
    /**
    * @description 
    * @author William Aldana | 10-22-2020 
    * @param oldList 
    **/
    public static void clearRelatedObjectEvent(List<Event> oldList){
        List<SObject> sObjectsToUpdate = new List<SObject>();
        for (Event oldEvent : oldList) {
            if (oldEvent.whatId != null) {
                String objectName = getObjectName(oldEvent.whatId);
                if(objectName == 'Home_Services__c' || objectName == 'Installation__c' || objectName == 'Service__c'){
                    sObject outObj = Schema.getGlobalDescribe().get(objectName).newSObject();
                    outObj.put('Event__c', null);
                    outObj.put('Id', oldEvent.whatId);
                    sObjectsToUpdate.add(outObj);
                }    
            }    
        }
        update sObjectsToUpdate;
    }

    /**
    * @description get object name
    * @author William Aldana | 10-22-2020 
    * @param recordId 
    * @return String 
    **/
    public static String getObjectName(String recordId){
        return Id.valueOf(recordId).getSObjectType().getDescribe().getName();
    }

}