/**
* Diaco
* @author 			Kevin Vega Hernandez href=<kevin.vega.h@hotmail.com>
* Project:			Finance Component
* Description:		Migrate the Finance Component from SFI Org to Home Service Org .
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						 Description
*			-----	----------		--------------------		 ---------------
* @version	1.0		30/06/2020		Kevin Vega Hernandez (KVH)	 Migrate the Finance Component from SFI Org to Home Service Org. 
**/

@isTest
public class DiacoFinanceClassTest {
    	
/*    @isTest static void SetupAll() {
        
        ddsign__DiacoSign_Account__c dacc = new ddsign__DiacoSign_Account__c(Name='Test',ddsign__Type__c='Live',ddsign__API_Account_ID__c='test Apy');
        insert dacc;
        ddsign__DiacoSign_User__c duser = new ddsign__DiacoSign_User__c(Name='Pinnacle Finance',ddsign__Username__c='test@test.com',ddsign__IntegratorKey__c='test',
                                                                        ddsign__DiacoSign_Account__c=dacc.Id,ddsign__Password__c='pasww');
        insert duser;
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.Exp_Date__c = '7/24';
        hs.Name='test test test test';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        Event event = new Event(
            Home_Service__c = hs.Id,
            RecordTypeId = '012410000013G9CAAU',
            DurationInMinutes=1,
            WhatId = hs.Id,
            ActivityDateTime= Date.Today()
        );
        insert event;
        PaymentMethod__c PayM = new PaymentMethod__c(HomeService__c=hs.Id,PaymentMethodType__c='ACH');
        insert PayM;
        
        Finance__c FinancePackage = new Finance__c();
        FinancePackage.name = 'Package A';
        Finance__c fPackage = DiacoFinanceClass.create_update_Finance_package(FinancePackage);
        DiacoFinanceClass.delete_Finance_package(fPackage.Id);
        
        DiacoFinanceClass.getInfo_Finance_package();
        DiacoFinanceClass.getInfo_Finance(hs.Id);
        DiacoFinanceClass.setInfo_Finance(hs.Id,0.0,0.0,fPackage.name,'Finance',0.0,0.0,true,0.0);
        DiacoFinanceClass.setInHouse(hs.Id,true);
        
        DiacoFinanceClass.getInfo_Finance(event.Id);
        DiacoFinanceClass.getInfo_Finance(event.Id);
        DiacoFinanceClass.setInfo_Finance(event.Id,0.0,0.0,fPackage.name,'Finance',0.0,0.0,true,0.0);
        DiacoFinanceClass.setInHouse(event.Id,true);
        
        DiacoFinanceClass.getRecordTypeFromHS(hs.Id);
        DiacoFinanceClass.thereAreSigned(hs.Id);
        DiacoFinanceClass.sendToDocusign(hs.Id);
        
        
        
    }
  */ 
    
    
    
    @isTest
    static void testContract(){
        ddsign__DiacoSign_Account__c dacc = new ddsign__DiacoSign_Account__c(
            Name='Test',ddsign__Type__c='Live',ddsign__API_Account_ID__c='test Apy'
        );
        insert dacc;
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Id devRecordTypeId = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Home Automation Sales').getRecordTypeId();
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.Exp_Date__c = '7/24';
        hs.Name='test1';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        DiacoFinanceClass.getAlarmField(hs.Id);
        Event event = new Event(
            Home_Service__c = hs.Id,
            RecordTypeId = '012410000013G9CAAU',
            DurationInMinutes=1,
            WhatId = hs.Id,
            ActivityDateTime= Date.Today()
        );
      //  insert event;
        
        PaymentMethod__c PayM = new PaymentMethod__c(HomeService__c=hs.Id,PaymentMethodType__c='ACH',Bank_Account_Name__c='Test OK 1');
        insert PayM;
        
        Finance_Package__c pack = new Finance_Package__c(Name=hs.Id,Payment_Number__c=96,type__c='purchase',APR__c=12.99,
                                                        Purchase__c=123,Payment_Factor__c=0.016802,Monthly_Renewal_PURCHASE__c=12,
                                                        Monthly_Renewal_LEASE__c=1,Monthly_Term_PURCHASE__c=123,Monthly_Term_LEASE__c=1235,
                                                        Monthly_Payment_PURCHASE__c=1352,Monthly_Payment_LEASE__c=58,Monitoring__c=53,
                                                        Equipment_Min_Payment__c=63,X12_Months_Same_As_Cash__c=true,Total_Min_Payments__c=123,
                                                        Activation_Emergency_Video_PURCHASE__c=12,Activation_Emergency_Video_LEASE__c=12);
        insert pack;
        DiacoFinance2Class.sendToDocusign(hs.Id);
        ddsign__DiacoSign_User__c duser = new ddsign__DiacoSign_User__c(
            Name='Pinnacle Finance',ddsign__Username__c='scott@pinnaclefinance.com',ddsign__IntegratorKey__c='test',
            ddsign__DiacoSign_Account__c=dacc.Id,ddsign__Password__c='pasww'
        );
        insert duser;
        ddsign__Pre_Designed_Envelope__c Pevn = new ddsign__Pre_Designed_Envelope__c(
            Name='Pinnacle Contract',ddsign__DiacoSign_User__c=duser.Id
        );
        insert Pevn;
        
        DiacoFinance2Class.getRecordTypeFromHS(hs.Id);
        DiacoFinance2Class.thereAreSigned(hs.Id);
        DiacoFinance2Class.sendToDocusign(hs.Id);
        DiacoFinance2Class.getAlarmField(hs.Id);
        
        
         DiacoFinance2Class.getInfo_Finance_HS(hs.Id);
        DiacoFinance2Class.getInfo_Finance_HS(null);
        
        Finance_Package__c finance = new Finance_Package__c(Name='Default',
                                             X12_Months_Same_As_Cash__c =true,
                                             Activation_Emergency_Video_LEASE__c=0.0,
                                             Activation_Emergency_Video_PURCHASE__c=0.0,
                                             Customer_Owned_LEASE__c=true,
                                             Customer_Owned_PURCHASE__c=true,
                                             Equipment_Min_Payment__c=0.0,
                                             Monitoring__c=0.0,
                                             Monthly_Payment_LEASE__c=12,
                                             Monthly_Payment_PURCHASE__c=12,
                                             Monthly_Renewal_LEASE__c=10,
                                             Monthly_Renewal_PURCHASE__c=10,
                                             Monthly_Term_LEASE__c=10,
                                             Monthly_Term_PURCHASE__c=10,
                                             Payment_Factor__c=0.0,
                                             Purchase__c=10,
                                             Tax__c=true,
                                             Total_Min_Payments__c=10,
                                             type__c='yes',
                                             Video__c='yes',
                                             APR__c=0.0,
                                             Payment_Number__c=10);
        
        DiacoFinance2Class.create_update_Finance_HS(hs.Id,finance);
    	Finance_Package__c financeResponse = DiacoFinance2Class.create_update_Finance(finance);
        
        Home_Services__c hs2 = new Home_Services__c(Id = hs.Id, FinanceId__c = financeResponse.Id);
        update hs;
    	DiacoFinance2Class.getInfo_Finance_HS(hs2.Id);
        DiacoFinance2Class.getInfo_Finance_HS(null);
      //  DiacoFinance2Class.getInfo_Finance_Hs_With_Tax('a1203000000CpYUAA9', hs2.Id);
      //  DiacoFinance2Class.getInfo_Finance_Hs_With_Tax(pack.Id, hs2.Id);
      //  DiacoFinance2Class.getInfo_Finance_Hs_With_Tax(null, hs2.Id);
        DiacoFinance2Class.getInfo_Finance();
		
        DiacoFinance2Class.create_update_Finance_HS(hs.Id,financeResponse);
        DiacoFinance2Class.getInfo_HS(hs.Id);
        
    }
}