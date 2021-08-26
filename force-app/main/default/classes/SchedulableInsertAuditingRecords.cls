/********************************************************************************************
* Class Name : SchedulableInsertAuditingRecords
* Created By : Sankar Marappan
* Created Date : 2/10/2016
* Author : MST
* Description: Every day at 12 a.m PST the job runs to invoke InsertAuditingRecords class logic to insert PA_Import_Auditing Records
**********************************************************************************************/

global class SchedulableInsertAuditingRecords implements Schedulable {
    Set<String> countyWithStateSet = new Set<String>();
    
   global void execute(SchedulableContext sc) {  
       String query = 'SELECT County_State__c FROM County__c';    
            database.executebatch(new InsertAuditingRecords(query),200);
   }
}