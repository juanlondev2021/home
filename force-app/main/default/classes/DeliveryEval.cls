/** 
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Delivery eval
 * TestClass:          DeliveryObjtTriggerTest
 * Description:        
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08-07-2021         Jull Quintero D         Initial implementation of the class.
 **/

public with sharing class DeliveryEval {
    public static Boolean addressNoNull(Delivery_Object__c delivery) {
        return  delivery.Street__c != null  || 
                delivery.City__c != null    ||
                delivery.State__c != null   || 
                delivery.Zip__c != null     || 
                delivery.County__c != null;
    }

    public static Boolean addressChange(Delivery_Object__c delivery, Delivery_Object__c oldelivery) { 
        return  delivery.Street__c != oldelivery.Street__c ||
                delivery.City__c != oldelivery.City__c ||
                delivery.State__c != oldelivery.State__c ||
                delivery.Zip__c != oldelivery.Zip__c || 
                delivery.County__c != oldelivery.County__c;
    }

    public static Boolean locationNoNull(Delivery_Object__c delivery) {
        return  delivery.Maps_latitude__c != null && 
                delivery.Maps_longitude__c != null;
    }

    public static Boolean locationChange(Delivery_Object__c delivery, Delivery_Object__c oldelivery) {
        return  delivery.Maps_latitude__c != oldelivery.Maps_latitude__c || 
                delivery.Maps_longitude__c != oldelivery.Maps_longitude__c;
    }

    public static Boolean geoCodeChange(Delivery_Object__c delivery, Delivery_Object__c oldelivery) { 
        return  !System.isBatch() &&
                !System.isFuture() &&
                DeliveryEval.locationNoNull(delivery) &&
                DeliveryEval.addressNoNull(delivery) && 
                (DeliveryEval.locationChange(delivery, oldelivery) || DeliveryEval.addressChange(delivery, oldelivery));
    }

    public static Boolean mapLayerChangeLocation(Delivery_Object__c delivery, Delivery_Object__c oldelivery) { 
        return  DeliveryEval.locationNoNull(delivery) &&    
                DeliveryEval.addressNoNull(delivery)  &&
                DeliveryEval.locationChange(delivery, oldelivery) && 
                !DeliveryEval.addressChange(delivery, oldelivery) &&
                UserInfo.getUserId() != label.Data_com_Clean_User_Id;
    }
}