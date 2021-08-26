@isTest (SeeAllData = true)
public class DiacoAccountTriggerUnifiedTest {
    
    @isTest static void testAll(){
        
        List<Account> Teste = new List <Account>();
        list<Opportunity> oportunityList = new list<Opportunity>();
        Map<Id,Account> AccountMap = new Map<Id,Account>();
         Map<Id,Account> AccountNewMap = new Map<Id,Account>();
        list<User_Address__c> userAddressList = new list<User_Address__c>();
        
        
        
        for(Integer i=0;i<10;i++)
        {
            
            Teste.add(new Account(BillingState = 'CA', LastName = 'Pass v2'+i,
                                  RecordTypeId = '012410000012NOKAA2',
                                  PersonDoNotCall =True,
                                  Verbal_Consent__c='No',
                                  phone='123456789'));
            
        }
        
        for(Integer j=0;j<10;j++)
        {
            Teste.add(new Account(BillingState = 'NY', LastName = 'Not Pass v2'+j,
                                  RecordTypeId = '012410000012NOKAA2',
                                  PersonDoNotCall=false,
                                  Verbal_Consent__c='xxxx',
                                  Respond_Date__c=null,
                                  phone=null));
        }
        insert Teste;
        
        for (Account acc : Teste) {
            
            if(acc.phone == null){
                acc.phone='123456789';
            }
            AccountMap.put(acc.Id, acc);
            oportunityList.add(new Opportunity(
                Name = 'TestOpportunity',
                AccountId = acc.Id,
                StageName = 'Qualified',
                CloseDate = system.today()
            ));  
            
             userAddressList.add(new User_Address__c(UserAccount__c = acc.Id));
        }
        
        insert oportunityList;
        insert userAddressList;
        
        list<Account> updateList = AccountMap.values();
        
        update updateList;
         
        for (Account acc : updateList) {
            AccountNewMap.put(acc.Id,acc);
        }
   
        test.startTest();
        DiacoAccountTriggerUnifiedClass.beforeTriggersToExecute(Teste);
        DiacoAccountTriggerUnifiedClass.AccountMain(Teste,AccountMap,true,false);
        DiacoAccountTriggerUnifiedClass.AccountMain(Teste,AccountMap,false,true);
        DiacoAccountTriggerUnifiedClass.Account_OwnerChange(AccountMap, AccountNewMap);
        DiacoAccountTriggerUnifiedClass.setPhoneForUserAddress(AccountMap, AccountNewMap);
        test.stopTest();
        
    }
}