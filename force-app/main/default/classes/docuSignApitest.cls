@IsTest
private with sharing class docuSignApitest
{
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
    
    private static testMethod void coverMethodsApi()
    {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        DocuSignApi dsa = new DocuSignApi();
        DocuSignApi.SSN4InformationInput ssd = new  DocuSignApi.SSN4InformationInput();
        DocuSignApi.EventNotification ec = new DocuSignApi.EventNotification();
        DocuSignApi.ArrayOfServerTemplate ar =  new DocuSignApi.ArrayOfServerTemplate();
        DocuSignApi.ArrayOfTemplateReferenceFieldDataDataValue at = new  DocuSignApi.ArrayOfTemplateReferenceFieldDataDataValue();
        DocuSignApi.CreateEnvelopeResponse_element cel = new DocuSignApi.CreateEnvelopeResponse_element();
        DocuSignApi.SendEnvelopeResponse_element ser = new DocuSignApi.SendEnvelopeResponse_element();
        DocuSignApi.ArrayOfTemplateReferenceRoleAssignment artv = new DocuSignApi.ArrayOfTemplateReferenceRoleAssignment();
        DocuSignApi.Attachment att = new DocuSignApi.Attachment();
        DocuSignApi.SSN4Information ss = new DocuSignApi.SSN4Information();
        DocuSignApi.IDCheckInformation eid = new DocuSignApi.IDCheckInformation();
        DocuSignApi.Document doc = new DocuSignApi.Document();
        DocuSignApi.ArrayOfTemplateReference aoft = new DocuSignApi.ArrayOfTemplateReference();
        DocuSignApi.RecipientStatus rsrrt = new DocuSignApi.RecipientStatus();
        DocuSignApi.ArrayOfCompositeTemplate gdgd = new DocuSignApi.ArrayOfCompositeTemplate();
        DocuSignApi.CreateEnvelope_element jdj = new DocuSignApi.CreateEnvelope_element();
        DocuSignApi.Reminders shdh = new DocuSignApi.Reminders();
        DocuSignApi.CreateEnvelopeFromTemplates_element  jsjsjs = new DocuSignApi.CreateEnvelopeFromTemplates_element();
        DocuSignApi.ArrayOfCustomField atsh =  new DocuSignApi.ArrayOfCustomField();
        DocuSignApi.ArrayOfRecipient1 lal = new DocuSignApi.ArrayOfRecipient1();
        DocuSignApi.FormData jla =  new DocuSignApi.FormData();
        DocuSignApi.ArrayOfTab hs = new DocuSignApi.ArrayOfTab();
        DocuSignApi.RequestRecipientToken_element var1 = new DocuSignApi.RequestRecipientToken_element();
        DocuSignApi.EnvelopeEvent var2 = new DocuSignApi.EnvelopeEvent();
        DocuSignApi.Recipient var3 = new DocuSignApi.Recipient();
        DocuSignApi.FormDataXfdf var4 = new DocuSignApi.FormDataXfdf();
        DocuSignApi.RecipientCaptiveInfo var5 = new DocuSignApi.RecipientCaptiveInfo();
        DocuSignApi.ArrayOfRecipientStatus var6 = new DocuSignApi.ArrayOfRecipientStatus();
        DocuSignApi.AuthenticationStatus var7 = new DocuSignApi.AuthenticationStatus();
        DocuSignApi.ArrayOfFormDataXfdfField var8 = new DocuSignApi.ArrayOfFormDataXfdfField();
        DocuSignApi.RecipientPhoneAuthentication var9 = new DocuSignApi.RecipientPhoneAuthentication();
        DocuSignApi.TemplateReferenceFieldDataDataValue var10 = new DocuSignApi.TemplateReferenceFieldDataDataValue();
        DocuSignApi.CreateEnvelopeFromTemplatesAndFormsResponse_element var11 = new DocuSignApi.CreateEnvelopeFromTemplatesAndFormsResponse_element();
        DocuSignApi.ArrayOfString1 var12 = new DocuSignApi.ArrayOfString1();
        DocuSignApi.ArrayOfDocumentStatus var13 = new DocuSignApi.ArrayOfDocumentStatus();
        DocuSignApi.CreateEnvelopeFromTemplatesResponse_element var14 = new DocuSignApi.CreateEnvelopeFromTemplatesResponse_element();
        DocuSignApi.SendEnvelope_element var15 = new DocuSignApi.SendEnvelope_element();
        DocuSignApi.RequestRecipientFaxToken_element var16 = new DocuSignApi.RequestRecipientFaxToken_element();
        DocuSignApi.DOBInformationInput var17 = new DocuSignApi.DOBInformationInput();
        DocuSignApi.RequestSenderTokenResponse_element var = new DocuSignApi.RequestSenderTokenResponse_element();
        DocuSignApi.InlineTemplate var18 = new DocuSignApi.InlineTemplate();
        DocuSignApi.RecipientSignatureInfo var19 = new DocuSignApi.RecipientSignatureInfo();
        DocuSignApi.AddressInformationInput var20 = new DocuSignApi.AddressInformationInput();
        DocuSignApi.ArrayOfRecipient var21 = new DocuSignApi.ArrayOfRecipient();
        DocuSignApi.EnvelopeInformation var22 = new DocuSignApi.EnvelopeInformation();
        DocuSignApi.CreateEnvelopeFromTemplatesAndForms_element var23 = new DocuSignApi.CreateEnvelopeFromTemplatesAndForms_element();
        DocuSignApi.AddressInformation var24 = new DocuSignApi.AddressInformation();
        DocuSignApi.ArrayOfTabStatus var25 = new DocuSignApi.ArrayOfTabStatus();
        DocuSignApi.TemplateReferenceRoleAssignment var26 = new DocuSignApi.TemplateReferenceRoleAssignment();
        DocuSignApi.ArrayOfDocument var27 = new DocuSignApi.ArrayOfDocument();
        DocuSignApi.Envelope var28 = new DocuSignApi.Envelope();
        DocuSignApi.ArrayOfAttachment var29 = new DocuSignApi.ArrayOfAttachment();
        DocuSignApi.Notification var30 = new DocuSignApi.Notification();
        DocuSignApi.RequestSenderToken_element var31 = new DocuSignApi.RequestSenderToken_element();
        DocuSignApi.CreateAndSendEnvelopeResponse_element var32 = new DocuSignApi.CreateAndSendEnvelopeResponse_element();
        DocuSignApi.RequestRecipientTokenAuthenticationAssertion var33 = new DocuSignApi.RequestRecipientTokenAuthenticationAssertion();
        DocuSignApi.SSN9InformationInput var34 = new DocuSignApi.SSN9InformationInput();
        DocuSignApi.ServerTemplate var35 = new DocuSignApi.ServerTemplate();
        DocuSignApi.RequestRecipientTokenResponse_element var43 = new DocuSignApi.RequestRecipientTokenResponse_element();
        DocuSignApi.IDCheckInformationInput var36 = new DocuSignApi.IDCheckInformationInput();
        DocuSignApi.TabStatus var37 = new DocuSignApi.TabStatus();
        DocuSignApi.ArrayOfMatchBox var38 = new DocuSignApi.ArrayOfMatchBox();
        DocuSignApi.SSN9Information var39 = new DocuSignApi.SSN9Information();
        DocuSignApi.EnvelopeStatus var40 = new DocuSignApi.EnvelopeStatus();
        DocuSignApi.ArrayOfEnvelopeEvent var41 = new DocuSignApi.ArrayOfEnvelopeEvent();
        DocuSignApi.MatchBox var42 = new DocuSignApi.MatchBox();
        DocuSignApi.TemplateReferenceFieldData var44 = new DocuSignApi.TemplateReferenceFieldData();
        DocuSignApi.CompositeTemplate var45 = new DocuSignApi.CompositeTemplate();
        DocuSignApi.DOBInformation var46 = new DocuSignApi.DOBInformation();
        DocuSignApi.DocumentStatus var47 = new DocuSignApi.DocumentStatus();
        DocuSignApi.AnchorTab var48 = new DocuSignApi.AnchorTab();
        DocuSignApi.EventResult var49 = new DocuSignApi.EventResult();
        DocuSignApi.FormDataXfdfField va1 = new DocuSignApi.FormDataXfdfField();
        DocuSignApi.PDFMetaDataTemplate va2 = new DocuSignApi.PDFMetaDataTemplate();
        DocuSignApi.Tab va3 = new DocuSignApi.Tab();
        DocuSignApi.ArrayOfInlineTemplate va4 = new DocuSignApi.ArrayOfInlineTemplate();
        DocuSignApi.ArrayOfString va5 = new DocuSignApi.ArrayOfString();
        DocuSignApi.VaultingDetails va6 = new DocuSignApi.VaultingDetails();
        DocuSignApi.CustomField va7 = new DocuSignApi.CustomField();
        DocuSignApi.Expirations va8 = new DocuSignApi.Expirations();
        DocuSignApi.RecipientStatusEsignAgreementInformation va9 = new DocuSignApi.RecipientStatusEsignAgreementInformation();
        DocuSignApi.VaultingOptions va10 = new DocuSignApi.VaultingOptions();
        DocuSignApi.RequestRecipientTokenClientURLs va11 = new DocuSignApi.RequestRecipientTokenClientURLs();
        DocuSignApi.CreateAndSendEnvelope_element va12 = new DocuSignApi.CreateAndSendEnvelope_element();
        DocuSignApi.TemplateReference va14 = new DocuSignApi.TemplateReference();
        new DocuSignApi.APIServiceSoap().SendEnvelope(null, null);
        new DocuSignApi.APIServiceSoap().CreateEnvelopeFromTemplates(null, null, null, null);
        new DocuSignApi.APIServiceSoap().RequestSenderToken(null, null, null);
        
        new DocuSignApi.APIServiceSoap().RequestRecipientToken(null, null,null, null,null, null);
        new DocuSignApi.APIServiceSoap().CreateAndSendEnvelope(null);
        new DocuSignApi.APIServiceSoap().CreateEnvelope(null);
        new DocuSignApi.APIServiceSoap().CreateEnvelopeFromTemplatesAndForms(null, null, null);
    }
    
    @isTest static void coverMethodsSendController()
    {
        
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
        hs.RecordTypeId = '012410000013G9NAAU';
        hs.ApptSetter__c = per.Id;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        Home_Services__c hs2 = new  Home_Services__c();
        hs2.Account__c = Acc.Id;
        hs2.RecordTypeId = '012410000013G9JAAU';
        hs2.ApptSetter__c = per.Id;
        //hs.Sales_Rep__c = u.Id;
        insert hs2;
        
        Product__c pro = new Product__c();
        pro.Name = 'test';
        pro.Product_Type__c = 'Water';
        pro.active__c = true;
        insert pro;
        
        Product__c pro2 = new Product__c();
        pro2.Name = 'test';
        pro2.Product_Type__c = 'Water';
        pro2.Service__c = true; 
        pro2.active__c = true;
        insert pro2;
        
        Product__c pro3 = new Product__c();
        pro3.Name = 'test';
        pro3.Product_Type__c = 'Solar';
        pro3.active__c = true;
        insert pro3;
        
        Product__c pro4 = new Product__c();
        pro4.Name = 'test';
        pro4.Product_Type__c = 'Solar';
        pro4.Service__c = true; 
        pro4.active__c = true;
        insert pro4;
        
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
        
        Line_Item__c li4 = new Line_Item__c();
        li4.Name = 'test';
        li4.Home_Service__c = hs2.Id;
        li4.Product__c = pro3.Id;
        insert li4;
        
        Line_Item__c li5 = new Line_Item__c();
        li5.Name = 'test';
        li5.Home_Service__c = hs2.Id;
        li5.Product__c = pro4.Id;
        insert li5;
        docuSignConf__c doc = new docuSignConf__c(
            accountId__c = 'testaccouont', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId'
        ); 
        upsert doc;
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //
        ApexPages.StandardController sc = new ApexPages.StandardController(hs);
        SendToDocuSignController  stdc =  new SendToDocuSignController(sc);
        stdc.SendNow('Water', doc.accountId__c, doc.userId__c, doc.password__c, doc.integratorsKey__c, hs, 1);
        stdc.SendNow('Water', doc.accountId__c, doc.userId__c, doc.password__c, doc.integratorsKey__c, hs, 2);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(hs2);
        SendToDocuSignController  stdc2 =  new SendToDocuSignController(sc2);
        stdc.SendNow('Solar', doc.accountId__c, doc.userId__c, doc.password__c, doc.integratorsKey__c, hs2, 1);
        stdc.SendNow('Pest', doc.accountId__c, doc.userId__c, doc.password__c, doc.integratorsKey__c, hs2, 1);
        
        
        
    }
}