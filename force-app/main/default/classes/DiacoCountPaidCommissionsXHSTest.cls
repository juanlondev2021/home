@istest
public class DiacoCountPaidCommissionsXHSTest {
 
        @istest static void testAll(){
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
            
            Home_Services__c hs2 = new  Home_Services__c();
            hs2.Account__c = Acc.Id;
            hs2.RecordTypeId = '012410000013G9OAAU';
            hs2.Card_Number__c = '123456789';
            hs2.CSV__c = '123';
            hs2.Method_Of_Payment__c = 'Credit Card';		 
            hs2.ApptSetter__c = per.Id;
            hs2.Exp_Date__c = '7/24';
            hs2.Name='test test test test';
            hs2.Home_Services_Status__c='Schedule';
            hs2.Sales_Event_Current_Status__c='Schedule';
            hs2.Event_Count__c=1;
            //hs.Sales_Rep__c = u.Id;
            insert hs2;
            
            Commission__c c= new Commission__c();
            c.Name='Test';
            c.Home_Service__c=hs.Id;
            c.Personnel__c=per.Id;
            c.Commission_Status__c = 'Paid';
            
            insert c;
            
            test.startTest();
            
            c.Home_Service__c=hs2.Id;
            update c;
           
            test.stopTest();
        }
}