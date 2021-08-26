/**
 * Diaco
 * @author 			Fabian Pineda href=<fpineda@diaco.us>
 * Project:			Products & Installation
 * Description:		Handles actions by component diacoWalkThruForm.cmp
 *
 * Changes (Version)
 * -------------------------------------
 *			No.		Date			Author					Description
 *			-----	----------		--------------------	---------------
 * @version	1.0		2020/07/24		Fabian Pineda (FP)		Initial version.
 **/
public class DiacoWalkThruForm {
    public static void getFormContentDocumentLink(Map<String, sObject> io, Id homeServiceId) {
        io.put('formContentDocumentLink', null);
        io.put('formContentDocument', null);
        io.put('formContentVersion', null);
        
        List<ContentDocumentLink> cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId	= :homeServiceId];
        if (cdl != null && cdl.size() > 0) {
            List<Id> cdIds = new List<Id>();
            
            for (Integer i = 0; i < cdl.size(); i++) {
                cdIds.add(cdl[i].ContentDocumentId);
            }
            
            List<ContentDocument> cd = [SELECT LatestPublishedVersionId, Title, FileType, FileExtension FROM ContentDocument WHERE (Id IN :cdIds AND Title = 'Walk-Through Form' AND IsDeleted = false) LIMIT 1];
            if (cd != null && cd.size() > 0) {
                for (Integer i = 0; i < cdl.size(); i++) {
                    if (cd[0].Id == cdl[i].ContentDocumentId) {
                        io.put('formContentDocumentLink', cdl[i]);
                        break;
                    }
                }
                
                io.put('formContentDocument', cd[0]);
                
                List<ContentVersion> cv = [SELECT Id FROM ContentVersion WHERE (ContentDocumentId = :cd[0].Id AND IsLatest = true AND IsDeleted = false)];
                if (cv != null && cv.size() > 0) {
                    io.put('formContentVersion', cv[0]);
                }
            }
        }
    }
    
	@AuraEnabled
    public static Map<String, sObject> getData(String recordId) {
        Map<String, sObject> ret = new Map<String, sObject>();
        ret.put('event', null);
        ret.put('assignedTo', null);
        ret.put('homeService', null);
        ret.put('formContentDocumentLink', null);
        ret.put('formContentDocument', null);
        ret.put('formContentVersion', null);
        
        Id rId = (Id) recordId;
        String rType = rId.getSobjectType().getDescribe().getLocalName();
        
        if (rType == 'Home_Services__c') {
            List<Home_Services__c> homeService = [SELECT Walk_Thru_Complete__c, Walk_Thru_Form_Uploaded__c, Costs_In_Line__c, Walk_Thru_Notes__c FROM Home_Services__c WHERE Id = :recordId LIMIT 1];
            
            if (homeService != null && homeService.size() > 0) {
                ret.put('homeService', homeService[0]);
                getFormContentDocumentLink(ret, homeService[0].Id);
            }
        } else if (rType == 'Event') {
            List<Event> event = [SELECT Home_Service__c, OwnerId FROM Event WHERE Id = :recordId LIMIT 1];
            
            if (event != null && event.size() > 0) {
                ret.put('event', event[0]);
                
                List<Home_Services__c> homeService = [SELECT Walk_Thru_Complete__c, Walk_Thru_Form_Uploaded__c, Costs_In_Line__c, Walk_Thru_Notes__c FROM Home_Services__c WHERE Id = :event[0].Home_Service__c LIMIT 1];
                if (homeService != null && homeService.size() > 0) {
                    ret.put('homeService', homeService[0]);
                    getFormContentDocumentLink(ret, homeService[0].Id);
                }
                
                List<User> assignedTo = [SELECT Id FROM User WHERE Id = :event[0].OwnerId LIMIT 1];
                if (assignedTo != null && assignedTo.size() > 0) {
                    ret.put('assignedTo', assignedTo[0]);
                }
            }
        }
        
        System.debug(ret);
        return ret;
    }
    
    @AuraEnabled
    public static Map<String, sObject> updateAll(String recordId, Home_Services__c homeService) {
        update homeService;
        
        return getData(recordId);
    }
    
    @AuraEnabled
    public static Map<String, sObject> replaceForm(ContentDocumentLink oldContentDocumentLink, ContentDocument oldContentDocument, ContentVersion oldContentVersion, String newFileId, String homeServiceId, String recordId) {
        Map<String, sObject> ret = new Map<String, sObject>();
        ret.put('formContentDocumentLink', null);
        ret.put('formContentDocument', null);
        ret.put('formContentVersion', null);
        
        Id rId = (Id) recordId;
        String rType = rId.getSobjectType().getDescribe().getLocalName();
        
        // Delete the old objects if they exist
        if (oldContentDocumentLink != null) {
            delete oldContentDocumentLink;
        }
        
        if (oldContentDocument != null) {
            delete oldContentDocument;
        }
        
        if (oldContentVersion != null) {
            // "DML operation Delete not allowed on ContentVersion"
            //delete oldContentVersion;
        }
        
        // Fetch the new objects, if available
        List<ContentDocumentLink> cdlResult;
        List<ContentDocument> cdResult;
        List<ContentVersion> cvResult;
        
        ContentDocumentLink newCdl;
        
        if (newFileId != null && newFileId.trim().length() > 0 && homeServiceId != null && homeServiceId.trim().length() > 0) {
            cdResult = [SELECT Title, LatestPublishedVersionId FROM ContentDocument WHERE (Id = :newFileId AND IsDeleted = false) LIMIT 1];
            
            if (cdResult != null && cdResult.size() > 0) {
                cdlResult = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE (ContentDocumentId = :cdResult[0].Id AND LinkedEntityId = :recordId AND IsDeleted = false) LIMIT 1];
                
                if (cdlResult != null && cdlResult.size() > 0) {
                    // The uploaded file is linked to the Event if the component was run from an Event's record page.
                    // If attached to an event, this needs to be updated so that it's linked to the Home Service instead.
                    // However, since LinkedEntityId is not writable, we need to clone the ContentDocumentLink and delete the old link if the attachment is related to an Event and not a Home Service.
                    if (rType == 'Event') {
                        newCdl = cdlResult[0].clone();
                        newCdl.LinkedEntityId = homeServiceId;
                        insert newCdl;
                        delete cdlResult[0];
                        
                        ret.put('formContentDocumentLink', newCdl);
                    } else if (rType == 'Home_Services__c') {
                        // Else, if this is a Home Service, no updates are needed. Return the CDL as-is.
                        ret.put('formContentDocumentLink', cdlResult[0]);
                    }
                }
                
                // Set the new record's ContentDocument's title to "Walk-Through Form".
                cdResult[0].Title = 'Walk-Through Form';
                update cdResult[0];
				ret.put('formContentDocument', cdResult[0]);
                
                cvResult = [SELECT Id FROM ContentVersion WHERE (Id = :cdResult[0].LatestPublishedVersionId AND IsDeleted = false AND IsLatest = true) LIMIT 1];
                    
                if (cvResult != null && cvResult.size() > 0) {
                    ret.put('formContentVersion', cvResult[0]);
                }
            }
        }
        
        return ret;
    }
}