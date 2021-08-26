trigger Operation_Stageset_to_Gift_Card_Ordered on Gift_Card__c (after insert) {

    Set<ID> optySet=new Set<ID>(); 
    List<Opportunity> optyList=new List<Opportunity>();
    for(Gift_Card__c gf:Trigger.new){
        if(gf.Opportunity__c <> null){
            optySet.add(gf.Opportunity__c);
        }
    }
    for(Opportunity opty:[select id,Operational_Stages__c From Opportunity where id in:optySet and Operational_Stages__c = 'Gift Card Proof Approved' and Operational_Stages__c !='Gift Card Ordered'])
    {
        opty.Operational_Stages__c='Gift Card Ordered';
        optyList.add(opty);            
    }    
    if(optyList.size() >0) update optyList;
}