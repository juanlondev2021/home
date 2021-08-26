trigger LineItemTrigger on Line_Item__c ( before update) {
	System.debug('Trigger Update');
	new LineItemTriggerHandler().run('LineItemTrigger');
}