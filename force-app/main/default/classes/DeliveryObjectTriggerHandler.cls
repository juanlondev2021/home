/* Class Name : DeliveryObjectTriggerHandler
* Created By : Sailappa Vignesh P G
* Created Date : 2/17/2016
* Description : This handler is used by the DeliveryObjectTrigger. Once the Delivery Object record is get inserted the 'isRecent' flag is checked for all the inserted records and un check the same flag to the rest 
of delivery object record connected with the inserted record Person Account. 
*/
public class DeliveryObjectTriggerHandler {    
    public static void handleAfterInsert(list<Delivery_Object__c> deliveryObjectTriggerInstance){
        List<String> userAddressIds = new List<String>();
        List<Delivery_Object__c> deliveryObjectLst =  new List<Delivery_Object__c>();
        Map<ID,Map<String,Integer>> deliveryObjectCountMap = new Map<ID,map<String,Integer>>(); 
        for(Delivery_Object__c currDeliveryObject : deliveryObjectTriggerInstance){
            userAddressIds.add(currDeliveryObject.User_Address__c); 
        }
        /*for (AggregateResult aggregateResult : [SELECT Person_Account__c,count(id) FROM Delivery_Object__c WHERE Person_Account__c in :accountIds GROUP BY Person_Account__c]) {
deliveryObjectCountMap.put((ID)aggregateResult.get('Person_Account__c'),(Integer)aggregateResult.get('expr0'));        
}*/
        for (AggregateResult aggregateResult : [SELECT User_Address__c,count(id),Name FROM Delivery_Object__c WHERE User_Address__c in :userAddressIds group by User_Address__c,Name]) {
            //deliveryObjectCountMap.put((ID)aggregateResult.get('Person_Account__c'),(Integer)aggregateResult.get('expr0'));
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
            //newDeliveryObject.No_of_Attempts__c = (deliveryObjectCountMap.containsKey(currDeliveryObject.Person_Account__c) ? deliveryObjectCountMap.get(currDeliveryObject.Person_Account__c) : 0);
            newDeliveryObject.No_of_Attempts__c = (deliveryObjectCountMap.containsKey(currDeliveryObject.User_Address__c) ? deliveryObjectCountMap.get(currDeliveryObject.User_Address__c).get((string)currDeliveryObject.Name) : 0);
            newDeliveryObject.IsRecent__c = true;
            newDeliveryObject.Status_Updated_Date__c = System.today();
            deliveryObjectLst.add(newDeliveryObject);
        }    
        for(Delivery_Object__c currDeliveryObject : [SELECT ID,IsRecent__c FROM Delivery_Object__c WHERE User_Address__c in :userAddressIds and Id not in : deliveryObjectTriggerInstance]){
            Delivery_Object__c newDeliveryObject = new Delivery_Object__c();
            newDeliveryObject.id = currDeliveryObject.Id;
            newDeliveryObject.IsRecent__c = false;        
            deliveryObjectLst.add(newDeliveryObject);
        }
        if(deliveryObjectLst.size() > 0){
            update deliveryObjectLst;
        }   
    }

    //MST added
    public static void updateWelcomeGift(List<Delivery_Object__c> giftcardid,Set<string> giftcard){ 
        Map<string,id> maporder = new Map<string,id>();
        for(Gift_Card_Orders__c  gorder :[SELECT id,name From Gift_Card_Orders__c WHERE name IN :giftcard])
            maporder.put(gorder.name,gorder.id);
        
        for(Delivery_Object__c Delivery :giftcardid){
            if(maporder.containskey(Delivery.Scan_Code__c)){
                Delivery.Welcome_Gift__c=maporder.get(Delivery.Scan_Code__c);
            }
        }
    }
    
    //MST Added
    public static void updateParentGiftOrder(List<Delivery_Object__c> deliveryIds,Set<string> scanCodeSet){
        Map<string,id> giftCardsMap = New Map<string,id>();
        for(Gift_Card_Orders__c  giftIns :[SELECT id,Name From Gift_Card_Orders__c WHERE Name IN :scanCodeSet]){
            if(!giftCardsMap.containsKey(giftIns.name))
                giftCardsMap.put(giftIns.Name,giftIns.id);
        }
        system.debug('giftCardsMap value'+giftCardsMap);
        for(Delivery_Object__c deliveryIns :deliveryIds){
            String scanCode;
            if(deliveryIns.Scan_Code__c != Null)
             scanCode = deliveryIns.Scan_Code__c.substring(0,9)+' 0000 0000';
            if(giftCardsMap.containskey(scanCode)){
                deliveryIns.Parent_Gift_Card_Order__c = giftCardsMap.get(scanCode);
            }
        }
    }
    
    //MST added This method used to update the user address scan code based on the delivery object scan code.
    public static void updateaddressupdate(map<ID,String> accMap){ 
        List<User_Address__c> userAddressList = new List<User_Address__c>();
        if(accMap.size()>0){
            userAddressList = new List<User_Address__c>();
            //list<User_Address__c> userAddressList = [Select id,Scan_Code__c from User_Address__c where id in: accMap.keySet()];
            for(ID userAddressId : accMap.keySet()){
                userAddressList.add(new User_Address__c(id = userAddressId,Scan_Code__c = accMap.get(userAddressId)));
            }
            try{
                update userAddressList;
            }
            catch(exception e){
                System.debug('Error occured while updating the user address' +e.getmessage());
            }
        } 
        
    }
    
    
    public static void updateDriverLeadStatus(Set<Id> userAddresIds){   
        List<Delivery_Object__c> toUpdateDeliveries = new List<Delivery_Object__c>();
        Set<Id> userAddressIds = new Set<Id>();
        for(Delivery_Object__c currDelivery : [SELECT id,Driver_Lead_Status__c,Hung_Status__c,User_Address__c,Delivery_Date__c,Person_Account__c,User_Address__r.Respond_date__c FROM Delivery_Object__c WHERE User_Address__c IN: userAddresIds AND Delivery_Date__c != null AND Name ='1' AND Hung_Status__c = 'Hung'  ORDER BY createdDate DESC]){           
            if(!userAddressIds.contains(currDelivery.User_Address__c)){
                //Here we can make sure that, respond date always equal to the delivery date or not
                System.debug('@@@DeliveryDate: '+currDelivery.Delivery_Date__c.date() +' <= '+ currDelivery.User_Address__r.Respond_date__c+'RespondDate');
                if(currDelivery.Delivery_Date__c.Date() == currDelivery.User_Address__r.Respond_date__c){
                    userAddressIds.add(currDelivery.User_Address__c);
                    if(currDelivery.Driver_Lead_Status__c == null){
                        toUpdateDeliveries.add(new Delivery_Object__c(id = currDelivery.id,Driver_Lead_Status__c = 'Data'));
                    }
                }
            }
            else if(currDelivery.Driver_Lead_Status__c == 'Data'){
                toUpdateDeliveries.add(new Delivery_Object__c(id = currDelivery.id,Driver_Lead_Status__c = ''));
            }
        }
        System.debug('deliveriesWithDriverLeadStatus+++++++'+toUpdateDeliveries);
        try{
            if(toUpdateDeliveries.size() > 0){
                update toUpdateDeliveries;
            }
        }
        Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }
    }

     //MST added for Delivery 2 update based on the delivery date less the respond date on user address.
      public static void updateDriverLeadStatustwo(Set<Id> userAddresIdsset){   
        List<Delivery_Object__c> toUpdateDeliveriestwo = new List<Delivery_Object__c>();
        Set<Id> userAddressIds = new Set<Id>();
        for(Delivery_Object__c currDelivery : [SELECT id,Driver_Lead_Status__c,Hung_Status__c,User_Address__c,Delivery_Date__c,Person_Account__c,User_Address__r.Respond_date__c FROM Delivery_Object__c WHERE User_Address__c IN: userAddresIdsset AND Delivery_Date__c != null AND Hung_Status__c = 'Hung' AND Name ='2' ORDER BY createdDate DESC]){           
            if(userAddresIdsset.contains(currDelivery.User_Address__c)){
                //Here we can make sure that, respond date always equal to the delivery date or not
                System.debug('@@@DeliveryDate: '+currDelivery.Delivery_Date__c.date() +' <= '+ currDelivery.User_Address__r.Respond_date__c+'RespondDate');
                if(currDelivery.Delivery_Date__c.Date() < currDelivery.User_Address__r.Respond_date__c){
                
                    userAddresIdsset.add(currDelivery.User_Address__c);
                    if(currDelivery.Driver_Lead_Status__c == null){
                        toUpdateDeliveriestwo.add(new Delivery_Object__c(id = currDelivery.id,Driver_Lead_Status__c = 'Data'));
                    }
                }
            }
       }
       try{
            if(toUpdateDeliveriestwo.size() > 0){
                update toUpdateDeliveriestwo;
               DeliveryObjectTriggerHandler.updateDriverLeadStatusoneUpdate(userAddresIdsset);
            }
        }
        Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }
    }
    //MST Added for update the delivery one if the delivery date is less the respond date.
   public static void updateDriverLeadStatusoneUpdate(Set<Id> userAddresIdssetone){
    List<Delivery_Object__c>DeliveryListOne = new List<Delivery_Object__c>();
        for(Delivery_Object__c Delivery : [SELECT id,Name,Driver_Lead_Status__c,User_Address__c FROM Delivery_Object__c Where User_Address__c IN : userAddresIdssetone AND Delivery_Date__c != null AND Hung_Status__c = 'Hung' AND Name ='1']){
            if(Delivery.Driver_Lead_Status__c != null){
             Delivery.Driver_Lead_Status__c =''; 
             DeliveryListOne .add(Delivery);  
            }
         }
        try{
            if(DeliveryListOne .size() > 0){
                update DeliveryListOne ;
            }
        }
        Catch(Exception ex){
            System.debug('DML Exception'+ex.getMessage());
        }
    }    
        
    }