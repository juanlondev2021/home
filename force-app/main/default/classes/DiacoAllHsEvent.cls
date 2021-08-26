/*
* Diaco
* @author 			Kevin A. Vega H href=<kevin.vega.h@hotmail.com>
* Project:			Events
* Description:		
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version	1.0		25/05/2020		Kevin A. Vega H (KV)	Initial implementation of the class.
*/
public class DiacoAllHsEvent {
    @InvocableMethod(label='New Current appointment' description='New Current appointment.')
    
    public static void CurrentEvent(List<String> param) {
        
        System.debug(param);
        System.debug(param.size());
        
        List<Event> eventListByParam = [Select Id, RecordTypeId,RecordType.name,WhatId,Installation__r.Home_Service__c,Service__r.Home_Service__c,
                                        DiacoAppoiment2__EventConfig__c, Home_Service__c,Home_Service__r.Street__c, Home_Service__r.State__c,
                                        Home_Service__r.Zip__c, Home_Service__r.City__c,Home_Service__r.Industry_Formula__c, Name__c, 
                                        Home_Service__r.RecordType.Name from Event where Id in:param];
        
        if(eventListByParam.size()>0){
            
            List<String> idList = new List<String>(),
            whatIdList = new List<String>(),
            recordTypeIdList = new List<String>(),
            recordTypeNameList = new List<String>();
                  
            for(Event eventByParam :eventListByParam){
                                
                String id = eventByParam.Id; 
                String recordTypeId = eventByParam.RecordTypeId; 
                String recordTypeName = eventByParam.RecordType.Name;      
                String whatId = eventByParam.WhatId;    
                
                System.debug(whatId);
                
                // if the event contains an whatId this is execute.
                if(whatId != null){
                    String sObjName = getObjectName(whatId);
                    
                    if(sObjName =='Home_Services__c' || sObjName =='Installation__c'  || sObjName =='Service__c'){
                      
                        idList.add(id);
                        whatIdList.add(whatId);
                        recordTypeIdList.add(recordTypeId);
                        recordTypeNameList.add(recordTypeName);
                    
                    } 
                }
            }
            // Contains all events by WhatId list.
            List<Event> eventsByWhatIdList = [Select Id, WhatId, OwnerId, Owner.Name, RecordType.Name,
            Installation__r.Home_Service__c,Service__r.Home_Service__c, 
            Home_Service__c, Current_Appointment__c from Event where WhatId in :whatIdList];

            if(eventsByWhatIdList.size()> 0){

                list<Home_Services__c> homeServiceList = new list<Home_Services__c>();
                list<event> eventListToUpdate =  new list<event>();
                list<event> eventRTListToUpdate =  new list<event>();
                
                for (Integer i=0; i < idList.size(); i++) {

                    List<Event> eventListFiltered = new List<Event>();
                    List<Event> eventListByWhatId = new List<Event>();

                    for (Event event: eventsByWhatIdList){
                                  
                        if(whatIdList[i] == event.WhatId){

                            if((event.RecordTypeId == recordTypeIdList[i]) && 
                            (event.Id != idList[i]) && (event.Current_Appointment__c == true)){
                                
                                eventListFiltered.add(event);	                           
                                
                            }

                            eventListByWhatId.add(event);

                        }
                    }
                    
                    if(getObjectName(whatIdList[i]) =='Home_Services__c'){
                
                        homeServiceList.add(countSales(idList[i],whatIdList[i],eventListByWhatId));
                    
                    }  

                    list<Event> eventCurrentT = new list<Event>(); 
                    eventCurrentT = currentEvent(idList[i], eventListFiltered);

                    for(Event ev : eventCurrentT){
                        eventListToUpdate.add(ev);
                    }

                    for(event eventElement: eventListByParam){

                        if(idList[i] == eventElement.Id){
                            eventRTListToUpdate.add(EventsRT(eventElement,true));
                        }  
                    }                 
                }

                update homeServiceList;
                update eventListToUpdate;
                update eventRTListToUpdate;
            }                              
        }
          
    }
    
    public static Home_Services__c countSales(String id,string whatId, List<Event> events){
        
        Integer countSales = 0;                
        
        for (Event event: events){
            
            if(event.RecordType.Name == 'Sales'){
                countSales = countSales + 1;                           
            }
        }
        
        Home_Services__c hs = new Home_Services__c(
            Id = whatId,
            Event_Count__c = countSales,
            Event__c = id
        );
        
        return hs;
   
    }
    
    public static String getObjectName(String recordId){
        return Id.valueOf(recordId).getSObjectType().getDescribe().getName();
    }
    
    public static List<Event> currentEvent(String id, List<Event> eventsOld){
        
        List<Event> events = new List<Event>(); 
       
        Event eventCurrent =  new Event(
            Id = id,
            Current_Appointment__c = true
        );

        events.add(eventCurrent);
        for(Event event : eventsOld){
            event.Current_Appointment__c = false;

            events.add(event);
        }

        return events;

    }
    
    
    public static Event eventsRT(Event event ,boolean isProd){
 
        if(event.Home_Service__c == null || isProd==false){

            String recordType = event.RecordType.name;

            if(recordType == 'Sales' ){

                event.Home_Service__c = event.WhatId;

            }else if(recordType=='Installation'){

                event.Installation__c = event.WhatId;
                event.Home_Service__c = event.Installation__r.Home_Service__c;
                system.debug('Installation: '+event.Installation__c);
                system.debug('Installation - HS: '+event.Installation__c);

            }else if(recordType=='Service Technician'){

                event.Service__c = event.WhatId;
                event.Home_Service__c = event.Service__r.Home_Service__c; 
                system.debug('Installation: '+ event.Service__c);
                system.debug('Installation - HS: '+event.Home_Service__c); 

            }else {
                System.debug('Nothing was updated.');
            }
            
            /*if((recordType =='Service Technician' || 
            recordType=='Installation' || 
            recordType=='Sales' ) && 
               (event.DiacoAppoiment2__EventConfig__c == null)){
                   
                   list<Event> eventList = new list<Event>();
                   eventList.add(event);
                   DiacoEventConfig.eventAppt(eventList);
                   
               }*/    
        }

        return event;
    }    
}