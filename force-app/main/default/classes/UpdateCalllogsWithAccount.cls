global class UpdateCalllogsWithAccount implements Database.Batchable<sObject>,schedulable{

   global void execute(SchedulableContext sc) {
      database.executebatch(new UpdateCalllogsWithAccount());
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select id,ANI__c,User_Address__c,Account__c 
                                       from Call_Log__c where ANI__c !=null 
                                       and (Account__c = null or  User_Address__c = null)]);
   }

   global void execute(Database.BatchableContext BC, List<Call_Log__c> scope){
       Date conditionedDate = Date.Today().addDays(-2);
       Set<string> phoneAccount = new Set<string>();
        Set<string> phoneAddress = new Set<string>();
        for(Call_Log__c rec : scope){
            if(rec.Account__c == null)
                phoneAccount.add(rec.ANI__c);
            if(rec.User_Address__c == null)
                phoneAddress.add(rec.ANI__c);           
        }
       system.debug('xxx'+phoneAccount);
        
        List<Account> lstAccount = [select id,Phone,PersonMobilePhone 
                                            from account 
                                            where (Phone in : phoneAccount or PersonMobilePhone in : phoneAccount) 
                                            and Respond_Date__c >=: conditionedDate order by lastmodifiedDate desc];
        system.debug('AAAAAAAAAAAA' + lstAccount);
        Map<string,Account> accountPhoneMap = new Map<string,Account>();
        Map<string,Account> accountPersonMobileMap = new Map<string,Account>();
        for(Account acc : lstAccount){
            system.debug('mobile oho'+acc);
            if(acc.Phone != null)
                accountPhoneMap.put(acc.Phone,acc);
            if(acc.PersonMobilePhone != null)
                accountPersonMobileMap.put(acc.PersonMobilePhone,acc);
        }
        
        List<User_Address__c> lstUserAddress = New List<User_Address__c>();
        lstUserAddress = [select id,Phone__c,fPhone__c from User_Address__c where Address__c != null 
                            and (Phone__c in : phoneAddress or fPhone__c in : phoneAddress) 
                            and Respond_Date__c >= : conditionedDate order by lastmodifieddate desc NULLS LAST];
        
        system.debug('AAAAAAAAAAAA' + lstUserAddress.size() );
        Map<string,User_Address__c> userAddressPhoneMap = new Map<string,User_Address__c>();
        Map<string,User_Address__c> userAddressFPhoneMap = new Map<string,User_Address__c>();
        for(User_Address__c userAdd : lstUserAddress ){
            if(userAdd.Phone__c != null)
                userAddressPhoneMap.put(userAdd.Phone__c,userAdd);
            if(userAdd.fPhone__c != null)
                userAddressFPhoneMap.put(userAdd.fPhone__c,userAdd);
        }
        
        for(Call_Log__c rec : scope){
            if(rec.Account__c == null){
                If(accountPhoneMap.containsKey(rec.ANI__c)){
                    rec.Account__c = accountPhoneMap.get(rec.ANI__c).Id;
                }
                else If(accountPersonMobileMap.containsKey(rec.ANI__c)){
                    rec.Account__c = accountPersonMobileMap.get(rec.ANI__c).Id;
                }
            }
            
            if(rec.User_Address__c == null){
                If(userAddressPhoneMap.containsKey(rec.ANI__c)){
                    rec.User_Address__c = userAddressPhoneMap.get(rec.ANI__c).Id;
                }
                else If(userAddressFPhoneMap.containsKey(rec.ANI__c)){
                    rec.User_Address__c = userAddressFPhoneMap.get(rec.ANI__c).Id;
                }
            }   
        }
        
        update scope;
   
   }

   global void finish(Database.BatchableContext BC){
   
   }
}