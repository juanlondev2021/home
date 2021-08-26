@isTest
public class DeliveryAssignedTest {

    @testSetup 
    static void testData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(2);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);
        Id accountId = [SELECT Id FROM Account lIMIT 1]?.Id;
            Id giftCardOrderId = [SELECT Id FROM Gift_Card_Orders__c LIMIT 1]?.Id;
            Id driverId =  [SELECT Id FROM Driver__c LIMIT 1]?.Id;
            Id userAddressId = [SELECT ID FROM User_Address__c LIMIT 1]?.Id;

            List<Delivery_Object__c> deliveries = new List<Delivery_Object__c>();
            for (Integer i = 0; i < 200; i++) {
                Delivery_Object__c delivery = new Delivery_Object__c();        
                delivery.Person_Account__c = accountId;
                delivery.Driver__c = driverId;
                delivery.name = '1';
                delivery.Parent_Gift_Card_Order__c = giftCardOrderId;
                delivery.User_Address__c = userAddressId;
                delivery.Cheetah_Driver_Code__c = '0';           
                deliveries.add(delivery);   
            }
            insert deliveries;
        maps__Route__c mp = new maps__Route__c(
            Name='Test',
            maps__Date__c= Date.today()
        );
        insert mp;
        System.debug('Deliveries SOQL');
        System.debug([select Id from Delivery_Object__c limit 1]);
        maps__Waypoint__c wp = new maps__Waypoint__c(
            maps__Route__c = mp.Id,
            Name ='test',
            maps__BaseObject__c='Deliveries',
            maps__LinkId__c = [select Id from Delivery_Object__c limit 1][0].Id
        );
        insert wp;
    }

    @IsTest
    static void test() {
        
        DeliveryAssigned reminder = new DeliveryAssigned();
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        //reminder.execute(null);
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Remind Opp Owners', sch, reminder);
    }
}