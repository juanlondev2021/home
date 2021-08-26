/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          dsmsMessageTriggerTest
 * Description:        Trigger Handler Class
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 **/
public class dsmsMessageTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        dsmsMessageTriggerHelper.setConfByTextStatOnEvent((List<dsms__Message__c>)Trigger.new);
        dsmsMessageTriggerHelper.createSlackMessage((List<dsms__Message__c>)Trigger.new);
    }
}