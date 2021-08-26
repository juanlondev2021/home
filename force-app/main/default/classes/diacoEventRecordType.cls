public class diacoEventRecordType {
	@InvocableMethod(label='Event RecordType' description='Event RecordType.')
    public static void REcordTypeEvent(List<String> param) {
        if (param[0] != null){
            String str = param[0];
            if (str.contains(',')) {
                String[] strSplit = str.split(',');
                diacoEventRecordType dc = new diacoEventRecordType();
                dc.EventsRT(strSplit[0],strSplit[1], true);
            }
    }
    }
    public String EventsRT(String id, String recordType, boolean isProd){
        Event event = [Select Id, WhatId,OwnerId, Home_Service__c, Owner.Name, RecordType.Name, Installation__r.Home_Service__c,
                       Service__r.Home_Service__c from Event where Id=:id];
        System.debug(recordType);
        System.debug('--------------Old Event #1------------------');
        System.debug(recordType);
        System.debug('Hs: '+event.Home_Service__c);
        System.debug('WhatId: '+event.WhatId);
        event.IsPublic__c=isCalendar(event);
        if(event.Home_Service__c == null || isProd==false){
        if(recordType=='Sales' ){
            //do something
            event.Home_Service__c = event.WhatId;
            System.debug('Sales');
        }else if(recordType=='Installation'){
            //do something
            event.Installation__c = event.WhatId;
            event.Home_Service__c = event.Installation__r.Home_Service__c;
            System.debug('Installation');
        }else if(recordType=='Service Technician'){
            //do somethingevent.Installation__c = event.WhatId;
            event.Home_Service__c = event.Service__r.Home_Service__c;
            event.Service__c = event.WhatId;
            System.debug('Service Technician');
        }else {
            System.debug('Nothing was updated.');
        }
        }
        System.debug('New Event.');
        update event;
        System.debug(event);
        return 'Id updated';
    }
    
    public boolean isCalendar(Event event){
        System.debug('--------------Is calendar or User---------------');
        System.debug(event.Owner.Name);
        //System.debug(event.Owner.Name.contains('Public Calendar'));
        System.debug(event.OwnerId);
        boolean iscalendar = false;
        if(event.Owner.Name.contains('Public Calendar') ||
          event.Owner.Name=='Unassigned Calendar'){
            isCalendar= true;
            System.debug('Is calendar');
        }
        return isCalendar;
    }
}