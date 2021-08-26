/********************************************************************************************
* Class Name : AddressTriggerHandler_Test
* Created By : PriyankaShanmugam
* Created Date : 4/18/2016
* Author : MST
* Description: Test Classes for the Address Trigger , AddressTriggerHandler and as well AccountZipCodeMapper_Batch
* Modified By : Ganesh
* Description : Updated the class as per best practices.
**********************************************************************************************/
@isTest(SeeAllData = false)
private class AddressTriggerHandler_Test{
     //Create common test data
    @testSetup static void setup() {
        TestClassUtil.createZipcodeForBranch();        
        TestClassUtil.createAddress(3);
        TestClassUtil.createProperty(2);
    }    
    static testMethod void testAutoFieldPopulation(){
        test.startTest();
        for(Address__c addres : [SELECT Id,name,State__c,Unique_Key__c,Full_Zip_Code__c,Region_Code__c,MSA__c,City__c,Street__c,Zip_code__c,Zip_plus_four__c,Branch__c FROM Address__c]){
            //Verify auto population of field values
            System.assert(addres.Branch__c != null);
            System.assert(addres.Region_Code__c != null);
            System.assert(addres.MSA__c != null);
            //Verify address name field auto population
            System.assertEquals(addres.Name,addres.Street__c + ':' + addres.City__c + ':' + addres.State__c);
            //Verify Unique_Key field auto population
            System.assertEquals(addres.Unique_Key__c,addres.Street__c + ':' +addres.Zip_Code__c);
            //Verify full zipcode field auto population
            System.assertEquals(addres.Full_Zip_Code__c,addres.Zip_Code__c + '-' + addres.Zip_Plus_Four__c);
        }
        test.stopTest();
    }
    static testMethod void testAutoFieldPopulationOnUpdate(){
        test.startTest();
        List<Address__c> toBeUpdateAddress = [SELECT Id,name,Region_Code__c,MSA__c,State__c,City__c,Street__c,Zip_code__c,Zip_plus_four__c,Branch__c FROM Address__c];   
        if(!toBeUpdateAddress.isEmpty()){
            for(Address__c addr : toBeUpdateAddress){
                addr.State__c = 'DE';
                addr.City__c = 'Test City';
                addr.Street__c = 'Test Street';
                addr.Zip_Code__c = '27007';
            }
        }
        //Update invalid zipcode
        toBeUpdateAddress[0].Zip_Code__c = null;
        toBeUpdateAddress[1].Zip_Code__c = '12345';
        update toBeUpdateAddress;
        for(Address__c addres : [SELECT Id,name,State__c,Unique_Key__c,Full_Zip_Code__c,Region_Code__c,MSA__c,City__c,Street__c,Zip_code__c,Zip_plus_four__c,Branch__c FROM Address__c WHERE Branch__c != null]){
            //Verify auto population of field values
            System.assert(addres.Branch__c != null);
            System.assert(addres.Region_Code__c != null);
            System.assert(addres.MSA__c != null);
            //Verify address name field auto population
            System.assertEquals(addres.Name,addres.Street__c + ':' + addres.City__c + ':' + addres.State__c);
            //Verify Unique_Key field auto population
            System.assertEquals(addres.Unique_Key__c,addres.Street__c + ':' +addres.Zip_Code__c);
            //Verify full zipcode field auto population
            System.assertEquals(addres.Full_Zip_Code__c,addres.Zip_Code__c + '-' + addres.Zip_Plus_Four__c);
        }   
        test.stopTest();
    }
    static testMethod void testAddressDuplicationCreation(){  
        test.startTest();
        //Create address with same unique key then it will throw error like duplicate address 
        Address__c dupAddress = new Address__c(Name = 'DupAddress',City__c = 'Test',County__c = 'Polk County',
                                            Country__c = 'US',State__c = 'IN',Street__c = 'Test Street1',
                                            Zip_code__c = '27006',Zip_Plus_Four__c = '1111');
        try{
            insert dupAddress;
        }
        catch(Exception e){
            System.debug('Error Occured while updating the address'+e.getMessage());
        }
        system.assert([SELECT Id FROM Address__c WHERE Name = 'DupAddress'].size() == 0);
        test.stopTest(); 
    }    
    //This method is used to cover the Zip code based field population through batch    
    static testMethod void testZipCodeMatcherBatch(){
        Branch__c branch = [SELECT Id from Branch__c limit 1];
        //Create address with invalid zipcode 
        insert new Address__c(Name = 'Address1',City__c = 'Test',County__c = 'Polk County',
                                            Country__c = 'US',State__c = 'IN',Street__c = 'Test Street1',
                                            Zip_code__c = '27001',Zip_Plus_Four__c = '1111');
        //Create a record for the above zipcode in the Zipcode custom obj
        insert new zipcode__c(Name = '27001',ZipCode__c = '27001', branch__c = branch.id,MSA__c = 'Winston-Salem, NC MSA',Region_Code__c = 'SE3',State__c = 'NC');
        Test.startTest();
        Database.ExecuteBatch(new accountZipCodeMApper_Batch(),200);
        Test.stopTest(); 
        System.assertEquals([SELECT Id,Region_Code__c FROM Address__c WHERE zip_code__c ='27001'].Region_Code__c,'SE3');
    }
        //This method is used to cover the Zip code based field population through batch    
    static testMethod void testZipCodeMatcherBatch1(){
        Branch__c branch = [SELECT Id from Branch__c limit 1];
        //Create address with invalid zipcode 
        insert new Address__c(Name = 'Address1',City__c = 'Test',County__c = 'Polk County',
                                            Country__c = 'US',State__c = 'IN',Street__c = 'Test Street1',
                                            Zip_code__c = '27001',Zip_Plus_Four__c = '1111');
        //Create a record for the above zipcode in the Zipcode custom obj
        insert new zipcode__c(Name = '27002',ZipCode__c = '27002', branch__c = branch.id,MSA__c = 'Winston-Salem, NC MSA',Region_Code__c = 'SE3',State__c = 'NC');
        Test.startTest();
        Database.ExecuteBatch(new accountZipCodeMApper_Batch(),200);
        Test.stopTest(); 
        System.assertnotEquals([SELECT Id,Region_Code__c FROM Address__c WHERE zip_code__c ='27001'].Region_Code__c,'SE3');
    }
}