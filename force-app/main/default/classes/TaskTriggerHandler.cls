/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-19-2020
 * @last modified by  : William Aldana
 * Test               : DiacoHsCountTaskTest
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-19-2020   William Aldana   Initial Version
**/
public class TaskTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        TaskTriggerHelper.logCallCreation(Trigger.new);
        TaskTriggerHelper.countTaskAndSendSMS(Trigger.new);
    }
}