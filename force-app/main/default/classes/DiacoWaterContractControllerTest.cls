/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiacoContract Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		22/03/2020		Álvaro Ortega (AO)		Changes.
**/
@isTest
public class DiacoWaterContractControllerTest {
    @isTest static void testAll(){
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.Name='test test test test';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        hs.Sales_Rep__c=UserInfo.getUserId();

        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        County__c countyA = new County__c(County_Name__c='County A');
        County__c countyB = new County__c(County_Name__c='County B');
        List<County__c> counties = new List<County__c>{countyA, countyB};
        insert counties;
        
        test.startTest();
        
        DiacoWaterContractController.getDataHomeServicePricing(hs.Id);
        DiacoWaterContractController.getDataCustomerOne(hs.Id);
        DiacoWaterContractController.getDataCustomerTwo(hs.Id);
        DiacoWaterContractController.saveAccount(Acc);
        DiacoWaterContractController.getDataLocationAndPayments(hs.Id);
        DiacoWaterContractController.getInstallationDate(hs.Id);
        DiacoWaterContractController.getSalesReps();
        DiacoWaterContractController.getSalesRepsName(UserInfo.getUserId());
        DiacoWaterContractController.saveHomeService(hs);
        DiacoWaterContractController.getDataHomeService(hs.Id);
        DiacoWaterContractController.getSaleRepAssigned(hs.Id);
        DiacoWaterContractController.saveHomeServiceSalesRep(hs.Id,UserInfo.getUserId());
        DiacoWaterContractController.getDataHomeServiceAgreement(hs.Id);
        DiacoWaterContractController.getPaymentMethods(hs.Id);
        DiacoWaterContractController.saveHomeService3(hs);
        
        Map<String, String> countyResult = DiacoWaterContractController.getCountyData();
        
        test.stopTest();
        
        System.assertNotEquals(countyResult, null);
        System.assertEquals(countyResult.size(), 2);
    }

}