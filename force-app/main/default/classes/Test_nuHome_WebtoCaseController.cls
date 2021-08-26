// This class created for nuHome_WebtoCaseController class.

@isTest(seealldata=false)
private class Test_nuHome_WebtoCaseController
{
    @testsetup static void createtestdata(){
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        //Insert Case record
        Case caseIns = NEW Case();
        caseIns.recordtypeid = recordTypeID;
        caseIns.Status ='New';
        insert CaseIns;
        system.assertNotEquals(null, CaseIns.id);
        
    }
    static testmethod void createcase()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        Case caseIns = [select id from Case limit 1];
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','1');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.casecreate();
        test.stopTest();
    }
    static testmethod void createcaseWithAttachments()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId(); 
        Case caseIns = [select id from Case limit 1];
        
        Attachment attach = new Attachment();
        attach.Name = 'Test Attach';
        attach.body = blob.valueof('Test');
        
        List<Attachment> attachmentList = [select id,name,body from Attachment];
        attachmentList.add(attach);
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','2');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.newAttachments = attachmentList;
        controller.casecreate();
        test.stopTest();
    }
    static testmethod void createcaseWithAttachmentsWithException()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        
        Case caseIns = [select id from Case limit 1];
        
        Attachment attach = new Attachment();
        attach.body = blob.valueof('Test');
        
        List<Attachment> attachmentList = NEW List<Attachment>();
        attachmentList.add(attach);
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','2');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.newAttachments = attachmentList;
        controller.casecreate();
        test.stopTest();
    }
    static testmethod void GetCaseTypeValuesTest()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        Case caseIns = [select id from Case limit 1];
        
        Attachment attach = new Attachment();
        attach.body = blob.valueof('Test');
        
        List<Attachment> attachmentList = NEW List<Attachment>();
        attachmentList.add(attach);
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','3');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.newAttachments = attachmentList;
        controller.GetTypeValues();
        test.stopTest();
    }
    static testmethod void chooseRecordTypeTest()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        Case caseIns = [select id from Case limit 1];
        
        Attachment attach = new Attachment();
        attach.body = blob.valueof('Test');
        
        List<Attachment> attachmentList = NEW List<Attachment>();
        attachmentList.add(attach);
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','2');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.newAttachments = attachmentList;
        controller.chooseRT();
        test.stopTest();
    }
    static testmethod void CancelActionTest()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        Case caseIns = [select id from Case limit 1];
        
        Attachment attach = new Attachment();
        attach.body = blob.valueof('Test');
        
        List<Attachment> attachmentList = NEW List<Attachment>();
        attachmentList.add(attach);
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','2');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.newAttachments = attachmentList;
        controller.Cancel();
        test.stopTest();
    }
    static testmethod void AddMoreAttchmnetTest()
    {
        id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Building Maintenance').getRecordTypeId();
        Case caseIns = [select id from Case limit 1];
        
        Attachment attach = new Attachment();
        attach.body = blob.valueof('Test');
        
        List<Attachment> attachmentList = NEW List<Attachment>();
        attachmentList.add(attach);
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.nuHome_WebtoCase')); 
        System.currentPageReference().getParameters().put('step','2');
        System.currentPageReference().getParameters().put('RecordTypeid',(String)recordTypeID);
        System.currentPageReference().getParameters().put('Id',(String)caseIns.id);
        nuHome_WebtoCaseController controller = new nuHome_WebtoCaseController();
        controller.newAttachments = attachmentList;
        controller.NUM_ATTACHMENTS_TO_ADD = 4;
        controller.addMore();
        test.stopTest();
    }
    
}