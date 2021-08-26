/**
* Diaco
* @author 			Álvaro José Ortega Vargas href=<aovargassf@gmail.com>
* Project:			Commision for Home Services counter and update
* Description:		
*
* Changes (Version)
* ____________________________________
*			No.		Date			Author					Description
*			_____	__________		_____________________	___________________________________
* @version	1.0		17/10/2019		Álvaro Ortega (AO)		Count all Commission for HS and update Commission fiels
**/
public class DiacoCommissionXHSCounter {
	@InvocableMethod
    public static void counter(List<String> params) {
       // List<Commission__c> csToUpdate=new List<Commission__c>();
        system.debug('-----Entra al super contador-----');
        List<Commission__c> commissions= [select Id,CreatedDate,LastModifiedDate,Home_Service__c,
                              Home_Service__r.RecordType.Name,Home_Service__r.Closed_Won_Date__c,
                              Personnel__r.First_Name__c,Personnel__r.Last_Name__c,Personnel__r.SF_User__c,Personnel__r.SF_User__r.IsActive
                              from Commission__c 
                              where Id in :params];
       	List<String> HScommissions=new List<String>();
        for(Commission__c item : commissions){
            HScommissions.add(item.Home_Service__c);
        }
        AggregateResult[] counters=[select COUNT(Id), Home_Service__c from Commission__c where Home_Service__c in :HScommissions group by Home_Service__c];
        
        for(Integer i=0;i<counters.size();i++){
            Integer auxCount=0;
            for(Integer j=0;j<commissions.size();j++){
                if(String.valueof(counters[i].get('Home_Service__c'))==commissions[j].Home_Service__c){
                    Integer aux=integer.valueOf(counters[i].get('expr0'))-auxCount;
                    commissions[j].Name=commissions[j].Personnel__r.First_Name__c+' '+commissions[j].Personnel__r.Last_Name__c+' - M'+aux+' '+commissions[j].Home_Service__r.RecordType.Name;
                    if(!Test.isRunningTest()){
                        if(commissions[j].Personnel__r.SF_User__c != null && commissions[j].Personnel__r.SF_User__r.IsActive){
                    		commissions[j].OwnerId=commissions[j].Personnel__r.SF_User__c;
                        }
                	}
                	auxCount+=1;
                }
            }
        }
        update commissions;
        system.debug('-----Sale del super contador-----');
        /*for(String param : params) {
            string[] split= param.split(',');
         	string  id=split[0];
            system.debug('-----Entra al super contador 1-----');
            Commission__c c= [select Id,CreatedDate,LastModifiedDate,Home_Service__c,
                              Home_Service__r.RecordType.Name,Home_Service__r.Closed_Won_Date__c,
                              Personnel__r.First_Name__c,Personnel__r.Last_Name__c,Personnel__r.SF_User__c 
                              from Commission__c where Id=:id];
            if(c.CreatedDate==c.LastModifiedDate){
                system.debug('-----Entra al super contador 2-----');
                Integer cs= [select COUNT() from Commission__c where Home_Service__c=:c.Home_Service__c];
                c.Name=c.Personnel__r.First_Name__c+' '+c.Personnel__r.Last_Name__c+' - M'+cs+' '+c.Home_Service__r.RecordType.Name;
                c.OwnerId=c.Personnel__r.SF_User__c;
                //c.Closed_Won_Date__c=c.Home_Service__r.Closed_Won_Date__c;
               	csToUpdate.add(c);
            }
       }*/
       
    }

}