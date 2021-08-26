/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Docusign Integration
* Description:		class responsible of getting the documents from docusign each 15 minutes.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/01/2018		Jorge Martinez (JM)		Initial implementation of the trigger.
**/
public class diacoDocusignClassBridge {
    //constructor
    public diacoDocusignClassBridge(){
        Actions();
        deleteJob();
        Assignjob();
    }
    //method responsible of executing the batch class
    public static void Actions(){
        diacoDocusignBatcheableGetDocu myBatchObject = new diacoDocusignBatcheableGetDocu(); 
        Id batchId = Database.executeBatch(myBatchObject);
    }
    //method responsible of executing to assign a new job each 15 minutes
    public void Assignjob(){
        DateTime myDateTime = System.now().addMinutes(1);
        diacoDocusignScheduleClass request = new diacoDocusignScheduleClass();
        String title = 'Docusign job';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        String jobID = system.schedule(title, sch, request);
    }
    //method responsible of deleting the with the name: Docusign job.
    public void deleteJob(){
        String title = 'Docusign job';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
    
}