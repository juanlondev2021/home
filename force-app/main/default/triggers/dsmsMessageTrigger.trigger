/*
 * Diaco
 * @author             William Aldana
 * Project:            dsms__Message__c Trigger
 * TestClass:          dsmsMessageTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    10/12/2020         William Aldana         Initial implementation of the class.
 **/

trigger dsmsMessageTrigger on dsms__Message__c (after insert) {
    new dsmsMessageTriggerHandler().run('dsmsMessageTrigger');
}