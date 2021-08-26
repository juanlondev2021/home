@isTest
private class KunnectScheduleSettingTest {
    @TestSetup
    static void makeData() {
        
        TestClassUtil.createAccount(1);

        Id accountID = [SELECT Id FROM Account LIMIT 1]?.Id;        

        List<User_Address__c> userAddress = new List<User_Address__c>();
        for (Integer i = 0; i < 10; i++) {
            userAddress.add(
                new User_Address__c(
                    //Address__c = address[j].id, 
                    UserAccount__c = accountID,
                    User_Address_Type__c = 'Primary Owner',
                    Active__c = true,
                    Respond_date__c = Date.Today().addDays(-1)
                    )            
                );
        }
        insert userAddress;

        for (Integer i = 0; i < 10; i++) {
            userAddress[i].Phone__c = '1234556770';
        }
        update userAddress;
    }
    @IsTest
        static void methodName(){
            
            Test.startTest();

            KunnectScheduleSetting setting = new KunnectScheduleSetting();
            setting.name = 'inboundUserAddress';
            setting.newUserAddress = true;
            setting.recordSize = 100;
            setting.nextRun = Datetime.now().addMinutes(70);

            setting.getInboundUserAddress();
            setting.getOutboundSourceUserAddress();
            setting.getOutboundGravelUserAddress();
            setting.sendEmail(20);

            string settingStr = KunnectScheduleSetting.createJson(setting);
            KunnectScheduleSetting.parse(settingStr);
            
            Test.stopTest();
            
        }
    }