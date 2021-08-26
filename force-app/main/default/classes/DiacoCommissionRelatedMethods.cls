public class DiacoCommissionRelatedMethods {
    @future
    public static void updateTotalCommissionPaidField(set<String> homeServicesToUpdate){
        list<Home_Services__c> homeServices=new list<Home_Services__c>();
        list<AggregateResult> commissionsAggregated=
            [SELECT SUM(Commission_Amount__c) sums,Home_Service__c FROM Commission__c WHERE (Home_Service__c IN :homeServicesToUpdate and Commission_Status__c='Paid') GROUP BY Home_Service__c];
        system.debug('Resultado de la consulta');
        
        system.debug(commissionsAggregated);
        
        system.debug('hs a actualizar');
        
        system.debug(homeServicesToUpdate);
        for(AggregateResult result : commissionsAggregated){
            Home_Services__c hs= new Home_Services__c(Id=(String)result.get('Home_Service__c'),Sale_Commission_Paid__c=(Decimal)result.get('sums'));
            homeServices.add(hs); 
        }
        
        if(commissionsAggregated.size()<1){
            for(String hsId:homeServicesToUpdate){
                Home_Services__c hs= new Home_Services__c(Id=hsId,Sale_Commission_Paid__c=null);
                homeServices.add(hs); 
            }
            system.debug('lista vacia');
        }
        upsert homeServices;
    }
    
    
    @future
    public static void updateCommissionRecordAmountField(set<String> homeServicesToUpdate){
        list<Home_Services__c> homeServices=new list<Home_Services__c>();
        list<AggregateResult> commissionsAggregated=
            [SELECT SUM(Commission_Amount__c) sums,Home_Service__c FROM Commission__c WHERE Home_Service__c IN :homeServicesToUpdate GROUP BY Home_Service__c];
        //if(commissionsAggregated.size()<1)homeServices.add(hs); 
        for(AggregateResult result : commissionsAggregated){
            Home_Services__c hs= new Home_Services__c(Id=(String)result.get('Home_Service__c'),Commissions_Record_Amount__c=(Decimal)result.get('sums'));
            homeServices.add(hs); 
        }
        if(commissionsAggregated.size()<1){
            for(String hsId:homeServicesToUpdate){
                Home_Services__c hs= new Home_Services__c(Id=hsId,Commissions_Record_Amount__c=null);
                homeServices.add(hs); 
            }
            system.debug('lista vacia');
        }
        
        upsert homeServices;
    }
 
}