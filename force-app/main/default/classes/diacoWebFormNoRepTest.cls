@isTest
public class diacoWebFormNoRepTest {
   	@isTest static void testAll(){
        Personnel__c p = new Personnel__c();
        p.Name = 'Web NoRep';
        p.First_Name__c='Web';
        p.Last_Name__c='NoRep';
        p.Kunnect_ID__c='123456789';
        p.Active__c=true;
        upsert p;
        
        test.startTest();
        
        webForm__c w = new webForm__c();
        w.Name = 'test';
        insert w;
        
        String param=w.Id+',';
        List<String> params = new List<String>();
        params.add(param);
        
        diacoWebFormNoRep.noRep(params);
        
        test.stopTest();
    }
}