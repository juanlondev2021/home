/**************************************************************************************************************
Created By: MST
Description : Helper class for Docusign status trigger.  This will update the opportunity stage when status is update in docusign.
***************************************************************************************************************/
public class nuHome_Docusign_OppStage_Handler {
    public static void changeStage(List<dsfs__DocuSign_Status__c> docusignStatus){
        system.debug('Trigger New Size'+docusignStatus.size()+'Records'+docusignStatus);    
        String statusAccountid = '';
        String envelopeStatus = '';
        String envelopeSubject = '';
        List<Opportunity> OppList = new List<Opportunity>();
        for(dsfs__DocuSign_Status__c status:docusignStatus){
            statusAccountid = status.dsfs__Company__c;
            envelopeStatus = status.dsfs__Envelope_Status__c;
            envelopeSubject = status.dsfs__Subject__c;
        }
        
        //This is to update the Stage field as Docusign Sent when the envelope is sent
        if(statusAccountid!=''&&(envelopeStatus=='Sent'||envelopeStatus=='Delivered')&&envelopeSubject!='NuHome Payment Authorization Form'){
            for(Opportunity Opp:[SELECT id,StageName from Opportunity WHERE AccountId=:statusAccountid]){
                Opportunity oppIns = new Opportunity();
                oppIns.Id = Opp.Id;
                oppIns.StageName = 'Docusign Sent';
                OppList.add(oppIns);
            }
        }
        
        //This is to update the Stage field as Closed Won when the envelope is Completed 
        if(statusAccountid!=''&&envelopeStatus=='Completed'&&envelopeSubject!='NuHome Payment Authorization Form'){
            for(Opportunity Opp:[SELECT id,StageName from Opportunity WHERE AccountId=:statusAccountid]){
                Opportunity oppIns = new Opportunity();
                oppIns.Id = Opp.Id;
                oppIns.StageName = 'Closed Won';
                OppList.add(oppIns);
            }
        }
        //Update all the related opportunities.
        if(OppList.size()>0)
            update OppList;  
    }
}