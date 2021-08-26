/* Created By : MST Solutions
* Created Date : Jan/18/2017
* Description : This test class created for nuHome_Call_Center_Batch_AC class.
* */
@isTest
public class nuhome_Call_Center_Batch_Test {
    
    private static testMethod void nuHomeCallCenter_testbatch(){
        Test.startTest();
        // To insert call center campaign and get campaign Id
        Id CallCampaignId = TestNuHomeCallCenterUtill.insertCallCenterCampaign();
        Test.stopTest();
        // To call the method from controller
        CheckResultsJob__c Check =[SELECT id,Name,Job_Result__c,OBCMUserAddress__c,MatchingInventory__c,UnmatchingInventory__c,CallCountFiltered__c FROM CheckResultsJob__c];
        Check.Job_Result__c =2;
        Check.OBCMUserAddress__c =2;
        Check.MatchingInventory__c =2;
        Check.UnmatchingInventory__c =2;
        update Check;
        
        
        
        nuHome_Call_Center_AC nuHomeCallCenter = new nuHome_Call_Center_AC();
        //To send call center priorities values to controller method
        nuHomeCallCenter.selectedPriorityCampaign = CallCampaignId;
        nuHomeCallCenter.priorityInst.DailyCallCount__c = 5;
        nuHomeCallCenter.priorityInst.OBCMMatchingInventories__c = 5;
        nuHomeCallCenter.priorityInst.OBCMUnMatchingInventories__c = 0;
        nuHomeCallCenter.priorityInst.RespondDateMinRange__c = '0';
        nuHomeCallCenter.priorityInst.RespondDateMaximumRange__c = '5';
        
        
        nuHomeCallCenter.checkResults();
        nuHomeCallCenter.priorityInst.Id = nuHomeCallCenter.selectedPriorityId;
        nuHomeCallCenter.createCallLogs();
        nuHomeCallCenter.rolloverRefresh();
        
        // Database.executeBatch(new nuHome_Call_Center_Batch_AC(query),200);
    }
    
    private static testMethod void nuHomeCallCenter_testUnMatch(){
        
        TestNuHomeCallCenterUtill.insertCallRecords();
        
        
    }
    
}