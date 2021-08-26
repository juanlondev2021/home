@isTest
public class DiacoAssignRouteZipTest {
    
    @isTest 
    static void setup() {
        
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
        	name = '11111',
            Route__c = route[0].Id,
            Branch__c = branch.Id
        ));
        zips.add( new ZipCode__c(
        	name = 'unknown',
            Route__c = route[1].Id,
            Branch__c = branch.Id
        ));
        insert zips;
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA'));
        }
        accounts.add(new Account(name='Account 10', 
                billingcity='New York', billingcountry='USA',Zip__c='11111'));
        insert accounts;
        List<DiacoAssignRouteZip.param> params = new List<DiacoAssignRouteZip.param>();
        //List<param> accountsId = new List<param>();
        for(Account acc : accounts){
            DiacoAssignRouteZip.param param = new DiacoAssignRouteZip.param();  
           	param.Id=acc.Id;
            param.Route=acc.Route__c;
            param.Zip=acc.Zip__c;
            params.add(param);
        }
        Test.startTest();
        DiacoAssignRouteZip.ConnectWebformAccount(params);
        Test.stopTest();
    }

}