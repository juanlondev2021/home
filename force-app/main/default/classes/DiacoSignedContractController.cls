/*

Diaco
@author 			Álvaro José Ortega Vargas href=<aovargassf@gmail.com>
Project:			Signed Contract
Description:		Show Signed Contract

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		26/03/2020	Álvaro Ortega (AO)	    Show Signed Contract
@version	1.0		17/06/2020	John Hernandez(JH)	    New version to get signed contract by Pre design envelope Name
*/ 
public class DiacoSignedContractController {
    @AuraEnabled
    public static String signedContract(String recordId){
        List<ddsign__Envelope__c> evs = [select Id, ddsign__status__c
                                         from ddsign__Envelope__c
                                         where Home_Service__c = :recordId
                                         order by LastModifiedDate desc
                                         limit 1];
        
        String toDelete = '%' + recordId +'%';
        try{
        delete [select Id 
                from ContentDocument 
                WHERE Title like '%_signedContract_%' and Title like :toDelete];
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        if(evs.size() > 0){
            
            if(evs[0].ddsign__status__c != 'signed' && evs[0].ddsign__status__c != 'completed'){
                return null;
                //('signed', 'completed')
            }
            List<Attachment>  ats     = [select Id, Name, Body
                                         From Attachment 
                                         where ParentId = :evs[0].Id and (not name like '%certificate%') 
                                         order by LastModifiedDate desc 
                                         limit 1];
            
            if(ats.size() > 0){
                String contractName = ats[0].Name.replace('.pdf', '') + '_signedContract_' + recordId;
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.PathOnClient = '.pdf';
                cv.Origin = 'H';
                //cv.OwnerId = at.OwnerId;
                cv.Title = contractName;
                cv.VersionData = ats[0].Body;
                insert cv;
                
                string contentDocumentId;
                ContentVersion[] contentV= [select ContentDocumentId FROM ContentVersion WHERE Title = :contractName];
                if(contentV.size() > 0) {
                    contentDocumentId = contentV[0].ContentDocumentId; 
                    return contentDocumentId;
                }
            }
        }
        
        return null;
    }
    
    //Now a Home service can have several different contracts so a different treatment is needed, preEnvlope name will be used to separate logic.
    @AuraEnabled
    public static String signedContractByName(Id recordId,String preEnvName){
        List<ddsign__Envelope__c> evs = new List<ddsign__Envelope__c>();
        if(recordId != null){          
            if(recordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:recordId].WhatId;
                recordId = recordIdFromEvent;
            }
            
        }
        if(preEnvName!=null){
            evs = [select Id, ddsign__status__c,LastModifiedDate
                   from ddsign__Envelope__c
                   where Home_Service__c = :recordId and ddsign__Pre_Designed_Envelope__r.name=:preEnvName and (ddsign__status__c = 'signed' or ddsign__status__c = 'completed')
                   order by LastModifiedDate desc
                   limit 1];
        		
        }else{
            return null;
        }
        String toDelete = '%' + recordId +'%';
        system.debug('evs');
        system.debug('sin limit 1');
        system.debug(evs);
        if(preEnvName!= 'Pinnacle Contract'){
            try{
                delete [select Id 
                        from ContentDocument 
                        WHERE Title like '%_signedContract_%' and Title like :toDelete];
                
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        if(preEnvName== 'Pinnacle Contract'){
            try{
                delete [select Id 
                        from ContentDocument 
                        WHERE Title like '%Pinnacle Contract - %' and Title like :toDelete];
                
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        
        if(evs.size() > 0){    
            system.debug('evs size>0');
            if(evs[0].ddsign__status__c != 'signed' && evs[0].ddsign__status__c != 'completed'){
                return null;
                //('signed', 'completed')
            }
            List<Attachment>  ats     = [select Id, Name, Body
                                         From Attachment 
                                         where ParentId = :evs[0].Id and (not name like '%certificate%') 
                                         order by LastModifiedDate desc 
                                         limit 1];
            if(ats.size() > 0){
                system.debug('ats');
                system.debug(ats);
                String contractName;
                contractName = ats[0].Name.replace('.pdf', '') + '_signedContract_' + recordId;
                system.debug('contrctName');
                system.debug(contractName);
                if(preEnvName== 'Pinnacle Contract'){
                    contractName = 'Pinnacle Contract - '+recordId;
                }
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.PathOnClient = '.pdf';
                cv.Origin = 'H';
                //cv.OwnerId = at.OwnerId;
                cv.Title = contractName;
                cv.VersionData = ats[0].Body;
                insert cv;
                
                string contentDocumentId;
                ContentVersion[] contentV= [select ContentDocumentId FROM ContentVersion WHERE Title = :contractName];
                if(contentV.size() > 0) {
                    contentDocumentId = contentV[0].ContentDocumentId;
                    return contentDocumentId;
                }
            }
        }
        
        return null;
    }

    @AuraEnabled
    public static String getRecordTypeFromHS(Id RecordId){
        if(RecordId != null){          
            if(RecordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:RecordId].WhatId;
                RecordId = recordIdFromEvent;
            }
            
            if(recordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                Home_Services__c home =  [select Id,RecordType.Name from Home_Services__c where Id = :RecordId];
        		return home.RecordType.Name;  
            }
        }
        return null;
    }
}