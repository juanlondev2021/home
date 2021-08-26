/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-18-2020
 * @last modified by  : Fabian Pineda
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-17-2020   William Aldana   Initial Version
 * 1.0   09-18-2020   Fabian Pineda    Imported existing code from the older DiacoHomeServiceTrigger trigger.
**/
trigger HomeServicesTrigger on Home_Services__c (before update, after insert, after update) {
	new HomeServicesTriggerHandler().run('HomeServicesTrigger');
}