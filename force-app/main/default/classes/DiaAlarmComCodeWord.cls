/**
* Diaco
* @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiaAlarmComCodeWord Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		10/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
public class DiaAlarmComCodeWord {
	@AuraEnabled
    public static List<DiacoAlarm__DiacoCodeWord__c> getCodeWords(String recordId){
        return [select Name, DiacoAlarm__DiacoCodeWord__c, DiacoAlarm__CodeWordQuestion__c,
                DiacoAlarm__DiacoStatus__c
               from DiacoAlarm__DiacoCodeWord__c where DiacoAlarm__DIacoSiteAvantguard__r.DiacoAlarm__Diaco_Customer_Alarm__c =: recordId];
    }
    
    @AuraEnabled
    public static DiacoAlarm__DiacoSiteAvantguard__c getSite(String recordId) {
        List<DiacoAlarm__DiacoSiteAvantguard__c> site = [select Id from DiacoAlarm__DiacoSiteAvantguard__c 
                                                         where DiacoAlarm__Diaco_Customer_Alarm__c =: recordId];
        return site[0];
    }
    
    @AuraEnabled
    public static void deleteCodeWord(String recordId) {
        DiacoAlarm__DiacoCodeWord__c codeWord = new DiacoAlarm__DiacoCodeWord__c(
        	Id = recordId
        );
        delete codeWord;
    }
}