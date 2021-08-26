/*********************************************************
Created By: MST
Description : This test class created for nuHomeDocuSign2Chargent class.
Modified By: Ganesh
Modified on:
Description: Updated the test class as per best practices. 
**********************************************************/
@isTest(seealldata=false)
private class TestnuHomeDocuSign2Chargent{
    
    @testsetup static void createtestdata(){
        //Creating Account records
        Account testAccount = new Account();
        testAccount.LastName = 'TestAccount';
        testAccount.Verbal_Consent__c = 'No';
        insert testAccount; 
        
        //creating Inventory__C records
        Inventory__C inv = new Inventory__C();
        inv.Account__c = testAccount.id;
        inv.Phone_Mobile__c = '1234567891';
        insert inv;

        //Creating Region records
        Region__c regionIns = New Region__c(Name = 'Central');
        Insert regionIns;
        
        //Creating Branch__c records
        Branch__c branch = new Branch__c();
        branch.Name = 'AL-Birmingham';
        branch.State__c = 'AL';
        branch.MSA__c = 'Birmingham-Hoover, AL MSA';
        branch.Carrier_ID__c = 'Please Update';
        branch.Region_MD__c = regionIns.Id;
        Insert branch;
        
        //Creating Address__c records
        Address__c address = new Address__c();
        address.Name = '4330 W Chandler Blvd:Chandler:AZ';
        address.Zip_Code__c = '35004';
        address.Branch__c = branch.Id;
        Insert address;
        
        //Creating User_Address__c records
        User_Address__c insertUserAdd = new User_Address__c();
        insertUserAdd.Hot_Lead_Created__c = false;
        insertUserAdd.UserAccount__c = testAccount.Id;
        insertUserAdd.Address__c = address.id;
        insertUserAdd.Respond_Date__c = system.today();
        insertUserAdd.Scan_Code__c = '1234566';
        insert insertUserAdd;
        
        //Gift_Card_Orders__c creation
        Gift_Card_Orders__c pgo=new Gift_Card_Orders__c(Name='Cheetah Gift Card Order',Quantity_Ordered__c=2,Parent_Gift_Card_Order__c=null);
        insert pgo;
        
        Gift_Card_Orders__c go=new Gift_Card_Orders__c(Name='Test Gift card Order',Quantity_Ordered__c=2,Parent_Gift_Card_Order__c=pgo.id);
        insert go;
        system.assertEquals(2, [select count() from Gift_Card_Orders__c]);
        
       /* Insert new Driver__c(Name = 'Cheetah Driver',First_Name__c = 'Cheetah',Last_Name__c = 'Driver',
                                  Phone__c = '9999999999',Branch__c = 'AZ-Phoenix_East',Driver_Street__c = '0000',ID__c = '0',
                                  Driver_City__c = '0000',Driver_State__c = 'AZ',Driver_Country__c = 'US',Driver_Zip_Code__c = '0000');
		*/
        
        Insert new Driver__c(Name = 'Invalid Driver',First_Name__c = 'Invalid',Last_Name__c = 'Driver',
                                  Phone__c = '8877777777',Branch__c = 'CA-Los_Angeles',Driver_Street__c = '0000',ID__c = '45666',
                                  Driver_City__c = 'Chicago',Driver_State__c = 'IA',Driver_Country__c = 'US',Driver_Zip_Code__c = '620017');
        
            
        Delivery_Object__c newDelivery = new Delivery_Object__c();
        newDelivery.Hung_Status__c = 'Sent To Cheetah';
        newDelivery.Person_Account__c = testAccount.id;
        newDelivery.Name = '2';
        newDelivery.Cheetah_Driver_Code__c='45666';
        newDelivery.Scan_Code__c = '1234566';
        newDelivery.Parent_Gift_Card_Order__c = pgo.id;
        insert newDelivery;
        
 
    }
    
    static testmethod void test1(){
        test.startTest();
        Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Insert new Account(Lastname = 'test',Phone = '9876433325',Verbal_Consent__c = 'No',RecordTypeId = personAccRTId);
        system.assertEquals(2,[select count() from Account]);
        ID accid = [select id from Account where Lastname = 'test' limit 1].id;
        
        update new account(id=accid,Docusign_Credit_Card_Number__c = '1234567890123456',Docusign_Account_Number__c = '1234567891234567890012',
                           Docusign_Card_Type__c= 'Visa',Docusign_CVV_Security_Code__c = '123',Docusign_Expiration_Month__c = '12',
                           Docusign_Expiration_Year__c = '2016',Docusign_Name_On_Account__c = 'TestMST',
                           Docusign_Name_On_Credit_Card__c = 'First Name',
                           Docusign_Last_Name__c = 'Last Name',Docusign_Routing_Number__c = '12345678901',
                           Docusign_Address_Line_1__c = '11 street, streat',Verbal_Consent__c = 'Yes');
        test.stopTest();
    }
    
    static testmethod void test2(){
        test.startTest();
        Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Insert new Account(Lastname = 'test',Phone = '9876433325',Verbal_Consent__c = 'Yes',RecordTypeId = personAccRTId);
        system.assertEquals(2,[select count() from Account]);
        ID accid = [select id from Account where Lastname = 'test' limit 1].id;
        
        update new account(id=accid,Docusign_Credit_Card_Number__c = '1234567890123456',Docusign_Account_Number__c = '1234567891234567890012',
                           Docusign_Card_Type__c= 'American Express',Docusign_CVV_Security_Code__c = '123',Docusign_Expiration_Month__c = '12',
                           Docusign_Expiration_Year__c = '2016',Docusign_Name_On_Account__c = 'TestMST',
                           Docusign_Name_On_Credit_Card__c = 'First Name',Docusign_Last_Name__c = 'Last Name',
                           Docusign_Routing_Number__c = '12345678901',Docusign_Address_Line_1__c = '11 street, streat');
        test.stopTest();
    }
    static testmethod void updateacc(){
        test.startTest();
        //Updating Account record
        Account acc = [SELECT Id,PersonMobilePhone,Phone from Account where LastName='TestAccount' limit 1];
        acc.Phone  = '1234567893';
        acc.PersonMobilePhone  = '1234567894';
        acc.Verbal_Consent__c = 'Yes';
        acc.Respond_Date__c = system.today();
        update acc;
        test.stopTest();
    }
}