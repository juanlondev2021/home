/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            UpdateOrder Trigger
 * TestClass:          UpdateOrderTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    11/09/2020         Jull Quintero D         Initial implementation of the class.
 **/
trigger UpdateOrderTrigger on update_order__c (after insert) {
    new UpdateOrderTriggerHandler().run('UpdateOrderTrigger');
}