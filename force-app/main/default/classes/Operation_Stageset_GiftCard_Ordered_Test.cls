/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata=false)
private class Operation_Stageset_GiftCard_Ordered_Test
{
    @testsetup static void createtestdata() { 
        
        //Account creation
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.Phone = '1234567890';    
        insert acc;
        system.assertNotEquals(null, acc.id);
        
        //Opportunity creation
        Opportunity opp = new Opportunity();
        opp.accountId = acc.Id;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Proof Approved';
        opp.stageName = 'Closed Won';
        opp.Art_File__c='sunnyvale'; 
        opp.Back_pdf__c=2;
        opp.Front_pdf__c=2;
        opp.Forward_to_number__c = '8220708920';
        insert opp;
        system.assertNotEquals(null, opp.id);
        
        //Gift_Card_Orders__c creation
        Gift_Card_Orders__c pgo=new Gift_Card_Orders__c(Name='Test Gift card Order',Quantity_Ordered__c=2,Parent_Gift_Card_Order__c=null);
        insert pgo;
        
        Gift_Card_Orders__c go=new Gift_Card_Orders__c(Name='Test Gift card Order',Quantity_Ordered__c=2,Parent_Gift_Card_Order__c=pgo.id);
        insert go;
        system.assertEquals(2, [select count() from Gift_Card_Orders__c]);
        
        //Driver__c creation
        Driver__c dr=new Driver__c(Name='Invalid Driver');
        insert dr;
        system.assertNotEquals(null, dr.id);
        
        //Delivery_Object__c creation
        Delivery_Object__c d=new Delivery_Object__c(Name='Test Delivery',Parent_Gift_Card_Order__c=go.id,Delivered__c=1,Person_Account__c=acc.id);
        insert d;
		system.assertNotEquals(null, d.id);        
    }
    static testmethod void GCTrigTest(){
        test.startTest();
        Opportunity opp = [select id,Operational_Stages__c from Opportunity where stageName='Closed Won' limit 1];
        Gift_Card_Orders__c go = [select id from Gift_Card_Orders__c where Parent_Gift_Card_Order__c!=null limit 1];
        Gift_Card__c g=new Gift_Card__c(Name='Test Gift Card',Gift_Card_Order__c=go.id,Opportunity__c=opp.id);
        insert g;
        test.stopTest();
    } 
}