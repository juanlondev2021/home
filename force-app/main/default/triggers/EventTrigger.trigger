/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-15-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-15-2020   William Aldana   Initial Version
**/
trigger EventTrigger on Event (after insert,after update, after delete, before update) {
    new EventTriggerHandler().run('EventTrigger');
}