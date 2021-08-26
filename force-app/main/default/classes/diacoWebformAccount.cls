/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Unique webform 
* Description:		class responsible to assign webform to account.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		10/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
public class diacoWebformAccount {
    @InvocableMethod(label='Account to WebForm' description='Account relationship to WebForm.')
    public static void ConnectWebformAccount(List<String> param) {
        System.debug(param);
        diacoWebformAccountQueue updateJob = new diacoWebformAccountQueue(param);
        // enqueue the job for processing
        
           System.debug('###ID ENQUEUE##');
          ID jobID = System.enqueueJob(updateJob);
        System.debug(jobID);  
        
        return;
    }
    
   /* public String Webform(String idAccount){
        System.debug('#####Id Account####');
        System.debug(idAccount);
        Account acc =[select FirstName, LastName, PersonEmail, Phone from Account where Id=:idAccount];
        List<webForm__c> wf = [select Id from webForm__c where Account__c =: idAccount limit 1];
        System.debug('######Test WebForm#####');
        if(wf.size()>0){
            webForm__c webF = new webForm__c(
                Id=wf[0].Id,
                FirstName__c=acc.FirstName,
                LastName__c= acc.LastName,
                Email__c=acc.PersonEmail,
                Phone__c= acc.Phone,
                Affiliated_Rep__c='a131K000006VKdEQAW');
            update webF;
            System.debug('Update only');
        }else{
            webForm__c webF = new webForm__c(Account__c=idAccount,
                                             RecordTypeId='0121K000001AbYOQA0',
                                             FirstName__c=acc.FirstName,
                                             LastName__c= acc.LastName,
                                             Email__c=acc.PersonEmail,
                                             Phone__c= acc.Phone);
            insert webF;
            
            System.debug('Create a new Webform with Account');
        }
        System.debug(wf);
        return 'created';
    }*/
    
}