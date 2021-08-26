@isTest
public class diacoRenderContractControllerTest {
    
    @isTest static void myTest() {
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
       // Acc.RecordTypeId ='012410000012NOKAA2'; //???
        Acc.Customer_1_DOB__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_DOB__c =  Date.newInstance(2018, 7, 3);
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        
        DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c s= new DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c();
        s.Name='test';
        s.DiacoAlarm__DiacoUsername__c='test';
        s.DiacoAlarm__DiacoPassword__c='test';
        insert s;
        
        DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c di=new DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c();
        di.Name='Test';
        di.DiacoAlarm__DiacoPassword__c='test';
        di.DiacoAlarm__DiacoUsername__c='test';
        insert di;
        
        
        DiacoAlarm__Diaco_Customer_Alarm__c customerAlarm =  new DiacoAlarm__Diaco_Customer_Alarm__c();
        customerAlarm.DiacoAlarm__DiacoFirstNameAddress__c='test';
        customerAlarm.DiacoAlarm__DiacoLastnameAddress__c='test';
        customerAlarm.DiacoAlarm__DiacoCustomerAccountEmail__c='test@test.test';
        customerAlarm.DiacoAlarm__DiacoDesiredLoginName__c='test';
        customerAlarm.Name='test';
        customerAlarm.DiacoAlarm__DiacoCountryIdAddressWithName__c='USA';
        customerAlarm.DiacoAlarm__DiacoCityAddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoStateAddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoZipCodeAddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoStreet1AddressWithName__c='test';
        customerAlarm.DiacoAlarm__DiacoInstallationTimeZone__c='Norte';
        customerAlarm.DiacoAlarm__DiacoSameContactAddress__c=true;
        customerAlarm.DiacoAlarm__DiacoPanelType__c='NX';
        customerAlarm.DiacoAlarm__DiacoModemSerialNumber__c='12345678910111213';
        customerAlarm.DiacoAlarm__DiacoCentralStationForwardingOption__c='Never';
        customerAlarm.DiacoAlarm__DiacoCustomerAccountPhone__c='12345678';
        customerAlarm.DiacoAlarm__DiacoCentralStationReceiverNumber__c='123456789101112';
        customerAlarm.DiacoAlarm__DiacoInstanceWebserviceCutomer__c=di.Id;
        customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c = 'Cancels;NotSet';
        customerAlarm.DiacoAlarm__DiacoAddOnFeatures__c = 'ProVideo;ProVideoPlus;TwoWayVoice;' +
             'LiftMasterIntegration;GarageDoors;WeatherToPanel;' +
             'SevereWeatherAlerts;ZWaveLocks;ZWaveThermostats;' +
             'ZWaveLights;DoorbellCameras';
        insert customerAlarm;
        
        DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c iwa = new DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c(
            Name='test',
            DiacoAlarm__DiacoUsername__c='test',
            DiacoAlarm__DiacoPassword__c='test'
        );
        insert iwa;
        
        DiacoAlarm__DiacoSiteContact__c dsc = new DiacoAlarm__DiacoSiteContact__c();
        dsc.Name = 'test';
        dsc.DiacoAlarm__DiacoCustomerAlarm__c = customerAlarm.Id;
        dsc.DiacoAlarm__DiacoKeyType__c = 'Site';
        dsc.DiacoAlarm__DiacoPhone__c = '7586645';
        insert dsc;   
        
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        //hs.RecordTypeId = '012410000013G9OAAU'; //????
        hs.ApptSetter__c = per.Id;
        hs.Communication_By__c = 'POTS;Digital';
        hs.Monthly_Security_Services__c = 'Monitoring;Service';
        hs.Alarm_com_Additional_Services__c = 'Weather to Panel;Severe Weather Alerts';
        hs.Customer_Alarm__c = customerAlarm.Id;
        insert hs;
        Product__c pro = new Product__c();
        pro.Name = 'test';
        pro.Product_Type__c = 'Water';
        pro.active__c = true;
        pro.Service__c = false;
        insert pro;
        
        Product__c pro2 = new Product__c();
        pro2.Name = 'test';
        pro2.Product_Type__c = 'Water';
        pro2.Service__c = true; 
        pro2.active__c = true;
        insert pro2;
        
        Line_Item__c li = new Line_Item__c();
        li.Name = 'test';
        li.Home_Service__c = hs.Id;
        li.Product__c = pro.Id;
        insert li;
        
        Line_Item__c li2 = new Line_Item__c();
        li2.Name = 'test';
        li2.Home_Service__c = hs.Id;
        li2.Product__c = pro2.Id;
        insert li2;
        
        Line_Item__c li3 = new Line_Item__c();
        li3.Name = 'test';
        li3.Home_Service__c = hs.Id;
        li3.Product__c = pro2.Id;
        insert li3;
        
        Id installationCompanyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Installation Company').getRecordTypeId();
        Account installationCompany = new Account(
            LastName='DEF',
          // 	RecordTypeId=installationCompanyRecordTypeId,
            Installation_Company__c = true
        );
        insert installationCompany;
        hs.Installation_Company__c = installationCompany.Id;
        update hs;
        
        Contact installationCompanyApplicationContact = new Contact(
          //  AccountId=installationCompany.Id,
            type__c='Application',
            LastName='ABC'
        );
        insert installationCompanyApplicationContact;
        
        Contact installationCompanyDesignContact = new Contact(
          //  AccountId=installationCompany.Id,
            type__c='Design',
            LastName='DEF'
        );
        insert installationCompanyDesignContact;
        
        Account nergyAccount = new Account(
            LastName = 'NERGY LLC',
        //   	RecordTypeId=installationCompanyRecordTypeId,
            Installation_Company__c = true
        );
        insert nergyAccount;
        
        Contact nergyApplicationContact = new Contact(
         //   AccountId=nergyAccount.Id,
            type__c='Application',
            LastName='GHI'
        );
        insert nergyApplicationContact;
        
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(hs);
        diacoRenderContractController drcc =  new diacoRenderContractController(sc);
        
        drcc.getHomeServiceInfo(hs.Id);
        System.assert(!drcc.alarmcomAdditionalServicesList.isEmpty());
        drcc.paymentMethodList(hs.Id, 'Payment Destination');
        drcc.getContacts();
        drcc.getLineItems(hs.Id, false);
        diacoRenderContractController.IsWeekendDay(System.today());
        drcc.getPMChecking();
        diacoRenderContractController.AddBusinessDays(System.today(), 5);
        drcc.getExpirationDate();
        drcc.getPickListValuesIntoList();
        drcc.getPickListValuesIntoListCommunication();
        drcc.getPickListValuesMonthlySecurity();
        drcc.getPickListValueAlarmcomAdditionalServices();
        drcc.getPickListValueAlarmCommunication();
       //s system.debug(drcc.getExpirationDate());
       RenderContractController rendercontractController= new RenderContractController(sc);
        
        //TEst signature in visualforce
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Account Signature',
            VersionData = Blob.valueOf('Test Data'),
            IsMajorVersion = true,
            PathOnClient = 'Test.png'
        );
        insert contentVersion;
        
        // A ContentDocument is created automatically after the above insert
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :contentVersion.Id LIMIT 1];
        contentDocument.Title = 'Account Signature';
        update contentDocument;
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            ContentDocumentId=contentDocument.Id,
            LinkedEntityId=installationCompany.Id
        );
        insert contentDocumentLink;
        
        // Dealer (Nergy) account signature test
        ContentVersion dealerContentVersion = new ContentVersion(
            Title = 'Account Signature',
            VersionData = Blob.valueOf('Test Data'),
            IsMajorVersion = true,
            PathOnClient = 'Test.png'
        );
        insert dealerContentVersion;
        
        // A ContentDocument is created automatically after the above insert
        ContentDocument dealerContentDocument = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :dealerContentVersion.Id LIMIT 1];
        dealerContentDocument.Title = 'Account Signature';
        update dealerContentDocument;
        
        ContentDocumentLink dealerContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId=dealerContentDocument.Id,
            LinkedEntityId=nergyAccount.Id
        );
        insert dealerContentDocumentLink;
        
        rendercontractController.getSignatureLink();
        rendercontractController.getDealerSignatureLink();
        rendercontractController.getContractEnd();
        rendercontractController.getFinanceInfo();
        
        test.stopTest();
    }
    
}