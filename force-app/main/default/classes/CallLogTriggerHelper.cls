/*
    Developer Name : Ganesh
    Created Date : Dec 8th 2016
*/

public class CallLogTriggerHelper{

    private Static void ProcessInventoryfromCallLogs(map<id,Call_Log__c> newMap)
    {
        // COllecting All DID__c Id's
        set<ID> dIDRecSet = new set<ID>();
        List<Call_Log__c> updCallLogInvCreatedFlagColl = new List<Call_Log__c>();
        for(Call_Log__c callLogs : newMap.values()){
            dIDRecSet.add(callLogs.DID__c);
        }
        
        // Getting all Opportunity ids for DID__c records
        List<inventory__C> newInventoryList = new List<inventory__c>();
        map<id,DID__c> newMApWithDID = new map<id,DID__c>([select id,Opportunity__c 
                                                            from DID__c where id in : dIDRecSet and Opportunity__c != null]);
                                                            
        for(Call_Log__c callLogs : newMap.values()){
            if(callLogs.Billable__c && callLogs.Inventory_Created__c == false){
                
                id idCpl = (callLogs.DID__c == null ? null : newMApWithDID.get(callLogs.DID__c).Opportunity__c);                
                
                // Getting RecordType Name for Call_Log__c Record
                string nameRecType  = Schema.SObjectType.Call_Log__c.getRecordTypeInfosById().get(callLogs.RecordTypeId).getName(); 
                
                
                // Getting RecordType Id based on Call_Log__c record RecordTypeName
                Id recorcTyeId = Schema.SObjectType.inventory__c.getRecordTypeInfosByName().get(nameRecType).getRecordTypeId();
                
                // Forming New inventory__C
                newInventoryList.add(new inventory__C(recordtypeid = recorcTyeId ,
                    Sale_Disposition__c='Install',ANI__c = callLogs.ANI__c ,
                    Call_Disposition__c = callLogs.Call_Disposition__c ,
                    Call_Notes__c = callLogs.Call_Notes__c ,Account__c = callLogs.Account__c ,
                    User_Address__c = callLogs.User_Address__c ,Industry__c = callLogs.Industry__c,
                    Inventory_Type__c = callLogs.Record_Type__c, interactionStepId__c = callLogs.interactionStepId__c,
                    idCPL_Billing_Opportunity__c = idCpl,Call_Time__c = callLogs.Answered_Duration__c));  
                // update the inventory created flag after insertion of inventory records 
                updCallLogInvCreatedFlagColl.add(new Call_log__c(id=callLogs.id,Inventory_Created__c = true));
            }           
        }
        
        // Inserting New inventory__C Records
        if(newInventoryList.size() > 0){
            insert newInventoryList;
            update updCallLogInvCreatedFlagColl;
        }
    }
    public static void afterInsertHandler(map<id,Call_Log__c> newMap){
        CallLogTriggerHelper.ProcessInventoryfromCallLogs(newMap);           
    } 
    public static void afterUpdateHandler(map<id,Call_Log__c> newMap){        
        CallLogTriggerHelper.ProcessInventoryfromCallLogs(newMap);
    }    
}