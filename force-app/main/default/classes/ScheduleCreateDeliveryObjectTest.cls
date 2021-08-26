/* Class Name : ScheduleCreateDeliveryObject
* Created By : Sailappa Vignesh P G
* Created Date : 2/18/2016
* Description : This class will cover the code coverage for the schedule class 'ScheduleCreateDeliveryObject'. 
*/
@isTest(seeAllData = false) 
public class ScheduleCreateDeliveryObjectTest {
    public static testmethod  void  testschedule(){
        Test.StartTest();
        ScheduleCreateDeliveryObject schedule = new ScheduleCreateDeliveryObject();      
        String scheduleString = '0 0 23 * * ?';
        system.schedule('Test check', scheduleString, schedule);
        Test.stopTest();
    }
}