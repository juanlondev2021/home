/********************************************************************************************
* Class Name : TestClassUtil
* Created By : Sankar Marappan
* Created Date : 3/5/2016
* Author : MST
* Description: Common Test Utility Classes for Test Data Creation.
**********************************************************************************************/
@isTest(SeeAllData = false)
public class TestClassUtil {
    private static List<Account> accountTestRecords = new List<Account>();
    private static List<County__c> countyTestRecords = new List<County__c>();
    private static List<Branch__c> branches;
    private static List<Driver__c> drivers = new List<Driver__c>();
    private static List<Gift_Card_Orders__c> giftCardOrders = new List<Gift_Card_Orders__c>();
    private static List<Delivery_Object__c> deliveriesToInsert = new List<Delivery_Object__c>();
    private static List<Delivery_Object__c> deliveyToInsert = new List<Delivery_Object__c>();
    private static List<Delivery_Product__c> deliveriesToProduct = new List<Delivery_Product__c>();
    private static List<Address__c> addressTestRecords = new List<Address__c>();
    private static List<zipcode__c> zipCodes = new List<zipcode__c>();
    private static List<Branch__c> branchList = new List<Branch__c>();
    private static List<Property__c> properties = new List<Property__c>();
    private static List<User_Address__c> userAddress = new List<User_Address__c>();
    
    //Create given number of accounts.
    public static void createAccount(Integer count){
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Person Account' LIMIT 1];    
        City__c city = new City__c();
        city.Name       = 'City';
        insert city;

        Route__c route = new Route__c();
        route.Name = 'Route 1';
        insert route;

        County__c county = new County__c();
        county.County_Name__c = 'Unknown';
        insert county;

        for(Integer i=0;i<count;i++){
            Account accountTestRecord = new Account(FirstName = 'Test',
                                                    LastName = 'Account Record'+i,
                                                    RecordTypeId = rt.Id,
                                                    Home_Type__c = 'SF',                                                    
                                                    PersonEmail = 'testAcc'+i+'@ymail.com',
                                                    Primary_Shipping_State__c = 'AZ',
                                                    Primary_Shipping_County__c = 'Test County'+i,
                                                    Primary_Shipping_Zip_Code__c = '27007',
                                                    Primary_Shipping_City__c = 'Test City',
                                                    Primary_Shipping_Street__c = 'Test Street',
                                                    Primary_Shipping_Country__c = 'US',
                                                    State__c = 'AZ',
                                                    Zip__c = '27007',
                                                    Street__c = 'Test Street',
                                                    Sales_Price__c = 1000,
                                                    Recording_Date__c = Date.Today(),
                                                    City__c = 'test',
                                                    City_lookup__c = city.id,
                                                    Route__c = route.Id, 
                                                    County_Lookup__c = county.Id,
                                                    County__c = 'test',
                                                    Verbal_Consent__c = 'Yes',
                                                    Branch__c = 'AZ-Test Branch');
            accountTestRecords.add(accountTestRecord);            
        }    
        
        if(accountTestRecords.size() > 0){
            insert  accountTestRecords; 
        }        
    }
    //Create records for PA_Auditing_Setting in custom setting 
    public static void createPA_Auditing_Setting(Integer n){ 
        insert new PA_Auditing_Setting__c(Name = 'ThersoldValue',No_of_Days__c=n);
    }
    //Create records for Hung_Status_Setting in custom setting 
    public static void createHung_Status_Setting(){ 
        insert new Hung_Status_Setting__c(Name = 'Hung',Days_Until_Next_Delivery__c = 7,Buffer_Days__c = 0);
    }
    
    //Create records for County Object
    public static void createCounty(Integer count){
        for(Integer i=0;i<count;i++){
            countyTestRecords.add(new County__c(County_Name__c = 'Test County'+i,State__c = 'AZ'));
        }
        if(countyTestRecords.size() > 0){
            insert  countyTestRecords;  
        } 
    }
    
    // Create Driver Record
    public static void createDriver(){
        
        drivers.add(new Driver__c(Name = 'Cheetah Driver',First_Name__c = 'Cheetah',Last_Name__c = 'Driver',
                                  Phone__c = '9999999999',Branch__c = 'AZ-Phoenix_East',Driver_Street__c = '0000',ID__c = '0',
                                  Driver_City__c = '0000',Driver_State__c = 'AZ',Driver_Country__c = 'US',Driver_Zip_Code__c = '0000'));
        drivers.add(new Driver__c(Name = 'Invalid Driver',First_Name__c = 'Invalid',Last_Name__c = 'Driver',
                                  Phone__c = '8877777777',Branch__c = 'CA-Los_Angeles',Driver_Street__c = '0000',ID__c = '45666',
                                  Driver_City__c = 'Chicago',Driver_State__c = 'IA',Driver_Country__c = 'US',Driver_Zip_Code__c = '620017'));
        
        insert drivers;
    }
    
    // Create GiftCard Order
    public static void createCheetahGiftCardOrder(){
        Gift_Card_Orders__c giftCardOrder = new Gift_Card_Orders__c(Name = '0',Active_Custom_CheckBox__c = true,
                                                                    Branch_Location__c = 'AZ-Phoenix_West',Quantity_Ordered__c = 1);

        Gift_Card_Orders__c giftCardOrder2 = new Gift_Card_Orders__c(Name = 'Cheetah Gift Card Order',Active_Custom_CheckBox__c = true,
        Branch_Location__c = 'AZ-Phoenix_West',Quantity_Ordered__c = 1);
        
        Gift_Card_Orders__c giftCardOrder3 = new Gift_Card_Orders__c(Name = '1234 2134 2132 2343',Active_Custom_CheckBox__c = true,
                                                                    Branch_Location__c = 'AZ-Phoenix_West',Quantity_Ordered__c = 1);
        Gift_Card_Orders__c giftCardOrder4 = new Gift_Card_Orders__c(Name = '1234 2134 0000 0000',Active_Custom_CheckBox__c = true,
                                                                    Branch_Location__c = 'AZ-Phoenix_West',Quantity_Ordered__c = 1);
        
        giftCardOrders.add(giftCardOrder);
        giftCardOrders.add(giftCardOrder3);
        giftCardOrders.add(giftCardOrder2);
        giftCardOrders.add(giftCardOrder4);

        insert giftCardOrders;
    }
    //Create Zipcode for the branch
    public static void createZipcodeForBranch(){
        
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        
        Branch__C branch1 = new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = regionIns.Id);
        branchList.add(branch1);
        
        Branch__C branch2 = new Branch__c(Name = 'NC-Greensboro',Carrier_ID__c='NCG',Branch_stage__c = 'Delivering',Region_MD__c = regionIns.Id);
        branchList.add(branch2);
        insert branchList;
        
        zipCodes.add(new zipcode__c(Name = '27006',ZipCode__c = '27006', branch__c = branch1.id,MSA__c = 'Winston-Salem, NC MSA',
                                    Region_Code__c = 'SE3',State__c = 'NC'));
        zipCodes.add(new zipcode__c(Name = '27007',ZipCode__c = '27007', branch__c = branch2.id, MSA__c = 'Winston-Salem, AZ MSA',
                                    Region_Code__c = 'SE4',State__c = 'AC'));
        insert zipcodes;
    }
    // Create Branch
    public static void createBranch(){
        
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        
        branches = new List<Branch__c>();
        branches.add(new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = regionIns.Id));
        branches.add(new Branch__c(Name = 'NC-Greensboro',Carrier_ID__c='NCG',Branch_stage__c = 'Delivering',Region_MD__c = regionIns.Id));
        insert branches;
    }
    public static void createDeliveryProducts(){
        deliveriesToProduct.add(new Delivery_Product__c(name = 'Welcome Box'));
        deliveriesToProduct.add(new Delivery_Product__c(name = 'Door Tag'));
        if(deliveriesToProduct.size() > 0){
            insert deliveriesToProduct;
        }
    }
    
    public static void createDeliveryParameter(Integer deliveryNumber){
        String productName;
        integer counter = 1;
        for(Delivery_Product__c currProduct : [SELECT ID,name FROM Delivery_Product__c]){
            if(counter == 1){
                productName = currProduct.name;   
            }else{
                productName = productName+','+currProduct.name; 
            }
            counter++;
        }
        System.debug('parameter ++++++++++++++++'+productName);
        insert new Delivery_parameter__c(Branch__c = branchList[0].Id,Active__c = true,Delivery_Number__c = deliveryNumber,
                                         Included_ZipCodes__c = '27006',Excluded_ZipCodes__c='00000',Days_Until_Next_Delivery__c=7,
                                         Selected_Products__c = productName,Min_Sales_Price__c = 100,Allow_Multiple_Attempts__c=true,
                                         Max_Sales_Price__c = 2000,Close_Date__c = date.newInstance(2015,10,01),
                                         Create_Date_in_SFDC__c = date.newInstance(2015,10,01));
    }
    
    
    public static void createDeliveryOneRecord(){
        deliveriesToInsert.add(new Delivery_Object__c(Person_Account__c = accountTestRecords[0].Id,Name = '1',Scan_Code__c = '0000 0000',
                                                      Parent_Gift_Card_Order__c = giftCardOrders[0].Id,User_Address__c = userAddress[0].Id,
                                                      Driver__c = drivers[0].Id));
        try{
            insert deliveriesToInsert;
        }
        catch(DMLException e){
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        deliveriesToInsert[0].Hung_Status__c = 'Hung';
        deliveriesToInsert[0].Delivery_Date__c = Date.Today().addDays(-7);
        update deliveriesToInsert;
    }
    
    /* Method Name : createPersonAddress
    * Created By : Sailappa Vignesh P G
    * Created Date : 2/18/2016
    * Description : This function will create test record for the 'Hung Status' Custom setting and used in the Test class 'CreateDeliveryObjectTest'. 
    */
    public static void createProductAndHungStatus(){ 
        List<Delivery_Product__c> productLst = new List<Delivery_Product__c>();
        productLst.add(new Delivery_Product__c(Name = 'Box'));
        productLst.add(new Delivery_Product__c(Name = 'Hanging'));
        insert productLst;
        List<Hung_Status__c> hungStatusLst = new List<Hung_Status__c>();
        Hung_Status__c hungStatusForCantFind = new Hung_Status__c();
        //hungStatusForCantFind.Name = 'Cant Find';
        hungStatusForCantFind.Days_until_next_attempt__c = 1;
        hungStatusForCantFind.Hung_Status_Cheetah__c = 'Cant Find';
        hungStatusForCantFind.Hung_Status_Salesforce__c = 'Cant Find';
        hungStatusForCantFind.Maximum_number_of_attempts_per_status__c = 2;
        //hungStatusForCantFind.Next_Attempt_Delivery_type__c = '1';
        hungStatusForCantFind.Delivery_Product__c = productLst[0].id;
        hungStatusLst.add(hungStatusForCantFind);
        Hung_Status__c hungStatusForGated = new Hung_Status__c();
        //hungStatusForGated.Name = 'Gated';
        hungStatusForGated.Days_until_next_attempt__c = 7;
        hungStatusForGated.Hung_Status_Cheetah__c = 'Gated';
        hungStatusForGated.Hung_Status_Salesforce__c = 'Gated';
        hungStatusForGated.Maximum_number_of_attempts_per_status__c = 3;
        //hungStatusForGated.Next_Attempt_Delivery_type__c = '1';
        hungStatusForGated.Delivery_Product__c = productLst[0].id;
        hungStatusLst.add(hungStatusForGated);
        Hung_Status__c hungStatusForUnderConstruction = new Hung_Status__c();
        //hungStatusForUnderConstruction.Name = 'Under Construction';
        hungStatusForUnderConstruction.Days_until_next_attempt__c = 30;
        hungStatusForUnderConstruction.Hung_Status_Cheetah__c = 'Under Construction';
        hungStatusForUnderConstruction.Hung_Status_Salesforce__c = 'Under Construction';
        hungStatusForUnderConstruction.Maximum_number_of_attempts_per_status__c = 3;
        //hungStatusForUnderConstruction.Next_Attempt_Delivery_type__c = '1';
        hungStatusForUnderConstruction.Delivery_Product__c = productLst[0].id;
        hungStatusLst.add(hungStatusForUnderConstruction);         
        Hung_Status__c hungStatusForTooFar = new Hung_Status__c();
        //hungStatusForTooFar.Name = 'Too Far';
        hungStatusForTooFar.Days_until_next_attempt__c = 1;
        hungStatusForTooFar.Hung_Status_Cheetah__c = 'Too Far';
        hungStatusForTooFar.Hung_Status_Salesforce__c = 'Too Far';
        hungStatusForTooFar.Maximum_number_of_attempts_per_status__c = 3;
        //hungStatusForTooFar.Next_Attempt_Delivery_type__c = '1';
        hungStatusForTooFar.Delivery_Product__c = productLst[0].id;
        hungStatusLst.add(hungStatusForTooFar);
        Hung_Status__c hungStatusForCancelled = new Hung_Status__c();
        //hungStatusForCancelled.Name = 'Cancelled';
        hungStatusForCancelled.Days_until_next_attempt__c = 1;
        hungStatusForCancelled.Hung_Status_Cheetah__c = 'Cancelled';
        hungStatusForCancelled.Hung_Status_Salesforce__c = 'Cancelled';
        hungStatusForCancelled.Maximum_number_of_attempts_per_status__c = 3;
        //hungStatusForCancelled.Next_Attempt_Delivery_type__c = '1';
        hungStatusForCancelled.Delivery_Product__c = productLst[0].id;
        hungStatusLst.add(hungStatusForCancelled);
        Hung_Status__c hungStatusForHung = new Hung_Status__c();
        //hungStatusForHung.Name = 'Hung';
        hungStatusForHung.Days_until_next_attempt__c = 7;
        hungStatusForHung.Hung_Status_Cheetah__c = 'Completed';
        hungStatusForHung.Hung_Status_Salesforce__c = 'Hung';
        hungStatusForHung.Maximum_number_of_attempts_per_status__c = 0;
        //hungStatusForHung.Next_Attempt_Delivery_type__c = '2';
        hungStatusForHung.Delivery_Product__c = productLst[0].id;
        hungStatusLst.add(hungStatusForHung);
        try{
            insert hungStatusLst;    
        }catch(Exception ex){
            System.debug('DML Exception'+ ex.getMessage());
        }
        System.debug('hung Status++++++++++++++++++++++++++++++++++++++'+hungStatusLst);
        
    }
    /* Method Name : createPersonAddress
    * Created By : Sailappa Vignesh P G
    * Created Date : 2/22/2016
    * Description : This function will create test record for the Person Address object'. 
    */
    public static void createPersonAddress(Boolean isWithPhone,boolean isWithPersonalPhone){
        RecordType accountRecordType = [SELECT id,Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Person Account' Limit 1];
        Account accountTestRecord = new Account(FirstName = 'Test',
                                                LastName = 'Account Record',
                                                RecordTypeId = accountRecordType.Id,
                                                Home_Type__c = 'SF',
                                                Phone = '98737262',
                                                PersonEmail = 'testAcc@ymail.com',
                                                Primary_Shipping_State__c = 'AZ',
                                                Primary_Shipping_County__c = 'Test County',
                                                Primary_Shipping_Zip_Code__c = '27007',
                                                Sales_Price__c = 1000,
                                                Recording_Date__c = Date.Today(),
                                                Branch__c = 'AZ-Test Branch');
        
        
        try{
            insert accountTestRecord;
            
        }Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }        
        User_Address__c userAddr = new User_Address__c();
        userAddr.Address__c = [SELECT ID FROM Address__c LIMIT 1].ID;
        userAddr.UserAccount__c = accountTestRecord.id;
        if(isWithPhone){
            userAddr.Phone__c = '4807581192';                      
        }
        if(isWithPersonalPhone){            
            userAddr.PersonMobilePhone__c = '4807581192';           
        } 
        try{
            insert userAddr;
        }Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }  
    }
    
    
    public static void createAddress(Integer count){
        for(Integer i=0;i<count;i++){
            Address__c address = new Address__c(Name = 'Address'+i,City__c = 'Test'+count,County__c = 'Test County'+i,
                                                Country__c = 'US',State__c = 'AZ',Street__c = 'Test Street'+i,Home_Type__c = 'SF',
                                                Zip_code__c = zipCodes[0].Name,Zip_Plus_Four__c = '11'+count);
            addressTestRecords.add(address);
        }
        try{
            insert addressTestRecords;
        }Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        } 
    }
    
    public static void createProperty(Integer count){
        if(addressTestRecords.size() >= count){
            for(Integer i=0;i<count;i++){
                properties.add(new Property__c(Name = 'Test'+i,Address__c = addressTestRecords[i].Id));
            }
        }
        try{
            insert properties;
        }Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        } 
    }
    
    public static void createUserAddress(Integer Count){
        if(addressTestRecords.size() >= count && accountTestRecords.size() >= count){
            for(Integer i=0;i<count;i++){
                userAddress.add(new User_Address__c(Address__c = addressTestRecords[i].Id, UserAccount__c = accountTestRecords[i].Id,
                                                    User_Address_Type__c = 'Primary Owner',Active__c = true,Sales_Price__c = 1000,
                                                    Recording_Date__c = Date.Today(),Respond_date__c = Date.Today())); 
            }
        }
        try{
            insert userAddress;
            //Don't update createddate for first index User Address
            userAddress.remove(0);
            //User Address createddate within 0 to 15 days 
            Test.setCreatedDate(userAddress[1].id, Datetime.now().addDays(-5));
            Test.setCreatedDate(userAddress[10].id, Datetime.now().addDays(-10));
            //User Address createddate within 15 to 30 days 
            Test.setCreatedDate(userAddress[2].id, Datetime.now().addDays(-25));
            Test.setCreatedDate(userAddress[11].id, Datetime.now().addDays(-20));
            //User Address createddate within 30 to 60 days 
            Test.setCreatedDate(userAddress[3].id, Datetime.now().addDays(-40));
            Test.setCreatedDate(userAddress[12].id, Datetime.now().addDays(-50));
            //User Address createddate within 60 to 90 days 
            Test.setCreatedDate(userAddress[4].id, Datetime.now().addDays(-80));
            Test.setCreatedDate(userAddress[13].id, Datetime.now().addDays(-70));
        }Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        } 
    }
}