public class diacoContractHAServicePackageController {
    
    @AuraEnabled
    public static Home_Services__c getDataHomeService(String RecordId){
        Home_Services__c home =  [select Id, Account__c,Communication_By__c,Monthly_Security_Services__c, Hardness_gpg__c, Ph__c, Iron_Algae__c, Iron_ppm__c, Hyd_Supl_ppm__c, No_Reg__c, Other__c, Special_Instructions__c 
                                  from Home_Services__c where id = :RecordId];
        return home;
    }
    
        @AuraEnabled
    public static Home_Services__c saveHomeService(Home_Services__c Home_Services){
        upsert Home_Services;
        return Home_Services;
    }
}