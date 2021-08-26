/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoTaskWebformProcess
 Description:		class reponsible create task when the webform is created from website
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		07/12/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class DiacoTaskWebformProcess {
    
    @InvocableMethod(label='Create task from website' description='Create a task when the webform is created from website.')
    public static void createTask(List<String> param) {
        User us = [select Id from User where Name = 'Brittany Walka' and Profile.Name='Force - Manager'];
        List<webForm__c> WFs = [Select Id, date__c, type__c from webForm__c where Id IN :param];
        System.debug(WFs);
        List<Task> tasks = new List<Task>();
        for(webForm__c wf : WFs){
            if(wf.date__c != null){
                String [] dat = wf.date__c.split('-');
                Integer day, month, year;
                //DateTime activityDate = DateTime.parse(wf.date__c.replaceAll('-','/'));
                tasks.add(new Task(
                    Subject = 'Call',
                    ActivityDate = date.parse(dat[1]+'/'+dat[2]+'/'+dat[0]),
                    Web_Form__c = wf.Id,
                    Description = wf.type__c,
                    OwnerId = us.Id
                ));
            }
            
        }
        system.debug(param);
        insert tasks;
    }

}