trigger DriverMain on Driver__c (after insert,after update) {
	if(trigger.isInsert && trigger.isAfter){
		map<String,String> drIDvsid = new map<String,string>();
		for(Driver__c each : trigger.new){
			drIDvsid.put(each.ID__c,each.id);
		}
		list<Delivery_Object__c> tobeUpdtDO = new list<Delivery_Object__c>();
		tobeUpdtDO = [Select Driver__c,Cheetah_Driver_Code__c from Delivery_Object__c where Cheetah_Driver_Code__c in:drIDvsid.keyset()];
		for(Delivery_Object__c each : tobeUpdtDO){
			if(drIDvsid.containsKey(each.Cheetah_Driver_Code__c))
			each.Driver__c = drIDvsid.get(each.Cheetah_Driver_Code__c);
		}
		GlobalTriggerController.DeliveryObjectTriggerVariable = false;
		update tobeUpdtDO;
	}
}