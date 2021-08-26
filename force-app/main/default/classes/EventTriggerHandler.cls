/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-22-2020
 * @last modified by  : William Aldana
 * apex covered by   : EventTriggerTest
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-15-2020   William Aldana   Initial Version
 * 1.1   26-12-2020   Jull Quintero D  Create SMS
**/
public class EventTriggerHandler extends TriggerHandler {
   
    public override void afterInsert(){
        EventTriggerHelper.execute(Trigger.New);
        EventTriggerHelper.createSMS((List<Event>)Trigger.new, null,Trigger.isInsert,Trigger.isUpdate);
    }

    public override void afterUpdate() {
        EventTriggerHelper.execute(Trigger.New);
        EventTriggerHelper.executeV2(Trigger.old, Trigger.new, Trigger.isDelete, Trigger.isUpdate);
        EventTriggerHelper.createSMS((List<Event>)Trigger.new, (Map<Id, Event>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);
    }
     
    public override void afterDelete(){
        EventTriggerHelper.executeV2(Trigger.old, Trigger.new, Trigger.isDelete, Trigger.isUpdate);
        EventTriggerHelper.clearRelatedObjectEvent(Trigger.old);
    }

    public override void beforeUpdate(){
        EventTriggerHelper.sendEmailReviewMain(Trigger.isUpdate, (List<Event>)Trigger.new, (Map<Id, Event>)Trigger.oldMap);
    }
  
}