global class diacoScheduleNeverbounce implements Schedulable {
    global void execute(SchedulableContext SC) {
        validateEmailNeverBounce.verificateEmailFromNeverBounce();
    }
}