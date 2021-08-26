@isTest
private class UpdateOrderTriggerTest {
    @IsTest
    static void updateOrder(){
        Account acc = new Account();
        acc.FirstName = 'Test acc';
        acc.LastName  = 'last test';
        insert acc;

        List<Update_Order__c> uOrder = new List<Update_Order__c>();
        uOrder.add(new Update_Order__c(
            name              = 'test',
            Status__c         = 'In Process',
            List_of_Fields__c = 'Phone',
            List_of_Values__c = '3161111111',
            Parent_Id__c      = acc.id,
            Guest_User__c     = true

        ));

        uOrder.add(new Update_Order__c(
            name              = 'test',
            Status__c         = 'In Process',
            List_of_Fields__c = 'Phone',
            List_of_Values__c = '3161111111',
            Parent_Id__c      = acc.id,
            Guest_User__c     = false

        ));

        test.startTest();

            insert uOrder;
            
        Test.stopTest();
        
    }
}