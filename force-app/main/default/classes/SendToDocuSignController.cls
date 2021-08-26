public with sharing class SendToDocuSignController {
    //private final Contract contract;
    private final Home_Services__c homeService{get; set;}
    public String productType{get; set;}
    public String envelopeId {get;set;}
    private String accountId {get;set;}
    private String userId {get;set;}
    private String password {get;set;}
    private String integratorsKey {get;set;}
    //private String webServiceUrl = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
    public List<docuSignConf__c> docusignconf{get;set;}
    public docuSignConf__c conf{get;set;}
    
    public SendToDocuSignController(ApexPages.StandardController controller)
    {
        conf = new docuSignConf__c();
        docusignconf = [select accountId__c, integratorsKey__c, password__c, userId__c, userIdSolar__c, account__c, passwordSolar__c 
                        from docuSignConf__c];
        ContractsController cc =  new ContractsController();
        conf = docusignconf[0];
        this.homeService = [select Id,Name, Account__c, RecordTypeId from Home_Services__c where id = :controller.getRecord().Id];
        productType = cc.products(homeService.RecordTypeId);
        accountId = conf.accountId__c;
        if(productType == 'Water'){
            userId = conf.userId__c;
            password = conf.password__c;
        }else if(productType == 'Solar'){
            userId = conf.userIdSolar__c;
            password = conf.passwordSolar__c;
        }
        
        integratorsKey = conf.integratorsKey__c;
        envelopeId = 'this contract has not been sent yet!';
        
    }
    public SendToDocuSignController(){}
    
    
    
    public String SendNow(String productType, String accountId, String userId, String password, String integratorsKey, Home_Services__c homeService, Integer opt)
    {
        String envelopeId;
        String webServiceUrl = 'https://www.docusign.net/api/3.0/dsapi.asmx';
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = webServiceUrl;
        
        //updating dates!!
        //updateDates(homeService, productType);
        
        //Set Authentication
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        system.debug('auth : ' + auth);
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', 
                                         auth);
        
        
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        
        envelope.Subject = 'Please Sign this Contract';
        envelope.EmailBlurb = 'This is my new eSignature service,'+ 
            ' it allows me to get your signoff without having to fax, ' +
            'scan, retype, refile and wait forever';
        envelope.AccountId  = accountId;
        System.debug('Envelop: '+ accountId);
        // Render the contract
        System.debug('Rendering the contract');
        System.debug('productType' + productType);
        //initials
        PageReference pageRef ;//new PageReference('/apex/RenderContract');
        if(productType == 'Water'){
            if(opt == 1){
                pageRef  = new PageReference('/apex/Aqua_Bright_Water_LLC');//Page.RenderContract;
            }else if(opt == 2){
                pageRef  = new PageReference('/apex/diacoContractServiceAgreement');//Page.RenderContract;
            }
            
        }
        else if(productType == 'Solar'){
            //pageRef  = new PageReference('/apex/RenderNergyContract?id='+homeService.Id);//Page.RenderNergyContract;
            pageRef  = new PageReference('/apex/Purchase_Contract');//Page.RenderNergyContract;
        }
        else if(productType == 'Pest'){
            pageRef  = new PageReference('/apex/PEST_CONTROL_AGREEMENT');
        }
        else if(productType == 'Home Automation'){
            pageRef  = new PageReference('/apex/diacoRenderContractAutomation');
        }
        system.debug('homeService : '+ homeService);
        pageRef.getParameters().put('id',homeService.Id); 
        
        Blob pdfBlob;// = pageRef.getContent();   
        if(Test.isRunningTest()) { 
            pdfBlob = blob.valueOf('Unit.Test');
        } else {
            pdfBlob = pageRef.getContentAsPDF();
        }
        
        system.debug('pdfBlob : '+ pdfBlob);
        // Document
        DocuSignAPI.Document document = new DocuSignAPI.Document();
        document.ID = 1;
        document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
        document.Name = 'Contract';
        document.FileExtension = 'pdf';
        envelope.Documents = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document = new DocuSignAPI.Document[1];
        envelope.Documents.Document[0] = document;
        
        // Recipient
        System.debug('getting the contact');
        Account acct = [SELECT PersonEmail, AcctFirstName__c, AcctLastName__c, Homeowner_2_Email__c
                        from Account where id = :homeService.Account__c];
        
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = 1;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = 1;
        recipient.Email = acct.PersonEmail;
        recipient.UserName = acct.AcctFirstName__c + ' ' + acct.AcctLastName__c;
        // This setting seems required or you see the error:
        // "The string '' is not a valid Boolean value. 
        // at System.Xml.XmlConvert.ToBoolean(String s)" 
        
        /**
        * if you want to have more than 1 assignature or person signing in your 
        * contract, you need to add recipients to your envelope, change the recipient.ID and change the recipient.Email.
        *
        * 
        * change the recipient.UserName is not necessary but you can do it if you want. 
        */
        recipient.RequireIDLookup = false;
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[2];
        envelope.Recipients.Recipient[0] = recipient;
        
        if(productType == 'Water')
        {
            envelope = SendWaterContract(envelope, acct);
        }
        else if(productType == 'Solar')
        {
            envelope = SendSolarContract(envelope, acct);
        }
        else if(productType == 'Pest')
        {
            envelope = SendPestContract(envelope, acct);
        }
        else if(productType == 'Home Automation')
        {
            envelope = SendHAContract(envelope, acct);
        }
        
        
        
        System.debug('Calling the API');
        
        try {
            system.debug('request : '+ json.serialize(envelope));
            DocuSignAPI.EnvelopeStatus es 
                = dsApiSend.CreateAndSendEnvelope(envelope);
            envelopeId = es.EnvelopeID;
            
            if(opt == 1){
                homeService.envelopeId__c = envelopeId;
                homeService.Sending_Date_Product_Contract__c = Date.today();
                homeService.Contract_Period_Product__c = '12';
                homeService.Sent_By_Product_Contract__c = UserInfo.getUserId();
                homeService.Contract_Status_Product__c = 'Waiting';
                
            }else if(opt == 2){
                homeService.EnvelopeAgreeId__c = envelopeId;
                homeService.Sending_Date_Service_Contract__c = Date.today();
                homeService.Contract_Period_Service__c = '12';
                homeService.Sent_By_Service_Contract__c = UserInfo.getUserId();
                homeService.Contract_Status_Service__c = 'Waiting';
            }
            
            update homeService;
            return envelopeId;
            
        } catch ( CalloutException e) {
            System.debug('Exception - ' + e );
            return envelopeId = 'Exception - ' + e;
        }
        
    }
    
    
    public DocuSignAPI.Envelope SendWaterContract(DocuSignAPI.Envelope envelope, Account acct){
        DocuSignAPI.Recipient recipient2 = new DocuSignAPI.Recipient();
        recipient2.ID = 2;
        recipient2.Type_x = 'Signer';
        recipient2.RoutingOrder = 1;
        recipient2.Email = acct.Homeowner_2_Email__c;
        recipient2.UserName = acct.AcctFirstName__c + ' ' + acct.AcctLastName__c;
        recipient2.RequireIDLookup = false;
        envelope.Recipients.Recipient[1] = recipient2;
        
        // Tab
        DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
        tab1.Type_x = 'SignHere';
        tab1.RecipientID = 1;
        tab1.DocumentID = 1;
        tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab1.AnchorTabItem.AnchorTabString = '--.';
        
        
        DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
        tab2.Type_x = 'SignHere';
        tab2.RecipientID = 2;
        tab2.DocumentID = 1;
        tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab2.AnchorTabItem.AnchorTabString = '__.';
        
        DocuSignAPI.Tab tab3 = new DocuSignAPI.Tab();
        tab3.Type_x = 'SignHere';
        tab3.RecipientID = 1;
        tab3.DocumentID = 1;
        tab3.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab3.AnchorTabItem.AnchorTabString = '#1 ';
        
        DocuSignAPI.Tab tab4 = new DocuSignAPI.Tab();
        tab4.Type_x = 'SignHere';
        tab4.RecipientID = 2;
        tab4.DocumentID = 1;
        tab4.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab4.AnchorTabItem.AnchorTabString = '#2 ';
        
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[4];
        envelope.Tabs.Tab[0] = tab1;        
        envelope.Tabs.Tab[1] = tab2; 
        envelope.Tabs.Tab[2] = tab3;        
        envelope.Tabs.Tab[3] = tab4; 
        
        return envelope;
    }
    
    
    public DocuSignAPI.Envelope SendHAContract(DocuSignAPI.Envelope envelope, Account acct){
        DocuSignAPI.Recipient recipient2 = new DocuSignAPI.Recipient();
        recipient2.ID = 2;
        recipient2.Type_x = 'Signer';
        recipient2.RoutingOrder = 1;
        recipient2.Email = acct.Homeowner_2_Email__c;
        recipient2.UserName = acct.AcctFirstName__c + ' ' + acct.AcctLastName__c;
        recipient2.RequireIDLookup = false;
        envelope.Recipients.Recipient[1] = recipient2;
        
        // Tab
        DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
        tab1.Type_x = 'SignHere';
        tab1.RecipientID = 1;
        tab1.DocumentID = 1;
        tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab1.AnchorTabItem.AnchorTabString = '--.';
        
        
        DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
        tab2.Type_x = 'SignHere';
        tab2.RecipientID = 2;
        tab2.DocumentID = 1;
        tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab2.AnchorTabItem.AnchorTabString = '__.';
        
        DocuSignAPI.Tab tab3 = new DocuSignAPI.Tab();
        tab3.Type_x = 'SignHere';
        tab3.RecipientID = 1;
        tab3.DocumentID = 1;
        tab3.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab3.AnchorTabItem.AnchorTabString = '#1 ';
        
        DocuSignAPI.Tab tab4 = new DocuSignAPI.Tab();
        tab4.Type_x = 'SignHere';
        tab4.RecipientID = 2;
        tab4.DocumentID = 1;
        tab4.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab4.AnchorTabItem.AnchorTabString = '#2 ';
        
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[4];
        envelope.Tabs.Tab[0] = tab1;        
        envelope.Tabs.Tab[1] = tab2; 
        envelope.Tabs.Tab[2] = tab3;        
        envelope.Tabs.Tab[3] = tab4; 
        
        return envelope;
    }
    
    
    public DocuSignAPI.Envelope SendSolarContract(DocuSignAPI.Envelope envelope, Account acct){
        User NameUser = [select Name, Id, Email from User where Id =: UserInfo.getUserId()];
        
        
        DocuSignAPI.Recipient recipient2 = new DocuSignAPI.Recipient();
        recipient2.ID = 2;
        recipient2.Type_x = 'Signer';
        recipient2.RoutingOrder = 1;
        recipient2.Email = NameUser.Email;
        recipient2.UserName = NameUser.Name;
        recipient2.RequireIDLookup = false;
        envelope.Recipients.Recipient[1] = recipient2;
        
        DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
        tab1.Type_x = 'SignHere';
        tab1.RecipientID = 1;
        tab1.DocumentID = 1;
        tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab1.AnchorTabItem.AnchorTabString = '*.';
        
        
        DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
        tab2.Type_x = 'SignHere';
        tab2.RecipientID = 2;
        tab2.DocumentID = 1;
        tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab2.AnchorTabItem.AnchorTabString = '**_.';
        
        DocuSignAPI.Tab tab3 = new DocuSignAPI.Tab();
        tab3.Type_x = 'InitialHere';
        tab3.RecipientID = 1;
        tab3.DocumentID = 1;
        tab3.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab3.AnchorTabItem.AnchorTabString = '.*_';
        
        DocuSignAPI.Tab tab4 = new DocuSignAPI.Tab();
        tab4.Type_x = 'SignHere';
        tab4.RecipientID = 1;
        tab4.DocumentID = 1;
        tab4.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab4.AnchorTabItem.AnchorTabString = 'Co.__';
        
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[4];
        envelope.Tabs.Tab[0] = tab1;        
        envelope.Tabs.Tab[1] = tab2;
        envelope.Tabs.Tab[2] = tab3; 
        envelope.Tabs.Tab[3] = tab4; 
        return envelope;
    }
    
    
     public DocuSignAPI.Envelope SendPestContract(DocuSignAPI.Envelope envelope, Account acct){
        DocuSignAPI.Recipient recipient2 = new DocuSignAPI.Recipient();
        recipient2.ID = 2;
        recipient2.Type_x = 'Signer';
        recipient2.RoutingOrder = 1;
        recipient2.Email = acct.Homeowner_2_Email__c;
        recipient2.UserName = acct.AcctFirstName__c + ' ' + acct.AcctLastName__c;
        recipient2.RequireIDLookup = false;
        envelope.Recipients.Recipient[1] = recipient2;
        
        // Tab
        DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
        tab1.Type_x = 'SignHere';
        tab1.RecipientID = 1;
        tab1.DocumentID = 1;
        tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab1.AnchorTabItem.AnchorTabString = '__.';
        
        
        DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
        tab2.Type_x = 'SignHere';
        tab2.RecipientID = 2;
        tab2.DocumentID = 1;
        tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab2.AnchorTabItem.AnchorTabString = '.___';
        
        DocuSignAPI.Tab tab3 = new DocuSignAPI.Tab();
        tab3.Type_x = 'SignHere';
        tab3.RecipientID = 1;
        tab3.DocumentID = 1;
        tab3.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab3.AnchorTabItem.AnchorTabString = '#1 __________________________';
        
        DocuSignAPI.Tab tab4 = new DocuSignAPI.Tab();
        tab4.Type_x = 'SignHere';
        tab4.RecipientID = 2;
        tab4.DocumentID = 1;
        tab4.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab4.AnchorTabItem.AnchorTabString = '#2 __________________________';
        
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[4];
        envelope.Tabs.Tab[0] = tab1;        
        envelope.Tabs.Tab[1] = tab2; 
        envelope.Tabs.Tab[2] = tab3;        
        envelope.Tabs.Tab[3] = tab4; 
        
        return envelope;
    }
        
}