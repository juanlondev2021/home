/*****************************************************************************************
*  Class Name : DeliveryParameterUI_Test
*  Created By : Sankar Marappan
*  Created Date : 20/4/2016
*  Author : MST
*  Description : This class will cover the code coverage for 'DeliveryParameterUI'.
*  Modified By: Ganesh
*  Modified on:
*  Description: Updated the test class as per best practices. 
****************************************************************************************/
@isTest(SeeAllData = false)
private class DeliveryParameterUI_Test {
    //Create common test data
    @testSetup static void loadData(){
        TestClassUtil.createAccount(5);
        TestClassUtil.createBranch();
        TestClassUtil.createHung_Status_Setting();
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createDeliveryProducts();
        TestClassUtil.createDeliveryParameter(1);//Create delivery number one record in Delivery Parameter obj.
    }
    static testmethod void testDeliveryParameterWithActive(){
        //When edit active delivery parameter record
        Delivery_parameter__c deliveryParameter = [SELECT id,name,branch__c FROM Delivery_parameter__c];
        PageReference pageRef = Page.DeliveryParameter_VF; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('retURL',deliveryParameter.branch__c); 
        test.startTest();
        DeliveryParameterUI controller = new DeliveryParameterUI(new ApexPages.StandardController(deliveryParameter));
        controller.excludedZipCodes.add(controller.includedZipCodes.get(0));
        controller.includedZipCodes.remove(0);
        controller.save();
        controller.redirect();
        DeliveryParameterUI con = new DeliveryParameterUI(new ApexPages.StandardController(deliveryParameter));
        test.stopTest();
    }
    static testmethod void testNewDeliveryParameter(){
        //When new delivery parameter button clicked
        List<Branch__c> branchList = [SELECT id,name FROM Branch__c WHERE Name = 'AZ-Test Branch'];
        Delivery_parameter__c newDeliveryParameter = new Delivery_parameter__c(Branch__c = branchList[0].id);
        PageReference pageRef = Page.DeliveryParameter_VF; 
        Test.setCurrentPage(pageRef);
        test.startTest();
        DeliveryParameterUI controller = new DeliveryParameterUI(new ApexPages.StandardController(newDeliveryParameter));     
        controller.ischanged = false;
        controller.updateBranchNextAttemptDays();
        controller.selectedProducts.clear();
        controller.save();
        test.stopTest();
    }
    static testmethod void testInitialDeliveryParameter(){
        //When very first branch's delivery parameter new button clicked.
        List<Branch__c> branchList = [SELECT id,name FROM Branch__c WHERE Name = 'NC-Greensboro'];
        Delivery_parameter__c firstDeliveryParameter = new Delivery_parameter__c(Branch__c = branchList[0].id);
        PageReference pageRef = Page.DeliveryParameter_VF; 
        Test.setCurrentPage(pageRef);
        test.startTest();
        DeliveryParameterUI controller = new DeliveryParameterUI(new ApexPages.StandardController(firstDeliveryParameter));
        controller.ischanged = false;
        controller.updateBranchNextAttemptDays();
        controller.save();
        test.stopTest();
    }
    static testmethod void testInActiveDeliveryParameter(){
        //When user edit inactive delivery parameter record
        test.startTest();
        Delivery_parameter__c deliveryParameter = [SELECT id,name,branch__c FROM Delivery_parameter__c];
        PageReference pageRef = Page.DeliveryParameter_VF; 
        Test.setCurrentPage(pageRef);
        DeliveryParameterUI controller = new DeliveryParameterUI(new ApexPages.StandardController(deliveryParameter));
        controller.delivery.Max_Sales_Price__c = 100;   
        controller.ischanged = true;
        controller.updateBranchNextAttemptDays();
        controller.save();
        test.stopTest();
    }
    static testmethod void testDMLError(){
        //When user edit inactive delivery parameter record
        test.startTest();
        Delivery_parameter__c deliveryParameter = [SELECT id,name,branch__c FROM Delivery_parameter__c];
        PageReference pageRef = Page.DeliveryParameter_VF; 
        Test.setCurrentPage(pageRef);
        DeliveryParameterUI controller = new DeliveryParameterUI(new ApexPages.StandardController(deliveryParameter));
        controller.delivery.Max_Sales_Price__c = 0;   
        controller.save();
        test.stopTest();
    }
}