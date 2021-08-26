@isTest
public class diacoContractHAServicePackageCtrlTest {
    @TestSetup static void setup() {
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Customer_1_DOB__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_DOB__c =  Date.newInstance(2018, 7, 3);
        
        Acc.Customer_1_Drivers_License_Issue_Date__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_Drivers_License_Issue__c =  Date.newInstance(2018, 7, 3);
        
        Acc.Customer_1_Drivers_License_Expiration__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_Drivers_License_Expiration__c =  Date.newInstance(2018, 7, 3);
        
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter External User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            
            
        );
        
        insert u;
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
    }
    @isTest static void testAll(){
         Home_Services__c hs = [Select Id from Home_Services__c ];
        
        diacoContractHAServicePackageController.getDataHomeService(hs.Id);
        diacoContractHAServicePackageController.saveHomeService(hs);
    }
    
}