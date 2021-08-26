public class diacoEventCurrent {
	@InvocableMethod(label='Current appointment' description='Current appointment.')
    public static void CurrentEvent(List<String> param) {
        if (param[0] != null){
            String str = param[0];
            if (str.contains(',')) {
                String[] strSplit = str.split(',');
                diacoEventCurrent current = New diacoEventCurrent();
                String result = current.currentEvent(strSplit[0], strSplit[1], strSplit[2]);
                System.debug(result);
            }
        }
    }
    
    public String currentEvent(String id, String recordType, String hs){
        Event eventCurrent = [Select Id, Home_Service__c, Current_Appointment__c from Event where Id=:id]; 
        List<Event> eventsOld =[Select Id, Home_Service__c, Current_Appointment__c from Event 
                                Where RecordTypeId=:recordType AND Home_Service__c=:hs AND Id!=:id
                               AND Current_Appointment__c = true];
        List<Event> events = new List<Event>(); 
        System.debug('New');
        System.debug(eventCurrent);
        System.debug('Old');
        System.debug(eventsOld);
        System.debug(eventsOld.size());
        eventCurrent.Current_Appointment__c = true;
        events.add(eventCurrent);
        for(Event event : eventsOld){
            event.Current_Appointment__c = false;
            events.add(event);
        }
        update events;
        System.debug('Updated');
        System.debug(events);
        return 'Good Updated';
    }
}