trigger diacoReferralCounter on referral__c (after insert,after update, after delete) {
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete){
        List<referral__c> olds=Trigger.isInsert? Trigger.New :Trigger.Old;
        List<referral__c> news=Trigger.isDelete? Trigger.Old : Trigger.New;
        
        for(Integer x=0;x<olds.size();x++) {
            /*system.debug(news[x].OwnerId+'-'+olds[x].OwnerId);
            system.debug(news[x].Current_Appointment__c+'-'+olds[x].Current_Appointment__c);
            system.debug(Trigger.isDelete);*/
            if(news[x].ApptSetter__c!=olds[x].ApptSetter__c || news[x].Status__c!=olds[x].Status__c || Trigger.isDelete || Trigger.isInsert){
                //system.debug('________Count Trigger_______________________________________________________________________________________________________');
                //system.debug('Sí entra 0');
                //String idToSearch=Trigger.isDelete? olds[x].OwnerId : news[x].OwnerId;
                system.debug('________Start count Referral Trigger__________');
                
                system.debug('Personnels: *'+news[x].ApptSetter__c+'* - *'+olds[x].ApptSetter__c+'*');
                if(news[x].ApptSetter__c!=null){
                    system.debug('Inicia -1 a');
                    DiacoTriggerPersonnelCountReferral.execute(news[x].ApptSetter__c);
                }
                
                if(Trigger.isUpdate && news[x].ApptSetter__c!=olds[x].ApptSetter__c && olds[x].ApptSetter__c!=null){
                    system.debug('Inicia -1 b');
                    DiacoTriggerPersonnelCountReferral.execute(olds[x].ApptSetter__c);
                }
                system.debug('________End count Referral Trigger__________');
    
                    
            }
        }
    }
    if(Trigger.isInsert){
        for(referral__c ref : Trigger.New){
            List<Account> accs = [select Id, referralCounter__c, PersonEmail, FirstName, LastName from Account where Id =:ref.account__c];
            if(accs.size()>0){
                Account acc=accs[0];
                if(acc.referralCounter__c == null){
                    acc.referralCounter__c = 0;
                }
                acc.referralCounter__c += 1;
                if(acc.referralCounter__c >= 5){
                    acc.referralCounter__c = 0;
                    
                    List<referral__c> refList = [select Id,Name , lastName__c, firstName__c, emailSent__c, account__c from referral__c where account__c = :ref.account__c and emailSent__c = false];
                    
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setOrgWideEmailAddressId([select id, Address, DisplayName from OrgWideEmailAddress where Address = 'referrals@nergysolutions.com' limit 1].Id);
                    message.toAddresses = new String[] {acc.PersonEmail, 'kregan@myhomes.services'};//'kregan@myhomes.services'
                        message.optOutPolicy = 'FILTER';
                    message.subject = 'Referrals From '+acc.FirstName +' ' +acc.LastName+' - '+acc.Id;
                    message.plainTextBody = 'these referrals was sent by:'+acc.FirstName +' ' +acc.LastName+' - https://myhomeservices.lightning.force.com/lightning/r/Account/'+acc.Id+'/view\n';
                    for(referral__c refe : refList){
                        refe.emailSent__c = true;
                        system.debug(refe);
                        message.plainTextBody += refe.firstName__c+' '+ refe.lastName__c+'\n';
                        
                    }
                    update refList;
                    
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }
                update acc;
                
            }
            
        }
    }
    
}