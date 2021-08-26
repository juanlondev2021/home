/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          smagicinteractSmsMagicTriggerTest
 * Description:        Helper Class
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 **/
public class smagicinteractSmsMagicTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        smagicinteractSmsMagicTriggerHelper.setConfByTextStatOnEvent((List<smagicinteract__smsMagic__c>)Trigger.new);
    }
}