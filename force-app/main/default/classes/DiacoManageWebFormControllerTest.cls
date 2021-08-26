@isTest
public class DiacoManageWebFormControllerTest {
    @isTest static void testAll(){
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
        
        webForm__c w = new webForm__c();
        w.Name = 'Test';
        w.Account__c = Acc.Id;
        insert w;
        
        test.startTest();
        
        DiacoManageWebFormController.getCurrentInfo(Acc.Id);
        DiacoManageWebFormController.saveAccount(Acc);
        DiacoManageWebFormController.createWebForm(w);
        DiacoManageWebFormController.getWebForms(Acc.Id);
        DiacoManageWebFormController.getPickListValuesIntoList('Account','Interests__c');
        DiacoManageWebFormController.deleteWebForm(w.Id);
        DiacoManageWebFormController.getDataRecordType();
        
        test.stopTest();
        
    }
}