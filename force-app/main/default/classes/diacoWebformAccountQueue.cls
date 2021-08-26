public class diacoWebformAccountQueue implements Queueable{
    private List<String> param;
    public diacoWebformAccountQueue(List<String> param ) {
        this.param = param;
    }
    
    public void execute(QueueableContext context) {
        System.debug('####Param###');
        System.debug(param);
        // awesome code here
        List<Account> accounts =[select FirstName, LastName, PersonEmail, Phone, Web_Form__c, Web_Form__r.Id
                                 from Account where Id IN :param];
        //Account with webform to update
        System.debug(accounts);
        List<webForm__c> WFs = new List<webForm__c>();
        //Account without webform to create
        //List<Account> accWF = new List<Account>();
        for(Account acc : accounts){
            webForm__c webForm = new webForm__c();
            if(acc.Web_Form__c !=null){
                webForm.Id=acc.Web_Form__c;
                webForm.FirstName__c=acc.FirstName;
                webForm.LastName__c= acc.LastName;
                webForm.Email__c=acc.PersonEmail;
                webForm.Phone__c= acc.Phone;
                //webForm.Type__c = 'Sweepstake';
                WFs.add(webForm);
                //webForm.Affiliated_Rep__c='a131K000006VKdEQAW';
            }else{
                webForm.FirstName__c=acc.FirstName;
                webForm.LastName__c= acc.LastName;
                webForm.Email__c=acc.PersonEmail;
                webForm.Phone__c= acc.Phone;
                webForm.Account__c=acc.Id;
                webForm.Type__c = 'Home Services';
                //webForm.RecordTypeId = '0121K000001h2IKQAY';
                WFs.add(webForm); 
            }
        }
        System.debug('####List WebForm22###');
        System.debug(WFs);
        upsert WFs;
        System.debug('####List WebForm###');
        System.debug(WFs);
    }

}