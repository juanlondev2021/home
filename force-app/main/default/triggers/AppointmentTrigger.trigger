trigger AppointmentTrigger on Appointment__c (before insert, before update, after insert, after update) {
    new AppointmentTriggerHandler().run('AppointmentTrigger');
}