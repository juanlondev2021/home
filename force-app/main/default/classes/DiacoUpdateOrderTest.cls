/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			Update Order.
 * Test:            DiacoUpdateOrderTest
 * Description:		Update records with the Update Order parameters..
 *
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		30/07/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/
@istest
public class DiacoUpdateOrderTest {
    @istest static void test() {

        Account acc = new Account();
        acc.FirstName = 'Test acc';
        acc.LastName  = 'last test';
        insert acc;

        List<Update_Order__c> uOrder = new List<Update_Order__c>();
        uOrder.add(new Update_Order__c(
            name              = 'test',
            Status__c         = 'In Process',
            List_of_Fields__c = 'Phone/,/DNC_HVAC__c',
            List_of_Values__c = '3161111111/,/false',
            Parent_Id__c      = acc.id,
            Guest_User__c     = true

        ));

        uOrder.add(new Update_Order__c(
            name              = 'test',
            Status__c         = 'In Process',
            List_of_Fields__c = 'Phone',
            List_of_Values__c = '3161111111',
            Parent_Id__c      = acc.id,
            Guest_User__c     = false

        ));

        test.startTest();

        DateTime myDateTime = System.now().addMinutes(2);
        String title = 'Update Order';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ? '+myDateTime.year();
        String jobID = system.schedule(title, sch, new DiacoUpdateOrderScheduleJob());

        insert uOrder;

        test.stopTest();

    }
}