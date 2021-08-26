/*
--------------------------
 * Created By: Ganesh
 * Description: This test class covers UpdateCalllogsWithAccount batch class. 
-----------------------------
*/
@isTest(seealldata=false)
private class UpdateCalllogsWithAccount_Test {

    @TestSetup
    static void createtestrecords()
    {
        //Region creation
        Region__c recRegion = New Region__c( Name = 'Central' );
        Insert recRegion;          
          
        //Branch creation
        Branch__c recBranch = new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = recRegion.Id);
        insert recBranch;
        
        //Address Creation.
        Address__c recAddress = new Address__c(city__c = 'Test',county__c= 'Test',Branch__c = recBranch.id, Home_Type__c = 'CT',MSA__c = '',Invalid__c = True);
        insert recAddress;
        
        //Account creation.
        Account recAccount = new Account(FirstName = 'Test',
                                         LastName = 'Account Record',
                                         Home_Type__c = 'SF',
                                        // Phone = '(888) 111-4444',
                                         PersonMobilePhone = '(987) 372-6612',
                                         PersonEmail = 'testAcc@ymail.com',
                                         Sales_Price__c = 1000,
                                         Respond_Date__c = Date.Today(),
                                         Branch__c = recBranch.id);
        Insert recAccount;
        System.assertNotEquals(null, recAccount.id);

        //User address Creation.
        User_Address__c userAddress = new User_Address__c(Address__c = recAddress.Id,UserAccount__c = recAccount.Id,
                                                          User_Address_Type__c = 'Primary Owner',Phone__c = '8881114444', Active__c = true,Sales_Price__c = 1000,Respond_Date__c = Date.Today()); 
        insert userAddress;
        
        //Call_Log__C  list creation.
        List<Call_Log__C> collCallLog = new List<Call_Log__C>();
        Call_Log__C calllog1 = new Call_Log__C(ANI__c='(987) 372-6612');
        collCallLog.add(calllog1);
        Call_Log__C calllog2 = new Call_Log__C(ANI__c='(888) 111-4444');
        collCallLog.add(calllog2); 
        insert collCallLog;
        system.assertEquals(2,[select count() from Call_Log__C]);
    }
    static testmethod void BatchScheduling()
    {        
        Test.StartTest();
        datetime dt=datetime.now().addSeconds(10);
        system.schedule('temp: Running at '+dt.format(), dt.format('s m H d M ? yyyy'), new UpdateCalllogsWithAccount());      
        Test.stopTest();
    }
}