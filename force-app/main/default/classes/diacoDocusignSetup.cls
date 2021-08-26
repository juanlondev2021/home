public class diacoDocusignSetup {
    public List<docuSignConf__c> docusignconf{get;set;}
    public docuSignConf__c conf{get;set;}
    public String pass{get;set;}
    public diacoDocusignSetup(){
        conf = new docuSignConf__c();
        docusignconf = [select accountId__c, integratorsKey__c, password__c, userId__c, User_Id_Pest_Control__c,
                        userIdSolar__c, account__c, passwordSolar__c, PassWord_Pest_Control__c
                                              from docuSignConf__c];
        conf = docusignconf[0];
        pass = conf.password__c;
    }
    
    public void save(){
        if( conf.password__c == '' || conf.password__c == null ){
            conf.password__c = pass;
        }
        upsert conf;
    }
}