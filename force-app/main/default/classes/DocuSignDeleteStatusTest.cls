@isTest
public class DocuSignDeleteStatusTest {
	@testSetup
    static void setup(){
        ddsign__Envelope__c env = new ddsign__Envelope__c(ddsign__shipping_type__c = 'Manually');
        insert env;
        ddsign__Envelope__c env1 = new ddsign__Envelope__c(ddsign__shipping_type__c = 'Manually');
        insert env1;
        List<ddsign__Status__c> status = new List<ddsign__Status__c>();
        status.add(new ddsign__Status__c(ddsign__Name__c='Sending Envelope To docusign',
                                        ddsign__Envelope__c=env.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status',
                                        ddsign__Envelope__c=env.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status',
                                        ddsign__Envelope__c=env.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='Sending Envelope To docusign(HTTP)',
                                        ddsign__Envelope_HTTP__c=env.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting signer status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env.Id));
         status.add(new ddsign__Status__c(ddsign__Name__c='getting signer status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env.Id));
        
        
        status.add(new ddsign__Status__c(ddsign__Name__c='Sending Envelope To docusign',
                                        ddsign__Envelope__c=env1.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status',
                                        ddsign__Envelope__c=env1.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status',
                                        ddsign__Envelope__c=env1.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='Sending Envelope To docusign(HTTP)',
                                        ddsign__Envelope_HTTP__c=env1.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting signer status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env1.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env1.Id));
         status.add(new ddsign__Status__c(ddsign__Name__c='getting signer status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env1.Id));
        status.add(new ddsign__Status__c(ddsign__Name__c='getting Envelope status(HTTP)',
                                        ddsign__Envelope_HTTP__c=env1.Id));
        insert status;

    }
    static testmethod void DocuSignDeleteStatusTest(){
        Test.startTest();
        DocuSignDeleteStatusBridge.DeleteStatus(3,100);
        Test.stopTest();
        List<ddsign__Status__c> sta = [Select Id,ddsign__Name__c,Selected__c from ddsign__Status__c where Selected__c=true];
        for(ddsign__Status__c a:sta){
            System.debug(a); 
        }
        System.assertEquals(6, sta.size());
        DocusignDeleteStatusBridge.UpdateStatus();
        System.debug('----');
        sta = [Select Id,ddsign__Name__c,Selected__c from ddsign__Status__c];
        for(ddsign__Status__c a:sta){
            System.debug(a);
        }
        System.assertEquals(10, sta.size());
    }
}