@isTest
public class DiacoDocusignBatchTest {
    static testmethod void test() {
        Account Acc = new Account();
        Acc.FirstName = 'Account';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs1 = new  Home_Services__c();
        hs1.Name = 'test test - Water Treatment Sales';
        hs1.Account__c = Acc.Id;
        hs1.RecordTypeId = '012410000013G9NAAU';
        hs1.Method_Of_Payment__c = 'Credit Card';		 
        hs1.ApptSetter__c = per.Id;
        hs1.Exp_Date__c = '7/24';
        hs1.sendDate__c = Date.today();
        hs1.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        hs1.contractDocument__c = false;
        insert hs1;
        
        Home_Services__c hs2 = new  Home_Services__c();
        hs2.Name = 'test test - Water Treatment Sales';
        hs2.Account__c = Acc.Id;
        hs2.RecordTypeId = '012410000013G9NAAU';
        hs2.Method_Of_Payment__c = 'Credit Card';		 
        hs2.ApptSetter__c = per.Id;
        hs2.Exp_Date__c = '7/24';
        hs2.sendDate__c = Date.today();
        hs2.Contract_Status_Product__c = 'Waiting';
        hs2.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        hs2.contractDocument__c = false;
        insert hs2;
        
        Home_Services__c hs3 = new  Home_Services__c();
        hs3.Name = 'test test - Water Treatment Sales';
        hs3.Account__c = Acc.Id;
        hs3.RecordTypeId = '012410000013G9NAAU';
        hs3.Method_Of_Payment__c = 'Credit Card';		 
        hs3.ApptSetter__c = per.Id;
        hs3.Contract_Status_Service__c = 'Waiting';
        hs3.Exp_Date__c = '7/24';
        hs3.sendDate__c = Date.today();
        hs3.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        hs3.contractDocument__c = false;
        insert hs3;
        docuSignConf__c doc = new docuSignConf__c(
            account__c = '1234567', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId',
            tokenPart1__c = '123', tokenPart2__c= '123', tokenPart3__c= '123'
        ); 
        upsert doc;
        
        List<Home_Services__c> lsths = [select envelopeId__c, contractDocument__c, id, Name, sendDate__c, Account__c, RecordTypeId, Contract_Status_Product__c, Contract_Status_Service__c
                                          from Home_Services__c 
                                          where (envelopeId__c != null or envelopeId__c != '') and contractDocument__c = false];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DiacoDocuSignCalloutMock());
        diacoDocusignBatcheableGetDocu dbstsroua = new diacoDocusignBatcheableGetDocu();
        dbstsroua.execute(null, lsths);
        dbstsroua.finish(null);
        dbstsroua.start(null);
        Test.stopTest();
    }
    
    static testmethod void test1() {
        Account Acc = new Account();
        Acc.FirstName = 'Account';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs1 = new  Home_Services__c();
        hs1.Name = 'test test - Water Treatment Sales';
        hs1.Account__c = Acc.Id;
        hs1.RecordTypeId = '012410000013G9NAAU';
        hs1.Method_Of_Payment__c = 'Credit Card';		 
        hs1.ApptSetter__c = per.Id;
        hs1.Exp_Date__c = '7/24';
        hs1.sendDate__c = Date.today();
        hs1.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        hs1.contractDocument__c = false;
        insert hs1;
        
        Home_Services__c hs2 = new  Home_Services__c();
        hs2.Name = 'test test - Water Treatment Sales';
        hs2.Account__c = Acc.Id;
        hs2.RecordTypeId = '012410000013G9NAAU';
        hs2.Method_Of_Payment__c = 'Credit Card';		 
        hs2.ApptSetter__c = per.Id;
        hs2.Exp_Date__c = '7/24';
        hs2.sendDate__c = Date.today();
        hs2.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        hs2.contractDocument__c = false;
        insert hs2;
        
        Home_Services__c hs3 = new  Home_Services__c();
        hs3.Name = 'test test - Water Treatment Sales';
        hs3.Account__c = Acc.Id;
        hs3.RecordTypeId = '012410000013G9NAAU';
        hs3.Method_Of_Payment__c = 'Credit Card';		 
        hs3.ApptSetter__c = per.Id;
        hs3.Exp_Date__c = '7/24';
        hs3.sendDate__c = Date.today();
        hs3.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        hs3.contractDocument__c = false;
        insert hs3;
        docuSignConf__c doc = new docuSignConf__c(
            account__c = '1234567', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId',
            tokenPart1__c = '123', tokenPart2__c= '123', tokenPart3__c= '123'
        ); 
        upsert doc;
        
        List<Home_Services__c> lsths = [select envelopeId__c, contractDocument__c, id, Name, sendDate__c, Account__c, RecordTypeId
                                          from Home_Services__c 
                                          where (envelopeId__c != null or envelopeId__c != '') and contractDocument__c = false];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DiacoDocuSignCalloutMock());
        DateTime myDateTime = System.now().addMinutes(1);
        diacoDocusignScheduleClass request = new diacoDocusignScheduleClass();
        String title = 'Docusign job xx';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        String jobID = system.schedule(title, sch, request);
        Test.stopTest();
    }
}