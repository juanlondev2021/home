trigger OpportunityLineMain on OpportunityLineItem (after delete, after insert) {
	map<String,String> pMap = new map<String,String>();
	list<String> oppIds = new list<String>();
	if(trigger.isInsert){
		for(OpportunityLineItem each : trigger.new){
			pMap.put(each.product2id,each.opportunityId);
		}
		for(Product2 eachProd : [select id,name from product2 where id in:pMap.keySet()]){
			if(eachProd.name == 'Prime Front cards')
			oppIds.add(pMap.get(eachProd.Id));
		}
		if(oppIds.size()>0){
			list<Opportunity> oppList = [Select id,Prime_Front__c from Opportunity where id in: oppIds];
			for(Opportunity eachOpp : oppList){
				eachOpp.Prime_Front__c = true;
			}
			try{
				update oppList;
			}
			catch(exception e){
				system.assert(false,e.getMessage());
			}
		}
	}
	if(trigger.isDelete){
		list<String> delOppids = new list<String>();
		map<String,set<String>> oppVsProdMap = new map<String,Set<String>>();
		for(OpportunityLineItem each : trigger.Old){
			delOppids.add(each.opportunityId);
		}
	    system.debug('------delOppids'+delOppids);
		list<OpportunityLineItem> existLineItems = new list<OpportunityLineItem>();
		existLineItems = [select id,opportunityId,product2id,Product_Name__c from OpportunityLineItem where opportunityId in:delOppids];
		if(existLineItems.size()==0){
			list<Opportunity> toBeUpdtOpp = [Select id,Prime_Front__c from Opportunity where id in: delOppids];
			for(Opportunity each : toBeUpdtOpp){
				each.Prime_Front__c = false;
			}
			try{
				update toBeUpdtOpp;
			}
			catch(exception e){
				system.assert(false,e.getMessage());
			}
		}
		else{
			for(OpportunityLineItem each : existLineItems){
				if(!oppVsProdMap.containsKey(each.opportunityId)){
					oppVsProdMap.put(each.opportunityId,new set<String>());
					oppVsProdMap.get(each.opportunityId).add(each.Product_Name__c);
				}
				else
				oppVsProdMap.get(each.opportunityId).add(each.Product_Name__c);
			}
			system.debug('$$$$$$$$'+oppVsProdMap);
			list<opportunity> oppListUpdt = [Select id,Prime_Front__c from Opportunity where id in: oppVsProdMap.keySet()];
			for(Opportunity each : oppListUpdt){
				each.Prime_Front__c = false;
				for(String eachP : oppVsProdMap.get(each.Id)){
					if(eachP == 'Prime Front cards')
					each.Prime_Front__c = true;
				}
			}
			try{
					update oppListUpdt;
			}
			catch(exception e){
				system.assert(false,e.getMessage());
			}
		}
	}
}