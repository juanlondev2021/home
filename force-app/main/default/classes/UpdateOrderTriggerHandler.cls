/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            UpdateOrder Trigger
 * TestClass:          UpdateOrderTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    11/09/2020         Jull Quintero D         Initial implementation of the class.
 **/
public class UpdateOrderTriggerHandler extends TriggerHandler{

    public override void afterInsert() {
        List<update_order__c> newOrder = (List<update_order__c>)Trigger.new;
        UpdateOrderTriggerHelper.UpdateOrderData(newOrder);
    }
}