/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Delivery Object Trigger unifications
 * TestClass:          DeliveryObjtTriggerTest
 * Description:        Trigger
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     01-27-2015          **
 * @version   1.0     01-29-2021         Jull Quintero D         Initial implementation of the class(Unification)
 **/

trigger DeliveryObjtTrigger on Delivery_Object__c(after insert,before insert,before update,after update) {
    new DeliveryObjtTriggerHandler().run('DeliveryObjectTrigger');
}