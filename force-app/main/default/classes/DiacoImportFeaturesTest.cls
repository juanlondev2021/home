/*

 Diaco
 @author 			Jeison Hernandez Sanchez  href=<jeison14.99@gmail.com>
 Project:			Jitterbit Replacement
 Description:		Support the account import process
     
 Changes (Version)
 _________________________________________

            No.		Date			Author					Description
            ____	__________      ____________________    _____________________________________
@version	1.0		07/10/2019		Jeison Hernandez (JH)	Initial implementation  of the class.
*/
@isTest
public class DiacoImportFeaturesTest {
    @TestSetup
    static void setup(){
        String s = '"Hometype","Rental","New","SalePrice","Down","Firstname","Lastname","phone","address","city","state","plus4","zip","DATE","PostDate","Update","County","FileNumber","BMPS"\n'+
        '"SF",,,510000.00,288329.00,"OMAR","GASTELUM COTA",,"6303 N 65TH DR","GLENDALE","AZ","4315","85301","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359061","14415011"\n'+
        '"SF",,"N",342990.00,10289.00,"PETER & CAROL","VALENTINO",,"2727 W APOLLO RD","PHOENIX","AZ","5486","85041","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359063","10592048"\n'+
        '"SF",,,364000.00,36400.00,"MARGARET","JOHNSON",,"3813 E PARK AVE","PHOENIX","AZ","8255","85044","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359070","30601625"\n'+
        '"CT",,,265000.00,105000.00,"KEITH & KIMBERLY","EWING",,"2101 S YELLOW WOOD UNIT 14","MESA","AZ","1486","85209","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359072","31212008"\n'+
        '"SF",,,650000.00,154000.00,"MICHAEL","ALLEN",,"26250 N 46TH ST","PHOENIX","AZ","8510","85050","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359082","21209227"\n'+
        '"SF",,"N",469699.00,23485.00,"ARIEL & TROY","AUELUA",,"4706 S MARS","MESA","AZ","3270","85212","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359089","31216546"\n'+
        '"SF",,,610000.00,610000.00,"PAUL","INDELICATO",,"8212 E SHERIDAN ST","SCOTTSDALE","AZ","2344","85257","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359156","13133059"\n'+
        '"SF",,,585000.00,58500.00,"BRIAN & LAUREN","WEST",,"2481 E BELLERIVE PL","CHANDLER","AZ","4142","85249","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359164","30356382"';
        String contractName = 'test document 3';
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.PathOnClient = '.csv';
        //cv.OwnerId = at.OwnerId;
        cv.Title = contractName;
        cv.VersionData = blob.valueOf(s);
        insert cv;
        Hung_Status_Setting__c af = new Hung_Status_Setting__c(Name='Hung',Buffer_Days__c=26,Days_Until_Next_Delivery__c=7);
        insert af;
        diaco__diacoSlackApp__c app = new diaco__diacoSlackApp__c(
                Name = label.InternalAppSlackName,
                diaco__tokenApp__c = 'xoxa-408782345031-419122738544-419859988770-6b6f61c477d9067446e812035c7d14ac',
                diaco__byDefault__c = true
        );
        insert app;

        diaco__diacoSlackChat__c channelsapp = new diaco__diacoSlackChat__c(
                Name = 'testChannel',
                diaco__channelId__c ='CBZMYR96E',
                diaco__Slack_App__c = app.Id,
                diaco__members__c = 'UBZMYR69G,UBZMYR69G'
        );
        insert channelsapp;
        diaco__diacoSlackUser__c slackUser = new diaco__diacoSlackUser__c(
                name = 'test',
                diaco__slackUserId__c = 'UBZMYR69G',
                diaco__Slack_App__c = app.Id
        );
        insert slackUser;
        diaco__diacoSlackUser__c slackUser2 = new diaco__diacoSlackUser__c(
                name = 'test',
                diaco__slackUserId__c = 'UBZN1GYPL',
                diaco__Slack_App__c = app.Id
        );
        insert slackUser2;
    }

    @isTest
    static void importTest() {
        List<Account> Accts = new List<Account>();
        List<Address__c> Address = new List<Address__c>();
        List<User_Address__c> Uaddress = new List<User_Address__c>();
        String contractName = 'test document 3';
        string contentDocumentId;
        ContentVersion[] contentV= [select ContentDocumentId FROM ContentVersion WHERE Title = :contractName];
        if(contentV.size() > 0) {
            contentDocumentId = contentV[0].ContentDocumentId;
            System.debug(contentDocumentId);
        }
        List<DiacoImportFeatures.csvRecord> csvs = new List<DiacoImportFeatures.csvRecord>();
        Test.setMock(HttpCalloutMock.class, new DiacoImportFeaturesMockTest());
        Test.startTest();
        csvs = DiacoImportFeatures.GetCsvData(contentDocumentId);
        if(!csvs.isEmpty()){
        	System.assert(8==csvs.size());
        }
        for (DiacoImportFeatures.csvRecord item:csvs){
        	Account account = new Account(
                FirstName=item.Firstname, LastName=item.Lastname, 
                City__c=item.city, County__c= item.County, Down_Payment__c=item.Down,
                FileNumber__c=item.FileNumber, Home_Type__c=item.Hometype, New__c= (item.iNew=='N'?true:false),
                Recording_Date__c=item.iDATE,Sales_Price__c=item.SalePrice, State__c=item.state, 
                Street__c=item.address, Zip__c= item.zip
            );
            Accts.add(account);
            Address__c address1 = new Address__c(
                City__c=item.city,County__c=item.County, Data_Provider__c= 'ION',
                FileNumber__c=item.FileNumber, Home_Type__c= item.Hometype,
                State__c=item.state, Street__c=item.address, Zip_Code__c=item.zip
            );
            Address.add(address1);
            User_Address__c uaddress1 = new User_Address__c(
                Active__c=true,Data_Provider_ID__c='ION',Down_Payment__c=item.Down,FileNumber__c=item.FileNumber,
                New__c=(item.iNew=='N'?true:false),Recording_Date__c=item.iDATE,Sales_Price__c=item.SalePrice,
                Start_Date__c=item.iDATE,User_Address_Type__c='Primary Owner'
            );
            Uaddress.add(uaddress1);
        }

        DiacoImportFeatures.recordsInsert(Accts,Address,Uaddress,true);
        DiacoImportFeaturesSchedule p = new DiacoImportFeaturesSchedule();
        Datetime tem = Datetime.now().addSeconds(10);
        String cron = tem.second()+' '+tem.minute()+' '+tem.hour()+' '+tem.day()+' '+tem.month()+' ?';
        system.schedule('Import test', cron, p);
        //DiacoImportFeatures.createDeliveries();
        Test.stopTest();
        List<Account> re = [Select Id,Name from Account where New__c=true order by Name];
        System.assert(2==re.size());
    }
}