Public class TCPAComplianceHandler
{
  
    public Static void CreateTCPACompliance(Map<Id,Account> newAccountMap)
    {
        List<TCPA_Compliance__c> ewcComplianceList = new List<TCPA_Compliance__c>();
        Set<Id> accountIds = new Set<Id>();
        Id ecwRTId= Schema.SObjectType.TCPA_Compliance__c.RecordTypeInfosByName.get('Express Written Consent').RecordTypeId;
        for(Account currAccount : newAccountMap.values())
        {
              
            TCPA_Compliance__c newEBRTCPA = new TCPA_Compliance__c();
          
           
            newEBRTCPA.RecordTypeId = ecwRTId;
            newEBRTCPA.Name =currAccount.FirstName+' '+ currAccount.LastName +'- EWC -' + currAccount.verbal_consent__c;
            newEBRTCPA.User_Account__c = currAccount.id;
            newEBRTCPA.Call_Center_Agent__c= userinfo.getUserId();
            newEBRTCPA.Is_Active__c = True;
            ewcComplianceList.add(newEBRTCPA);
            accountIds.add(currAccount.id);
            
            
        }
        
        if(ewcComplianceList.size() > 0)
        {
           
            
            List<TCPA_Compliance__c> updatExTCPARecords = new List<TCPA_Compliance__c>();
            updatExTCPARecords  = [SELECT Id,is_Active__c FROM TCPA_Compliance__c WHERE  User_Account__c IN :accountIds AND RecordTypeId = :ecwRTId AND is_Active__c=True];
            for(TCPA_Compliance__c updteRec : updatExTCPARecords)
            {
                updteRec.is_Active__c = False;
            }
          
           Update updatExTCPARecords; 
           insert ewcComplianceList;
        }
    
    }
    
   



}