@isTest(seealldata = false)
private class nuHome_DTS_View_AC_Test{
/* Created By : MST Solutions
* Created Date : April/11/2016
* Description : This test class is developed to increase the code coverage for nuHome_DTS_View_AC contoller.
* */
    @testsetup
    static  void createtestdata(){ 
        
        Id complianceRecordTypeId = Schema.SObjectType.Door_Tag_Script__c.getRecordTypeInfosByName().get('nuHome Door Tag Compliance').getRecordTypeId();
        Door_Tag_Script__c doorTagScript = TestNuHomeStatisticControlUtil.insertDoorTag();
        Door_Tag_Script__c doorTagScriptIns = TestNuHomeStatisticControlUtil.insertDoorTag();
        
        List<DTSQuestion__c> dtsList = New List<DTSQuestion__c>();
        
        dtsList.add(new DTSQuestion__c(Section__c = 'Section 1',DTSQuestion_Type__c = 'Inbound',Order__c = 1));
        dtsList.add(new DTSQuestion__c(Section__c = 'Section 2',DTSQuestion_Type__c = 'Outbound',Order__c = 1));
        dtsList.add(new DTSQuestion__c(Section__c = 'Section 3',Verbiage_Type__c = 'Inbound',Order__c = 1));
        dtsList.add(new DTSQuestion__c(Section__c = 'Section 4',Order__c = 1));
        dtsList.add(new DTSQuestion__c(Section__c = 'Section 5',Order__c = 1));
        dtsList.add(new DTSQuestion__c(Section__c = 'Confirm Email',Order__c = 1));
        dtsList.add(new DTSQuestion__c(DTSQuestion_Type__c = 'Outbound',Order__c = 1));
        dtsList.add(new DTSQuestion__c(DTSQuestion_Type__c = 'Inbound',Order__c = 1));
        
        insert dtsList;
        
        doorTagScriptIns.survey_details__c = doorTagScript.id; 
        doorTagScriptIns.RecordTypeId = complianceRecordTypeId;
        update doorTagScriptIns;
        //
    }
    static testmethod void test1(){       
        Door_Tag_Script__c doorTagScriptIns = [select id,Survey_Details__c,User_Address__c,Starting_Agent__c,RecordTypeId,Starting_Date__c,Finishing_Date__c,Total_Fields__c,Person_Account__c  from Door_Tag_Script__c where survey_details__c != null limit 1];        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(doorTagScriptIns );
        nuHome_DTS_View_AC nuHomeController = new nuHome_DTS_View_AC(stdCon);         
        nuHomeController.dtsId = 'Test'; 
        nuHomeController.Edit();
        nuHomeController.editSurvey();
    }    
    static testmethod void insertDoorTagScript2(){                    
        Door_Tag_Script__c doorTagScript = [select id,Survey_Details__c,User_Address__c,Starting_Agent__c,RecordTypeId,Starting_Date__c,Finishing_Date__c,Total_Fields__c,Person_Account__c from Door_Tag_Script__c where survey_details__c = null limit 1];        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(doorTagScript );
        nuHome_DTS_View_AC nuHomeController = new nuHome_DTS_View_AC(stdCon); 
        System.assertEquals(doorTagScript .Total_Fields__c ,5);
        nuHomeController.Edit(); 
    }
}