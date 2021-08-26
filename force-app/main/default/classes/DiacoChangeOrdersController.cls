/**
* Diaco
* @author 			Álvaro Ortega href=<aovargas05@gmail.com>
* Project:			Change Order
* Description:		Component to create Change Order Objects and Order Item Objects
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version	1.0		14/11/2019		Alvaro Ortega (AO)		Component.
**/
public class DiacoChangeOrdersController {
    @AuraEnabled
    public static List<Boolean> thereAreProductAndServices(String recordId){
        // system.debug('______________o_______________ 1');
        List<Product__c> p = getProducts(recordId);
        List<Product__c> s = getServices(recordId);
        // system.debug('______________o_______________ 2');
        
        List<Order_Item__c> oip = getOrderItems(recordId);
        List<Order_Item__c> ois = getOrderItemsServices(recordId);
        // system.debug('______________o_______________ 3');
        
        List<Boolean> result = new List<Boolean>();
        
        result.add( (p.size() > 0) || (oip.size() > 0) ); 
        result.add( (s.size() > 0) || (ois.size() > 0) ); 
        // system.debug('______________o_______________ 4');
        
        return result;
    }
    @AuraEnabled
    public static List<Change_Order__c> getChangeOrders(String recordId){
        List<Change_Order__c> cos=[select Id,Name,Gross_Sale__c,CreatedDate from Change_Order__c where Installation__c=:recordId order by CreatedDate desc];
        return cos;
    }
    
    @AuraEnabled
    public static List<Order_Item__c> getOrderItems(String recordId){
        List<Order_Item__c> ois=[select Id,Name,Price__c,Total_Price__c,Quantity__c from Order_Item__c where Change_Order__c=:recordId and Service_Check__c=false order by CreatedDate desc];
        return ois;
    }
    @AuraEnabled
    public static List<Order_Item__c> getOrderItemsServices(String recordId){
        List<Order_Item__c> ois=[select Id,Name,Billing_Frequency__c,Bill_Start_Date__c,Monthly_Investment__c from Order_Item__c where Change_Order__c=:recordId and Service_Check__c=true order by CreatedDate desc];
        return ois;
    }
        
    @AuraEnabled
    public static Change_Order__c createNewCO(String recordId, String name){
        Change_Order__c co = new Change_Order__c();
        co.Name = name;
        co.Installation__c = recordId;
        
        insert co;
        return co;
    }
    
    @AuraEnabled
    public static List<Product__c> getProducts(String recordId){
        // system.debug('______________o_______________  Esto se está poniendo raro');
        Change_Order__c co = [SELECT Installation__c FROM Change_Order__c where Id=:recordId];
        // system.debug(co);
        Installation__c i = [SELECT RecordType.Name FROM Installation__c where Id=:co.Installation__c];
        // system.debug(i.RecordType.Name);
        List<Product__c> ps=[select Id,Name,Sales_Price__c,Service__c from Product__c where active__c=true and Product_Type__c=:i.RecordType.Name and Service__c=false];
        // system.debug(i.RecordType.Name);
        // system.debug('______________o_______________ Esto se está poniendo raro');
        return ps;
    }
    
    @AuraEnabled
    public static List<Product__c> getServices(String recordId){
        Change_Order__c co = [SELECT Installation__c FROM Change_Order__c where Id=:recordId];
        Installation__c i = [SELECT RecordType.Name FROM Installation__c where Id=:co.Installation__c];
        List<Product__c> ps=[select Id,Name,Sales_Price__c,Service__c from Product__c where active__c=true and Product_Type__c=:i.RecordType.Name and Service__c=true];
        return ps;
    }
    
    @AuraEnabled
    public static String deleteChangeOrder(String recordId){
        Change_Order__c co = new Change_Order__c();
        co.Id = recordId;
        delete co;
        return recordId;
    }
    
    @AuraEnabled
    public static String deleteOrderItem(String recordId){
        Order_Item__c oi = new Order_Item__c();
        oi.Id = recordId;
        delete oi;
        return recordId;
    }
    @AuraEnabled
    public static List<Order_Item__c> updateOrderItem(List<Order_Item__c> recordToUpdate){
        update recordToUpdate;
        return recordToUpdate;
    }
    
    @AuraEnabled
    public static List<Order_Item__c> addProductsToCO(String recordId, String[] selectedOptions){
        List<Product__c> options = getProducts(recordId);
        List<Order_Item__c> ois = new List<Order_Item__c>();
        for(integer i = 0; i < selectedOptions.size(); i++){
            for(integer j = 0; i < options.size(); j++){
                if(selectedOptions[i] == options[j].Id){
                    Order_Item__c aux = new Order_Item__c();
                    aux.Name =  options[j].Name;
                    aux.Change_Order__c = recordId;
                    aux.Product_HS__c = options[j].Id;
                    aux.Price__c = options[j].Sales_Price__c != null ? options[j].Sales_Price__c : 0;
                    aux.Quantity__c = 1;
                    ois.add(aux);
                    break;
                } 
            }
        }
        insert ois;
        return ois;
    }
    @AuraEnabled
    public static List<Order_Item__c> addServicesToCO(String recordId, String[] selectedOptions,String frequency){
        List<Product__c> options = getServices(recordId);
        List<Order_Item__c> ois = new List<Order_Item__c>();
        for(integer i = 0; i < selectedOptions.size(); i++){
            for(integer j = 0; i < options.size(); j++){
                if(selectedOptions[i] == options[j].Id){
                    Order_Item__c aux = new Order_Item__c();
                    aux.Name =  options[j].Name;
                    aux.Change_Order__c = recordId;
                    
                    aux.Product_HS__c = options[j].Id;
                    aux.Monthly_Investment__c = options[j].Sales_Price__c != null ? options[j].Sales_Price__c : 0;
                    aux.Service_Check__c = true;
                    
                    if(frequency != ''){
                        aux.Billing_Frequency__c = frequency;
                    }
                   // Date actualDate=date.today();
                    DateTime actualDate=dateTime.now();
                    //aux.Bill_Start_Date__c = actualDate.addHours(7).addYears(1).addDays(-1).date();
                    aux.Bill_Start_Date__c = actualDate.addYears(1).date();
                    
                    ois.add(aux);
                    
                    //Name,Billing_Frequency__c,Bill_Start_Date__c,Monthly_Investment__c
                    break;
                } 
            }
        }
        insert ois;
        return ois;
    }
}