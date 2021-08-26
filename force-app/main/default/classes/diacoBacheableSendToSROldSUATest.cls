@isTest
public class diacoBacheableSendToSROldSUATest {
    
    
    static testmethod void test() {
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
            
            
            List<User_Address__c> UserAddress = new List<User_Address__c>();
            for(Integer i = 0; i < 5; i++){
                UserAddress.add(
                    new User_Address__c(
                        Email__c = 'test'+String.valueOf(i)+'@test.com',
                        Phone__c = '662778'+String.valueOf(i),
                        PersonMobilePhone__c= '301426336'+String.valueOf(i),
                        UserAccount__c = acc.Id,
                        Address__c = ads.Id,
                        Sales_Price__c = 30000 + (i + 1)
                    )
                );
            }
            insert UserAddress;
            Date today = Date.today();
            Date before = today.addDays(-Integer.valueOf('5'));
        
            list<User_Address__c> UserList = [select Id, name, status__c, UserAccount__c, sales_rabbit_leadId__c, Sales_Price__c, CreatedDate, knock_counter__c, CreatedById,
                                         fFirstName__c, fLastName__c, Phone__c, PersonMobilePhone__c, fAddress__c, fCity__c, fState__c, fzipCode__c, fEmail__c, Confirmation_Number__c,
                                         creationDate__c, deletionDate__c
                                from User_Address__c 
                                ];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DiacoSalesRabbitIntegrationCalloutMock());
            diacoBacheableSendToSROldSUserAddress dbstsroua = new diacoBacheableSendToSROldSUserAddress();
            dbstsroua.execute(null, UserList);
            dbstsroua.finish(null);
            dbstsroua.start(null);
            Test.stopTest();
            System.assertEquals(5, [select count() from User_Address__c]);
        }
        
        
    }
    
}