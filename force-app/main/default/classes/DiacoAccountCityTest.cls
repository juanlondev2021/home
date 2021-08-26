/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			City on Account
 * Class            DiacoAccountCity        
 * Test:            DiacoAccountCityTest
 * Description:		Relate a City record with the Account.
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		24/06/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/
@IsTest
public class DiacoAccountCityTest {
 
        @istest static void testAll(){

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


            Account acc = new Account();
                acc.FirstName = 'Test acc';
                acc.LastName  = 'last test';
                acc.City__c   =  'City';
                acc.County__c = 'test';
                insert acc;
            
            Account acc2 = new Account();
                acc2.FirstName = 'Test acc';
                acc2.LastName  = 'last test';
                acc2.City__c   =  'Test';
                acc2.County__c = 'test';
                insert acc2;
            
            Account acc3 = new Account();
                acc3.FirstName = 'Test acc';
                acc3.LastName  = 'last test';
                acc3.City__c   =  'Test2';
                acc3.County__c = 'test';
                insert acc3;
            
            Account acc5 = new Account();
                acc5.FirstName = 'Test acc';
                acc5.LastName  = 'last test';
                acc5.City__c   = 'test3';
                acc5.County__c = 'test';
                insert acc5;
            
       

            test.startTest();
            
        /*  List<String> params = new List<String> ();
            params.add(acc.Id);
            params.add(acc2.Id);
            params.add(acc3.Id);
            params.add(acc5.Id);
                
            DiacoAccountCity.accountWithCity(params);
        */

        DiacoAccountCity.param param = new DiacoAccountCity.param();
        param.city  = acc.City__c;
        param.accountId = acc.id;


        DiacoAccountCity.paramList(new List<DiacoAccountCity.param> {param});

            List<Account> accs = new List<Account> ();
            accs.add(acc);
            accs.add(acc2);
            accs.add(acc3);
            accs.add(acc5);
            
            List<City__c> cis = new List<City__c> ();
            cis.add(ci);
            cis.add(ci2);
            
            DiacoAccountCity.currentAccount(accs, cis, ci2.Id);
        
            test.stopTest();


        }
   	   
}