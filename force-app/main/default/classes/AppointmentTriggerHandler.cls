/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Appointemnt Trigger
 * TestClass:          AppointmentTriggerTest
 * Description:        Handler
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    12/09/2020         Jull Quintero D         Initial implementation of the class.
 **/

public class AppointmentTriggerHandler extends TriggerHandler{

    public override void beforeInsert() {
        List<Appointment__c>  newAppts = (List<Appointment__c>)Trigger.new;
        AppointmentTriggerHelper.settingAppointments(newAppts, Trigger.isInsert);
    }

    public override void beforeUpdate() {
        List<Appointment__c>  newAppts = (List<Appointment__c>)Trigger.new;
        AppointmentTriggerHelper.settingAppointments(newAppts,Trigger.isInsert);

    }

    public override void afterInsert() {
        set<Id> newApptIds = Trigger.newMap.KeySet();
        AppointmentTriggerHelper.createHs(newApptIds);
        AppointmentTriggerHelper.createSMS((List<Appointment__c>)Trigger.new, (Map<Id,Appointment__c>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);
    }

    public override void afterUpdate() {
        set<Id> newApptIds = Trigger.newMap.KeySet();
        AppointmentTriggerHelper.createHs(newApptIds);
        AppointmentTriggerHelper.createSMS((List<Appointment__c>)Trigger.new, (Map<Id,Appointment__c>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);
        //AppointmentTriggerHelper.partnerNotification((List<Appointment__c>)Trigger.new, (Map<Id,Appointment__c>)Trigger.oldMap);
    }
}