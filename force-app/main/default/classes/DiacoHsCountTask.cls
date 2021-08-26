/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			diacoHsCountTask
Description:		Class reponsible to send sms when the Confirmation_Call_Count__c == 5

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		07/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class DiacoHsCountTask {
    
    /**
    * 
    * This method is responsible to execute all method this class.
    * 
    * This method is used in:
    * DiacoHsCountTaskQueue class
    *  
    * 
    * @param List<ID> recordIds
    * @return nothing
    **/
    @future
    public static void execute (List<ID> recordIds){
        List<Task> tasks = [select WhatId, Subject, Home_Service__c, Home_Service__r.Account__r.Phone,
                            Home_Service__r.RecordType.Name, Home_Service__r.Automatic_Text_Confirmation_C__c
                            from Task where Id IN :recordIds];
        Map<ID,String> hsPhone = new Map<ID,String>();
        Map<ID, String> hsRecordType = new Map<ID,String>();
        Map<ID, String> hsConfirmation = new Map<ID,String>();
        for(Task task : tasks){
            hsPhone.put(task.Home_Service__c,task.Home_Service__r.Account__r.Phone);
            hsRecordType.put(task.Home_Service__c, task.Home_Service__r.RecordType.Name);
            hsConfirmation.put(task.Home_Service__c, task.Home_Service__r.Automatic_Text_Confirmation_C__c);
        }
        updateHSCount(getIdHS(tasks), hsPhone, hsRecordType, hsConfirmation);
    }
    
    /**
    * 
    * This method is responsible to send sms.
    * 
    * This method is used in:
    *  DiacoHsCountTask (method updateHSCount)
    *  
    * 
    * @param List<Home_Services__c> homeServices
    * @return String
    **/
    /*public static String sendSms(List<Home_Services__c> homeServices, Map<ID,String> hsPhone, 
                                 Map<ID, String> hsRecordType, Map<ID, String> hsConfirmation){
        List <smagicinteract__smsmagic__c> smsObjectList = new List <smagicinteract__smsmagic__c>();
        String senderId = '';
        String ownerId = [Select Id From User where Name ='Jennifer Hinson' and isActive=true][0].Id;
        List<smagicinteract__SMS_SenderId__c> senders = [select smagicinteract__Label__c, smagicinteract__senderId__c
                         from smagicinteract__SMS_SenderId__c where smagicinteract__Label__c like 'Sales:%'];
        String industryText = '';
        for(Home_Services__c hs:homeServices){
            industryText = industryText(hsRecordType.get(hs.Id), hsConfirmation.get(hs.Id));
            senderId = getSenderId(senders, hsRecordType.get(hs.Id));
            System.debug(hsPhone.get(hs.Id));
            System.debug(industryText);
            if(hsPhone.get(hs.Id) != null && industryText != ''){
                
                Map<Id,String> templates = textBody(hs, industryText);
                String templateText = templates.get(hs.Id); // you can fetch the template text by querying the record on smagicinteract__SMS_Template__c object
                smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                smsObject.smagicinteract__SenderId__c = senderId;
                smsObject.smagicinteract__PhoneNumber__c = hsPhone.get(hs.Id);
                smsObject.smagicinteract__Name__c = hs.Name; // records name
                smsObject.smagicinteract__ObjectType__c = 'Home_Services__c'; // record type
                smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                smsObject.smagicinteract__SMSText__c = templateText;
                //smsObject.smagicinteract__Source__c ='1495';
                smsObject.OwnerId = ownerId;
                smsObject.Home_Service__c = hs.Id;
                smsObjectList.add(smsObject);
            }
        }
        System.debug('###SMSOBJECTLIST###');
        System.debug(smsObjectList);
        insert smsObjectList;
        return 'send';
    }*/
    
    /**
    * 
    * This method is responsible to decide converse template sms depending recordtype.
    * 
    * This method is used in:
    *  DiacoHsCountTask (sendSms method)
    *  
    * 
    * @param String Recordtype 
    * @return String (converse template)
    **/
    /*public static String industryText(String recordType, String confirmation){
        String result = '';
        String [] confirmations = confirmation.split('\n');
        String query = 'Automatic Text - Confirmation "C" ';
        List<smagicinteract__SMS_Template__c> templateText = new List<smagicinteract__SMS_Template__c>();
        if(recordType != null){
            if(recordType.contains('Solar') && confirmation.contains('Solar')){
                query +='Solar';
                templateText = [select smagicinteract__Text__c 
                                from smagicinteract__SMS_Template__c 
                                where smagicinteract__Name__c like :query];
                result = templateText[0].smagicinteract__Text__c;
            } else if(recordType.contains('Water') && confirmation.contains('Water')){
                query +='Water';
                templateText = [select smagicinteract__Text__c 
                                from smagicinteract__SMS_Template__c 
                                where smagicinteract__Name__c like :query];
                result = templateText[0].smagicinteract__Text__c;
            } else if(recordType.contains('Home Automation') && confirmation.contains('Home Automation')){
                query +='Home Automation';
                templateText = [select smagicinteract__Text__c 
                                from smagicinteract__SMS_Template__c 
                                where smagicinteract__Name__c like :query];
                result = templateText[0].smagicinteract__Text__c;
            } else if(recordType.contains('Pest Control') && confirmation.contains('Pest Control')){
                query +='Pest Control';
                templateText = [select smagicinteract__Text__c 
                                from smagicinteract__SMS_Template__c 
                                where smagicinteract__Name__c like :query];
                result = templateText[0].smagicinteract__Text__c;
            } else if(recordType.contains('Remodel') && confirmation.contains('Remodel')){
                query +='Remodel';
                templateText = [select smagicinteract__Text__c 
                                from smagicinteract__SMS_Template__c 
                                where smagicinteract__Name__c like :query];
                result = templateText[0].smagicinteract__Text__c;
            }
        }
        System.debug('##Result##');
        System.debug(result);
        return result;
    }*/
    
    /**
    * 
    * This method is responsible to build text sms with converse template and parameter.
    * 
    * This method is used in:
    *  DiacoHsCountTask (sendSms method)
    *  
    * 
    * @param Home_Services__c homeServices (value), String templateText (Body text with parameter) 
    * @return String (Body text sms)
    **/
    /*public static Map<Id,String> textBody(Home_Services__c homeServices, String templateText){
        List<Id> IdList = new List<Id>();
        Map<Id,String> Template = new Map<Id,String>();
        //Home_Services__c hs = [select First_Name__c, Appt_Window_Time__c, Id 
          //                     from Home_Services__c where Id=:homeServices.Id];
        IdList.add(homeServices.id); 
        Set<String> extraFieldSet=new Set<String>{'first_name__c' , 'appt_window_time__c'};
            smagicinteract.TemplateResolver temp = new smagicinteract.TemplateResolver();
        Map<sobject,String> objectTextmap =temp.resolveTemplate(templateText, homeServices.getSObjectType(), IdList, extraFieldSet);
        for(sobject accName: objectTextmap.keySet()){
            String tempList = objectTextmap.get(accName);
            Template.put(homeServices.Id, tempList); 
        }
        return Template;
    }*/
    
    /**
    * 
    * This method works to choose the sernderId.
    * 
    * This method is used in:
    *  DiacoHsCountTask (sendSms method)
    *  
    * 
    * @param List<Task> tasks
    * @return List<smagicinteract__SMS_SenderId__c> senders, String recordType
    **/
    /*public static String getSenderId (List<smagicinteract__SMS_SenderId__c> senders, String recordType){
        String result = '';
        System.debug('###SenderList##');
        System.debug(senders);
        System.debug(recordType);
        if(recordType != null){
            if(recordType.contains('Home Automation')){
                recordType = 'HA';
            }else if(recordType.contains('Solar')){
                recordType = 'Solar';
            }else if(recordType.contains('Water')){
                recordType = 'Water';
            }else if(recordType.contains('Pest Control')){
                recordType = 'Pest';
            }else if(recordType.contains('Pest Control')){
                recordType = 'Pest';
            }else if(recordType.contains('Remodel')){
                recordType = 'Remodel';
            }
        }
        for(smagicinteract__SMS_SenderId__c sender: senders){
            if(sender.smagicinteract__Label__c != null){
                if(sender.smagicinteract__Label__c.contains(recordType)){
                    result = sender.smagicinteract__senderId__c;
                    break;
                }
                
            }
        }
        return result;
    }*/
    
    
	 /**
    * 
    * This method is create a homeservices list .
    * 
    * This method is used in:
    *  DiacoHsCountTask (execute method)
    *  
    * 
    * @param List<Task> tasks
    * @return List<String> (Home services Id)
    **/
    public static List<String> getIdHS (List<Task> tasks){
        List<String> IdHS = new List<String>();
        Set<String> HomeServices = new Set<String>();
        for(Task task : tasks) {
            Id idToProccess = task.WhatId; 
            if(String.valueOf(idToProccess.getSObjectType())=='Home_Services__c'
               && task.Subject=='Confirmation Call - No answer'){
                   HomeServices.add(task.WhatId);
               }
        }
        IdHS.addAll(HomeServices);
        return IdHS;
    }
    
    /**
    * 
    * This method is responsible to update count number in homeservices record.
    * 
    * This method is used in:
    *  DiacoHsCountTask (execute method)
    *  
    * 
    * @param List<String> IdHS, Map<ID,String> hsPhone, Map<ID, String> hsRecordType
    * @return String
    **/
    public Static String updateHSCount(List<String> IdHS, Map<ID,String> hsPhone, 
                                       Map<ID, String> hsRecordType, 
                                       Map<ID, String> hsConfirmation){ 
        
      	AggregateResult[] tasks = [select  WhatId, count(Id) from Task where WhatId in :IdHS group by WhatId ];
        List<Home_Services__c> homeServices = new List<Home_Services__c>();
        //List<Home_Services__c> homeServicesFive = new List<Home_Services__c>();
        for(AggregateResult result: tasks){
            Home_Services__c hs = new Home_Services__c(
                       Id = String.valueof(result.get('WhatId')),
                       Confirmation_Call_Count__c = integer.valueOf(result.get('expr0'))
                   ); 
            homeServices.add(hs);
            System.debug('##TASK##############');
        	System.debug(hs.Confirmation_Call_Count__c);
            /*if(hs.Confirmation_Call_Count__c == 5
              && hsConfirmation.get(hs.Id) != null){
                homeServicesFive.add(hs);
            }*/
            System.debug(hsConfirmation.get(hs.Id));
        }
        /*if(homeServicesFive.size()>0){
            sendSms(homeServicesFive, hsPhone, hsRecordType, hsConfirmation);
        }*/
        upsert homeServices;
        return 'update';
    }
}