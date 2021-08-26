/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          smagicinteractSmsMagicTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 **/
trigger smagicinteractSmsMagicTrigger on smagicinteract__smsMagic__c (after insert) {
    new smagicinteractSmsMagicTriggerHandler().run('smagicinteractSmsMagicTrigger');
}