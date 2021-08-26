/**
* Diaco
* @author 			<a href = "mailto:crstian.mosquera@globant.com">Cristian Jose Mosquera Puello </a>
* Project:			My Home service
* Description:		Class responsible to define batch for ntiofication email for coupons.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		22/11/20		Cristian Mosquera (CM)		Initial implementation of the class .
**/
global class DiacoSendNotificationCouponBatch implements Database.Batchable<SObject>, Schedulable
{

    /**
     * @see Database.Batchable.start(Database.BatchableContext)
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recordTypeId =
                Schema.SObjectType.Coupon__c.getRecordTypeInfosByDeveloperName()
                        .get('Diaco_EmailNotification').getRecordTypeId();
        List <Coupon__c> lstCurrentCouponNotification  =
                Database.query(getCouponsNotification(recordTypeId));

        List<Diaco_EmailConfigurationCupon__mdt> lstEmailsRecipients = getEmailRecipients();
        if (lstEmailsRecipients.isEmpty()) {
            return null;
        }

        List<Diaco_EmailConfigurationCupon__mdt> lstEmailsProperties = getEmailProperties();

        if (lstEmailsRecipients.isEmpty() || lstEmailsProperties.isEmpty()) {
            return null;
        }

        if (lstCurrentCouponNotification.isEmpty()) {
            integer counter = 1;
            Coupon__c coupon = new Coupon__c();
            setSendNotificationCouponProperties(coupon, lstEmailsRecipients,
                    lstEmailsProperties.get(0), recordTypeId, null, null);
            insert coupon;
        }
        Database.QueryLocator queryLocatorResp  =
                Database.getQueryLocator(getCouponsNotification(recordTypeId));
        return  queryLocatorResp;

    }



    /**
     * Method responsible to set attributes for send notification.
     *
     * @param coupon the coupon target top set attributes.
     * @param lstEmailsRecipients list of recipients.
     * @param emailProperties email properties.
     * @param recordTypeId record type id identifier.
     */
    global void setSendNotificationCouponProperties (Coupon__c coupon,
                List<Diaco_EmailConfigurationCupon__mdt> lstEmailsRecipients,
            Diaco_EmailConfigurationCupon__mdt emailProperties, Id recordTypeId,
                Decimal percentCurrent, Decimal totalAvailable) {
        integer counter = 1;

        for (Diaco_EmailConfigurationCupon__mdt emailRecipientIt : lstEmailsRecipients) {
            coupon.put('Diaco_EmailNotification' + counter + '__c',
                                emailRecipientIt.Diaco_EmailRecipient__c);
            counter ++;
        }
        coupon.Diaco_PercentTrigger__c = emailProperties.Diaco_PercentTrigger__c;
        coupon.Diaco_PercentTriggerCurrent__c = percentCurrent;
        coupon.Diaco_TotalCouponAvailable__c = totalAvailable;
        coupon.RecordTypeId = recordTypeId;
    }

    /**
     * Get query for coupon notification.
     *
     * @param recordTypeId record type id identifier.
     *
     * @return query for coupon notification.
     */
    global String getCouponsNotification (Id recordTypeId) {
        return 'select id, ' +
                'Diaco_EmailNotification1__c, Diaco_PercentTrigger__c, ' +
                'Diaco_DateSentNotificationTrigger__c, RecordTypeId, Diaco_EmailNotification2__c,' +
                ' Diaco_EmailNotification3__c, Diaco_EmailNotification4__c,' +
                ' Diaco_EmailNotification5__c from Coupon__c ' +
                'where RecordTypeId =:recordTypeId limit 1 ';
    }

    /**
     * Method responsible to get list of email recipients.
     *
     * @return list of email recipients.
     */
    global List<Diaco_EmailConfigurationCupon__mdt> getEmailRecipients () {
        return [
                select Diaco_EmailRecipient__c from Diaco_EmailConfigurationCupon__mdt where
                        Diaco_RecordType__c = 'EmailRecipient'
        ];
    }

    /**
     * Method responsible to get list of email configuration properties.
     *
     * @return list of email configuration properties.
     */
    global List<Diaco_EmailConfigurationCupon__mdt> getEmailProperties () {
        return [
                select Diaco_EmailRecipient__c, Diaco_PercentTrigger__c from Diaco_EmailConfigurationCupon__mdt where
                        Diaco_RecordType__c = 'EmailProperties'
        ];
    }

    /**
     * @see Database.Batchable.execute(Database.BatchableContext, List<SObject>)
     */
    global void execute(Database.BatchableContext bc, List<Coupon__c> records){
        Id recordTypeId =
                Schema.SObjectType.Coupon__c.getRecordTypeInfosByDeveloperName()
                        .get('Diaco_EmailNotification').getRecordTypeId();

        Id recordTypeIdStandard =
                Schema.SObjectType.Coupon__c.getRecordTypeInfosByDeveloperName()
                        .get('Standard').getRecordTypeId();

        List<Diaco_EmailConfigurationCupon__mdt> lstEmailsRecipients = getEmailRecipients();
        if (lstEmailsRecipients.isEmpty()) {
            return;
        }

        List<Diaco_EmailConfigurationCupon__mdt> lstEmailsProperties = getEmailProperties();
        if (lstEmailsRecipients.isEmpty() || lstEmailsProperties.isEmpty()) {
            return ;
        }

        Coupon__c coupon = records.get(0);
        if (coupon.Diaco_DateSentNotificationTrigger__c  == System.today()) {
            return;
        }


        List<AggregateResult> totalCouponAggregated=[SELECT COUNT(id) total,Seen__c FROM Coupon__c
        WHERE RecordTypeId =:recordTypeIdStandard
        GROUP BY Seen__c];
        Map<String, Decimal> mapAggrCoupon = new Map<String, Decimal>();
        for (AggregateResult aggrIt : totalCouponAggregated ) {
            Decimal test = 0;

            mapAggrCoupon.put(String.valueOf(aggrIt.get('Seen__c')),
                            Decimal.valueOf(String.valueOf(aggrIt.get('total'))) );
        }

        Decimal totalSeens = mapAggrCoupon.containsKey('true') ? mapAggrCoupon.get('true') : 0;
        Decimal totalNotSeens = mapAggrCoupon.containsKey('false') ? mapAggrCoupon.get('false') : 0;

        Decimal total = totalSeens + totalNotSeens;
        Decimal percentSeen = (totalSeens * 100 ) / total;


        setSendNotificationCouponProperties(coupon, lstEmailsRecipients ,
                lstEmailsProperties.get(0), recordTypeId, percentSeen, totalNotSeens);
        if (lstEmailsProperties.get(0).Diaco_PercentTrigger__c != null
                && percentSeen >= lstEmailsProperties.get(0).Diaco_PercentTrigger__c) {
            coupon.Diaco_DateSentNotificationTrigger__c =  System.today();
            update coupon;
        }



    }

    /**
     * @see Database.Schedulable.execute(Database.SchedulableContext)
     */
    global void execute(SchedulableContext param1) {
        DiacoSendNotificationCouponBatch myBatchObject = new DiacoSendNotificationCouponBatch();
        Database.executeBatch(myBatchObject);

    }

    /**
     * @see Database.Batchable.finish(Database.BatchableContext)
     */
    global void finish(Database.BatchableContext bc){
        DiacoSendNotificationCouponBatch myBatchObject = new DiacoSendNotificationCouponBatch();
        Database.executeBatch(myBatchObject);
    }
}