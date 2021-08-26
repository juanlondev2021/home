public class diacoContractHA {

    @AuraEnabled
    public static Id generateContract(String recordId,String name){
        return DiacoCmpContractController.generateContract(recordId, name);
    }
    
    @AuraEnabled
    public static String getUtilityContractName(String RecordId){
        system.debug('RECORD ID');
        system.debug(RecordId);
        Home_Services__c hs = [select Id, Utility_Company__c 
                               from Home_Services__c 
                               where Id = :RecordId];
        return hs.Utility_Company__c;
    }
    
    @AuraEnabled
    public static integer howManyEnvelope(String RecordId){
        List<ddsign__Envelope__c> env = [select id
                                        from ddsign__Envelope__c
                                        where Home_Service__c = :RecordId ];
        
        return env.size();
    }
        @AuraEnabled
    public static integer howManyEnvelopeByPredesignName(String RecordId, String preDesignName){
        List<ddsign__Envelope__c> env = [select id
                                        from ddsign__Envelope__c
                                        where Home_Service__c = :RecordId and ddsign__Pre_Designed_Envelope__r.name=:preDesignName];
        return env.size();
    }
    
    @AuraEnabled
    public static void newSendToDocusign(String RecordId){
        Home_Services__c hs = [select Id, Industry_Formula__c 
                               from Home_Services__c 
                               where Id = :RecordId];
        
        List<ddsign__Pre_Designed_Envelope__c> envelope = [select Id, Name
                                                     from ddsign__Pre_Designed_Envelope__c
                                                     where Name = :hs.Industry_Formula__c limit 1];
        
        System.debug(envelope);
        if(envelope.size() > 0){
            diacoSignSendVFPasDocumentBDS.sendToDocusign(envelope[0].Id, RecordId);
        }else{
            if (!Test.isRunningTest()){ 
                throw new AuraHandledException('Pre-Designed Envelope not exists');
            }
            
        }
    }
    
    @AuraEnabled
    public static void sendToDocusignWithPreDesignName(String RecordId,String preDesignEnvelopeName){
        List<ddsign__Pre_Designed_Envelope__c> envelope = [select Id, Name
                                                           from ddsign__Pre_Designed_Envelope__c
                                                           where Name = :preDesignEnvelopeName limit 1];
        
        System.debug(envelope);
        if(envelope.size() > 0){
            diacoSignSendVFPasDocumentBDS.sendToDocusign(envelope[0].Id, RecordId);
        }else{
            if (!Test.isRunningTest()){ 
                throw new AuraHandledException('Pre-Designed Envelope not exists');
            }
            
        }
    }
    
    @AuraEnabled
    public static string sendToDocusign(String RecordId, Integer opt){
        docuSignConf__c conf = new docuSignConf__c();
        String envelopeId, userId, password, accountId, productType;
        List<docuSignConf__c> docusignconf = [select accountId__c, integratorsKey__c, password__c, userId__c, userIdSolar__c, account__c, passwordSolar__c,
                                              PassWord_Pest_Control__c, User_Id_Pest_Control__c, User_Id_HA__c, password_HA__c
                                              from docuSignConf__c];
        SendToDocuSignController stdc =  new SendToDocuSignController();
        Home_Services__c homeService = [select Id,Name, Account__c, RecordType.Name from Home_Services__c where Id = :RecordId];
        System.debug('RecordTypeName====>'+ homeService.RecordType.Name);
        if(!homeService.RecordType.Name.contains('Home Automation')){
            productType = DiacoCmpContractController.products(homeService.RecordType.Name);
        }else{
            productType = 'Home Automation';
        }
        System.debug('Product Type ####>'+ productType);
        conf = docusignconf[0];
        accountId = conf.accountId__c;
        if(productType == 'Home Automation'){
            userId = 'agreements@protectionsource.com';//conf.User_Id_HA__c;
            password = conf.password_HA__c;
        }
        
        String integratorsKey = conf.integratorsKey__c;
        System.debug(password+ '-----'+userId);
        envelopeId = stdc.SendNow(productType, accountId, userId, password, integratorsKey, homeService, opt);
        return envelopeId ;
    }
    
    @AuraEnabled
    public static void updateDates(String RecordId){
        DiacoCmpContractController.updateDates(RecordId);
    }

    @AuraEnabled
    public static void saveSendContract(String recordId, boolean sendContract){
        Home_Services__c hs = new Home_Services__c(
            Id= recordId,
            Send_Utility_Solar__c = sendContract
        );
        update hs;
    }

    @AuraEnabled
    public static list<Line_Item__c> getlineItems(String recordId, Integer option){
        return DiacoCmpContractController.getlineItems(recordId, option);
    }

    @AuraEnabled
    public static boolean getHs(String recordId){
        return [select Send_Utility_Solar__c from Home_Services__c 
        where Id=:recordId].Send_Utility_Solar__c;
    }
}