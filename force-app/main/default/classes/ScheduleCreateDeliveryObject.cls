/* Class Name : ScheduleCreateDeliveryObject
* Created By : Sailappa Vignesh P G
* Created Date : 2/18/2016
* Description : This class will Schedule the execution of batch class named CreateDeliveryObject. 
*/
global class ScheduleCreateDeliveryObject implements Schedulable {
    global void execute(SchedulableContext sc) {
        CreateDeliveryObject createDeliveryObjectBatchClass = new CreateDeliveryObject(); 
        database.executebatch(createDeliveryObjectBatchClass,100);
    }
}