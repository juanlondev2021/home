@isTest
public class DiacoScheduleCommissionOnLineItemTest {
    @isTest static void testAll(){
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        User u = new user();
        u.LastName = 'Test Event';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'TestEvent@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = '00e41000001hNuFAAU';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.Personnel__c=per.Id;
        insert u;
        
        //per.SF_User__c=u.Id;
        //Update per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.Name='test test test test';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        
        Product__c p = new Product__c();
        p.Name = 'Test';
		p.Product_Type__c = 'Water';
        p.Service__c = true;
        p.active__c = true;
		insert p;
        
        Line_Item__c li = new Line_Item__c();
        li.Name = 'Test';
        li.Home_Service__c = hs.Id;
        li.Product__c = p.Id;
        li.Active__c =true;
        li.Service_Check__c = true;
        li.Monthly_Investment__c = 2;
        upsert p;

        test.startTest();
        
        
        DiacoScheduleCommissionOnLineItem.decimalMod(12.4,4);
        DiacoScheduleCommissionOnLineItem.createCommission(li, per.Id);

        DateTime myDateTime = system.now();
        // f1_CambioEstadoCartadeIntencion shedule = new f1_CambioEstadoCartadeIntencion();
        DiacoScheduleCommissionOnLineItemCaller shedule = new DiacoScheduleCommissionOnLineItemCaller();
       	String title = 'Create Commission monthly during a year of Line Item';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        // system.debug(sch);
        system.schedule(title, sch, shedule);  
        
        test.stopTest();
    }

}