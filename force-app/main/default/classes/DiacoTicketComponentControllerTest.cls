@isTest
public class DiacoTicketComponentControllerTest {
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
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Ticket_Type__c tt = new Ticket_Type__c();
        tt.Name = 'Test Ticket Type';
        insert tt;
        
        Ticket__c tk = new Ticket__c();
        tk.Name = 'Ticket Test';
        tk.Ticket_Type__c = tt.Id;
        tk.Priority__c = 'Low';
        insert tk;
        
        Attention__c at = new Attention__c();
        at.Name = 'Test';
        at.Ticket__c = tk.Id;
        at.Personnel__c = per.Id;
        insert at;
        
        List<String> data = new List<String>();
        data.add('');
        data.add('');
        data.add('');
        data.add('');
        data.add('');
        
        test.startTest();
        
        DiacoTicketComponentController.getAllTickets();
        DiacoTicketComponentController.getAllTicketTypes();
        DiacoTicketComponentController.deleteAttention(at.Id);
        DiacoTicketComponentController.getAttentions(tk.Id);
        DiacoTicketComponentController.getAllFilterTickets(data);
        data[4] = 'Low';
        DiacoTicketComponentController.getAllFilterTickets(data);
        
        test.stopTest();
        
    }
}