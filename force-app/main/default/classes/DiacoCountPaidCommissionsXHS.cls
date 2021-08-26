public class DiacoCountPaidCommissionsXHS {
    public static void execute (List<Commission__c> olds, List<Commission__c> news,boolean isUpdate, boolean isDelete){
        List<String> HSs = new List<String>();
        List<Home_Services__c> HStoUpdate = new List<Home_Services__c>();
        
        for(Integer x = 0; x < olds.size(); x++) {
            if((news[x].Home_Service__c != olds[x].Home_Service__c || news[x].Commission_Status__c != olds[x].Commission_Status__c || isDelete) && news[x].Commission_Status__c == 'Paid'){
                // system.debug('----------------------------- AQUI COMIENZA LO BUENO :) --------------------------------');
                
                HSs.add(olds[x].Home_Service__c);
                
                if(!isDelete && news[x].Home_Service__c != olds[x].Home_Service__c){
                    /* Home_Services__c h = new Home_Services__c();
                    h.Id = olds[x].Home_Service__c;
                    h.Sale_Commission_Paid__c = 0;
                    HStoUpdate.add(h); */
                    
                    HSs.add(news[x].Home_Service__c);
                }
            }
        }
        if(HSs.size() > 0){
            AggregateResult[] counters=[select SUM(Commission_Paid_Amount__c), Home_Service__c from Commission__c where Home_Service__c in :HSs group by Home_Service__c];
            
            
            for(Integer i = 0; i < HSs.size(); i++){
                boolean isIt = false;
                for(Integer j = 0; j < counters.size(); j++){
                    if(HSs[i] == counters[j].get('Home_Service__c')){
                        // system.debug(integer.valueOf(counters[j].get('expr0')));
                        // system.debug(counters[j].get('Home_Service__c'));
                        
                        Home_Services__c h = new Home_Services__c();
                        h.Id = String.valueof(counters[j].get('Home_Service__c'));
                        h.Sale_Commission_Paid__c = integer.valueOf(counters[j].get('expr0'));
                        
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
                    h.Sale_Commission_Paid__c = 0;
                    
                    HStoUpdate.add(h);
                    
                }
            }
            if(HStoUpdate.size() > 0){
                update HStoUpdate;
            }
        }
        system.debug('------------------------------- Aquí acaba lo bueno :( ---------------------------------');
   
    }

}