/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible for testing DiacoSalesRabbitIntegrationc class
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		04/09/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
public class DiacoSalesRabbitIntegrationTest {
    @isTest static void Test() {
        
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User user = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        insert user;
        
        
        
        
        
        System.runAs ( user ) {
            Personnel__c personnel = new Personnel__c(
                    Name = 'tst',
                    Kunnect_ID__c = 'none',
                    salesRabbitUserId__c = '911705138',
                	SF_User__c = user.Id
            );
            insert personnel;
            salesRabbitSchedule__c customsetting = new salesRabbitSchedule__c(
                    quantityDayOrHour__c = 2,
                    options__c = 'hours',
                    knockCounter__c = 5,
                    deleteAfter__c = 5,
                    minSalePrice__c = 20000,
                    maxSalePrice__c = 100000,
                    deleteAfterOptions__c = 'days',
                	token__c = 'T3ok8e9nt7e4s1t1'
            );
            upsert customsetting;
            Account acc = new Account(
                FirstName ='test',
                LastName = 'test',
                Phone = '6643433',
                PersonMobilePhone = '1234567890',
                Street__c = 'cll 43',
                State__c = 'CO',
                City__c = 'cartagena',
                Zip__c  = '12345'
            );
            insert acc;
            Address__c ads = new Address__c(
                City__c = 'cartagena',
                Country__c = 'US',
                State__c = 'CO',
                Street__c = 'test',
                Zip_Code__c = '12352'
            );
            insert ads;
            User_Address__c uadd = new User_Address__c(
                Email__c = 'test@test.com',
                Phone__c = '6627786',
                status__c ='Other',
                knock_counter__c = 4,
                PersonMobilePhone__c= '3014263364',
                UserAccount__c = acc.Id,
                Address__c = ads.Id,
                sales_rabbit_leadId__c = '85',
                Sales_Price__c = 50000
            );
            insert uadd;
            User_Address__c uadd2 = new User_Address__c(
                Email__c = 'test@test.com',
                Phone__c = '6627786',
                status__c ='Other',
                knock_counter__c = 3,
                PersonMobilePhone__c= '3014263364',
                UserAccount__c = acc.Id,
                Address__c = ads.Id,
                sales_rabbit_leadId__c = '85',
                Sales_Price__c = 50000
            );
            insert uadd2;
            neverBounce__c nb = new neverBounce__c(
                Job_id__c = '277461',
                number_of_pages__c = 10,
                next_page__c = 1, 
                ApiKey__c = 'Apikey******', 
                First_Job__c = 3, 
                Second_Job__c =1, 
                Emails_per_page__c = 10 
            );
            upsert nb;
            

            String token = 'e9d241343edfbe085176aeae2661282c8cb8e62490ff5b09563dddf22523158ed53b2142cd9e4f3d551c375b6489eaebac663f7eca480dd002c4c44fc357c307'; 
            String body = '{"data": {"userId":911705138,"firstName":"jorge test","lastName":"martinez","phonePrimary":"6627786","phoneAlternate":"(301) 426-3364","street1":"la candelaria","city":"cartagena","state":"AR","zip":"523621","status":"New Lead","email":"test@test.com"}}';
            Date ifModifiedSince = Date.newInstance(2018, 08, 07);
            Test.startTest();
            Integer leadId = 85;
            Test.setMock(HttpCalloutMock.class, new DiacoSalesRabbitIntegrationCalloutMock());
            DiacoSalesRabbitIntegration.leadsToUpdate(
                DiacoSalesRabbitIntegration.allLeads(token, ifModifiedSince)
            );
            DiacoSalesRabbitIntegration.createLeadSR(token, body, uadd.Id);
            DiacoSalesRabbitIntegration.createLeads(token, body);
            DiacoSalesRabbitIntegration.dateStmap('2018-08-16T17:51:02+00:00');
            DiacoSalesRabbitIntegration.allLeadsSR(token, ifModifiedSince);
            DiacoSalesRabbitIntegration.deleteLead(token, leadId);
            Test.stopTest();
            
        }
    }
}