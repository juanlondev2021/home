/**************************************************************************************************************
Created By: MST
Description : Test class for nuHome_Docusign_OppStage_Handler class.
Modified By: Ganesh
Modified on:
Description: Updated the test class as per best practices.
***************************************************************************************************************/
@isTest(seealldata=false)
private class nuHome_Docusign_OppStage_Handler_Test {
    //This method is to create docusign status records.
    @testsetup static void createtestdata(){
        Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        //Creating account record.
        Account accIns = new Account();
        accIns.Lastname = 'test';
        accIns.Phone = '9876433325';
        accIns.RecordTypeId = personAccRTId;
        accIns.Primary_Billing_City__c='Sunnyvale';
        accIns.Primary_Billing_Country__c='US';
        accIns.Primary_Billing_State__c='CA';
        accIns.Primary_Billing_Street__c='260 N Mathilda Ave';
        accIns.Primary_Billing_Zip_Code__c='94086'; 
        Insert accIns;
        system.assertNotEquals(null, accIns.id);
        
        //Creating opportunity record with account id.
        Opportunity oppIns = new Opportunity();
        oppIns.Name = 'test';
        oppIns.AccountId = accIns.Id;
        oppIns.Type = 'Existing Business';
        oppIns.Forward_to_number__c = '9876543212';
        oppIns.Branch__c = 'AL-Birmingham';
        oppIns.StageName = 'Qualified';
        oppIns.CloseDate = system.today();
        Insert oppIns;
        system.assertNotEquals(null, oppIns.id);
        
        //Creating docusign status record with account id.
        dsfs__DocuSign_Status__c docusignStatus = new dsfs__DocuSign_Status__c();
        docusignStatus.dsfs__Company__c = accIns.Id;
        docusignStatus.dsfs__Envelope_Status__c = 'Sent';
        docusignStatus.dsfs__DocuSign_Envelope_ID__c = 'TEST Envelope';
        insert docusignStatus;
        
        //Updating the docusign status as Delivered.
        Update new  dsfs__DocuSign_Status__c(id= docusignStatus.Id,dsfs__Envelope_Status__c = 'Delivered');
        /* 
Insert new  dsfs__DocuSign_Status__c(dsfs__Company__c = accIns.Id,dsfs__DocuSign_Envelope_ID__c = 'TEST Envelope',dsfs__Envelope_Status__c = 'Completed'); 
*/
        system.assertEquals(1, [select count() from dsfs__DocuSign_Status__c]);
    }
    static testmethod void docstagetest(){
        
        Opportunity opp = [select id, StageName from Opportunity];
        List<dsfs__DocuSign_Status__c> docusignStatus = [select id,dsfs__Company__c,dsfs__Subject__c,dsfs__Envelope_Status__c,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c];
        test.startTest();
        nuHome_Docusign_OppStage_Handler.changeStage(docusignStatus);
        test.stopTest();
    }
    static testmethod void docstagetest1(){
        dsfs__DocuSign_Status__c doc1 = [select id,dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__DocuSign_Envelope_ID__c = 'TEST Envelope' limit 1];
        doc1.dsfs__Envelope_Status__c = 'Completed';
        update doc1;
        
        Opportunity opp = [select id, StageName from Opportunity];
        List<dsfs__DocuSign_Status__c> docusignStatus = [select id,dsfs__Company__c,dsfs__Subject__c,dsfs__Envelope_Status__c,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c];
        test.startTest();
        nuHome_Docusign_OppStage_Handler.changeStage(docusignStatus);
        test.stopTest();
    }
}