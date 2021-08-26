@isTest
public class diacoDocusignSetupTest {
    static testMethod void test(){
        docuSignConf__c doc = new docuSignConf__c(
            accountId__c = 'testaccouont', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId'
        ); 
        upsert doc;
        Test.startTest();
        diacoDocusignSetup setup = new diacoDocusignSetup();
        setup.conf.password__c = '';
        setup.save();
        Test.stopTest();
        
    }

}