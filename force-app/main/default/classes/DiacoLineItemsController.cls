/**
* Diaco
* @author 			Álvaro Ortega href=<aovargas05@gmail.com>
* Project:			Change Order
* Description:		Component to create Line Items
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version	1.0		05/03/2020		Alvaro Ortega (AO)		Component.
* @version	1.0		16/10/2020		Fabian Pineda (FP)		Added shouldDisplayInstallerPointColumn method.
**/
public class DiacoLineItemsController {
    @AuraEnabled
    public static Boolean shouldDisplayInstallerPointColumn(String recordId) {
        Id profileId = UserInfo.getProfileId();

        List<Profile> profile = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1];

        List<Home_Services__c> hsResult = [SELECT RecordTypeId FROM Home_Services__c WHERE Id = :recordId LIMIT 1];
        
        if (hsResult != null && hsResult.size() > 0) {
            List<RecordType> rtResult = [SELECT Name FROM RecordType WHERE Id = :hsResult[0].RecordTypeId];

            return profile != null && profile.size() > 0 && profile[0].Name != null && !profile[0].Name.endsWith('Sales') && rtResult != null && rtResult.size() > 0 && rtResult[0].Name != null && rtResult[0].Name.contains('Home Automation');
        }

        return false;
    }

    @AuraEnabled
    public static List<Line_Item__c> getLineItems(String recordId){
        List<Line_Item__c> cos=[select Id, Name, Unit_Price__c, Total_Price__c,Installer_Points__c, Quantity__c,Product__c,Home_Service__c,Product__r.Subcategory__c
                                from Line_Item__c
                                where Home_Service__c = :recordId  and Service_Check__c = false
                                order by CreatedDate desc];
        return cos;
    }
    @AuraEnabled
    public static List<Line_Item__c> getLineItemsServices(String recordId){
        List<Line_Item__c> ois=[select Id, Name, Billing_Frequency__c, Bill_Start_Date__c, Monthly_Investment__c 
                                from Line_Item__c
                                where Home_Service__c = :recordId  and Service_Check__c = true
                                order by CreatedDate desc];
        return ois;
    }
    @AuraEnabled
    public static void updatePaymentItemsServices(String recordId,String newBillingFrecuency){
        List<Line_Item__c> listToUpdate=new List<Line_Item__c>();
        List<Line_Item__c> ois=[select Id, Name, Billing_Frequency__c, Bill_Start_Date__c, Monthly_Investment__c 
                                from Line_Item__c
                                where Home_Service__c = :recordId  and Service_Check__c = true
                                order by CreatedDate desc];
        for(Line_Item__c item:ois){
            listToUpdate.add(New Line_Item__c(id=item.Id,Billing_Frequency__c=newBillingFrecuency));
        }
        update listToUpdate;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> updateLineItems(List<Line_Item__c> recordToUpdate){
        update recordToUpdate;
        return recordToUpdate;
    }
    
    @AuraEnabled
    public static List<Product__c> getProducts(String recordId){
        Home_Services__c hs = [select Industry_Formula__c 
                               from Home_Services__c 
                               where Id = :recordId];
        String industryName = hs.Industry_Formula__c == 'Water Treatment' ? 'Water' : (hs.Industry_Formula__c == 'Pest Control' ? 'Pest' : hs.Industry_Formula__c);
            List<Product__c> ps = new List<Product__c>();
        ps = [select Id, Name, Sales_Price__c, Service__c, Subcategory__c 
                               from Product__c 
                               where active__c = true and Product_Type__c = :industryName and Service__c = false order by Index__C];
            /*if(industryName== 'Water'){
                ps = [select Id, Name, Sales_Price__c, Service__c, Subcategory__c 
                               from Product__c 
                               where active__c = true and Product_Type__c = :industryName and Service__c = false order by Index__C];
            }else{
                ps = [select Id, Name, Sales_Price__c, Service__c, Subcategory__c 
                               from Product__c 
                               where active__c = true and Product_Type__c = :industryName and Service__c = false order by Index__C];
            }*/
            
        return ps;
    }
    @AuraEnabled
    public static List<Product__c> getServices(String recordId){
        Home_Services__c hs = [select Industry_Formula__c 
                               from Home_Services__c 
                               where Id = :recordId];
        String industryName = hs.Industry_Formula__c == 'Water Treatment' ? 'Water' : (hs.Industry_Formula__c == 'Pest Control' ? 'Pest' : hs.Industry_Formula__c);
        List<Product__c> ps = [select Id, Name, Sales_Price__c, Service__c 
                               from Product__c 
                               where active__c = true and Product_Type__c = :industryName and Service__c = true];
        return ps;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> addProductsToHS(String recordId, String[] selectedOptions){
        List<Product__c> options = getProducts(recordId);
        List<Line_Item__c> ois = new List<Line_Item__c>();
        for(integer i = 0; i < selectedOptions.size(); i++){
            for(integer j = 0; i < options.size(); j++){
                if(selectedOptions[i] == options[j].Id){
                    Line_Item__c aux = new Line_Item__c();
                    aux.Name =  options[j].Name;
                    aux.Home_Service__c = recordId;
                    aux.Product__c = options[j].Id;
                    aux.Unit_Price__c = options[j].Sales_Price__c != null ? options[j].Sales_Price__c : 0;
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
    public static List<Line_Item__c> addServicesToHS(String recordId, String[] selectedOptions, 
                                                     String frequency){
        List<Product__c> options = getServices(recordId);
        List<Line_Item__c> ois = new List<Line_Item__c>();
        for(integer i = 0; i < selectedOptions.size(); i++){
            for(integer j = 0; i < options.size(); j++){
                if(selectedOptions[i] == options[j].Id){
                    Line_Item__c aux = new Line_Item__c();
                    aux.Name =  options[j].Name;
                    aux.Home_Service__c = recordId;
                    
                    aux.Product__c = options[j].Id;
                    aux.Monthly_Investment__c = options[j].Sales_Price__c != null ? options[j].Sales_Price__c : 0;
                    aux.Service_Check__c = true;
                    
                    if(frequency != ''){
                        aux.Billing_Frequency__c = frequency;
                    }
                   // Date actualDate=date.today();
                    DateTime actualDate = dateTime.now();
                    aux.Bill_Start_Date__c = actualDate.addMonths(1).date();
                    //aux.Bill_Start_Date__c = actualDate.addYears(1).date();
                    
                    ois.add(aux);
                    
                    //Name,Billing_Frequency__c,Bill_Start_Date__c,Monthly_Investment__c
                    break;
                } 
            }
        }
        insert ois;
        return ois;
    }
    
    @AuraEnabled
    public static String deleteLineItem(String recordId){
        Line_Item__c li = new Line_Item__c();
        li.Id = recordId;
        delete li;
        return recordId;
    }


}