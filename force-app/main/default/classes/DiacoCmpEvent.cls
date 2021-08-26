/**
 *
 * Diaco
 * @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 * Project:			diacoCmpTask
 * Description:		Class reponsible provide method to diacocreateEventFlow
 *
 * Changes (Version)
 * _________________________________________
 *
 * 			No.		Date			Author					Description
 * 			____	__________      __________________ 		_____________________________________
 * @version	1.0		14/07/2020		Esnayder Morales (ES)	Initial implementation  of the class.
 */
public class DiacoCmpEvent {
    /**
 * This method is responsible to save event
 * 
 * This method is used in:
 * diacocreateEventFlowHelper.js
 * 
 * @param Event event
 * @return event
 **/
	@AuraEnabled
    public static Event saveDataEvent(Event event){
        List<RecordType> rts = [Select Id, Name, SobjectType from RecordType where Name='Sales' and SobjectType='Event'];
        event.RecordTypeId = rts[0].Id;
        upsert event;

        return event;
    }
}