/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          dsmsMessageTriggerTest
 * Description:        Trigger Helper Class
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 * @version   1.0     10/12/2020        Jull Q Daza             Reply to slack Messages
 **/
public class dsmsMessageTriggerHelper {
    /**
    * @description Sets Status Confirmed by text on NEW SMS = C with Event
    * @author William Aldana | 12-10-2020 
    **/
    public static void setConfByTextStatOnEvent(List<dsms__Message__c> newList){
        Integer newListSize =  newList.size();
        Set<String> idsToReview = new Set<String>();
        for (Integer i = 0; i < newListSize; i++) {
            dsms__Message__c newVal = newList[i];
            String cleannedMessage = newVal.dsms__Message__c != null ? newVal.dsms__Message__c.trim() : '';
            cleannedMessage = cleannedMessage.toUpperCase();
            cleannedMessage = cleannedMessage.replaceAll('\"', '');
            if(newVal.dsms__Type__c == 'inbound' && cleannedMessage == 'C' && newVal.Home_Services_lk__c != null){
                idsToReview.add(newVal.Home_Services_lk__c);
            }
        }

        if(!idsToReview.isEmpty()){
            List<Event> toUpdate = new List<Event>();
            List<Event> hsToReview = [Select Id, Confirmation_Status__c from Event where WhatId in :idsToReview and Current_Appointment__c = true];
            for (Event eventVal : hsToReview) {
                if(eventVal.Confirmation_Status__c == null){
                    Event upEvent = new Event();
                    upEvent.Id = eventVal.Id;
                    upEvent.Confirmation_Status__c = 'Confirmed via Text';
                    //TODO: if Exists and event PBs consolidation field could be added here
                    toUpdate.add(upEvent);
                }
            }

            if(!toUpdate.isEmpty()){
                TriggerHandler.bypass('EventTrigger');
                    update toUpdate;
                TriggerHandler.clearBypass('EventTrigger');
            }
        }
    }

    /*
    *@author: Jull Q Daza - 10/12/2020
     * This method is responsible to create SMS Responses when a message is inbound type 
     * This method is run After Intert
     * 
     * This method is used in:
     * DsmsMessageTrigger
     * 
     * @param List dsms__Message__c,
     */
    public static void createSlackMessage(List<dsms__Message__c> currentMessages ) {
        Set<String> sDiacophonenumbers = new Set<String>();
        Map<Id,String> parentNameMap = new Map<Id,String>();

        List<diaco__slackMessages__c> slackMesgs = new List<diaco__slackMessages__c>();
        List<dsms__Message__c> dsmsMessages  = new List<dsms__Message__c>();
        set<Id> parentIds = new set<Id>(); 

        Integer smsMessagesLength = currentMessages.size();
        for (Integer j = 0; j < smsMessagesLength; j++) {
            dsms__Message__c current = currentMessages[j];
            if( String.isNotBlank(current.dsms__parentId__c) && current.dsms__Type__c == 'inbound') {
                if( !parentIds.contains(current.dsms__parentId__c) ) parentIds.add(current.dsms__parentId__c); 
                if( !sDiacophonenumbers.contains(current.dsms__To__c)) sDiacophonenumbers.add(current.dsms__To__c);
                dsmsMessages.add(current); 
            }
        }

        if( !parentIds.isEmpty() ) {
            parentNameMap = DiacoSMSettings.getParentNames(parentIds);
        }

        if( !dsmsMessages.isEmpty() ) {            
            Integer dsmsMessagesLength = dsmsMessages.size();
            for (Integer i = 0; i < dsmsMessagesLength; i++) {
                dsms__Message__c current = dsmsMessages[i];    
                String slackChannel = DiacoSMSettings.getDiacoSMSenderSlackChannel(sDiacophonenumbers).get(current.dsms__To__c);
                if( String.isNotEmpty(slackChannel) ) {
                    String parentName = parentNameMap.get(current.dsms__parentId__c);
                    diaco__slackMessages__c dSlack = new diaco__slackMessages__c(
                        diaco__message__c = slackMessage(current,parentName),
                        diaco__slackChannel__c = slackChannel,
                        diaco__Batch_Or_Future__c = true,
                        diaco__mentionToEveryBody__c = true
                    );
                    slackMesgs.add(dSlack);
                }
            }
            if( !slackMesgs.isEmpty() ) {
                Database.insert(slackMesgs, false);
            }
        }
    }

    /*
    *@Author: Jull Q Daza - 10/12/2020
     * This method is responsible to create message
     * This method is run After Intert
     * 
     * This method is used in:
     * createSlackMessage - this class
     * 
     * @param dsms__Message__c,
     */
    private static String slackMessage(dsms__Message__c smsMessage,string name) {
        //String name = parentName.get(smsMessage.dsms__parentId__c);
        String smsInfo;
        if( String.isEmpty(name) ) {
            smsInfo = ' - This message was sent by Mobile Number: ' + smsMessage.dsms__From__c;
        }else{
            smsInfo = ' - This message was sent by ' +  name +' - Mobile Number: ' + smsMessage.dsms__From__c;
        }
        String text = smsMessage.dsms__Message__c + smsInfo + '. Here is a link: https://myhomeservices.lightning.force.com/'+smsMessage.dsms__parentId__c;
        return text;
    }

}