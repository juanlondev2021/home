/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class rensible for scheduling the data updating process and the lead removing process in salesrabbit
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		18/08/2018		Jorge Martinez (JM)		Initial implementation of the trigger.
**/
public class diacoRequestSalesRabbitToUpdateInSF {
    public List<salesRabbitSchedule__c> settingList{get;set;}
    public salesRabbitSchedule__c salesRabbitSchedule{get;set;}
    public diacoRequestSalesRabbitToUpdateInSF(){
        settingList = new List<salesRabbitSchedule__c>();
        salesRabbitSchedule =  new salesRabbitSchedule__c();
        settingList = [select Id, 
                       quantityDayOrHour__c, 
                       options__c, 
                       last_update__c,
                       knockCounter__c,
                       token__c
                       from salesRabbitSchedule__c];
         salesRabbitSchedule = settingList[0]; 
        
        Actions(salesRabbitSchedule);
        deleteJob(salesRabbitSchedule);
        Assignjob();
    }
    public static void Actions(salesRabbitSchedule__c salesRabbitSchedule){
        DiacoSalesRabbitIntegration.allLeadsSR(salesRabbitSchedule.token__c, System.today());
    }
    
    public void Assignjob(){
        DateTime myDateTime = System.now();
        DateTime newDateTime2;
        List<salesRabbitSchedule__c> settingList = [select Id, 
                                  quantityDayOrHour__c, 
                                  options__c, 
                                  last_update__c
                       		from salesRabbitSchedule__c];
        salesRabbitSchedule__c salesRabbitSchedule = settingList[0];
        if(salesRabbitSchedule.options__c == 'minutes'){
            newDateTime2 = myDateTime.addMinutes(Integer.valueOf(salesRabbitSchedule.quantityDayOrHour__c));
        }else if(salesRabbitSchedule.options__c == 'days'){
            newDateTime2 = myDateTime.addDays(Integer.valueOf(salesRabbitSchedule.quantityDayOrHour__c));
        }else if(salesRabbitSchedule.options__c == 'months'){
            newDateTime2 = myDateTime.addMonths(Integer.valueOf(salesRabbitSchedule.quantityDayOrHour__c));
        }else if(salesRabbitSchedule.options__c == 'hours'){
            newDateTime2 = myDateTime.addHours(Integer.valueOf(salesRabbitSchedule.quantityDayOrHour__c));
        }        
        diacoScheduleClass request = new diacoScheduleClass();
        String title = 'Salesrabbit job';
        String sch = '0 '+newDateTime2.minute()+' '+newDateTime2.hour()+' '+newDateTime2.day()+' '+newDateTime2.month()+' ?';
        System.debug('sch' + sch);
        String jobID = system.schedule(title, sch, request);
        salesRabbitSchedule.last_update__c = myDateTime;
        upsert salesRabbitSchedule;
        
    }
    
    public void deleteJob(salesRabbitSchedule__c salesRabbitSchedule){
        String title = 'Salesrabbit job';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }

}