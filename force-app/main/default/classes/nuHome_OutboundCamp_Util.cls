public class nuHome_OutboundCamp_Util {
    
    public Static Id createAccount(){
        String accRecTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();         
        //Creating Account Record.
        Account accIns = new Account();
        accIns.Lastname = 'testAccount';  
        accIns.Primary_Billing_City__c='Sunnyvale';    
        accIns.Primary_Billing_Country__c='US';
        accIns.Primary_Billing_State__c='CA';
        accIns.Primary_Billing_Street__c='260 N Mathilda Ave';
        accIns.Primary_Billing_Zip_Code__c='94086'; 
        accIns.branch__c = 'CA-San_Jose';  
        accIns.recordTypeid = accRecTypeId;  
        accIns.Phone = '1234567891';
        accIns.Verbal_Consent__c = 'Y';
        insert accIns;
        return accIns.id;
    }

    public Static Id createOpportunity(){
        
        //Creating Price book.
        Pricebook2 pbook = new Pricebook2();
        pbook.Name = 'nuHome OB Campaign';
        pbook.isactive = true;
        insert pbook;

        Id accIns = createAccount();
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId();
        Opportunity oppIns = new Opportunity();
        oppIns.accountId = accIns;
        oppIns.name='TestOpp';
        oppIns.closeDate = date.today();
        oppIns.Operational_Stages__c = 'Gift Card Active Customer';
        oppIns.Forward_to_number__c = 'Test';
        oppIns.stageName = 'Needs Analysis';
        oppIns.Art_File__c='sunnyvale'; 
        oppIns.Back_pdf__c=2;
        oppIns.Front_pdf__c=2;
        oppIns.pricebook2Id = pbook.id;
        oppIns.recordTypeId = oppRecTypeId;
        oppIns.OB_Operation_Stage__c = 'Active';
        insert oppIns;
        return oppIns.id;
        
    }
    
    public static Id createUserAddress()
    {
         Id accIns = createAccount();
         
         Address__c add = new Address__c();
         add.Name = 'Test';
         Insert add;
         
         User_Address__c userAdd = new User_Address__c();
         userAdd.UserAccount__c = accIns;
         userAdd.Address__c = add.Id;
         userAdd.Active__c = True;
         userAdd.User_Address_Type__c = 'Primary Owner';
         Insert userAdd;
         
         return userAdd.id;
          
    }
    public Static Id createObMember(){

        Id accIns = createAccount();
        Id oppIns = createOpportunity();  
        Id userAddId = createUserAddress();
        
        OB_Campaign__c obCampaignRec = new OB_Campaign__c(Opportunity__c = oppIns);
        insert obCampaignRec;
        
        OB_Campaign_Member__c obCampaignMem = new OB_Campaign_Member__c();
       
        obCampaignMem.OB_Campaign__c = obCampaignRec.id;
        obCampaignMem.AccountName__c = accIns;
        obCampaignMem.User_Address__c = userAddId;
        obCampaignMem.Appointment_Outcome__c = 'Appointment Set';
        insert obCampaignMem;
        return obCampaignMem.id;
    }
       
}