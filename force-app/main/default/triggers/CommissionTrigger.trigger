/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Commission Trigger
 * TestClass:          CommissionTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    06/10/2020         Jull Quintero D         Initial implementation of the class.
 **/
trigger CommissionTrigger on Commission__c (after insert,after update, after delete) {
    new CommissionTriggerHandler().run('CommissionTrigger');
}