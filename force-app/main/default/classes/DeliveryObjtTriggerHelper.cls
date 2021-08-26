/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Delivery Object Trigger unifications
 * TestClass:          DeliveryObjtTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    01-21-2021         Jull Quintero D         Initial implementation of the class.
 **/

public class DeliveryObjtTriggerHelper {

    private static Id invId;
    private static Id getDriverInvId {
        get {
            if ( invId == null ) {
                invId = [SELECT Id FROM Driver__c WHERE name='Invalid Driver' LIMIT 1]?.Id;
            }
            return invId;
        }
    }

    /*
     * This method is responsible to set delivery Fields
     * 
     * This method is run Before insert and update
     * 
     * This method is used in:
     * DeliveryObject
     * 
     * @param List Delivery
     **/
    public static void setDeliveryFields(List<Delivery_Object__c> deliveries,Map<Id,Delivery_Object__c> oldMapDeliveries,Boolean isInsert, Boolean IsUpdate) 
    {
        set<string> scanCodeSet = new set<string>();
        set<String> driverCodeSet = new set<String>();
        Integer deliverieSize = deliveries.size();

        for (Integer i = 0; i < deliverieSize; i++) {
            Delivery_Object__c current = deliveries[i];
            Delivery_Object__c old =  isUpdate ? oldMapDeliveries.get(current.Id) : null;

            if ( isUpdate ) {  
                // update GiftFields
                if( current.Scan_Code__c != null ) {
                    scanCodeSet.add(current.Scan_Code__c);
                    if(current.Scan_Code__c.length() >= 9) {
                        scanCodeSet.add(current.Scan_Code__c.substring(0,9)+' 0000 0000');
                    }
                } 
            }     

            // assign driver
            driverCodeSet.add(current.Cheetah_Driver_Code__c); 
        }

        if( !driverCodeSet.isEmpty() ) assigndriver(deliveries,oldMapDeliveries,driverCodeSet,isInsert,IsUpdate);
        if( !scanCodeSet.isEmpty() ) setGiftFields(deliveries,scanCodeSet);
    }


    /*
     * This method is responsible to set delivery Fields: 
     * Welcome_Gift__c, Parent_Gift_Card_Order__c
     * 
     * This method is run Before insert and update
     * 
     * This method is used in:
     * this class
     * 
     * @param List Delivery
     * @param giftcard (Set<string>) 
     **/
    private static void setGiftFields(List<Delivery_Object__c> deliveries,Set<string> giftcard)
    { 
        Map<string,id> giftCardsMap = new Map<string,id>();
        List<Gift_Card_Orders__c> GiftCardOrders = [SELECT id,name From Gift_Card_Orders__c WHERE name IN :giftcard];

        Integer GiftCardOrdersSize = GiftCardOrders.size();
        for (Integer i = 0; i < GiftCardOrdersSize; i++) {
            Gift_Card_Orders__c current = GiftCardOrders[i];
            if(!giftCardsMap.containsKey(current.name)) {
                giftCardsMap.put(current.name,current.id);
            }
        }

        Integer deliverieSize = deliveries.size();
        for (Integer i = 0; i < deliverieSize; i++) {
            Delivery_Object__c current = deliveries[i];
            String scanCode;
            if(current.Scan_Code__c != null) {
                current.Welcome_Gift__c = giftCardsMap.get(current.Scan_Code__c);
                if(current.Scan_Code__c.length() >= 9) {
                    scanCode = current.Scan_Code__c.substring(0,9)+' 0000 0000';
                    current.Parent_Gift_Card_Order__c = giftCardsMap.get(scanCode);            
                }
            }
        }
    }


    /*
     * This method is responsible to Assign driver 
     * Cheetah_Driver_Code__c
     * This method is run Before insert and update
     * 
     * This method is used in:
     * This class
     * 
     * @param List Delivery, Map Old Delivery
     **/
    private static void assigndriver(List<Delivery_Object__c> deliveries, Map<Id,Delivery_Object__c> oldMapDeliveries,set<String> driverCodeSet,Boolean isInsert, Boolean IsUpdate ) 
    {
        map<String,String> drNameVsId = new map<String,String>();

        List<Driver__c> drivers =  [SELECT Id,ID__c,name FROM Driver__c WHERE ID__c IN:driverCodeSet];
        Integer driverSize = drivers.size();
        for (Integer i = 0; i < driverSize; i++) {
            Driver__c current = drivers[i];
            drNameVsId.put(current.ID__c,current.Id);
        }
        Integer deliverieSize = deliveries.size();
        for (Integer i = 0; i < deliverieSize; i++) {
            Delivery_Object__c current = deliveries[i];
            Boolean changeDriverCode = false;
            if( isInsert ) {
                changeDriverCode = current.Cheetah_Driver_Code__c != null && current.Cheetah_Driver_Code__c != '';
            }else if ( isUpdate ) {
                Delivery_Object__c old = oldMapDeliveries.get(current.Id);
                changeDriverCode = current.Cheetah_Driver_Code__c != null && current.Cheetah_Driver_Code__c != '' && current.Cheetah_Driver_Code__c != old.Cheetah_Driver_Code__c;
            }
            if(drNameVsId.containsKey(current.Cheetah_Driver_Code__c))
                current.Driver__c = drNameVsId.get(current.Cheetah_Driver_Code__c);
            else if( changeDriverCode )
                current.Driver__c = getDriverInvId; 
        } 
    }
    
    /*
     * This method is responsible to update user Address Scan_Code__c
     * 
     * This method is run After insert and update
     * 
     * This method is used in:
     * DeliveryObject
     * 
     * @param List Delivery, Map Old Delivery
     **/
    public static void setUserAddresScanCode(List<Delivery_Object__c> deliveries, Map<Id,Delivery_Object__c> oldMapDeliveries,Boolean isInsert, Boolean isUpdate) 
    {
        map<Id,String> scanCodeMap = new map<ID,String>();
        List<User_Address__c> userAddress = new List<User_Address__c>();
        
        Integer deliverieSize = deliveries.size();
        for (Integer i = 0; i < deliverieSize; i++) {
            Delivery_Object__c current = deliveries[i];
            Boolean changeScanCode = false;
            if( isInsert ) {
                changeScanCode = current.Scan_Code__c != null && current.Scan_Code__c != '' && current.User_Address__c != null;
            }else if( isUpdate ) {
                Delivery_Object__c old = oldMapDeliveries.get(current.Id);
                changeScanCode = current.Scan_Code__c != null && current.Scan_Code__c != '' && current.User_address__c != null 
                && current.Scan_Code__c != old.Scan_Code__c;
            }
            if( changeScanCode ) scanCodeMap.put(current.User_Address__c,current.Scan_Code__c);
            
        }

        if( !scanCodeMap.isEmpty() ) {
            for(Id userAddressId : scanCodeMap.keySet()) {
                userAddress.add(new User_Address__c(Id = userAddressId,Scan_Code__c = scanCodeMap.get(userAddressId)));
            }
        }
        TriggerHandler.bypass('UserAddressTrigger');
            update userAddress;
        TriggerHandler.clearBypass('UserAddressTrigger');
    }

    /*
     *Created By : Sailappa Vignesh P G
     *Created Date : 2/17/2016
     * Update field Driver_Lead_Status__c
     * 
     * This method is run Aftert update
     * 
     * This method is used in:
     * this class
     * 
     * @param List Delivery
     * @param Old Map Delvery
     **/
    public static void setDriverLeadStatus(List<Delivery_Object__c> deliveries,Map<Id,Delivery_Object__c> oldMapDeliveries) 
    { 
        Set<Id> userAddresIds= new Set<Id>();

        Integer deliverieSize = deliveries.size();
        for (Integer i = 0; i < deliverieSize; i++) {
            Delivery_Object__c current = deliveries[i];
            Delivery_Object__c old = oldMapDeliveries.get(current.Id);
            Boolean ischangeDeliveryDate = current.Delivery_Date__c != null && old.Delivery_Date__c != current.Delivery_Date__c && current.Hung_status__c == 'Hung' && current.Driver_Lead_Status__c == null && current.User_Address__c != null;
            if( ischangeDeliveryDate ) {
                userAddresIds.add(current.User_Address__c);
            }
        }

        List<Delivery_Object__c> toUpdateDeliveries = new List<Delivery_Object__c>();
        Set<Id> userAddressIds = new Set<Id>();
        List<Delivery_Object__c> dls = [SELECT id,bypass_PB__c,Name,Driver_Lead_Status__c,Hung_Status__c,User_Address__c,Delivery_Date__c,Person_Account__c,User_Address__r.Respond_date__c FROM Delivery_Object__c WHERE User_Address__c IN: userAddresIds AND (Name ='1' OR Name ='2') AND Hung_Status__c = 'Hung' ORDER BY createdDate DESC];
        for(Delivery_Object__c current : dls ) {        
            if ( current.Delivery_Date__c != null ) {
                if( current.Name == '1' ) {
                    if ( !userAddressIds.contains(current.User_Address__c ) ) {
                        //Here we can make sure that, respond date always equal to the delivery date or not
                        if( current.Delivery_Date__c.Date() == current.User_Address__r.Respond_date__c ) {
                            userAddressIds.add(current.User_Address__c );
                            if( current.Driver_Lead_Status__c == null ) {
                                toUpdateDeliveries.add(new Delivery_Object__c(id = current.id, bypass_PB__c=!current.bypass_PB__c, Driver_Lead_Status__c = 'Data'));
                            }
                        }
                    }
                    else if( current.Driver_Lead_Status__c == 'Data' ) {
                        toUpdateDeliveries.add(new Delivery_Object__c(id = current.id, bypass_PB__c=!current.bypass_PB__c,Driver_Lead_Status__c = ''));
                    }
                
                }else if ( current.Name == '2' ) {
                    if( current.Delivery_Date__c.Date() < current.User_Address__r.Respond_date__c ) {
                    
                        if(current.Driver_Lead_Status__c == null){
                            toUpdateDeliveries.add( new Delivery_Object__c(id = current.id, bypass_PB__c=!current.bypass_PB__c,Driver_Lead_Status__c = 'Data') );
                        }
                    }
                }  
            } 
        }

        if( !toUpdateDeliveries.isEmpty() ) {
            TriggerHandler.bypass('DeliveryObjectTrigger');
                update toUpdateDeliveries;
            TriggerHandler.clearBypass('DeliveryObjectTrigger');
        }
    }

    /*
     *Created By : Sailappa Vignesh P G
     *Created Date : 2/17/2016
     * Update Field IsRecent__c,Status_Updated_Date__c 
     * 
     * This method is run Aftert insert
     * 
     * This method is used in:
     * this class
     * 
     * @param List Delivery
     * @param Old Map Delvery
     **/
    public static void setDeliveryIsRecent(list<Delivery_Object__c> deliveryObjectTriggerInstance)
    {
        List<String> userAddressIds = new List<String>();
        List<Delivery_Object__c> deliveryObjectLst =  new List<Delivery_Object__c>();
        Map<ID,Map<String,Integer>> deliveryObjectCountMap = new Map<ID,map<String,Integer>>(); 
        for(Delivery_Object__c currDeliveryObject : deliveryObjectTriggerInstance){
            userAddressIds.add(currDeliveryObject.User_Address__c); 
        }

        for(AggregateResult aggregateResult : [SELECT User_Address__c,count(id),Name FROM Delivery_Object__c WHERE User_Address__c in :userAddressIds group by User_Address__c,Name]) {
            if(deliveryObjectCountMap.get((ID)aggregateResult.get('User_Address__c')) == null){
                deliveryObjectCountMap.put((ID)aggregateResult.get('User_Address__c'), new Map<String,Integer>{(String)aggregateResult.get('Name') => (Integer)aggregateResult.get('expr0')});
            }
            else{
                deliveryObjectCountMap.get((ID)aggregateResult.get('User_Address__c')).put((String)aggregateResult.get('Name'), (Integer)aggregateResult.get('expr0'));
            } 
        }
        
        for(Delivery_Object__c currDeliveryObject : deliveryObjectTriggerInstance){                
            Delivery_Object__c newDeliveryObject = new Delivery_Object__c();
            newDeliveryObject.id = currDeliveryObject.Id;  
            newDeliveryObject.No_of_Attempts__c = (deliveryObjectCountMap.containsKey(currDeliveryObject.User_Address__c) ? deliveryObjectCountMap.get(currDeliveryObject.User_Address__c).get((string)currDeliveryObject.Name) : 0);
            newDeliveryObject.IsRecent__c = true;
            newDeliveryObject.Status_Updated_Date__c = System.today();
            deliveryObjectLst.add(newDeliveryObject);
        }    
        for(Delivery_Object__c currDeliveryObject : [SELECT ID,IsRecent__c,bypass_PB__c FROM Delivery_Object__c WHERE User_Address__c in :userAddressIds and Id not in : deliveryObjectTriggerInstance]){
            Delivery_Object__c newDeliveryObject = new Delivery_Object__c();
            newDeliveryObject.id = currDeliveryObject.Id;
            newDeliveryObject.IsRecent__c = false;
            newDeliveryObject.bypass_PB__c = !currDeliveryObject.bypass_PB__c;     
            deliveryObjectLst.add(newDeliveryObject);
        }
        if( !deliveryObjectLst.isEmpty() ) {
            TriggerHandler.bypass('DeliveryObjectTrigger');
                update deliveryObjectLst;
            TriggerHandler.clearBypass('DeliveryObjectTrigger');
        }   
    }

    /** 
    @author: Jull Quintero D - 07-06-2021
    * This method is responsible to update Account Geolocation when Address is change
    * This method is run and after Update.    
    * This method is used in:
    * DeliveryObjtTriggerHandler
    * 
    * @param List Delivery
    * @param Map delivery      
    **/
    public static void getAccountGeoLocation(List<Delivery_Object__c> deliveries, Map<Id,Delivery_Object__c> oldeliveryMap) {
        Map<Id,Account> accounts = new Map<Id,Account>();
        Integer deliverieSize = deliveries.size();
        for (Integer i = 0; i < deliverieSize; i++) {
            Delivery_Object__c current = deliveries[i];
            Delivery_Object__c oldelivery = oldeliveryMap.get(current.Id);

            if( DeliveryEval.geoCodeChange(current, oldelivery) && !accounts.containsKey(current.Person_Account__c) ) {
                accounts.put( 
                    current.Person_Account__c,
                    new Account(
                        Id = current.Person_Account__c,
                        Street__c = current.Street__c,
                        City__c = current.City__c,
                        State__c = current.State__c,
                        Zip__c = current.Zip__c,
                        County__c = current.County__c,
                        BillingLongitude = current.Maps_longitude__c,
                        BillingLatitude = current.Maps_latitude__c
                    )
                );
            }    
        }
    
        if( !accounts.isEmpty() ) {
            System.debug('Delivery Update Account');
            update accounts.values(); 
        }
    }
}