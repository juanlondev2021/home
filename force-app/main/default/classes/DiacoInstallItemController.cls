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
public class DiacoInstallItemController {
    @AuraEnabled
    public static List<Install_Item__c> getInstallItems(String recordId){
        List<Install_Item__c> ii = [select Id, Name, Bid_Amount__c, Invoiced_Amounts__c, Install_Item_Status__c, CreatedDate from Install_Item__c where Installation__c=:recordId order by CreatedDate desc];
        return ii;
    }
    
    @AuraEnabled
    public static String deleteInstallItem(String recordId){
        Install_Item__c co = new Install_Item__c();
        co.Id = recordId;
        delete co;
        return recordId;
    }
    
    @AuraEnabled
    public static List<Invoice__c> getInvoices(String recordId){
        List<Invoice__c> i = [select Id, Name, Bid_Amount__c, Invoiced_Amount__c,Invoice_Status__c, CreatedDate from Invoice__c where Install_Item__c=:recordId order by CreatedDate desc];
        return i;
    }
    
    @AuraEnabled
    public static String deleteInvoices(String recordId){
        Invoice__c co = new Invoice__c();
        co.Id = recordId;
        delete co;
        return recordId;
    }
    
    @AuraEnabled
    public static List<Invoice__c> updateInvoices(List<Invoice__c> recordToUpdate){
        update recordToUpdate;
        return recordToUpdate;
    }

}