/*
* Diaco
* @author 			Álvaro Ortega href=<aovargas05@gmail.com>
* Project:			To Windows
* Description:		Component to manage Products and Line Item on Window Industry
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version	1.0		20/12/2019		Alvaro Ortega (AO)		Component.
*/

public class DiacoWindowLineItemController {
    /*@AuraEnabled
public static List<Decimal> getCustomSetting(){
Job_Costing_Settings__c jc = Job_Costing_Settings__c.getOrgDefaults();
List<Decimal> rt = new List<Decimal>();
rt.add(jc.Dealer_Number__c);
rt.add(jc.Retail_Multiplier__c);

return rt;
}*/
    @AuraEnabled
    public static List<String> getPicklistProductType(){
        /*List<String> ignored = new List<String>();
ignored.add('Carpet & Tile Cleaning');
ignored.add('Electric');
ignored.add('Garage Door');
ignored.add('Internet-Cable-Satellite');
ignored.add('Landscape Maintenance');
ignored.add('Lock Smith');
ignored.add('Maid Service');
ignored.add('Misc');
ignored.add('Pool Install');
ignored.add('Pool Maintenance');
ignored.add('Security Doors');
ignored.add('Weed Removal');
ignored.add('Window');*/
        
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Product__c.Remodel_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        
        /*for( Schema.PicklistEntry pickListVal : ple){
boolean aux = false;
for(String ing: ignored){
if(ing == pickListVal.getLabel()){
aux = true;
break;
}
}
if(!aux){
pickListValuesList.add(pickListVal.getLabel());
}
}  */   
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static List<Decimal> getInfoFromHS(string recordId){
        Home_Services__c hs = [SELECT Id,Dealer_Number__c, Retail_Multiplier__c FROM Home_Services__c where Id=:recordId];
        List<Decimal> rt = new List<Decimal>();
        rt.add(hs.Dealer_Number__c);
        rt.add(hs.Retail_Multiplier__c);
        
        if(hs.Dealer_Number__c == null || hs.Retail_Multiplier__c == null){
            hs.Dealer_Number__c = hs.Dealer_Number__c == null ? 0.0 : hs.Dealer_Number__c ;
            hs.Retail_Multiplier__c = hs.Retail_Multiplier__c == null ? 1 : hs.Retail_Multiplier__c;
            
            update hs;
        }
        
        /*system.debug('------------------------------------------------------@@@@---------------------------------------------------');
system.debug(hs.Dealer_Number__c);
system.debug(hs.Retail_Multiplier__c);
system.debug('------------------------------------------------------@@@@---------------------------------------------------');*/
        
        return rt;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> updateHSLineItem(String recordId){
        List<Line_Item__c> lis = [select Id, Quantity__c, Unit_Price__c, Total_Sales_Price_p__c, Home_Service__r.Retail_Multiplier__c
                                  from Line_Item__c 
                                  where Home_Service__c=:recordId];
        for(integer i = 0; i < lis.size(); i++){
            //aux.Total_Sales_Price_p__c = aux.Quantity__c * aux.Unit_Price__c * multiplier
            lis[i].Total_Sales_Price_p__c = lis[i].Quantity__c * lis[i].Unit_Price__c * lis[i].Home_Service__r.Retail_Multiplier__c;
        }
        update lis;
        return lis;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> updateLineItem(List<Line_Item__c> recordToUpdate){
        update recordToUpdate;
        return recordToUpdate;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> getWindowsLineItems(String recordId){
        List<Line_Item__c> lis = [select Product__r.Remodel_Category__c, Latch_Suggested_Retail_w_Install__c , Latch_Suggested_Retail_w_Install_Fee__c 
                                  from Line_Item__c 
                                  where Home_Service__c=:recordId and Product__c!=null];
        return lis;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> getWindowsLineItemsCategory(String recordId, String category){
        List<Line_Item__c> lis = [select Name, Latch_UOM__c, Quantity__c, Latch_Suggested_Retail_w_Install__c, Latch_Suggested_Retail_w_Install_Fee__c, Unit_Price__c, Product__r.Unit_Total_Cost__c
                                  from Line_Item__c 
                                  where Home_Service__c =:recordId and Product__r.Remodel_Category__c =:category
                                  order by CreatedDate desc ];
        return lis;
    }
    
    public static List<SObject> slice(List<SObject> input, Integer ge, Integer l){
        List<Product__c> output = input.clone();
        for (Integer i = 0; i < ge; i++) output.remove(0);
        Integer elements = l - ge;
        while (output.size() > elements) output.remove(elements);
        return output;
    }
    
    @AuraEnabled
    public static List<Product__c> getProducts(String recordId, String category){
        Home_Services__c hs = [SELECT Industry_Formula__c 
                               FROM Home_Services__c 
                               where Id=:recordId];
        List<Product__c> ps1 = [select Id, Name, Sales_Price__c, Service__c,Unit_Total_Cost__c
                                from Product__c 
                                where active__c=true and Service__c=false and Remodel_Category__c=:category
                                and (Name like '0%' or Name like '1%' or Name like '2%' or Name like '3%' or Name like '4%' or Name like '5%'
                                     or Name like '6%' or Name like '7%' or Name like '8%' or Name like '9%')
                                order by Name];
        
        List<Product__c> ps2 = [select Id, Name, Sales_Price__c, Service__c,Unit_Total_Cost__c
                                from Product__c 
                                where active__c=true and Service__c=false and Remodel_Category__c=:category
                                and (NOT Name like '0%') and (NOT Name like '1%') and (NOT Name like '2%') and (NOT Name like '3%') and (NOT Name like '4%') 
                                and (NOT Name like '5%') and (NOT Name like '6%') and (NOT Name like '7%') and (NOT Name like '8%') and (NOT Name like '9%')
                                order by Name];
        List<Product__c> ps = new List<Product__c>();
        ps.addAll(ps2);
        ps.addAll(ps1);
        
        return ps;
    }
    
    @AuraEnabled
    public static List<Line_Item__c> addProductsToHS(String recordId, List<SObject> selectedOptions, String category, Decimal multiplier){
        try {
            //system.debug('___________________________________________________________________');
            //system.debug('Entra para agregar: '+selectedOptions);
            List<Product__c> options = getProducts(recordId, category);
            List<Line_Item__c> ois = new List<Line_Item__c>();
            
            for(integer i = 0; i < selectedOptions.size(); i++){
                //system.debug('Primer for: '+selectedOptions[i].Id);
                for(integer j = 0; i < options.size(); j++){
                    //system.debug('Segundo for: '+options[j].Id);
                    if(selectedOptions[i].Id == options[j].Id){
                        system.debug('Entra al IF');
                        Line_Item__c aux = new Line_Item__c();
                        aux.Name =  options[j].Name;
                        aux.Home_Service__c = recordId;
                        aux.Product__c = options[j].Id;
                        aux.Unit_Price__c = options[j].Sales_Price__c != null && options[j].Sales_Price__c != 0? options[j].Sales_Price__c : options[j].Unit_Total_Cost__c;
                        //aux.Price__c = options[j].Sales_Price__c != null ? options[j].Sales_Price__c : 0;
                        aux.Quantity__c = 1;
                        //ois[i].Quantity__c * (ois[i].Unit_Price__c)
                        aux.Total_Sales_Price_p__c = aux.Quantity__c * aux.Unit_Price__c * multiplier;
                        //aux.Latch_Category__c = category;
                        ois.add(aux);
                        system.debug('Todo bien despues de entrar al IF');
                        break;
                    } 
                }
            }
            insert ois;
            System.debug('Todo bien al crear');
            system.debug('___________________________________________________________________');
            return ois;
        } catch(Exception e) {
            System.debug('@--->' + e);
            return null;
        }
        
    }
    
    @AuraEnabled
    public static String deleteLineItem(String recordId){
        Line_Item__c oi = new Line_Item__c();
        oi.Id = recordId;
        delete oi;
        return recordId;
    }
}