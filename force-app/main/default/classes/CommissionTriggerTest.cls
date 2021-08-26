@IsTest
private class CommissionTriggerTest { //DiacoCommissionTriggerUnifiedTest
    @isTest static void TestInsertCommissionForUpdate() {
        
        Personnel__c personnel=new Personnel__c(name='personnel test',Kunnect_ID__c='none');
        insert personnel;
        Home_Services__c hs=new Home_Services__c(Name='test hs',ApptSetter__c=personnel.Id);
        insert hs;
        List<Commission__c> commissions = new List<Commission__c>();
        for (Integer i = 0; i < 10; i++) {
            commissions.add(
                new Commission__c
                (
                    Name='test commission',
                    Approved__c=true,Paid__c=true,
                    Commission_Status__c='Paid',
                    Commission_Amount__c=1000,
                    Home_Service__c=hs.Id,
                    Personnel__c=personnel.Id
                ));  
        }
        Test.startTest();
            insert commissions;
        Test.stopTest();  
        System.debug('after insert test');
        System.debug([SELECT id,Sale_Commission_Paid__c FROM Home_Services__c].Sale_Commission_Paid__c==1000);
    }

    @isTest static void TestUpdateCommissionForUpdate() {
        
        Personnel__c personnel=new Personnel__c(name='personnel test',Kunnect_ID__c='none');
        insert personnel;
        Home_Services__c hs=new Home_Services__c(Name='test hs',ApptSetter__c=personnel.Id);
        insert hs;

        Commission__c commission = new Commission__c(Name='test commission',Approved__c=true,Paid__c=true,Commission_Status__c='Paid',Home_Service__c=hs.Id,Commission_Amount__c=100);
        insert commission;
        
        Commission__c commission2 = new Commission__c(Name='test commission',Approved__c=true,Paid__c=true,Commission_Status__c='Paid',Home_Service__c=hs.Id,Commission_Amount__c=200);
        insert commission2;
        // Perform test
        System.debug('Before update test');
        
        Test.startTest();
        commission.Paid__c=false;
        commission.Commission_Status__c='Approved';
        commission2.Commission_Amount__c=500;
        update commission;
        update commission2;
        Test.stopTest();  
        
        System.debug('after update test');
        System.debug([SELECT id,Sale_Commission_Paid__c FROM Home_Services__c].Sale_Commission_Paid__c==500);
    }

    @isTest static void TestDeleteCommissionForUpdate() {
        
        Personnel__c personnel=new Personnel__c(name='personnel test',Kunnect_ID__c='none');
        insert personnel;
        Home_Services__c hs=new Home_Services__c(Name='test hs',ApptSetter__c=personnel.Id);
        insert hs;
        

        Commission__c commission2 = new Commission__c(Name='test commission',Approved__c=true,Paid__c=true,Commission_Status__c='Paid',Home_Service__c=hs.Id,Commission_Amount__c=200);
        insert commission2;
        
        System.debug('Before delete test');
        
        Test.startTest();
        delete commission2;
        Test.stopTest();  
        
        System.debug('after delete test');
        System.debug([SELECT id,Sale_Commission_Paid__c FROM Home_Services__c].Sale_Commission_Paid__c==0);
    }

}