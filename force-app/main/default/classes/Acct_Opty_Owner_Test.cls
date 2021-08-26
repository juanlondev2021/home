@isTest
private class Acct_Opty_Owner_Test {

     static testMethod void myUnitTest() {
     
           
            Account acc = new Account();
            acc.name = 'testAccount';  
            acc.Primary_Billing_City__c='Sunnyvale';    
            acc.Primary_Billing_Country__c='US';
            acc.Primary_Billing_State__c='CA';
            acc.Primary_Billing_Street__c='260 N Mathilda Ave';
            acc.Primary_Billing_Zip_Code__c='94086';  
            acc.Phone = '1234567891';
            acc.Invalid_Email_Deleted__c = false;
            insert acc;
           
                       
            Opportunity opp = new Opportunity();
            opp.accountId = acc.Id;
            opp.name='TestOpp';
            opp.closeDate = date.today();
            opp.Operational_Stages__c = 'Gift Card Active Customer';
            opp.stageName = 'Closed Won';
            opp.Art_File__c='sunnyvale'; 
            opp.Back_pdf__c=2;
            opp.Front_pdf__c=2;
            opp.Forward_to_number__c = '8220708920';
            insert opp;
            
             user u=[select id from user where isActive=true limit 1];
            acc.ownerid=u.id;
            update acc;
            
            opp.Ownerid=u.id;
            update opp;
            
       }  

}