/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 12-09-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-01-2020   William Aldana   Initial Version
**/
@isTest
private class ClientServiceCallControllerTest {
    @isTest static void ClientServiceCallControllerGetCallsTest() {
        Account newAcc = new Account();
        newAcc.LastName = 'Test';
        insert newAcc;

        String strObj = '{"objName":"Task","comments":"sdadsdada","status":"Voicemail","type":"Customer Issues","callDateTime":"2020-12-07T23:27:00.000Z","followUpCallRequired":"Yes","followUpDateTime":"2020-12-09T23:28:00.000Z","id":"00T01000003L7y7EAC"}';
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(strObj);
        Map<String, String> inpt = new Map<String, String>();
        
        for(String key : m.keySet()){
            String item = String.valueOf(m.get(key));
            inpt.put(key, item);
        }

        List<Map<String, String>> nput = new List<Map<String, String>>();
        nput.add(inpt);
        ClientServiceCallController.saveTaskRecords(newAcc.Id, nput);

        List<Account> lsTAccount = [Select id from Account limit 1];
        ClientServiceCallController.getCalls(lsTAccount.get(0).Id);
    }
   
    @isTest static void ClientServiceCallControllerDeleteCallsTest() {
        Account newAcc = new Account();
        newAcc.LastName = 'Test';
        insert newAcc;

        String strObj = '{"objName":"Task","comments":"sdadsdada","status":"Voicemail","type":"Customer Issues","callDateTime":"2020-12-07T23:27:00.000Z","followUpCallRequired":"Yes","followUpDateTime":"2020-12-09T23:28:00.000Z","id":"00T01000003L7y7EAC"}';
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(strObj);
        Map<String, String> inpt = new Map<String, String>();
        
        for(String key : m.keySet()){
            String item = String.valueOf(m.get(key));
            inpt.put(key, item);
        }

        List<Map<String, String>> nput = new List<Map<String, String>>();
        nput.add(inpt);
        ClientServiceCallController.saveTaskRecords(newAcc.Id, nput);

        List<Task> lsCC = [Select id from Task limit 1];
        list<Id> lstCallId = new list<Id>();
        if(!lsCC.isEmpty()) lstCallId.add(lsCC.get(0).Id);
        ClientServiceCallController.deleteCalls(lstCallId);
    }

    @isTest static void ClientServiceCallControllerDeleteCallsExTest() {
        Account newAcc = new Account();
        newAcc.LastName = 'Test';
        insert newAcc;

        Task call = new Task();
        call.Call_Timestamp__c = System.now();
        call.Type = 'Quality Control';
        call.Confirmation__c = 'Yes';
        call.Confirmation_DateTime__c = System.now().addDays(1);
        call.Description = 'test notes';
        call.WhatId  = newAcc.Id;
        call.Status = 'No Answer';
        insert call;  
        Id val = call.Id;
        delete call;

        list<Id> lstCallId = new list<Id>();
        lstCallId.add(val);
        try {
            ClientServiceCallController.deleteCalls(lstCallId);
        } catch (Exception ex) {
            ex.getStackTraceString();
        }
        
    }
}