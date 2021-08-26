/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Installation Trigger
 * TestClass:          InstallationTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    11/09/2020         Jull Quintero D         Initial implementation of the class.
 **/
trigger InstallationTrigger on Installation__c (before update, after insert, after update) {
    new InstallationTriggerHandler().run('InstallationTrigger');
}