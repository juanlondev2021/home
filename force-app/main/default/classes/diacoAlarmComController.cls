/**
* Diaco
* @author 			Álvaro José Ortega Vargas href=<aovargassf@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiacoContract Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		10/07/2019		Álvaro Orteg (AO)		Initial implementation of the class.
**/
public class diacoAlarmComController {
    @AuraEnabled
    public static DiacoAlarm__Diaco_Customer_Alarm__c saveHomeService(Id homeServiceId, DiacoAlarm__Diaco_Customer_Alarm__c customer, string action) {
        try {
            if( action == 'update' ) {
                update customer;
    
            }else if( action == 'insert' ) {
                DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c[] setupAlarmInstance = [SELECT Id FROM DiacoAlarm__Diaco_Setup_Alarm_Instance_Security__c  ORDER BY CreatedDate DESC LIMIT 1];
                
                if( !setupAlarmInstance.isEmpty() ) {
                    customer.DiacoAlarm__DiacoInstanceWebserviceCutomer__c = setupAlarmInstance[0].Id;
                    insert customer;
                    
                    Home_Services__c hs = new Home_Services__c(Id = homeServiceId);
                        hs.Customer_Alarm__c = customer.Id;
                    update hs;
        
                    DiacoAlarm__DiacoSiteContact__c contact = new DiacoAlarm__DiacoSiteContact__c();
                    contact.Name                                = customer.DiacoAlarm__DiacoFirstNameAddress__c + ' ' + customer.DiacoAlarm__DiacoLastnameAddress__c;
                    contact.DiacoAlarm__DiacoCustomerAlarm__c   = customer.Id;
                    contact.DiacoAlarm__DiacoKeyType__c         = 'Site';
                    contact.DiacoAlarm__DiacoPhone__c           = customer.DiacoAlarm__DiacoPhoneAddress__c;
                    contact.DiacoAlarm__DiacoFirstName__c       = customer.DiacoAlarm__DiacoFirstNameAddress__c;
                    contact.DiacoAlarm__DiacoLastName__c        = customer.DiacoAlarm__DiacoLastnameAddress__c;
                    contact.DiacoAlarm__DiacoECVFlag__c         = true;
                    contact.DiacoAlarm__DiacoAuthority__c       = '12';
                    contact.DiacoAlarm__DiacoRelation__c        ='- Own';
                    insert contact;
                }else{
                    throw new AuraHandledException('You need to create an Instance Web Service Customer');
                }
            }
            return customer;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
    
   @AuraEnabled
   public static Home_Services__c getRecordTypeFromHS(String RecordId){
       Home_Services__c home =  [select Id,RecordType.Name from Home_Services__c where Id = :RecordId];
       return home;
   }
    
   @AuraEnabled
   public static String getRecordIdFromEvent(String RecordId){
       Event e =  [select Id,Home_Service__c from Event where Id = :RecordId];
       return e.Home_Service__c;
   }
    
   @AuraEnabled
   public static String getObjectType(String RecordId){
       String objectAPIName = '';
       String keyPrefix = RecordId.substring(0,3);
       for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
           String prefix = obj.getDescribe().getKeyPrefix();
           if(prefix == keyPrefix){
               objectAPIName = obj.getDescribe().getName();
               break;
           }
       }
       return objectAPIName;
   	}
    
   @AuraEnabled
   public static Account getAccount(String RecordId){
       Home_Services__c home =  [select Id,Account__c from Home_Services__c where Id = :RecordId];
       Account a =  [select Id,Name,AcctFirstName__c,AcctLastName__c,PersonEmail,Customer_Company_Name__c,City__c,State__c,Zip__c,Street__c,Phone from Account where Id=:home.Account__c];
       return a;
   }
    
   @AuraEnabled
   public static List<DiacoAlarm__DiacoSiteContact__c> getSiteContacts(String recordId){
       List<DiacoAlarm__DiacoSiteContact__c> cs =  [select Id, Name,DiacoAlarm__DiacoCustomerAlarm__r.Name, DiacoAlarm__DiacoStatus__c from DiacoAlarm__DiacoSiteContact__c where DiacoAlarm__DiacoCustomerAlarm__c=:recordId order by CreatedDate desc];
       return cs;
   }
   
   @AuraEnabled
   public static string deleteSiteContact(String recordId){
       DiacoAlarm__DiacoSiteContact__c c = new DiacoAlarm__DiacoSiteContact__c();
       c.Id = recordId;
       delete c;
       return recordId;
   }
    
   @AuraEnabled
   public static DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c getLastInstance(){
       List<DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c> is =  [select Id,Name from DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c order by CreatedDate desc];
       if(is.size() > 0){
           return is[0];
       }
       return null;
   }
   
   @AuraEnabled
   public static List<DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c> getInstances(){
       List<DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c> is =  [select Id,Name from DiacoAlarm__DiacoSetUpAvantguardInstanceSecurity__c order by CreatedDate desc];
       if(is.size() > 0){
           return is;
       }
       return null;
   }
   /* 
   @AuraEnabled
   public static List<DiacoAlarm__DiacoDeviceType__c> getDeviceType(String recordId){
        return [select Id,Name,DiacoAlarm__DiacoInstanceSecurityAvantguard__c 
                from DiacoAlarm__DiacoDeviceType__c 
                where DiacoAlarm__DiacoInstanceSecurityAvantguard__c =:recordId order by CreatedDate desc];
    }*/
    
    @AuraEnabled
    public static DiacoAlarm__DiacoSiteAvantguard__c getSite(String recordId){

        List<DiacoAlarm__DiacoSiteAvantguard__c> s =  [ SELECT  Name, DiacoAlarm__Diaco_Customer_Alarm__r.Name,
                                                                DiacoAlarm__Diaco_Customer_Alarm__r.DiacoAlarm__DiacoMonitoringStatitionStatus__c, 
                                                                DiacoAlarm__DiacoAuthority__c,
                                                                DiacoAlarm__DiacoInstanceSecurityAvantguard__c,DiacoAlarm__DiacoSiteName__c,
                                                                DiacoAlarm__DiacoSiteNum__c,DiacoAlarm__DiacoSiteLanguage__c,
                                                                DiacoAlarm__SubDivision__c,DiacoAlarm__DiacoULCode__c,
                                                                DiacoAlarm__DiacoDevNum__c,DiacoAlarm__DiacoTransmitterCode__c,
                                                                DiacoAlarm__DiacoPets__c,DiacoAlarm__DiacoSiteID1__c,
                                                                DiacoAlarm__DiacoSiteID2__c,DiacoAlarm__DiacoDispatchType__c,
                                                                DiacoAlarm__DiacoReportFrequency__c,DiacoAlarm__DiacoRunawayThreshold__c,
                                                                DiacoAlarm__DiacoSiteType__c,DiacoAlarm__DiacoCrossStreet__c,
                                                                DiacoAlarm__DiacoDirections__c,DiacoAlarm__DiacoMap__c,
                                                                DiacoAlarm__DiacoMapPage__c,DiacoAlarm__DiacoMapCoordinates__c,
                                                                DiacoAlarm__DiacoRegion__c,DiacoAlarm__DiacoTimeZoneNum__c
                                                        FROM DiacoAlarm__DiacoSiteAvantguard__c 
                                                        WHERE DiacoAlarm__Diaco_Customer_Alarm__c=:recordId limit 1];

        if(s.size() > 0){
            return s[0];
        }
        return null;
    }

    @AuraEnabled
    public static DiacoAlarm__DiacoSiteAvantguard__c set_avanguard(DiacoAlarm__DiacoSiteAvantguard__c siteAvenguard) {

        update siteAvenguard;
        return siteAvenguard;
    }
    
    @AuraEnabled
    public static DiacoAlarm__Diaco_Customer_Alarm__c getDataCustomerOne(String RecordId) {
        
        Home_Services__c home =  [SELECT Customer_Alarm__c FROM Home_Services__c WHERE Id = :RecordId];

        List<DiacoAlarm__Diaco_Customer_Alarm__c> ca = [SELECT  Id, Name, OwnerId, DiacoAlarm__DiacoPropertyType__c, DiacoAlarm__DiacoPendingUpdateAvantguard__c,
                                                                DiacoAlarm__DiacoPendingUpdateAvantguardDev__c, Home_Service__c, 
                                                                DiacoAlarm__DiacoCompanyNameAddress__c,DiacoAlarm__DiacoFirstNameAddress__c,
                                                                DiacoAlarm__DiacoLastnameAddress__c,DiacoAlarm__DiacoCustomerAccountEmail__c,
                                                                DiacoAlarm__DiacoDesiredLoginName__c,DiacoAlarm__DiacoCountryIdAddressWithName__c,
                                                                DiacoAlarm__DiacoCityAddressWithName__c,DiacoAlarm__DiacoStateAddressWithName__c,
                                                                DiacoAlarm__DiacoZipCodeAddressWithName__c,DiacoAlarm__DiacoStreet1AddressWithName__c,
                                                                DiacoAlarm__DiacoStreet2AddressWithName__c,DiacoAlarm__DiacoPhoneAddress__c,
                                                                DiacoAlarm__DiacoSameContactAddress__c,DiacoAlarm__DiacoInstallationTimeZone__c,
                                                                DiacoAlarm__DiacoCountryId__c,DiacoAlarm__DiacoState__c,
                                                                DiacoAlarm__DiacoCity__c,DiacoAlarm__DiacoStreet1__c,DiacoAlarm__DiacoZipCode__c,
                                                                DiacoAlarm__DiacoStreet2__c,DiacoAlarm__DiacoSalesRepLoginName__c,
                                                                DiacoAlarm__DiacoInstallerLoginName__c,DiacoAlarm__DiacoContractLengthInMonths__c,
                                                                DiacoAlarm__DiacoContractEndDate__c,DiacoAlarm__DiacoPanelType__c,
                                                                DiacoAlarm__DiacoModemSerialNumber__c,DiacoAlarm__DiacoPhoneLinePresent__c,
                                                                DiacoAlarm__DiacoCentralStationForwardingOption__c,DiacoAlarm__DiacoCentralStationAccountNumber__c,
                                                                DiacoAlarm__DiacoCsEventGroupsToForward__c,DiacoAlarm__DiacoCustomerAccountPhone__c,
                                                                DiacoAlarm__DiacoCentralStationReceiverNumber__c,DiacoAlarm__DiacoInstanceWebserviceCutomer__c,
                                                                DiacoAlarm__DiacoCustomerId__c,DiacoAlarm__DiacoCreatedLoginName__c,DiacoAlarm__DiacoStatus__c,
                                                                DiacoAlarm__DiacoCreatedPassword__c, DiacoAlarm__DiacoPackageId__c
                                                        FROM  DiacoAlarm__Diaco_Customer_Alarm__c
                                                        WHERE Id =: home.Customer_Alarm__c];

        if ( ca.size() > 0 ) {
            return ca[0];
        }
        return null;
    }
    
    @AuraEnabled        
    public static List<Map<String, String>> getPickListValues(String objectName, List<String> picklistFields) {
    
        return diacoKnifeFunc.getPicklistValues(objectName, picklistFields);
    }
}