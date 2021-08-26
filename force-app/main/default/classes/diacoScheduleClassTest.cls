/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible for testing diacoScheduleClass class
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		04/09/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
public class diacoScheduleClassTest {
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
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DiacoSalesRabbitIntegrationCalloutMock());
            DateTime myDateTime = System.now();
            
            DateTime newDateTime2 = myDateTime.addMinutes(1);
            diacoScheduleClass m = new diacoScheduleClass();
            String title = 'job '+newDateTime2;
            String sch = '0 '+newDateTime2.minute()+' '+newDateTime2.hour()+' '+newDateTime2.day()+' '+newDateTime2.month()+' ?';
            String jobID = system.schedule(title, sch, m);
            
            System.debug('sch  : ' + sch );
            System.debug('today + 1 min : ' + newDateTime2 );
            Test.stopTest();
        }
    }
}