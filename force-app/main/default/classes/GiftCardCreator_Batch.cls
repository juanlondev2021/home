global class GiftCardCreator_Batch implements Database.Batchable<Sobject>, Database.Stateful{
	global String selectedBranch;
    global String batchNumber;
    global list<String> gcoIds;
    global map<String,String> csMap;
    global list<String> oppList;
   global GiftCardCreator_Batch(String selBranch,String bNumber,list<String> gcIds,map<String,String> cMap, list<String> oppLst){
   		gcoIds = new list<String>(); 
   		csMap = new map<String,String>();
   		oppList = new list<String>();
		this.csMap.putAll(cMap); 
		this.gcoIds.addAll(gcIds);
		this.selectedBranch = selBranch;
		this.batchNumber = bNumber;
		this.oppList.addAll(oppLst);
		system.debug('-------'+oppList);
		system.debug('----oppLst---'+oppLst);
	}
	
	 global Database.queryLocator start(Database.BatchableContext bc){
	 	String ids = '(';
	 	for(String each : gcoIds){
	 		ids+='\''+each+'\''+',';
	 	}
	 	ids =ids.removeEnd(',');
	 	ids+=')';
	 	String query = 'Select id,name from Gift_Card_Orders__c where id in'+ids;
	 	return Database.getQueryLocator(query);
	 }
	 global void execute(Database.BatchableContext bc, List<Sobject> scope) {
	 	list<Gift_Card_Orders__c> gcoList = (list<Gift_Card_Orders__c>)scope;
	 	list<Gift_Card__c> giftCardList = new list<Gift_Card__c>();
        integer i=1;
        for(Gift_Card_Orders__c each :  gcoList){
             for(String eachOpp : oppList){
                String nnth = String.valueOf(i);
                if(nnth.length() == 1)nnth='000'+nnth;
                 if(nnth.length() == 2)nnth='00'+nnth;
                  if(nnth.length() == 3)nnth='0'+nnth;
                Gift_Card__c giftCard = new Gift_Card__c();
                giftCard.Opportunity__c = eachOpp;
                giftCard.Gift_Card_Order__c = each.Id;
                system.debug('@@@@'+each.name);
                giftCard.name = csMap.get(selectedBranch)+' '+batchNumber+' '+nnth+' '+each.name.substring(each.name.length()-4,each.name.length());
                giftCardList.add(giftCard);
                i++;
                if(i>oppList.size())i=1;
             }
		 }
		  database.insert(giftCardList,false);
	 }
	  global void finish(Database.BatchableContext bc){
	  	
	  }

}