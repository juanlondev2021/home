public class LineItemTriggerHelper {
    
    public static void taxFields(List<Line_Item__c> newList){
        List<Line_Item__c> liNews =new List<Line_Item__c>();
        for (Line_Item__c li : newList) {
            System.debug('Total sales '+ li.Total_Sales_Price_p__c);
            if(li.Product__c != null && li.Total_Sales_Price_p__c!=null &&
               li.Home_Service__c != null && (li.City_Tax_Rate__c!= null||li.County_Tax_Rate__c!= null)
               && li.Taxable__c){
                   System.debug(li);
                   li.City_Tax_Amount__c = li.Total_Sales_Price_p__c * li.City_Tax_Rate__c ;
                   li.County_Tax_Amount__c = li.Total_Sales_Price_p__c * li.County_Tax_Rate__c ;
                   liNews.add(li);
                   System.debug(li.City_Tax_Amount__c+ ', '+li.County_Tax_Amount__c);
               }
        }
    }
    
}