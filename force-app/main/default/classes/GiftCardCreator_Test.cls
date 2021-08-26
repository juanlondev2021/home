/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata=false)
private class GiftCardCreator_Test {
    @testsetup static void createtestdata() {
        
        BatchBillingHandler.donothing();
        
        Account acc = new Account();
        acc.name = 'testAccount';
        acc.Phone = '1234567898';
        try{
            insert acc;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the acc '+e.getMessage());
        }
        
        Contact con = new Contact();
        con.LastName = 'testcontact';
        con.Accountid = acc.id;
        insert con;
        
        update new account(id=acc.id,Marketing_Contact__c = con.id);
        
        Opportunity opp = new Opportunity();
        opp.accountId = acc.Id;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Active Customer';
        opp.Branch__c = 'Asheville-NC';
        opp.type = 'Existing Business';
        opp.DID__c = 'Test';
        opp.Back_pdf__c = 2;
        opp.Front_pdf__c = 2;
        opp.Art_File__c = 'asdcvfdgf';
        opp.stageName = 'Proposal/Price Quote';
        try{
            insert opp;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the opp'+e.getMessage());
        }
        
        BranchLocation_Mapper__c cs = new BranchLocation_Mapper__c();
        cs.Branch_Name__c = 'Asheville-NC';
        cs.Location_Name__c = '620';
        cs.name = 'Asheville-NC';
        try{
            insert cs;
        }
        catch(exception e){
            system.assert(false,e.getMessage());
        }
        
        
        Gift_Card_Orders__c gco = new Gift_Card_Orders__c();
        gco.Date_Ordered__c = date.today();
        gco.Branch_Location__c = 'Asheville-NC';
        gco.Quantity_Ordered__c = 1;
        gco.name = '0001'+'0001'+' '+'0000'+' '+'0000';
        try{
            insert gco;
        }
        catch(exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getmessage()));
        }
    }
    static testmethod void myUnittest(){
        Opportunity opp = [select id from Opportunity where Branch__c='Asheville-NC' limit 1 ];
        list<String> oppList = new list<String>();
        oppList.add(opp.Id);
        Test.SetCurrentPageReference(new PageReference('Page.GiftCardCreator_VP'));
        ApexPages.currentPage().getParameters().put('selBranch', 'Asheville-NC');
        ApexPages.currentPage().getParameters().put('oppIds', opp.Id+',');
        GiftCardCreator_Ctrl obj = new GiftCardCreator_Ctrl();
        obj.processSelection();
        obj.qnty = 1;
        obj.selectedBranch = 'Asheville-NC';
        obj.saveOrder();
        
        Gift_Card_Orders__c gco = [select id from Gift_Card_Orders__c where Branch_Location__c = 'Asheville-NC' limit 1];
        list<String> gcoList = new list<String>();
        gcoList.add(gco.Id);
        
        BranchLocation_Mapper__c cs = [select Branch_Name__c,Location_Name__c from BranchLocation_Mapper__c where Location_Name__c='620' limit 1];
        map<String,String> csMap = new map<String,String>();
        csMap.put(cs.Branch_Name__c,cs.Location_Name__c);
        
        test.startTest();
        GiftCardCreator_Batch bobj = new GiftCardCreator_Batch('Asheville-NC','0001',gcoList,csMap,oppList);
        database.executeBatch(bobj);
        GiftCardCreator_StatusCtrl newObj = new GiftCardCreator_StatusCtrl();
        newObj.incrementCounter();
        test.stopTest();
    }
}