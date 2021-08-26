@isTest(seealldata=false)
public class nuHome_DoorTagCompliance_AC_Test{
    /* Created By : MST Solutions
* Created Date : Apr/11/2016
* Description : This test class created for nuHome_DoorTagCompliance_AC class.
* */
    
    /************ insertDoorTagScript **************/
    
    
    public static testMethod void insertDoorTagScript(){ 
       
        
        TestNuHomeStatisticControlUtil.lineitemcreation('Siding','AL-Birmingham-Siding');
        system.debug('SOQL Queries: ' + Limits.getQueries());
        test.starttest();
        Door_Tag_Script__c doorTagScript = TestNuHomeStatisticControlUtil.insertDoorTag();
        system.debug('SOQL Queries: ' + Limits.getQueries());
        Account accIns = [SELECT Id,LastName,Verbal_Consent__c,Previous_Street__c,Previous_City__c,Previous_Country__c,Previous_State__c,Previous_Zip__c,
                       Phone,Primary_Shipping_Zip_Code__c,Primary_Billing_City__c,Primary_Billing_Country__c,Primary_Billing_State__c,Primary_Billing_Street__c,Primary_Billing_Zip_Code__c,branch__c FROM Account LIMIT 1];
        Id accountId = accIns.Id;
        Branch__c branch = [SELECT Id,Name,State__c,MSA__c,Carrier_ID__c FROM Branch__c LIMIT 1];
        
        Address__c address = [SELECT Id,Name,Zip_Code__c,Branch__c FROM Address__c LIMIT 1];
        
        User_Address__c userAddress = [SELECT Id,UserAccount__c,Address__c,Active__c,User_Address_Type__c,Respond_Date__c,PersonMobilePhone__c,phone__c FROM User_Address__c LIMIT 1];

        Id dtsRecTypeId = Schema.SObjectType.Door_Tag_Script__c.getRecordTypeInfosByName().get('nuHome Door Tag Compliance').getRecordTypeId();                          
        Door_Tag_Script__c complaince = new Door_Tag_Script__c();
        complaince.survey_details__c = doorTagScript.id;
        complaince.Person_Account__c = accountId ;
        complaince.Account_Phone__c = '8220708920';
        complaince.Account_Mobile__c = '8220708920';
        complaince.Person_Email__c = 'test@gmail.com';
        complaince.TCPA_Response__c = 'Yes';
        complaince.Compliance_Agent__c = UserInfo.getUserId();
        //complaince.Call_Center_Agent__c = '';
        complaince.RecordTypeId = dtsRecTypeId;
        complaince.User_Address__c = userAddress.Id;
        
        
        
        
        insert complaince;
        
        String currentAccountId =  ApexPages.currentPage().getParameters().put('accountId',accountId);
        String currentUserAddressId = ApexPages.currentPage().getParameters().put('userAddressId',userAddress.Id);
        
        string dtsComplianceId = ApexPages.currentPage().getParameters().put('id', complaince.Id);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(complaince);
        nuHome_DoorTagCompliance_AC nuHomeController = new nuHome_DoorTagCompliance_AC(stdCon);
        
        nuHomeController.doorTagIns = doorTagScript;
        
        nuHomeController.SaveRec();
        nuHomeController.editSurveyFunc();
        nuHomeController.EditRec();
        system.debug('SOQL Queries: ' + Limits.getQueries());
        test.stopTest();
        
        
        
    }
    
    
}