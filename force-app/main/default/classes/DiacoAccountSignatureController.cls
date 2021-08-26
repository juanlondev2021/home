/**
 * Diaco
 * @author 			Fabian Pineda href=<fpineda@diaco.us>
 * Project:			Account Signatures
 * Description:		Controller for Aura component diacoAccountSignature.cmp
 *
 * Changes (Version)
 * _________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		02/07/2020		Fabian Pineda (FP)		Initial version
 **/
public class DiacoAccountSignatureController {
	@AuraEnabled
    public static Map<String, sObject> getSignature(String recordId) {
        Map<String, sObject> ret = new Map<String, sObject>();
        ret.put('ContentDocumentLink', null);
        ret.put('ContentDocument', null);
        ret.put('ContentVersion', null);
        
        List<ContentDocumentLink> cdl;
        List<Id> cdlIds = new List<Id>();
        
        List<ContentDocument> cd;
        List<ContentVersion> cv;
        
        if (recordId != null && recordId.trim().length() > 0) {
            cdl = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE (LinkedEntityId = :recordId AND IsDeleted = false)];
            
            if (cdl != null && cdl.size() > 0) {
                for (Integer i = 0; i < cdl.size(); i++) {
                    cdlIds.add(cdl[i].ContentDocumentId);
                }
                
                cd = [SELECT LatestPublishedVersionId FROM ContentDocument WHERE (Id IN :cdlIds AND IsDeleted = false AND Title = 'Account Signature') LIMIT 1];
                
                if (cd != null && cd.size() > 0) {
                    for (Integer i = 0; i < cdl.size(); i++) {
                        if (cdl[i].ContentDocumentId == cd[0].Id) {
                            ret.put('ContentDocumentLink', cdl[i]);
                            break;
                        }
                    }
                    
                    ret.put('ContentDocument', cd[0]);
                    
                    cv = [SELECT Dealer_Certification_Title__c, Dealer_Certification_Name__c FROM ContentVersion WHERE (Id = :cd[0].LatestPublishedVersionId AND IsDeleted = false AND IsLatest = true) LIMIT 1];
                    
                    if (cv != null && cv.size() > 0) {
                        ret.put('ContentVersion', cv[0]);
                    }
                }
            }
        }
        
        return ret;
    }
    
    @AuraEnabled
    public static Map<String, sObject> replaceSignature(ContentDocumentLink oldContentDocumentLink, ContentDocument oldContentDocument, ContentVersion oldContentVersion, String newFileId, String accountId) {
        Map<String, sObject> ret = new Map<String, sObject>();
        ret.put('ContentDocumentLink', null);
        ret.put('ContentDocument', null);
        ret.put('ContentVersion', null);
        
        // Keep important values in temporal variables before deletion, if available
        String dealerCertificationTitle = null;
        if (oldContentVersion != null && oldContentVersion.Dealer_Certification_Title__c != null) {
            dealerCertificationTitle = oldContentVersion.Dealer_Certification_Title__c;
        }
        
        String dealerCertificationName = null;
        if (oldContentVersion != null && oldContentVersion.Dealer_Certification_Name__c != null) {
            dealerCertificationName = oldContentVersion.Dealer_Certification_Name__c;
        }
        
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
        
        if (newFileId != null && newFileId.trim().length() > 0 && accountId != null && accountId.trim().length() > 0) {
            cdResult = [SELECT Title, LatestPublishedVersionId FROM ContentDocument WHERE (Id = :newFileId AND IsDeleted = false) LIMIT 1];
            
            if (cdResult != null && cdResult.size() > 0) {
                cdlResult = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE (ContentDocumentId = :cdResult[0].Id AND LinkedEntityId = :accountId AND IsDeleted = false) LIMIT 1];
                
                if (cdlResult != null && cdlResult.size() > 0) {
                    ret.put('ContentDocumentLink', cdlResult[0]);
                }
                
                // Set the new record's ContentDocument's title to "Account Signature".
                cdResult[0].Title = 'Account Signature';
                update cdResult[0];
				ret.put('ContentDocument', cdResult[0]);
                
                cvResult = [SELECT Dealer_Certification_Title__c, Dealer_Certification_Name__c FROM ContentVersion WHERE (Id = :cdResult[0].LatestPublishedVersionId AND IsDeleted = false AND IsLatest = true) LIMIT 1];
                    
                if (cvResult != null && cvResult.size() > 0) {
                    // Update the new record's ContentVersion with the old record's data, if available.
                    cvResult[0].Dealer_Certification_Title__c = dealerCertificationTitle;
                    cvResult[0].Dealer_Certification_Name__c = dealerCertificationName;
                    update cvResult[0];
                    
                    ret.put('ContentVersion', cvResult[0]);
                }
            }
        }
        
        return ret;
    }
}