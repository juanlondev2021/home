/**
* Diaco
* @author 			Kevin Vega Hernandez href=<kevin.vega.h@hotmail.com>
* Project:			Finance Component
* Description:		Migrate the Finance Component from SFI Org to Home Service Org .
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						 Description
*			-----	----------		--------------------		 ---------------
* @version	1.0		30/06/2020		Kevin Vega Hernandez (KVH)	 Migrate the Finance Component from SFI Org to Home Service Org. 
**/

public class DiacoFinanceClass {

    /*
     @AuraEnabled
    public static List<Finance__c> getInfo_Finance_package(){ 
        
        list<Finance__c> info = [select 
                                 Id, 
                                 Name, 
                                 Package_Price__c,
                                 Monitoring__c,
                                 Promotional_Discount__c,
                                 Monthly_Renewal_FINANCE__c,				
                                 Monthly_Renewal_PROMOTION__c,				
                                 Monthly_Term_FINANCE__c,			
                                 Monthly_Term_PROMOTION__c  from Finance__c ORDER BY CreatedDate];
        
        return info;
    }
    
    @AuraEnabled
    public static Home_Services__c getInfo_Finance(Id recordId){
        
        Home_Services__c info = new Home_Services__c();
        
        if(recordId != null){
            if(recordId.getSObjectType().getDescribe().getName() == 'Event'){
                Id  recordIdFromEvent = [select Id,WhatId from Event where Id=:recordId].WhatId;
                recordId = recordIdFromEvent;
            }
            
            if(recordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                info = [select Id, In_house__c,Total_Monthly_Investment__c, Package_Name_FINANCE__c, Type_of_order_FINANCE__c from Home_Services__c where Id=:recordId];
            }
        }
        return info;
    }
    
    @AuraEnabled
    public static void setInfo_Finance(Id recordId, decimal valueOfFinance, decimal valueOfFinanceTotal, 
                                    String packageName, String typeOfOrder, decimal installFee, decimal rmr,
                                    boolean InHouse,decimal EPBT) { 
      
      if(recordId != null){                                  
            if(recordId.getSObjectType().getDescribe().getName() == 'Event'){
               Id recordIdFromEvent = [select Id,WhatId from Event where Id=:recordId].WhatId;
               recordId = recordIdFromEvent;
            }                               
                                            
            if(recordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){                                
           
                Home_Services__c homeService = new Home_Services__c(
                    Id = recordId,
                    Package_Name_FINANCE__c = packageName,
                    Type_of_order_FINANCE__c = typeOfOrder,
                    Install_Fee__c = installFee,
                   	RMR__c = rmr,
                   	Equipment_Payment_Before_Tax__c = EPBT,
                    In_house__c = InHouse 
                );                               
                 
                  //  finance.Equipment_Charge__c = valueOfFinanceTotal;
                  //  finance.Monitoring_Center__c = valueOfFinance;
                    
                   // finance.Install_Fee__c = installFee;
                   // finance.RMR__c = rmr;
                   // finance.Equipment_Payment_Before_Tax__c = EPBT;
            
                update homeService;      
       
            }
    	}
    }                                   
    @AuraEnabled
    public static void setInHouse(Id recordId, boolean InHouse) {
        
        if(recordId != null){          
            if(recordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:recordId].WhatId;
                recordId = recordIdFromEvent;
            }
            
            if(recordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                
                Home_Services__c finance_updated = new Home_Services__c(Id=recordId,In_house__c =InHouse );
                
                update finance_updated; 
            }
        }
    }
    
    @AuraEnabled
    public static Finance__c create_update_Finance_package(Finance__c newPackage){ 
        
        upsert newPackage; 
        
        return newPackage;
    } 
    
    @AuraEnabled
    public static List<Finance__c> delete_Finance_package(Id packageId){ 
       
        Finance__c deletePackage = new Finance__c(Id=packageId);
        
        delete deletePackage; 
        
        return getInfo_Finance_package();
    }
    
    @AuraEnabled
    public static Home_Services__c getRecordTypeFromHS(Id RecordId){
        if(RecordId != null){          
            if(RecordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:RecordId].WhatId;
                RecordId = recordIdFromEvent;
            }
            
            if(RecordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                
                Home_Services__c home =  [select Id,RecordType.Name,In_house__c,Type_of_order_FINANCE__c from Home_Services__c where Id = :RecordId];
                PaymentMethod__c PayM = new PaymentMethod__c();
                List<DiacoAlarm__Diaco_Customer_Alarm__c> Alarm = new List<DiacoAlarm__Diaco_Customer_Alarm__c>();
                Alarm = [Select DiacoAlarm__DiacoModemSerialNumber__c,DiacoAlarm__DiacoPanelType__c From DiacoAlarm__Diaco_Customer_Alarm__c where Home_Service__c=:RecordId];
                try{
                    PayM = [select id from PaymentMethod__c Where HomeService__c=:RecordId And PaymentMethodType__c='ACH'];
                }catch(DmlException e){
                    PayM.Id=null;
                }
                if(home.Type_of_order_FINANCE__c=='Finance' && PayM.Id!=null){
                    return home;
                }
            }
        }
        return null;
    }
    
   
    
    @AuraEnabled
    public static Integer thereAreSigned(Id RecordId){
        List<ddsign__Envelope__c> evs = new List<ddsign__Envelope__c>();
        if(RecordId != null){          
            if(RecordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:RecordId].WhatId;
                RecordId = recordIdFromEvent;
            }
            
            if(RecordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                evs = [select Id, ddsign__status__c,LastModifiedDate
                       from ddsign__Envelope__c
                       where Home_Service__c = :RecordId and (ddsign__status__c = 'signed' or ddsign__status__c = 'completed') and 
                       ddsign__DiacoSign_User__r.Name='Pinnacle Finance' order by LastModifiedDate desc limit 1];

            }
        }
        return evs.size();
    }
    
    @AuraEnabled
    public static Id sendToDocusign(Id homeserviceId){
        if(homeserviceId != null){          
            if(homeserviceId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:homeserviceId].WhatId;
                homeserviceId = recordIdFromEvent;
            }
            
            if(homeserviceId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                List<docuSignConf__c> auth = [select password_PFC__C from docuSignConf__c];
                List<ddsign__DiacoSign_User__c> userD = new List<ddsign__DiacoSign_User__c>();
                try{
                    userD = [select Id, name, ddsign__baseUrl__c, ddsign__IntegratorKey__c, ddsign__Password__c, 
                             ddsign__Username__c, ddsign__DiacoSign_Account__r.ddsign__Url_Server__c
                             From ddsign__DiacoSign_User__c 
                             where name = 'Pinnacle Finance' LIMIT 1];
                }catch(DmlException e){
                    
                }
                ddsign.diacoSignHttpRequests dshr = new ddsign.diacoSignHttpRequests();
                String body = diacoDocusignApiRestIntegrationJson.Completion_Certificate_Template(homeserviceId, '07a82c1e-95da-4b08-bd27-e7933d3100c9');
                HttpResponse res = new HttpResponse();
                Map<String, Object> mapRes = new Map<String, Object>();
                if(!Test.isRunningTest()){
                    res = dshr.sendEnvelope(userD[0].ddsign__baseUrl__c, userD[0].ddsign__Username__c, 
                                            auth[0].password_PFC__c, userD[0].ddsign__IntegratorKey__c, body);
                    
                    system.debug('status'+res.getStatus());
                    ddsign.diacoSignJsonFunctions dsjf = new ddsign.diacoSignJsonFunctions();
                    mapRes = dsjf.deserializeResponse(res);
                }else{
                    mapRes.put('envelopeId', '0000');
                    mapRes.put('status', 'sent');
                }
                List<ddsign__Pre_Designed_Envelope__c> pevs = new List<ddsign__Pre_Designed_Envelope__c>();
                pevs = [select Id from ddsign__Pre_Designed_Envelope__c where Name='Pinnacle Contract'];
                ddsign__Envelope__c env =  new ddsign__Envelope__c(
                    ddsign__shipping_type__c = 'Manually',
                    ddsign__Pre_Designed_Envelope__c=pevs[0].Id,
                    Home_Service__c = homeserviceId,
                    ddsign__DiacoSign_User__c = userD[0].Id,
                    ddsign__Envelope_Id__c = String.valueOf(mapRes.get('envelopeId')),
                    ddsign__Sent_Date__c = DateTime.now(),
                    ddsign__status__c = String.valueOf(mapRes.get('status'))
                );
                insert env;
                return env.Id;
            }
        }
        return null;
    }
*/
    
     @AuraEnabled
    public static Boolean getAlarmField(Id RecordId){
        /*
        if(RecordId != null){          
            if(RecordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:RecordId].WhatId;
                RecordId = recordIdFromEvent;
            }
          */  
            if(RecordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                List<DiacoAlarm__Diaco_Customer_Alarm__c> Alarm = new List<DiacoAlarm__Diaco_Customer_Alarm__c>();
                Alarm = [Select DiacoAlarm__DiacoModemSerialNumber__c,DiacoAlarm__DiacoPanelType__c From DiacoAlarm__Diaco_Customer_Alarm__c where Home_Service__c=:RecordId];
                return (Alarm.size()>0?((Alarm[0].DiacoAlarm__DiacoModemSerialNumber__c!=null && Alarm[0].DiacoAlarm__DiacoModemSerialNumber__c!=null)?true:false):false);
            }
        
        return null;
    }
}