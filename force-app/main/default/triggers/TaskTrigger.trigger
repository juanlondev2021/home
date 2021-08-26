/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-19-2020
 * @last modified by  : William Aldana
 * Tests              : DiacoHsCountTaskTest
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-19-2020   William Aldana   Initial Version
**/
trigger TaskTrigger on Task (after insert) {
    new TaskTriggerHandler().run('TaskTrigger');
}