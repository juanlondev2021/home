@isTest
public class DiacoPlayRecTest {
    @isTest static void testSendgrid(){
        test.startTest();
        System.debug(DiacoPlayRec.getCallByUA('test'));
        test.stopTest();
    }

}