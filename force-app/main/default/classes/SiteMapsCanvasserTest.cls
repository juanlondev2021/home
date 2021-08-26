@isTest
public class SiteMapsCanvasserTest {
    @TestSetup
    static void makeData() {

        // SMS
        dsms.diacoSmsExternalTest.setSetup();
        DiacoSMSettingsTest.consentCanvasser();

        // Account
        List<Account> accounts = new List <Account>();
        Id personAcctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        for(Integer i=0;i<10;i++)
        {
            accounts.add(new Account(
                FirstName='test',
                BillingState = 'CA', LastName = 'Pass v2'+i,
                RecordTypeId = personAcctRecordTypeId,
                PersonDoNotCall =True,
                Verbal_Consent__c='No',
                phone=null));
        }
        insert accounts;


        // Delivery
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);

    }
    
    @IsTest
    static void test() {
        
        Test.startTest();
        
            Id giftCardOrderId = [SELECT Id FROM Gift_Card_Orders__c LIMIT 1]?.Id;
            Id driverId =  [SELECT Id FROM Driver__c LIMIT 1]?.Id;
            Id userAddressId = [SELECT ID FROM User_Address__c LIMIT 1]?.Id;

            List<Account> accounts = [SELECT Id,FirstName,LastName,Phone,PersonEmail,
                                    Street__c,Zip__c,State__c,City__c,Year_Built__c,Pool__c,
                                    Number_of_AC_Units__c,Number_of_Stories__c,
                                    Homeowner_2_First_Name__c,Homeowner_2_Last_Name__c,
                                    Homeowner_2_Email__c,Homeowner_2_Phone_Number__c,
                                    Homeowner_2_Mobile__c,Canvasser_Disposition__c 
                                    FROM Account ];       
                                    
            Decimal latitude = 10.3867885;         
            Decimal longitude = -75.4906915;

            Delivery_Object__c delivery = new Delivery_Object__c();        
            delivery.Person_Account__c = accounts[0].Id;
            delivery.Driver__c = driverId;
            delivery.name = '1';
            delivery.Parent_Gift_Card_Order__c = giftCardOrderId;
            delivery.User_Address__c = userAddressId;
            delivery.Cheetah_Driver_Code__c = '0';           
            
            insert delivery;

            SiteMapsCanvasserController.getDataAccount(accounts[0].Id,new List<String>{'Canvasser_Disposition__c'});
            SiteMapsCanvasserController.getDataAccount(delivery.Id,new List<String>{'Canvasser_Disposition__c'});
            SiteMapsCanvasserController.setAccount(accounts[0],latitude,longitude);

            // SMS Magic
            List<String> phoneNumbers = new List <String>();
            for(Integer i=0;i<2;i++){
                phoneNumbers.add('1234567890');
            }
            SiteMapsCanvasserController.sendSMSto(accounts[0],'15428502', phoneNumbers);        
        Test.stopTest();
        
    }
}