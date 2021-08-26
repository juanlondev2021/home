/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible for handling the visualforce page
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		07/09/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
public class diacoSettingPageSalesRabbitController {
    
    public String option{get;set;}
    public String scheduleTime{get;set;}
    public String lastTime{get;set;}
    public String knockCounter{get;set;}
    public String deleteAfter{get;set;}
    public String token{get;set;}
    public String deleteAfterOptions{get;set;}
    public String minSalePrice{get;set;}
    public String maxSalePrice{get;set;}
    public salesRabbitSchedule__c salesRabbitSchedule{get;set;}
    public List<salesRabbitSchedule__c> settingList{get;set;}
    
    /**
     * 
     * constructor
    */
    public diacoSettingPageSalesRabbitController(){
        salesRabbitSchedule = new salesRabbitSchedule__c();
        settingList = new List<salesRabbitSchedule__c>();
        this.settingList = [select Id,
                                  quantityDayOrHour__c,
                                  options__c,
                                  last_update__c,
                                  knockCounter__c,
                                  deleteAfter__c,
                                  minSalePrice__c,
                                  maxSalePrice__c,
                            	  deleteAfterOptions__c,
                            	  token__c
                            from salesRabbitSchedule__c];
        salesRabbitSchedule = this.settingList[0];

        scheduleTime = String.valueOf(salesRabbitSchedule.quantityDayOrHour__c);
        option = salesRabbitSchedule.options__c;
        lastTime = timeAgo(salesRabbitSchedule.last_update__c);
        knockCounter = String.valueOf(salesRabbitSchedule.knockCounter__c);
        deleteAfter = String.valueOf(salesRabbitSchedule.deleteAfter__c);
        deleteAfterOptions= String.valueOf(salesRabbitSchedule.deleteAfterOptions__c);
        minSalePrice = String.valueOf(salesRabbitSchedule.minSalePrice__c);
        maxSalePrice = String.valueOf(salesRabbitSchedule.maxSalePrice__c);
        token = salesRabbitSchedule.token__c;
            
    }
    public String timeAgo(DateTime last){
        Long dt1Long = last.getTime();
        Long dt2Long = DateTime.now().getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        Long hours = minutes / 60;
        Long days = hours / 24;
        String toReturn = '';
        if(hours > 24){
            toReturn = String.valueOf(days) + ' days ago';
        }else if(minutes  > 60){
            toReturn = String.valueOf(hours) + ' hours ago';
        }else if(seconds > 60){
            toReturn = String.valueOf(minutes) + ' minutes ago';
        }else if(milliseconds > 1000){
            toReturn = String.valueOf(seconds) + ' seconds ago';
        }
        return toReturn;
    }
    /**
     * method reposible for returning a list with options to save in the custom setting
     * 
     * @return a selectOption list. 
     * 
	*/
    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--NONE--','--NONE--'));
        options.add(new SelectOption('minutes','minutes'));
        options.add(new SelectOption('hours','hours'));
        return options;
    }
    /**
    * method reposible for returning a list with options to delete in the custom setting
    *
    * @return a selectOption list.
    *
   */
    public List<SelectOption> getOptionsDelete() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--NONE--','--NONE--'));
        options.add(new SelectOption('days','days'));
        return options;
    }
    
    /*
     * method responsible for updating the custom setting and scheduling the new jobs 
	 */
    public void updateSchedule(){
        salesRabbitSchedule.quantityDayOrHour__c = Decimal.valueOf(scheduleTime);
        salesRabbitSchedule.options__c = option;
        salesRabbitSchedule.knockCounter__c = Decimal.valueOf(knockCounter);
        salesRabbitSchedule.maxSalePrice__c = Decimal.valueOf(maxSalePrice);
        salesRabbitSchedule.minSalePrice__c = Decimal.valueOf(minSalePrice);
        salesRabbitSchedule.deleteAfter__c = Decimal.valueOf(deleteAfter);
        salesRabbitSchedule.deleteAfterOptions__c = deleteAfterOptions;
        salesRabbitSchedule.token__c = token;
        upsert salesRabbitSchedule;
        deleteJob(salesRabbitSchedule);
        Assignjob( salesRabbitSchedule.quantityDayOrHour__c,  salesRabbitSchedule.options__c);
        
    }


    /*
     * method responsible for deleting jobs in list to add new jobs without generate exception. 
     */    
    public void deleteJob(salesRabbitSchedule__c salesRabbitSchedule){
        String title = 'Salesrabbit job';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
    /*
     * method responsible to creating new jobs and schedule the new jobs
     * 
	 */
    public void Assignjob(Decimal quantity, String option){
    	System.debug(quantity + ' ' + option);
        DateTime myDateTime = System.now();
        DateTime newDateTime2;
        if(option == 'minutes'){
            newDateTime2 = myDateTime.addMinutes(Integer.valueOf(quantity));
        }else if(option == 'hours'){
            newDateTime2 = myDateTime.addHours(Integer.valueOf(quantity));
        }else if(option == 'days'){
            newDateTime2 = myDateTime.addDays(Integer.valueOf(quantity));
        }else if(option == 'months'){
            newDateTime2 = myDateTime.addMonths(Integer.valueOf(quantity));
        }        
        diacoScheduleClass request = new diacoScheduleClass();
        String title = 'Salesrabbit job';
        System.debug('title : ' + title);
        String sch = '0 '+newDateTime2.minute()+' '+newDateTime2.hour()+' '+newDateTime2.day()+' '+newDateTime2.month()+' ?';
        String jobID = system.schedule(title, sch, request);
    }

}