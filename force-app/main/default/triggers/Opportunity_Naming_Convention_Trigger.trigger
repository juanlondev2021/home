trigger Opportunity_Naming_Convention_Trigger on Opportunity (before insert,before update, after insert) {

    String OptyName='';
    Map<ID,String> acctMap=new Map<ID,String>();
    set<ID> acctSet=new Set<ID>();
    
    for(Opportunity opty: Trigger.New){        
        acctSet.add(opty.Accountid);
    }
    for(Account a:[select Id,Name from Account where id in :acctSet]){
       acctMap.put(a.id,a.Name); 
   }    
    
   if(Trigger.isbefore && (Trigger.isInsert || Trigger.isUpdate))
   {   
    for(Opportunity opty: Trigger.New){        
        if(OptyName ==''){           
            OptyName=acctMap.get(opty.Accountid); 
            if(opty.Stage_Types__c <> Null)
            {
               OptyName =OptyName +'-'+opty.Stage_Types__c; 
            }else{
               OptyName +='-Null'; 
            }
            if(opty.Branch__c <> Null)
            {
               OptyName=OptyName +'-'+opty.Branch__c; 
            }else{
               OptyName=OptyName +'-'+'Null'; 
            }           
            OptyName=OptyName +'-'+opty.Opp_Number__c;            
            opty.Name=OptyName; 
            OptyName=''; 
        }         
    }    
  }
  /*
  if(Trigger.isAfter && Trigger.isInsert){
      
      for(Opportunity opty: Trigger.New){        
        if(OptyName ==''){           
            OptyName=acctMap.get(opty.Accountid); 
            if(opty.Stage_Types__c <> Null)
            {
               OptyName =OptyName +'-'+opty.Stage_Types__c; 
            }else{
               OptyName +='-Null'; 
            }
            if(opty.Branch__c <> Null)
            {
               OptyName=OptyName +'-'+opty.Branch__c; 
            }else{
               OptyName=OptyName +'-'+'Null'; 
            }           
            OptyName=OptyName +'-'+opty.Opp_Number__c;                       
            opty.Name=OptyName; 
            OptyName=''; 
        }         
    }
  }*/
  
}