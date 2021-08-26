/**************************************************************************
Developed by: MST
Description : This test class created for updateZipCode_Ac. 
**************************************************************************/
@isTest
public class updateZipCode_Ac_Test {
     
    static testmethod void testRecordCreation() {
      
       Region__c regionIns = New Region__c( Name = 'Central' );
       Insert regionIns;
        
        Branch__c branch = new Branch__c();
        branch.Name = 'AL-Birmingham';
        branch.State__c = 'AL';
        branch.MSA__c = 'Birmingham-Hoover, AL MSA';
        branch.Carrier_ID__c = 'Please Update';
        branch.Region_MD__c = regionIns.Id;
        Insert branch;
        
         ZipCode__c currZip = new ZipCode__c();
        currZip.Name = 'testZip';
        currZip.ZipCode__c = '62100';
        currZip.Branch__c = branch.id;
        insert currZip;
        
         Product2 newProd = new Product2();
        newProd.Name = 'AL-Birmingham-pestcontroll';
        newProd.Product_Industry__c = 'pestcontroll';
        newProd.Available_ZipCodes__c = '35004';
        newProd.Branch__c = branch.id; 
        insert newProd;
        
        Product2 newProd1 = new Product2();
        newProd1.Name = 'AL-Birmingham-Handyman';
        newProd1.Product_Industry__c = 'Handyman';
        newProd1.Available_ZipCodes__c = '35004';
        newProd1.Branch__c = branch.id; 
        insert newProd1;
        
        
        Test.startTest();
        updateZipCode updatebatch = new  updateZipCode();
        database.executeBatch(updatebatch);
        Test.stopTest();
       
        
        
            
        
    }
    

}