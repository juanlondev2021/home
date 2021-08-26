/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Address Trigger
 * TestClass:          AddressTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    3/08/2016         Priyanka Shanmugam          *
 * @version    2.0    12/10/2020        Jull Quintero D         Trigger Configuration
 * 
 **/
trigger AddressTrigger on Address__c (before insert,before update,after update) {
    new AddressTriggerHandler().run('AddressTrigger');
}