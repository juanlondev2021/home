public class diacoEventPublic {
    
    @InvocableMethod(label='Event is user o calendar' description='Event RecordType.')
    public static void Ispublic(List<String> param) {
        
        if (param[0] != null){
            System.debug('--------------Test Funtionality------------------');
        System.debug(param);
            String str = param[0];
            if (str.contains(',')) {
                String[] strSplit = str.split(',');
                diacoEventPublic dc = new diacoEventPublic();
                dc.EventsIsPublic(strSplit[0]);
            }
    }
    }
    
    public String EventsIsPublic(String id){
        Event event = [Select Id, Owner.Name, IsPublic__c from Event where Id=:id];
        System.debug('--------------Old Event #1------------------');
        System.debug(event);
        event.IsPublic__c=isCalendar(event);
        System.debug('--------------New Event #1------------------');
        System.debug(event);
        update event;
        return 'Event updated';
    }
    
	public boolean isCalendar(Event event){
        System.debug('Is calendar or User');
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