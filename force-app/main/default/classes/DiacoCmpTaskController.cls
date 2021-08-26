/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			diacoCmpTask
Description:		Class reponsible provide method to diacocmp task 

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		21/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class DiacoCmpTaskController {
    
    /**
    * 
    * This method is responsible to get webform's task
    * 
    * This method is used in:
    * DiacoTaskWebformHelper.js
    *  
    * 
    * @param String recordIds
    * @return tasks
    **/
    @AuraEnabled
    public static List<Task> getTasks(String RecordId){
        List<Task> tasks = [select Id, Subject, OwnerId, WhatId, Owner.Name, Status,
                            Owner.Type, What.Name, What.Type, CreatedDate
                            from Task where Web_Form__c =:RecordId ORDER BY CreatedDate DESC];        
        return tasks;
    } 
    
    /**
    * 
    * This method is responsible to get account's information by webForm
    * 
    * This method is used in:
    * DiacoWebformAccountHelper.js
    *  
    * 
    * @param String recordId
    * @return webForm__c
    **/
    @AuraEnabled
    public static webForm__c getIdAccount(String RecordId){
        webForm__c acc = [select Account__c, Account__r.State__c, FirstName__c,
                          LastName__c, Phone__c,  Address__c, Zip__c,
                          Email__c, State__c, City__c
                          from webForm__c where Id=:RecordId];        
        return acc;
    } 
    
    /**
    * 
    * This method is responsible to update task and create homeservices
    * 
    * This method is used in:
    * DiacoWebformActionTaskHelper.js
    *  
    * 
    * @param Task, String
    * @return String
    **/
    @AuraEnabled
    public static String updateTask(Task task, String services){
        Type idArrType = Type.forName('List<string>');
    	List<string> wrapperList = (List<string>) JSON.deserialize(services, idArrType);
        Task task2 = [select Id, Name__c, ActivityDate, WhatId, Web_Form__c, What.type,
                      Web_Form__r.firstName__c, Web_Form__r.lastName__c,Web_Form__r.email__c,
                      Web_Form__r.Phone__c, Web_Form__r.Zip__c, Web_Form__r.City__c,Web_Form__r.Address__c,
                      Web_Form__r.State__c, Web_Form__r.type__c, Description, Web_Form__r.Account__c
                      from Task where Id =:task.Id];
        
        //Change firstName to Name in prod
        Personnel__c personnel = [select Id from Personnel__c where Name='1- None' limit 1];
        List<Home_Services__c> homeservices = new List<Home_Services__c>();
        Account account = new Account();
        
        
        //List<DateTime> datesActivity = DiacoResourceTaskController.ActivityDate(task2.ActivityDate,task2.Hours__c);
        if(task.Status == 'Completed' && 
           task2.Web_Form__r.Account__c != null){ 
               for(String hsId : wrapperList){
                   Home_Services__c hs = new Home_Services__c();
                   hs.Account__c = task2.Web_Form__r.Account__c;
                   hs.Industry__c= task2.Description;
                   //hs.Appointment_Date_Time__c = datesActivity[0];
                   //hs.Appt_End_Time__c = datesActivity[1];
                   hs.ApptSetter__c = personnel.Id;
                   hs.RecordTypeId = hsId;
                   homeservices.add(hs);
                      
               }
               insert homeservices;
               
           }else {
               account.FirstName=task2.Web_Form__r.firstName__c;
               account.LastName=task2.Web_Form__r.lastName__c;
               account.PersonEmail=task2.Web_Form__r.email__c;
               account.Phone=task2.Web_Form__r.Phone__c;
               account.State__c=task2.Web_Form__r.State__c;
               account.City__c=task2.Web_Form__r.City__c;
               account.Street__c=task2.Web_Form__r.Address__c;
               account.Zip__c=task2.Web_Form__r.Zip__c;
               account.Web_Form__c = task2.Web_Form__c;
               insert account;
               System.debug(account);
               for(String hsId : wrapperList){     
                   Home_Services__c hs2 = new Home_Services__c();
                   hs2.Account__c=account.Id;
                   hs2.Industry__c= task2.Description;
                   //hs.Appointment_Date_Time__c = datesActivity[0];
                   //hs.Appt_End_Time__c = datesActivity[1];
                   hs2.ApptSetter__c=personnel.Id;
                   hs2.RecordTypeId = hsId;
                   homeservices.add(hs2);
               }
               insert homeservices;
               System.debug(homeservices);
           }
        update task;
        return 'Updated';
    }
    
    /**
    * 
    * This method is responsible to get task by Id
    * 
    * This method is used in:
    * DiacoWebformActionTaskHelper.js
    *  
    * 
    * @param Task
    * @return Task
    **/
    @AuraEnabled
    public static Task getDataTask(String recordId){
        Task task = [select Description, Status from Task where Id=:recordId];
        System.debug(task);
        return task;
    }
    
    /**
    * 
    * This method is responsible to get task by Id
    * 
    * This method is used in:
    * DiacoWebformActionTaskHelper.js
    *  
    * 
    * @param nothing
    * @return List<RecordType>
    **/
    @AuraEnabled
    public static List<RecordType> getDataHS(){
        List<RecordType> RT = [select Id,Name from RecordType where sObjectType='Home_Services__c' and Name like '%Sales'];
        return RT;
    }
    
    
    /**
    * 
    * This method is responsible to update webform with a new account
    * 
    * This method is used in:
    * DiacoWebformActionTaskHelper.js
    *  
    * 
    * @param nothing
    * @return List<RecordType>
    **/
    @AuraEnabled
    public static String updateWebForm(String accountId, String WebformId){
        webForm__c wf = new webForm__c();
        wf.Id = WebformId;
        wf.Account__c = accountId;
        update wf;
        return 'Success';
    }
    
}