/**
* Diaco
* @author 			Álvaro José Ortega Vargas href=<aovargassf@gmail.com>
* Project:			Referral Create HS
* Description:		
*
* Changes (Version)
* ____________________________________
*			No.		Date			Author					Description
*			_____	__________		_____________________	___________________________________
* @version	1.0		12/10/2019		Álvaro Ortega (AO)		Create Home Services per Referral in Account
**/
public class DiacoAccountReferralCreateHS {
    @AuraEnabled
    public static List<referral__c> getReferrals(String recordId){
        List<referral__c> rs=[select Id, Name, Home_Service__c,Home_Service__r.Home_Services_Status__c from referral__c where account__c=:recordId];
        return rs;
    }
    @AuraEnabled
    public static List<RecordType> getDataRecordType(){
        List<RecordType> RT = [select Id,Name from RecordType where sObjectType='Home_Services__c' AND Name like '%Sales'];
        return RT;
    }
    @AuraEnabled
    public static referral__c saveHsOnReferral(String recordId,String HSId){
        referral__c r=new referral__c();
        r.Id=recordId;
        r.Home_Service__c=HSId;
        update r;
        
        Home_Services__c h = new  Home_Services__c();
        h.Id=HSId;
        h.Referral__c=recordId;
        update h;
        
        return r;
    }
    
    
}