@isTest
public class DiacoTaskWebformProcessTest {
	@isTest static void testAll(){
        /*Account acc = new Account(
        	FirstName = 'Test acc',
            LastName = 'last test'  
        );
        insert acc;*/
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        List<String> paramList = new List<String>();
        webForm__c webForm = new webForm__c();
        webForm.Name = 'Test';
        webForm.date__c = '2019-12-07';
        webForm.Type__c = 'Solar';
        insert webForm;
        test.startTest();
        List<String> st = new List<String>();
        st.add(webForm.Id);
        DiacoTaskWebformProcess.createTask(st);
        test.stopTest();
    }    
}