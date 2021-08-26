/**
* Diaco
* @author 			Kevin Vega Hernandez href=<kevin.vega.h@hotmail.com>
* Project:			Finance Component
* Description:		New Finance Component to HS. 
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						 Description
*			-----	----------		--------------------		 ---------------
* @version	1.0		07/09/2020		Kevin Vega Hernandez (KVH)	 New Finance Component to HS. 
**/
public class DiacoFinance2Class {
    
    @AuraEnabled
    public static Finance_Package__c getInfo_Finance(){ 
        
        list<Finance_Package__c> info = [select 
                                         Id,
                                         Name,
                                         X12_Months_Same_As_Cash__c,
                                         Activation_Emergency_Video_LEASE__c,
                                         Activation_Emergency_Video_PURCHASE__c,
                                         Customer_Owned_LEASE__c,
                                         Customer_Owned_PURCHASE__c,
                                         Equipment_Min_Payment__c,
                                         Monitoring__c,
                                         Monthly_Payment_LEASE__c,
                                         Monthly_Payment_PURCHASE__c,
                                         Monthly_Renewal_LEASE__c,
                                         Monthly_Renewal_PURCHASE__c,
                                         Monthly_Term_LEASE__c,
                                         Monthly_Term_PURCHASE__c,
                                         Payment_Factor__c,
                                         Purchase__c,
                                         Tax__c,
                                         Total_Min_Payments__c,
                                         type__c,
                                         Video__c,
                                         APR__c,
                                         Payment_Number__c
                                         from Finance_Package__c where name='Default'];
        
        if(info.size() == 0){
            return new Finance_Package__c();
        }
        
        Finance_Package__c infoFinance = info[0];     
        
        return infoFinance;
        
    }
    
    @AuraEnabled
    public static Finance_Package__c create_update_Finance(Finance_Package__c financeInfo){ 
        upsert financeInfo; 
        return financeInfo;
    }

    @AuraEnabled
    public static Finance_Package__c getInfo_Finance_HS_With_Tax(Id recordId, id hsId) {
        Finance_Package__c financePackage = new Finance_Package__c();
        List<Home_Services__c> hs;
        
        if(recordId != null){   
            list<Finance_Package__c> info = [select 
                                             Id,
                                             Name,
                                             X12_Months_Same_As_Cash__c,
                                             Activation_Emergency_Video_LEASE__c,
                                             Activation_Emergency_Video_PURCHASE__c,
                                             Customer_Owned_LEASE__c,
                                             Customer_Owned_PURCHASE__c,
                                             Equipment_Min_Payment__c,
                                             Monitoring__c,
                                             Monthly_Payment_LEASE__c,
                                             Monthly_Payment_PURCHASE__c,
                                             Monthly_Renewal_LEASE__c,
                                             Monthly_Renewal_PURCHASE__c,
                                             Monthly_Term_LEASE__c,
                                             Monthly_Term_PURCHASE__c,
                                             Payment_Factor__c,
                                             Purchase__c,
                                             Tax__c,
                                             Total_Min_Payments__c,
                                             type__c,
                                             Video__c,
                                             APR__c,
                                             Payment_Number__c
                                             from Finance_Package__c where Id=:recordId];
            
            if(info.size() == 0){
                if (hsId != null) {
                    hs = [SELECT Tax__c FROM Home_Services__c WHERE Id = :hsId LIMIT 1];

                    if (hs != null && hs.size() > 0) {
                        financePackage = new Finance_Package__c(Tax__c = hs[0].Tax__c == 'Yes');
                    } else {
                        financePackage = new Finance_Package__c(Tax__c = false);
                    }
                } else {
                    financePackage = new Finance_Package__c(Tax__c = false);
                }

                return financePackage;
            } 

            financePackage = info[0];
            
        }else{
            list<Finance_Package__c> info = [select 
                                             Id,
                                             Name,
                                             X12_Months_Same_As_Cash__c,
                                             Activation_Emergency_Video_LEASE__c,
                                             Activation_Emergency_Video_PURCHASE__c,
                                             Customer_Owned_LEASE__c,
                                             Customer_Owned_PURCHASE__c,
                                             Equipment_Min_Payment__c,
                                             Monitoring__c,
                                             Monthly_Payment_LEASE__c,
                                             Monthly_Payment_PURCHASE__c,
                                             Monthly_Renewal_LEASE__c,
                                             Monthly_Renewal_PURCHASE__c,
                                             Monthly_Term_LEASE__c,
                                             Monthly_Term_PURCHASE__c,
                                             Payment_Factor__c,
                                             Purchase__c,
                                             Tax__c,
                                             Total_Min_Payments__c,
                                             type__c,
                                             Video__c,
                                             APR__c,
                                             Payment_Number__c
                                             from Finance_Package__c where Name='Default'];

            if (hsId != null) {
                hs = [SELECT Tax__c FROM Home_Services__c WHERE Id = :hsId LIMIT 1];
            }
            
            if(info.size() == 0){
                if (hs != null && hs.size() > 0) {
                    financePackage = new Finance_Package__c(Tax__c = hs[0].Tax__c == 'Yes');
                } else {
                    financePackage = new Finance_Package__c(Tax__c = false);
                }

                return financePackage;
            } else if (hs != null && hs.size() > 0) {
                info[0].Tax__c = hs[0].Tax__c == 'Yes';
            }
            
            financePackage = info[0];
        }

        return financePackage;     
    }
    
    // Method name kept for compatibility with existing code.
    @AuraEnabled
    public static Finance_Package__c getInfo_Finance_HS(Id recordId){ 
        return getInfo_Finance_HS_With_Tax(recordId, null);
    }
    
    @AuraEnabled
    public static Home_Services__c getInfo_HS(Id recordId){
        
        Home_Services__c info = new Home_Services__c();
        
        if(recordId != null){
            if(recordId.getSObjectType().getDescribe().getName() == 'Event'){
                Id  recordIdFromEvent = [select Id,WhatId from Event where Id=:recordId].WhatId;
                recordId = recordIdFromEvent;
            }
            
            if(recordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                info = [select Id,FinanceId__c from Home_Services__c where Id=:recordId];
            }
        }
        return info;
    }
    
    @AuraEnabled
    public static Finance_Package__c create_update_Finance_HS(Id recordId,Finance_Package__c financeInfo){ 
        String newTaxValue = financeInfo.Tax__c ? 'Yes' : 'No';

        if(financeInfo.Id == null){
            System.debug(financeInfo.Id);
            insert financeInfo;

            if (recordId != null) {
                Home_Services__c homeService = new Home_Services__c(Id = recordId,FinanceId__c =financeInfo.Id, 
                Tax__c = newTaxValue,
                APR__c =financeInfo.APR__c,
                Number_of_payments__C=String.valueof(financeInfo.Payment_Number__c));
                update homeService;
            }
        }else{
            update financeInfo;

            if (recordId != null) {
                Home_Services__c homeService = new Home_Services__c(Id = recordId, Tax__c = newTaxValue,
                                                                    APR__c =financeInfo.APR__c,
                                                                    Number_of_payments__C=String.valueof(financeInfo.Payment_Number__c));
                update homeService;
            }
        }
        
        return financeInfo;
    }
    //Send To docusign funcions
    @AuraEnabled
    public static List<String> getRecordTypeFromHS(Id RecordId){
        List<String> result = new List<String>();
        if(RecordId != null){          
            if(RecordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:RecordId].WhatId;
                RecordId = recordIdFromEvent;
            }
            
            if(RecordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                
                Home_Services__c home =  [select Id,RecordType.Name,FinanceId__c from Home_Services__c where Id = :RecordId];
                PaymentMethod__c PayM = new PaymentMethod__c();
                List<DiacoAlarm__Diaco_Customer_Alarm__c> Alarm = new List<DiacoAlarm__Diaco_Customer_Alarm__c>();
                Alarm = [Select DiacoAlarm__DiacoModemSerialNumber__c,DiacoAlarm__DiacoPanelType__c From DiacoAlarm__Diaco_Customer_Alarm__c where Home_Service__c=:RecordId];
                try{
                    PayM = [select id from PaymentMethod__c Where HomeService__c=:RecordId And PaymentMethodType__c='ACH' limit 1];
                }catch(QueryException e){
                    PayM.Id=null;
                }
                Finance_Package__c pack = Finance_Package__c.getValues(home.Id);
                if(pack!=null){
                    if(pack.Type__c=='Purchase'){
                        result.add(home.RecordType.Name);
                        if(PayM.Id!=null){
                            result.add('OK'); 
                        }else{
                            result.add('Fail'); 
                        }
                        return result;
                    }
                }
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean getAlarmField(Id RecordId){
        if(RecordId != null){          
            if(RecordId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:RecordId].WhatId;
                RecordId = recordIdFromEvent;
            }
            
            if(RecordId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                List<DiacoAlarm__Diaco_Customer_Alarm__c> Alarm = new List<DiacoAlarm__Diaco_Customer_Alarm__c>();
                Alarm = [Select DiacoAlarm__DiacoModemSerialNumber__c,DiacoAlarm__DiacoPanelType__c From DiacoAlarm__Diaco_Customer_Alarm__c where Home_Service__c=:RecordId];
                return (Alarm.size()>0?((Alarm[0].DiacoAlarm__DiacoModemSerialNumber__c!=null && Alarm[0].DiacoAlarm__DiacoModemSerialNumber__c!=null)?true:false):false);
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
    public static List<String> sendToDocusign(Id homeserviceId){
        List<String> result = new List<String>();
        if(homeserviceId != null){          
            if(homeserviceId.getSObjectType().getDescribe().getName() == 'Event'){
                String  recordIdFromEvent = [select Id,WhatId from Event where Id=:homeserviceId].WhatId;
                homeserviceId = recordIdFromEvent;
            }
            
            if(homeserviceId.getSObjectType().getDescribe().getName() == 'Home_Services__c'){
                ddsign__DiacoSign_User__c userD = new ddsign__DiacoSign_User__c();
                try{
                    userD = [select Id, name, ddsign__baseUrl__c, ddsign__IntegratorKey__c, ddsign__Password__c, 
                             ddsign__Username__c, ddsign__DiacoSign_Account__r.ddsign__Url_Server__c
                             From ddsign__DiacoSign_User__c 
                             where ddsign__Username__c = 'scott@pinnaclefinance.com' LIMIT 1];
                }catch(QueryException e){
                    result.add('Error');
                    result.add('Docusign user to send this Contract isn\'t Configured');
                    return result;
                }
                ddsign.diacoSignHttpRequests dshr = new ddsign.diacoSignHttpRequests();
                String body = diacoDocusignApiRestIntegrationJson.Completion_Certificate_Template(homeserviceId, '07a82c1e-95da-4b08-bd27-e7933d3100c9');
                HttpResponse res = new HttpResponse();
                Map<String, Object> mapRes = new Map<String, Object>();
                if(!Test.isRunningTest()){
                    
                    res = dshr.sendEnvelope(userD.ddsign__baseUrl__c, userD.ddsign__Username__c, 
                                            'eagles85', userD.ddsign__IntegratorKey__c, body);
                    
                    ddsign.diacoSignJsonFunctions dsjf = new ddsign.diacoSignJsonFunctions();
                    mapRes = dsjf.deserializeResponse(res);
                }else{
                    res.setStatus('Created');
                    mapRes.put('envelopeId', '0000');
                    mapRes.put('status', 'sent');
                }
                if(res.getStatus()=='Created'){
                    List<ddsign__Pre_Designed_Envelope__c> pevs = new List<ddsign__Pre_Designed_Envelope__c>();
                    
                    pevs = [select Id from ddsign__Pre_Designed_Envelope__c where ddsign__DiacoSign_User__c=:userD.Id Limit 1];
                    ddsign__Envelope__c env =  new ddsign__Envelope__c(
                        ddsign__shipping_type__c = 'Manually',
                        Home_Service__c = homeserviceId,
                        ddsign__DiacoSign_User__c = userD.Id,
                        ddsign__Envelope_Id__c = String.valueOf(mapRes.get('envelopeId')),
                        ddsign__Sent_Date__c = DateTime.now(),
                        ddsign__status__c = String.valueOf(mapRes.get('status'))
                    );
                    if(!pevs.isEmpty()){
                        env.ddsign__Pre_Designed_Envelope__c=pevs[0].Id;
                    }
                    insert env;
                    result.add(res.getStatus());
                    return result;
                }else if(res.getStatus()=='Bad Request' || res.getStatus()=='Unauthorized'){
                    result.add(res.getStatus());
                    result.add(String.valueOf(mapRes.get('errorCode'))+', '+String.valueOf(mapRes.get('message')));
                    return result;
                }else{
                    result.add(res.getStatus());
                    result.add(res.getBody());
                    return result;
                }
            }
        }
        return null;
    }

}