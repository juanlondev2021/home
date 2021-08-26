public class DiacoTriggerPersonnelCountReferral {
    @future
    public static void execute (String userId){
        system.debug('Inicia 0');
        //List<Personnel__c> p=[select Id fromPersonnel__c where Id=:userId];
        Personnel__c p=new Personnel__c();
        p.Id=userId;
        system.debug('Inicia 1');
        if(p!=null){
            system.debug('Inicia 2');
            //system.debug('Sí entra 1');
            Date actualDate=date.today();
            DateTime toDate=actualDate.toStartOfWeek().addDays(10);
            toDate=toDate.addHours(7); 
            DateTime fromDate=toDate.addDays(-84);  //84 days same 12 weeks        
            List<referral__c> rs=[select Id,Home_Service__r.Home_Services_Status__c from referral__c where ApptSetter__c=:userId and CreatedDate>=:fromDate and CreatedDate<=:toDate];
            
            Integer closedStatusCount=0;
            for(Integer i=0;i<rs.size();i++){   
                if(rs[i].Home_Service__r.Home_Services_Status__c=='Closed Won'){
                    closedStatusCount+=1;
                }
            }
            system.debug('Size:'+rs.size());
            //u[0].Total_Of_Event__c=0;
            //u[0].Event_Sales_Approved__c=2;
            p.Total_Referrals__c=rs.size();
            p.Referrals_Sold__c=closedStatusCount;
            update p;
            
            /*if(u[0].Personnel__c!=null && u[0].Personnel__c!=''){
Personnel__c p=new Personnel__c();
p.Id=u[0].Personnel__c;
p.Total_Of_Event__c=es.size();
p.Event_Sales_Approved__c=closedStatusCount;
update p;  
}*/
        }
        
    }
}