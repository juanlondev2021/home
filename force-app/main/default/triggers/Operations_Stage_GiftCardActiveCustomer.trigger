trigger  Operations_Stage_GiftCardActiveCustomer on Gift_Card_Orders__c (after update) 
{
    Set<ID> gSet=new Set<ID>();
    Map<ID,String> gcMap=new Map<ID,String>();
    Map<ID,String> gcoMap=new Map<ID,String>();
    Map<ID,ID> opMap=new Map<ID,ID>();
    Set<ID> optySet=new Set<ID>();
    List<Opportunity> optyListUpdate=new List<Opportunity>();
    /*
    for(Gift_Card_Orders__c gco:Trigger.new){
        if(gco.Parent_Gift_Card_Order__c == null){
            gSet.add(gco.id);    
        }
    }   
    integer ic=1;   
    for(Delivery_Object__c d:[select ID,Parent_Gift_Card_Order__c from Delivery_Object__c where Parent_Gift_Card_Order__c in :gSet and Delivered__c >0 and Delivered__c !=null]){
        
        if(gcMap.containsKey(d.Parent_Gift_Card_Order__c)){
            integer i=gcMap.get(d.Parent_Gift_Card_Order__c)+1;
            gcMap.put(d.Parent_Gift_Card_Order__c,i);
        }else{
            gcMap.put(d.Parent_Gift_Card_Order__c,ic);
        }
        ic=0;
    }
    for(Gift_Card_Orders__c gco :[select id,Name,Parent_Gift_Card_Order__c from Gift_Card_Orders__c where Parent_Gift_Card_Order__c in :gSet  order by Name limit 1]){
        if(!gcoMap.containsKey(gco.id)){
            if(gcMap.get(gco.Parent_Gift_Card_Order__c) >=1)
            gcoMap.put(gco.ID,gco.Name);
        }        
    }   
    system.debug('gcoMap ##'+gcoMap);
    */
    for(Gift_Card_Orders__c gco : Trigger.new){
        if(gco.Active_Custom_CheckBox__c ==true && gco.Parent_Gift_Card_Order__c == null)
        gcoMap.put(gco.ID,gco.Name);
    }
    system.debug('gcoMap ###'+gcoMap);
    
    for(Gift_Card_Orders__c gco :[select id,Name,Parent_Gift_Card_Order__c from Gift_Card_Orders__c where Parent_Gift_Card_Order__c in :gcoMap.keyset() order by Name limit 1]){
        if(!gcMap.containsKey(gco.id)){          
            gcMap.put(gco.ID,gco.Name);
        }        
    }   
    
    for(Gift_Card__c gc:[select id,Opportunity__c,Opportunity__r.StageName,Opportunity__r.Stage_Types__c from Gift_Card__c where Gift_Card_Order__c in :gcMap.keyset()]){
      if(gc.Opportunity__r.StageName=='Closed Won' && gc.Opportunity__r.Stage_Types__c=='Gift Card')
     optySet.add(gc.Opportunity__c);
    }
    
    for(Opportunity opt:[select id,Operational_Stages__c from Opportunity where id in:optySet]){
       if(opt.Operational_Stages__c <> 'Deactivated Customer'){
            opt.Operational_Stages__c='Gift Card Active Customer';
            optyListUpdate.add(opt);
        }
    }
    if(optyListUpdate.size()>0) update optyListUpdate;
    
}