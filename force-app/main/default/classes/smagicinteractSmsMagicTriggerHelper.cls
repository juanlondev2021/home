/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          smagicinteractSmsMagicTriggerTest
 * Description:        Trigger Helper Class
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 **/
public class smagicinteractSmsMagicTriggerHelper {

    /**
    * @description Sets Status Confirmed by text on NEW SMS = C with Event
    * @author William Aldana | 12-10-2020 
    **/
    public static void setConfByTextStatOnEvent(List<smagicinteract__smsMagic__c> newList){
        Integer newListSize =  newList.size();
        Set<String> idsToReview = new Set<String>();
        for (Integer i = 0; i < newListSize; i++) {
            smagicinteract__smsMagic__c newVal = newList[i];
            String cleannedMessage = newVal.smagicinteract__SMSText__c != null ? newVal.smagicinteract__SMSText__c.trim() : '';
            cleannedMessage = cleannedMessage.toUpperCase();
            cleannedMessage = cleannedMessage.replaceAll('\"', '');
            if(newVal.smagicinteract__Direction__c == 'IN' && cleannedMessage == 'C' && newVal.Home_Service__c != null){
                idsToReview.add(newVal.Home_Service__c);
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
}