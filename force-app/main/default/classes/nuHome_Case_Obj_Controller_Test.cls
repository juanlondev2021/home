/**************************************************************************************************************
Created By:MST Solutions.
Description : Test Class for nuHome_Case_Obj_Controller class.
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
***************************************************************************************************************/
@isTest(seealldata=false)
private class nuHome_Case_Obj_Controller_Test {
     //Create common test data
    @testSetup static void loadTestData(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
        Case caseIns = new Case();
        caseIns.RecordTypeId = devRecordTypeId;
        caseIns.Status = 'New';
        caseIns.Origin = 'Web';
        caseIns.Subject = 'Test Class subject';
        caseIns.Priority = 'High';
        Insert caseIns;
    }
    //This method is to Call the api methods.
    public static testmethod void createCase(){        
        pageReference pgRef = Page.nuHome_Case;
        Test.setCurrentPage(pgRef);
        nuHome_Case_Obj_Controller objins = new nuHome_Case_Obj_Controller();
        objins.GetTypeValues();
        objins.showComment();  
    }
    
    public static testmethod void createCase1(){
        case caseIns = [select id from case limit 1];
        pageReference pgRef1 = Page.nuHome_Case_Comment;
        pgRef1.getParameters().put('Id', caseIns.Id);
        Test.setCurrentPage(pgRef1);
        
        nuHome_Case_Obj_Controller objins1 = new nuHome_Case_Obj_Controller();
        objins1.getComment();
        objins1.Comment();
        objins1.commentBody = 'Test Comment || Test ';
        objins1.editComment();
        objins1.updateComment();
        objins1.deleteComment();
        objins1.newCase();
        
        parseCase con = new parseCase();
        parseCase.cls_records parseCls = new parseCase.cls_records();
        parseCase.cls_attributes parseAtt = new parseCase.cls_attributes();
        
        String json = '{"attributes":{"type":"CaseComment","url":"/services/data/v20.0/sobjects/CaseComment/00a7A000000LdCWQA0"},'+
                        '"Id":"00a7A000000LdCWQA0","ParentId":"5007A000000mJoCQAU","IsPublished":false,"CommentBody":"testtest","CreatedById":"005j000000DCzzJAAT",'+
                        '"CreatedDate":"2016-01-17T16:31:48.000+0000","SystemModstamp":"2016-01-17T16:31:48.000+0000","LastModifiedDate":"2016-01-17T16:31:48.000+0000",'+
                        '"LastModifiedById":"005j000000DCzzJAAT","IsDeleted":false,"ConnectionReceivedId":null,"ConnectionSentId":null}';
        parseCasecomment.parse(json);
    }
    
    static testmethod void parseClass()
    {
        parseCase con = new parseCase();
        parseCase.cls_records parseCls = new parseCase.cls_records();
        parseCase.cls_attributes parseAtt = new parseCase.cls_attributes();
        parseAtt.type = 'Test Type';
        parseAtt.url = 'Test URL';
        String jsonString = '{"totalSize":1,"done":true,"records":[{"cls_records":{"cls_attributes":{"type":"Test","url":"testurl"},'+
                            '"Id":"5007A00000194emQAA","IsDeleted":false,"CaseNumber":"00001183","ContactId":null,'+
                            '"vf_owner__c":"Chris Edelen","Contact_Name__c":null,"AccountId":null,"Account_Name__c":null,'+
                            '"EntitlementId":"5507A0000004CidQAE","RecordTypeId":"0127A000000084pQAA",'+
                            '"Type":"Attorney General","Reason":"User didn&#39;t attend training","Status":"Escalated",'+
                            '"Origin":"Web","Subject":null,"Description":"Test Description","Priority":"Medium","IsClosed":false,'+
                            '"ClosedDate":null,"OwnerId":"005j000000BX2ucAAD","SlaStartDate":"2016-01-12T12:52:28.000+0000",'+
                            '"SlaExitDate":null,"CreatedDate":"2016-01-12T12:52:28.000+0000","CreatedById":"005j000000Ax79dAAB",'+
                            '"MilestoneStatus":"Open Violation","Sub_Type__c":null}}],'+
                            '"attributes":{"type":"Case","url":"/services/data/v20.0/sobjects/Case/5007A00000194emQAA"}}';
        con = parseCase.parse(jsonString);
        
        parseCls.IsDeleted = FALSE;
        parseCls.CaseNumber = '00001183';
        parseCls.ContactId = NULL;
        parseCls.vf_owner = 'Chris Edelen';
        parseCls.Contact_Name = NULL;
        parseCls.AccountId = NULL;
        parseCls.Account_Name = NULL;
        parseCls.EntitlementId = '5507A0000004CidQAE';
        parseCls.RecordTypeId = '0127A000000084pQAA';
        parseCls.Type = 'Attorney General';
        parseCls.Reason = 'User didn&#39;t attend training';
        parseCls.Status = 'Escalated';
        parseCls.Origin = 'Web'; 
        parseCls.Subject = 'Test Sub';
        parseCls.Description = 'Test Description';
        parseCls.Priority = 'Medium';
        parseCls.IsClosed = FALSE;
        parseCls.ClosedDate = NULL;
        parseCls.OwnerId = '005j000000BX2ucAAD';
        parseCls.SlaStartDate = '2016-01-12T12:52:28.000+0000';
        parseCls.SlaExitDate = '2016-01-12T12:52:28.000+0000';
        parseCls.CreatedDate = '2016-01-12T12:52:28.000+0000';
        parseCls.CreatedById = '005j000000BX2ucAAD';
        parseCls.MilestoneStatus = 'Test';
        parseCls.Sub_Type = 'test type';
        parseCls.attributes = parseAtt;
        con.records.add(parseCls);
    }
    
    static testmethod void parseCaseComment()
    {
        parseCasecomment prsComm = NEW parseCasecomment();
        prsComm.records = NEw List<parseCasecomment.cls_records>();
        parseCasecomment.cls_attributes prsClsattr = NEW parseCasecomment.cls_attributes();
        prsClsattr.type = 'Test';
        prsClsattr.url = 'test URL';
        parseCasecomment.cls_records prsClsRecs = NEW parseCasecomment.cls_records();
        prsClsRecs.attributes = prsClsattr;
        prsClsRecs.id ='5507A0000004CidQAE';
        prsClsRecs.CommentBody ='Test body';
        prsComm.records.add(prsClsRecs);
    }
}