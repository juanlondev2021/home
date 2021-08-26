@isTest
global class diacoSignSendVFPasDocumentBDSTest {

    @isTest static void diacoSignBodyHttpRequests_Test(){
        
        
        ddsign__Pre_Designed_Envelope__c pre3 = new ddsign__Pre_Designed_Envelope__c(
            ddsign__SObject_Assigned__c = 'Account',
            Name = 'test',
            ddsign__subject__c = 'Account',
            ddsign__Document_Types__c = 'VisualForce',
            ddsign__Assign_To__c = 'ddsign__Account__c'
        );
        
        upsert pre3;
        
        Id reVF = [Select Id,name, sobjecttype 
                   From RecordType 
                   where sobjecttype = 'ddsign__Envelope_Document__c' AND Name = 'VisualForce'].Id;
        
        ddsign__Envelope_Document__c env_doc3 = new ddsign__Envelope_Document__c(
            ddsign__document_Id__c = '1',
            ddsign__Document_Name__c = 'test',
            ddsign__VisualForce_Name__c = 'test',
            ddsign__Pre_Designed_Envelope__c = pre3.Id,
            RecordTypeId = reVF
        );
        
        upsert env_doc3;

        ddsign__diacoSign_Signer__c signer3 = new ddsign__diacoSign_Signer__c(
            ddsign__Sobject__c = 'Account',
            ddsign__routing_Order__c = '1',
            ddsign__email__c = 'ddsign__emial_1__c',
            Name = 'Name',
            ddsign__Pre_Designed_Envelope__c = pre3.Id,
            ddsign__Signer_Selection__c = 'sObject',
            ddsign__Recipient_Type__c='Signer'
        );
        upsert signer3;
        
        
        ddsign__Tab__c tab3 = new ddsign__Tab__c(
            ddsign__Sobject__c = 'Account',
            ddsign__Type__c = 'signHereTabs',
            ddsign__value__c= 'Name',
            ddsign__diacoSign_Signer__c = signer3.Id,
            ddsign__anchorString__c = 'test'
        );
        upsert tab3;
        
        Account acc = new Account (Name = 'test', ddsign__emial_1__c = 'tets@test.com');
        upsert acc;
        
        Test.startTest();
        
        List<String> param = new List<String>();
        param.add(pre3.Id+','+acc.Id);
        diacoSignSendToDSByProcess.sendToDocusign(param);
        Test.stopTest();
    }
}