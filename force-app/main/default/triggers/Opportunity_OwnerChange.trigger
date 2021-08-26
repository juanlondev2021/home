trigger Opportunity_OwnerChange on Opportunity (before insert,after update) {
    List<Account> actList=new List<Account>(); 
    set<id> aSet=new set<id>();
    for(Opportunity opt:Trigger.New){
        if(opt.StageName <> 'Closed Lost'){ 
            aSet.add(opt.Accountid);
        }
    }    
    Map<Id,Account> aMap = new Map<Id,Account>([SELECT ID, OwnerId FROM Account WHERE Id =: aSet]);
    for(Opportunity opt:Trigger.New){
        /*
        if(Trigger.isAfter && Trigger.isUpdate)
        { 
            if(aMap.get(opt.Accountid).ownerid <> opt.Ownerid){
                Account a=aMap.get(opt.Accountid);
                a.ownerid=opt.ownerid;
                actList.add(a);
            }
        }*/
        if(Trigger.isbefore && Trigger.isInsert)
        {
            if(opt.StageName <> 'Closed Lost'){ 
                 Account a=aMap.get(opt.Accountid);
                 opt.ownerid=a.ownerid;
             }                            
        }   
    }
    
    if(actList.size()>0) update actList;
     
   }