/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			County on Account
 * Class            DiacoAccountCounty        
 * Test:            DiacoAccountCountyTest
 * Description:		Relate a County record with the Account.
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		24/06/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/

@IsTest
public class DiacoAccountCountyTest {
 
        @istest static void testAll(){

            List<Route__c> route = new List<Route__c>();
            route.add(new Route__c(
                Name = 'Route 1'
            ));
            route.add(new Route__c(
                Name = 'unknown'
            ));
            insert route;

            Region__c region = new Region__c();
            region.Name      = 'Test';
            insert region;

            Branch__c branch     = new Branch__c();
            branch.Name          = 'Test';
            branch.Region_MD__c  = region.Id;
            branch.Carrier_ID__c = 'test';
            insert branch;

            List<ZipCode__c> zips = new List<ZipCode__c>();
            zips.add( new ZipCode__c(
                name      = '1111',
                Route__c  = route[0].Id,
                Branch__c = branch.Id
            ));

            zips.add( new ZipCode__c(
                name      = 'unknown',
                Route__c  = route[1].Id,
                Branch__c = branch.Id
            ));

            insert zips;

            City__c ci = new City__c();
                ci.Name       = 'City';
                insert ci;
            
            City__c ci2 = new City__c();
                ci2.Name       = 'Unknown';
                insert ci2;

            County__c c = new County__c();
                c.County_Name__c = 'City';
                insert c;
            
            County__c c2 = new County__c();
                c2.County_Name__c = 'Unknown';
                insert c2;

            webForm__c w = new webForm__c();
                w.Name = 'Unknown';
                insert w;
       
            Account acc = new Account();
                acc.FirstName = 'Test acc';
                acc.LastName  = 'last test';
                acc.City__c   =  'City';
                acc.County__c = 'test';
                acc.Web_Form__c = w.id;
                acc.Route__c = route[0].id;
                insert acc;
            
            Account acc2 = new Account();
                acc2.FirstName = 'Test acc';
                acc2.LastName  = 'last test';
                acc2.City__c   =  'Test';
                acc2.County__c = 'test';
                acc.Web_Form__c = w.id;
               acc.Route__c = route[0].id;
                insert acc2;
            
            Account acc3 = new Account();
                acc3.FirstName = 'Test acc';
                acc3.LastName  = 'last test';
                acc3.City__c   =  'Test2';
                acc3.County__c = 'test';
                acc.Web_Form__c = w.id;
                acc.Route__c = route[0].id;
                insert acc3;
            
            Account acc5 = new Account();
                acc5.FirstName = 'Test acc';
                acc5.LastName  = 'last test';
                acc5.City__c   = 'test3';
                acc5.County__c = 'test';
                acc.Web_Form__c = w.id;
                acc.Route__c = route[0].id;
                insert acc5;
            
       

            test.startTest();
            
        /*  List<String> params = new List<String> ();
            params.add(acc.Id);
            params.add(acc2.Id);
            params.add(acc3.Id);
            params.add(acc5.Id);
                
            DiacoAccountCounty.accountWithCounty(params); 
        */
            DiacoAccountCounty.param param = new DiacoAccountCounty.param();
            param.countyId  = acc.County__c;
            param.accountId = acc.id;


            DiacoAccountCounty.paramList(new List<DiacoAccountCounty.param> {param});

            List<Account> accs = new List<Account> ();
            accs.add(acc);
            accs.add(acc2);
            accs.add(acc3);
            accs.add(acc5);
            
            List<County__c> counties = new List<County__c> ();
            counties.add(c);
            counties.add(c2);
            
            DiacoAccountCounty.currentAccount(accs, counties, c2.Id);
        
            test.stopTest();


        }
   	   
}