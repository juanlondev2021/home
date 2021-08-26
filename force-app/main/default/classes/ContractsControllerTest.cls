/**
* Diaco
* @author 			Jorge Andres Martinez Peña href=<Jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible to test the class ContractsController.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		23/07/2018		Jorge Martinez (JM)		Initial implementation  of the class.
**/

@isTest
public class ContractsControllerTest {
     private class WebServiceMockImpl implements WebServiceMock
     {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            System.debug(request);
            if(request instanceof DocuSignApi.SendEnvelope_element){
                
                response.put('response_x', new DocuSignApi.SendEnvelopeResponse_element()) ;
                
                return;
            }else if(request instanceof DocuSignApi.CreateEnvelopeFromTemplates_element){
                
                response.put('response_x', new DocuSignApi.CreateEnvelopeFromTemplatesResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.RequestSenderToken_element){
                
                response.put('response_x', new DocuSignApi.RequestSenderTokenResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.RequestRecipientToken_element){
                
                response.put('response_x', new DocuSignApi.RequestRecipientTokenResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.CreateAndSendEnvelope_element){
                
                response.put('response_x', new DocuSignApi.CreateAndSendEnvelopeResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.CreateEnvelope_element){
                
                response.put('response_x', new DocuSignApi.CreateEnvelopeResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.CreateEnvelopeFromTemplatesAndForms_element){
                
                response.put('response_x', new DocuSignApi.CreateEnvelopeFromTemplatesAndFormsResponse_element());
                
                return;
            }
               
            
        }
    }
    
    /**
     * method responsible of all test.
     */
    static testMethod void test(){
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Customer_1_DOB__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_DOB__c =  Date.newInstance(2018, 7, 3);
        
        Acc.Customer_1_Drivers_License_Issue_Date__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_Drivers_License_Issue__c =  Date.newInstance(2018, 7, 3);
        
        Acc.Customer_1_Drivers_License_Expiration__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_Drivers_License_Expiration__c =  Date.newInstance(2018, 7, 3);
        
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        docuSignConf__c doc = new docuSignConf__c(
            accountId__c = 'testaccouont', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId'
        ); 
        upsert doc;
       
        User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter External User'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
            
            
        );

        insert u;
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        				   
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        //hs.Sales_Rep__c = u.Id;
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
        
        Event events =  new Event();
        DateTime StartHour = DateTime.newInstance(2018, 7, 22, 13, 30, 0);
        DateTime EndHour = StartHour.addHours(1);
        events.StartDateTime = StartHour;
        events.EndDateTime = EndHour;
        events.WhatId = hs.Id;
        events.Description = 'Description';
        events.RecordTypeId = '012410000013G9AAAU';
        insert events;       
        
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
        
        
        hs.Home_Services_Status__c = 'Closed Won';
        update hs;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ApexPages.StandardController sc = new ApexPages.StandardController(hs);
        
        ContractsController con = new ContractsController(sc);
        con.acct.dob__c = 'Jul 29, 2018';
        con.acct.dob2__c = 'Jul 29, 2018';
        con.acct.Homeowner_2_First_Name__c = 'test';
        con.acct.Homeowner_2_Last_Name__c = 'test';
        con.acct.Homeowner_2_Phone_Number__c = '00000000';
        con.acct.Homeowner_2_Email__c = 'test@test.com';
        con.print();
        con.IdEvent =  events.Id;
        con.installationHour = '06:10 AM';
        con.installationDay = 'Jul 29, 2018';
        con.Description = ' test description';
        con.SaveEvent();
        //con.Baddress();
        con.LineItems[0].Quantity__c = 1;
        con.Pprod();
        con.SaveLineItems();
        con.LineItem.Product__c = pro.Id;
        con.SaveLineItem();
        con.SaveHomeService();
        con.IdUser = u.Id;
        con.useUSer();
        con.upaccocunt();
        con.IdEvent =  events.Id;
        
        con.ServiceLineItems[0].Service_Check__c = true;
        con.ServiceLineItems[0].Total_Sales_Price_p__c = null;
        con.Pprod2();
        for(Line_Item__c lo : con.toServiceLineItems){
            lo.Bill_SD__c = 'Aug 18, 2018';
        }
        con.products('012410000013G9FAAU');
        con.SaveLineItemsservice();
        con.acct.Billing_Address_Same_As_Service_Address__c = true; 
        //con.Baddress();
        con.SaveHSService();
        
        con.IdtoServiceLineItems = li2.Id;
        con.IdtoLineItems = li.Id;
        con.DeleteLI();
        con.DeleteLIS();
        con.getDayList();
        con.getmonthList();
        con.getYearList();
        con.toServiceLineItems.add(li3);
        con.test();
        con.getMethods();
        con.getpayMethods(); 
        con.getAccountType();
        con.getextra();
        con.billingInformation();
        con.acct.Billing_Information_From__c = 'Client 1';
        con.billingInformation();
        con.acct.Billing_Information_From__c = 'Client 2';
        con.billingInformation();
        con.acct.Billing_Information_From__c = 'Client';
        con.billingInformation();
        con.getCards();
        con.paymentMethod();
        con.sendToDocusign();
        DateTime myDateTime = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
        List<String> timedate = con.dateTimeFrom(myDateTime);
        con.dateSaved(timedate);
        RenderContractController rcc =  new RenderContractController(sc);
        test.stopTest();
        
    }
    

}