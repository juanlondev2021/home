public class nuHome_Email_Task_AC {
    /* Created by : MSTSolutions
     * Date : 26 March 2016
     * Description : This will create task on when there is any email sent out to consumer after dts has been created or updated.
     * */
    public static void createTask(Map<Id, Door_Tag_Script__c> newMapRecordMap, Map<Id, Door_Tag_Script__c> oldMapRecordMap){
         system.debug('newMapRecordMap value '+newMapRecordMap);
        system.debug('oldMapRecordMap value '+oldMapRecordMap); 
        List<Task> taskList = New List<Task>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Account> accountsMap = new Map<Id,Account>();
        List<Door_Tag_Script__c> updateDTS = new List<Door_Tag_Script__c>();
        for(Door_Tag_Script__c doorScript:newMapRecordMap.values()){
            //Filtering Records that has true and previous value false on create task field.
            if(doorScript.Create_Task_Update__c == 'Email Sent'){
               accountIds.add(doorScript.Account__c);
            }
        }
        
        system.debug('accountsMap value'+accountsMap);
        if(accountIds.size() > 0)
        {
            accountsMap.putAll( [SELECT id,personcontactId from Account WHERE Id IN:accountIds AND isPersonAccount = True]);
        }
        system.debug('accountsMap value'+accountsMap);
        for(Door_Tag_Script__c doorScript:newMapRecordMap.values()){
            //Filtering Records that has true and previous value false on create task field.
            if(doorScript.Create_Task_Update__c == 'Email Sent'){
               Door_Tag_Script__c dtsIns = new Door_Tag_Script__c();
                Task taskIns = New Task();
                if(accountsMap.containsKey(doorScript.Account__c))
                    taskIns.whoId = accountsMap.get(doorScript.Account__c).personcontactId;
                
                taskIns.WhatId = doorScript.id;
                taskIns.Status = 'Completed';
                taskIns.Subject = 'Consumer Email Summary Sent';
                taskIns.Priority = 'Normal';
                taskList.add(taskIns);
                dtsIns.Id = doorScript.id;
                dtsIns.Create_Task_Update__c = 'Task Created';
                updateDTS.add(dtsIns);
            }
        }
        
       if(taskList.size() > 0)
       {
           System.debug('taskList value ' + taskList);
           insert taskList;
           
       }
        if(updateDTS.size()>0)
            update updateDTS;
    }
    
    
    // It will create task for Inventory and PA once client email has sent.
    public static void createInventoryTask(Map<Id, Inventory__c> newMapRecordMap, Map<Id, Inventory__c> oldMapRecordMap){
    
      Set<Id> personAccountIds = new Set<Id>();
      Map<Id,Account> accountsMap = new Map<Id,Account>();
      List<Task> taskList = new List<Task>();
      
       for(Inventory__c currInv : newMapRecordMap.values())
       {
           if(currInv.Lead_Emailed__c == True && oldMapRecordMap.get(currInv.id).Lead_Emailed__c == false)
               personAccountIds.add(currInv.account__c);
       }
      
       if(personAccountIds.size() > 0)
        {
            accountsMap.putAll( [SELECT id,personcontactId from Account WHERE Id IN:personAccountIds AND isPersonAccount = True]);
        }
   
       for(Inventory__c currInv : newMapRecordMap.values())
       {
           if(currInv.Lead_Emailed__c == True && oldMapRecordMap.get(currInv.id).Lead_Emailed__c == false)
           {
           
               Task taskIns = New Task();
            
             /*   if(accountsMap.containsKey(currInv.Account__c))
                    taskIns.whoId = accountsMap.get(currInv.Account__c).personcontactId; */
           
                taskIns.WhatId = currInv.id;
                taskIns.Status = 'Completed';
                taskIns.Subject = 'Client Email Summary Sent';
                taskIns.Priority = 'Normal';
                taskList.add(taskIns);

           }

       }
       //DML operation
       if(taskList.size() > 0)
         insert taskList;
    
    }

}