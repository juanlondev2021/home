/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-19-2020
 * @last modified by  : William Aldana
 * Test               : DiacoHsCountTaskTest
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   07/10/2019   Esnayder Morales (ES)   Initial Version
 * 2.0   10/19/2020   William Aldana          New Framework implementation
**/
public class TaskTriggerHelper {

    /**
    * @description 07/10/2019 Count task and send sms		
    * @author Esnayder Morales (ES) | 07/10/2019
    * @param newList 
    **/
    public static void countTaskAndSendSMS(List<Task> newList){
        List<ID> Ids = new List<ID>();
        for(Task task : newList) {
            if(task.WhatId != null){
                Id idToProccess = task.WhatId; 
                if(String.valueOf(idToProccess.getSObjectType())=='Home_Services__c'
                && task.Subject=='Confirmation Call - No answer'){
                    Ids.add(task.Id);
                }  
            }
        }
        DiacoHsCountTaskQueue updateJob = new DiacoHsCountTaskQueue(Ids);
        ID jobID = System.enqueueJob(updateJob);
    }    
    
    /**
    * @description ----------Log calls creation to update lead Forms Object----------
    * @author Esnayder Morales (ES) | 07/10/2019
    **/
    public static void logCallCreation(List<Task> newList){
        //Obtengo los Id de logs relacionados con lead forms
        List<ID> logIds = new List<ID>();
        List<ID> leadFormIds = new List<ID>();
        for(Task task : newList) {
            if(task.WhatId != null && task.Dispositions__c!=null ){
                Id idToProccess = task.WhatId; 
                if(String.valueOf(idToProccess.getSObjectType())=='Lead_Form__c'){
                    System.debug('This is a Lead form Call log');
                    //logIds.add(task.Id);
                    leadFormIds.add(idToProccess);
                    
                }
            }
        }
        //End of initial For
        //Now we get the Lead forms as a map Collection
        if(!leadFormIds.isEmpty()){
            Map<Id,Lead_Form__c> LeadFormIdMap=new Map<Id,Lead_Form__c>([select Id,
                                                                        name,
                                                                        Disposition__c,
                                                                        Call_attempts__c
                                                                        from Lead_Form__c 
                                                                        WHERE Id IN :leadFormIds]);
            list<Lead_Form__c> listToUpdate=new list<Lead_Form__c> ();
            //We check again to not update no lead form related tasks
            for(Task task : newList) {
                if(task.WhatId != null && task.Dispositions__c!=null ){
                    Id idToProccess = task.WhatId; 
                    if(String.valueOf(idToProccess.getSObjectType())=='Lead_Form__c'){
                        Lead_Form__c lf=LeadFormIdMap.get(task.WhatId);//Vacancy related to current application
                        Integer count=Integer.valueOf(lf.Call_attempts__c);
                        Lead_Form__c newLF=new Lead_Form__c(Id=task.WhatId,Call_attempts__c=count+1,Disposition__c=task.Dispositions__c);
                        listToUpdate.add(newLF);
                        
                    }
                }
            } 
            update listToUpdate;
        }
    }//End of Lead Form log Calls Treatment
}