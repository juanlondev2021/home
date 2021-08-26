/**
* Diaco
* @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiaAlarmComDevice Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		10/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
public class DiaAlarmComDevice {
	@AuraEnabled
    public static List<DiacoAlarm__DiacoDevice__c> getDevices(String recordId){
        return [select Name, DiacoAlarm__Diacostatus__c
               from DiacoAlarm__DiacoDevice__c where DiacoAlarm__DiacoCustomerAlarm__c =: recordId];
    }
    
    @AuraEnabled
    public static void deleteDevice(String recordId) {
        DiacoAlarm__DiacoDevice__c device = new DiacoAlarm__DiacoDevice__c(
        	Id = recordId
        );
        delete device;
    }
}