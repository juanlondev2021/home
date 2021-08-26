/** 
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Account Trigger
 * TestClass:          AccountTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     01-27-2015          **
 * @version   2.0     09-11-2020         Jull Quintero D         Initial implementation of the class (Unification)
 **/
trigger AccountTrigger on Account (before insert,before update, after insert, after update) {
    new AccountTriggerHandler().run('AccountTrigger');
}