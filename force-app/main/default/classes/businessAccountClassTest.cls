@isTest
public class businessAccountClassTest {
    
    
    @isTest static void myTest() {
        Account acc = new Account();
        Acc.Name = 'test';
        insert acc;
        Contact con = new Contact();
        con.FirstName ='test';
        con.LastName = 'test';
        con.AccountId = acc.Id;
        insert con;
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessAccountClass bac = new businessAccountClass(sc);
        bac.Contacts.FirstName = 'jorge';
        bac.Contacts.LastName = 'mmtz';
        
        bac.SaveContact();
       	bac.Appoint.Subject = 'myDateTime';
        bac.getDays();
        bac.getHours();
        bac.getItems();
        bac.hour = '13:00';
        bac.day='2';
        bac.year='2018';
        bac.month='7';
        bac.SaveEvent();
        bac.SelectedChatId = bac.Contacts.Id;
       	bac.DeleteContact();
        bac.SelectedChatId = con.Id;
       	bac.DeleteContact();
        System.debug('hola mundo : '+bac.SelectedChatId);
        Test.stopTest();
    }

}