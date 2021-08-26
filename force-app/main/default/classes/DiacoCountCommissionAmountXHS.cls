public class DiacoCountCommissionAmountXHS {
    public static void execute (List<Commission__c> olds, List<Commission__c> news,boolean isUpdate, boolean isDelete, boolean isInsert){
        List<String> HSs = new List<String>();
        List<Home_Services__c> HStoUpdate = new List<Home_Services__c>();
        
        for(Integer x = 0; x < news.size(); x++) {
            if(isInsert){
                HSs.add(news[x].Home_Service__c);
            }else if(isUpdate){
                HSs.add(news[x].Home_Service__c);
                if(news[x].Home_Service__c != olds[x].Home_Service__c){
                    HSs.add(olds[x].Home_Service__c);
                } 
            }else if(isDelete){
                HSs.add(olds[x].Home_Service__c);
            }
        }
        if(HSs.size() > 0){
            AggregateResult[] counters=[select SUM(Commission_Amount__c), Home_Service__c from Commission__c where Home_Service__c in :HSs group by Home_Service__c];
            
            
            for(Integer i = 0; i < HSs.size(); i++){
                boolean isIt = false;
                for(Integer j = 0; j < counters.size(); j++){
                    if(HSs[i] == counters[j].get('Home_Service__c')){
                        // system.debug(integer.valueOf(counters[j].get('expr0')));
                        // system.debug(counters[j].get('Home_Service__c'));
                        
                        Home_Services__c h = new Home_Services__c();
                        h.Id = String.valueof(counters[j].get('Home_Service__c'));
                        h.Commissions_Record_Amount__c = integer.valueOf(counters[j].get('expr0'));
                        
                        HStoUpdate.add(h);
                        isIt = true;
                        break;
                    }
                }
                if(!isIt){
                    // system.debug('0');
                    // system.debug(HSs[i]);
                    
                    Home_Services__c h = new Home_Services__c();
                    h.Id = HSs[i];
                    h.Commissions_Record_Amount__c = 0;
                    
                    HStoUpdate.add(h);
                    
                }
            }
            if(HStoUpdate.size() > 0){
                update HStoUpdate;
            }
        }
        
        
    }
}