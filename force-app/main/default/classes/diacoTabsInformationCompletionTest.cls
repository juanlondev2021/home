@isTest
public class diacoTabsInformationCompletionTest {
    @TestSetup static void setup() {
        //Account for positive Test
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test-positive';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Primary_Billing_State__c ='NY';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.Phone='2121212121';
        Acc.PersonMobilePhone='221212121';
        Acc.PersonEmail='212121@gmail.com';
        Acc.Homeowner_2_Phone_Number__c='21212121';
        Acc.Homeowner_2_Last_Name__c='SecondName Test';
        Acc.Homeowner_2_First_Name__c='firstNameTest';
        Acc.Homeowner_2_Mobile__c='212122121';
        Acc.Homeowner_2_Email__c='212121@gmail.com';
        Acc.Zip__c='12212';
        insert Acc;

        //Account for negative tests
        Account Acc2 = new Account();
        Acc2.FirstName = 'Account ';
        Acc2.LastName = 'Test-negative';
        Acc2.RecordTypeId ='012410000012NOKAA2';
        Acc2.Street__c='test';
        Acc2.City__c='test';
        Acc2.State__c='AZ';
        Acc2.Zip__c='test';
        Acc2.PersonEmail='212121@gmail.com';
        Acc2.Zip__c='12212';
        insert Acc2;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        //HomeServices for positive Test
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.Name='testChecked';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        hs.Communication_By__c='POTS';
        hs.Utility_Company__c='SRP';
        hs.Username__c='SRP user';
        hs.Password__c='SRP password';
        hs.Sales_Rep__c=UserInfo.getUserId();
        hs.Requested_Install_Date__c=System.now();

        insert hs;

        Installation__c i = new Installation__c();
        i.Name = 'Test';
        i.Home_Service__c = hs.Id;
        i.RecordTypeId = '012410000013IFMAA2';
        insert i;

        Product__c pr = new Product__c();
        pr.Name = 'test';
        pr.Product_Type__c = 'Water';
        pr.active__c = true;
        insert pr;

        Line_Item__c li = new Line_Item__c();
        li.Name = 'Test';
        li.Product__c = pr.Id;
        li.Home_Service__c = hs.Id;
        insert li;

        PaymentMethod__c payment1= New PaymentMethod__c();
        payment1.PaymentMethodType__c='ACH';
        payment1.Amount__c=3000;
        payment1.HomeService__c=hs.Id;
        insert payment1;
//HomeService for negative Tests
        Home_Services__c hs2 = new  Home_Services__c();
        hs2.Account__c = Acc2.Id;
        hs2.RecordTypeId = '012410000013G9OAAU';		 
        hs2.ApptSetter__c = per.Id;
        hs2.Exp_Date__c = '7/24';
        hs2.Name='testChecked';
        hs2.Home_Services_Status__c='Schedule';
        hs2.Sales_Event_Current_Status__c='Schedule';
        hs2.Event_Count__c=1;
        hs2.Sales_Rep__c=UserInfo.getUserId();
        
        //hs.Sales_Rep__c = u.Id;
        insert hs2;
        
    }
    
    
    @isTest static void testAll(){

        Home_Services__c hsPositive= [select Id,Name,Account__r.LastName from Home_Services__c where Account__r.LastName = 'Test-positive' Limit 1];
        Home_Services__c hsNegative= [select Id,Name,Account__r.LastName from Home_Services__c where Account__r.LastName = 'Test-negative'  limit 1];

        test.startTest();
        //Check First customer tab
        Boolean testFirstCustomerPositive = diacoTabsInformationCompletion.checkSolarFirstCustomer(hsPositive.Id);
        system.assert(testFirstCustomerPositive == true, 'Customer check should be positive');
        //System.assertEquals(true, testFirstCustomerPositive);
        Boolean testFirstCustomerNegative = diacoTabsInformationCompletion.checkSolarFirstCustomer(hsNegative.Id);
        //System.assertEquals(false, testFirstCustomerNegative);
       
       // Check Second Customer Tab
       Boolean testSecondCustomerPositive = diacoTabsInformationCompletion.checkSecondCustomer(hsPositive.Id);
       //System.assertEquals(true, testSecondCustomerPositive);
       Boolean testSecondCustomerNegative = diacoTabsInformationCompletion.checkSecondCustomer(hsNegative.Id);
       //System.assertEquals(false, testSecondCustomerNegative);

        // Check Product and services Customer Tab
        Boolean testProductsAndServicesPositive = diacoTabsInformationCompletion.checkProductsOrServices(hsPositive.Id);
      //  System.assertEquals(true, testProductsAndServicesPositive);
        Boolean testProductsAndServicesNegative = diacoTabsInformationCompletion.checkProductsOrServices(hsNegative.Id);
    //    System.assertEquals(false, testProductsAndServicesNegative);


        // Check Payments Method  Tab
        Boolean testPaymentsPositive = diacoTabsInformationCompletion.checkPayments(hsPositive.Id);
  //      System.assertEquals(true, testPaymentsPositive);
        Boolean testPaymentsNegative = diacoTabsInformationCompletion.checkPayments(hsNegative.Id);
//        System.assertEquals(false, testPaymentsNegative);

        // Check Billing addres
        Boolean testBillingAddressPositive = diacoTabsInformationCompletion.checkBillingInformation(hsPositive.Id);
        //System.assertEquals(true, testBillingAddressPositive);
        Boolean testBillingAddressNegative = diacoTabsInformationCompletion.checkBillingInformation(hsNegative.Id);
        //System.assertEquals(false, testBillingAddressNegative);
        
        
        // Check Instalattion Date
        Boolean testInstalattionDatePositive = diacoTabsInformationCompletion.checkInstallationDate(hsPositive.Id);
        //System.assertEquals(true, testInstalattionDatePositive);
        Boolean testInstalattionDateNegative = diacoTabsInformationCompletion.checkInstallationDate(hsNegative.Id);
        //System.assertEquals(false, testInstalattionDateNegative);
        
        // Check checkServicePackage
        Boolean testServicePackagePositive = diacoTabsInformationCompletion.checkServicePackage(hsPositive.Id);
        //System.assertEquals(true, testServicePackagePositive);
        Boolean testServicePackageNegative = diacoTabsInformationCompletion.checkServicePackage(hsNegative.Id);
        //System.assertEquals(false, testServicePackageNegative);
        
        // Check utilityInformation
        Boolean testUtilityInfoPositive = diacoTabsInformationCompletion.checkUtilityInformation(hsPositive.Id);
        //System.assertEquals(true, testUtilityInfoPositive);
        Boolean testUtilityInfoNegative = diacoTabsInformationCompletion.checkUtilityInformation(hsNegative.Id);
       // System.assertEquals(false, testUtilityInfoNegative);
      
        test.stopTest();
    }
    
}