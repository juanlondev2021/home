@isTest
public class LineItemTriggerTest {
    @testSetup 
    static void setup() {
        Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel',
            Kunnect_ID__c = 'test'

        );
        insert person;
        County__c county = new County__c(
            County_Name__c = 'Test',
            State__c = 'AZ',
            Tax_Rate__c = 90
        );
        insert county;
        City__c city = new City__c(
            Name = 'Test',
            Tax_Rate__c = 9
        );
        insert city;
        Account account = new Account(
                FirstName = 'Test acc',
                LastName = 'last test',
                
                Street__c = 'test',
                City__c = 'test',
                Zip__c = '12345',
                State__c = 'AZ',
                County_Lookup__c= county.Id,
                City_lookup__c = city.Id
            );
        insert account;
        Home_Services__c hs = new Home_Services__c(
                Name = 'test',
                Account__c = account.Id,
                ApptSetter__c = person.Id,
                Home_services_Status__c = '',
                Event_Count__c = 0,
                Installation__c = null,
                Service__c = null
             
            );
        insert hs;
        List<Product__c> products = new List<Product__c>();
        for (Integer i = 0; i < 15; i++) {
            products.add(new Product__c(
                Name = 'Test',
                Product_Type__c = 'Water',
                active__c = true,
                Service__c = false,
                Taxable__c = true
            ));
        }
        insert products;
    }

    static testmethod void test() {  
        List<Product__c> products = [Select Id from Product__c];
        Home_Services__c hs = [select Id from Home_Services__c limit 1];
        List<Line_Item__c> ltUpdate = new List<Line_Item__c>(); 
        for (Product__c product : products) {
            ltUpdate.add(new Line_Item__c(
                Name = 'test',
                Home_Service__c = hs.Id,
                Product__c = product.Id,
                Quantity__c = 8,
                Unit_Price__c = 900,
                Total_Sales_Price_p__c = 7500
            ));
        }
        insert ltUpdate;
        test.startTest();
        
        for (Integer i = 0; i < ltUpdate.size(); i++) {
            ltUpdate[i].Name ='Test '+i;
        }
        update ltUpdate;
        test.stopTest();
    }
}