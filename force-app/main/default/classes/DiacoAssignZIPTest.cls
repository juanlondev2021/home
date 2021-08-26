@isTest
public class DiacoAssignZIPTest {
    
    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA',
                                    zip__c='1111'));
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA',
                                    zip__c='0'));
        }
        insert accounts;
        List<Route__c> route = new List<Route__c>();
        route.add(new Route__c(
        	Name = 'Route 1'
        ));
        route.add(new Route__c(
        	Name = 'unknown'
        ));
        insert route;
        Region__c region = new Region__c();
        region.Name = 'Test';
        insert region;
        Branch__c branch = new Branch__c();
        branch.Name = 'Test';
        branch.Region_MD__c = region.Id;
        branch.Carrier_ID__c = 'test';
        insert branch;
        
        List<ZipCode__c> zips = new List<ZipCode__c>();
        zips.add( new ZipCode__c(
        	name = '1111',
            Route__c = route[0].Id,
            Branch__c = branch.Id
        ));
        zips.add( new ZipCode__c(
        	name = '0',
            Route__c = route[1].Id,
            Branch__c = branch.Id
        ));
        insert zips;
    }
    
    static testmethod void test() {        
        List<ZipCode__c> routeId = [select Id, Name, Route__c from ZipCode__c]; 
        DiacoAssignZIP di = new DiacoAssignZIP(10, routeId);
        Id batchId = Database.executeBatch(di);
    }

}