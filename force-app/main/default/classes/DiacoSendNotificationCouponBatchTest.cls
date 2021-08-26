/**
* Diaco
* @author 			<a href = "mailto:crstian.mosquera@globant.com">Cristian Jose Mosquera Puello </a>
* Project:			MyHomeService
* Description:		Class responsible to execute the unit test for the Class DiacoSendNotificationCouponBatchTest
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		28/11/20		Cristian Mosquera (CM)		Initial implementation of the class .
**/
@IsTest
private class DiacoSendNotificationCouponBatchTest {

    @TestSetup
    private static void initData () {

        Id recordTypeId =
                Schema.SObjectType.Coupon__c.getRecordTypeInfosByDeveloperName()
                        .get('Diaco_EmailNotification').getRecordTypeId();

        Id recordTypeIdStandard =
                Schema.SObjectType.Coupon__c.getRecordTypeInfosByDeveloperName()
                        .get('Standard').getRecordTypeId();
        Coupon__c coupon = new Coupon__c(Diaco_EmailNotification1__c = 'cmosquera@gmail.com1',
                Diaco_EmailNotification2__c = 'cmosquera@gmail.com2',
                Diaco_EmailNotification3__c = 'cmosquera@gmail.com3',
                Diaco_EmailNotification4__c = 'cmosquera@gmail.com4',
                Diaco_EmailNotification5__c = 'cmosquera@gmail.com5',
                Diaco_PercentTrigger__c = 75, RecordTypeId = recordTypeId);
        insert coupon;
        TestData.generateCoupon(true, recordTypeIdStandard);
    }

    @IsTest
    private static void testExecuteMajorThan75Percent () {

        DiacoSendNotificationCouponBatch batch = new DiacoSendNotificationCouponBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        List<Coupon__c> coupons = new List<Coupon__c>();
        Database.QueryLocatorIterator iterator = queryLocator.iterator();
        while (iterator.hasNext()) {
            coupons.add((Coupon__c) iterator.next());
        }
        batch.execute(null, coupons);

        List<Coupon__c> couponsToSend =  [select id, Diaco_DateSentNotificationTrigger__c from Coupon__c where id in:coupons];

        for (Coupon__c coupIt : couponsToSend) {
            System.assertEquals(System.today(), coupIt.Diaco_DateSentNotificationTrigger__c);
        }
    }

    @IsTest
    private static void testExecuteMajorThan75PercentInitial () {
        DiacoSendNotificationCouponBatch batch = new DiacoSendNotificationCouponBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        Database.QueryLocatorIterator iteratorInitial = queryLocator.iterator();
        while (iteratorInitial.hasNext()) {
            delete iteratorInitial.next();
        }
        queryLocator = batch.start(null);
        List<Coupon__c> coupons = new List<Coupon__c>();
        Database.QueryLocatorIterator iterator = queryLocator.iterator();
        while (iterator.hasNext()) {
            coupons.add((Coupon__c) iterator.next());
        }
        batch.execute(null, coupons);

        List<Coupon__c> couponsToSend =  [select id, Diaco_DateSentNotificationTrigger__c from Coupon__c where id in:coupons];

        for (Coupon__c coupIt : couponsToSend) {
            System.assertEquals(System.today(), coupIt.Diaco_DateSentNotificationTrigger__c);
        }
    }

    @IsTest
    private static void testExcecuteLessThan75Percent () {
        Id recordTypeIdStandard =
                Schema.SObjectType.Coupon__c.getRecordTypeInfosByName()
                        .get('Standard').getRecordTypeId();
        Coupon__c coupon1 = TestData.generateCoupon(false, recordTypeIdStandard);
        coupon1.Seen__c = false;
        Coupon__c coupon2 = TestData.generateCoupon(false, recordTypeIdStandard);
        coupon2.Seen__c = false;
        List<Coupon__c> couponToInsert = new List<Coupon__c>();
        couponToInsert.add(coupon1);
        couponToInsert.add(coupon2);
        insert couponToInsert;
        DiacoSendNotificationCouponBatch batch = new DiacoSendNotificationCouponBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        List<Coupon__c> coupons = new List<Coupon__c>();
        Database.QueryLocatorIterator iterator = queryLocator.iterator();
        while (iterator.hasNext()) {
            coupons.add((Coupon__c) iterator.next());
        }
        batch.execute(null, coupons);

        List<Coupon__c> couponsToSend =  [select id, Diaco_DateSentNotificationTrigger__c from Coupon__c where id in:coupons];

        for (Coupon__c coupIt : couponsToSend) {
            System.assertNotEquals(System.today(), coupIt.Diaco_DateSentNotificationTrigger__c);
        }
    }
}