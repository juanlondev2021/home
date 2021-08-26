/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible for testing diacoSettingPageSalesRabbitController class
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		04/09/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
public class diacoSPSalesRabbitControllerTest {
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
            salesRabbitSchedule__c scd = new salesRabbitSchedule__c(
                quantityDayOrHour__c = 2.0, 
                options__c = 'months', 
                last_update__c = Date.today(),
                knockCounter__c  = 2
            );
            
            upsert scd;                   
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DiacoSalesRabbitIntegrationCalloutMock());
            diacoSettingPageSalesRabbitController dspsrc = new diacoSettingPageSalesRabbitController();
            dspsrc.getOptions();
            dspsrc.Assignjob(2.0, 'hours');
            dspsrc.minSalePrice = '20000';
            dspsrc.maxSalePrice = '100000';
            dspsrc.deleteAfter = '2';
            dspsrc.deleteAfterOptions = 'days';
            dspsrc.updateSchedule();
            dspsrc.getOptionsDelete();
            Test.stopTest();
        }
    }

}