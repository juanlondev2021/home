/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Docusign Integration
* Description:		method responsible for getting all completed document in docusign.  
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/01/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
global class diacoDocusignBatcheableGetDocu implements Database.Batchable<sObject>, /*Schedulable, */Database.AllowsCallouts, Database.Stateful {
    
    
    /***
    * 
    * method responsible for starting the batch
    * 
    * @param BC the  batch context.
    * 
    * @return a list with home services.
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return  Database.getQueryLocator([select envelopeId__c, contractDocument__c, id, Name, sendDate__c, Account__c, RecordTypeId,Sending_Date_Service_Contract__c,
                                          Sending_Date_Product_Contract__c, Contract_Status_Product__c, Contract_Status_Service__c
                                          from Home_Services__c 
                                          where (envelopeId__c != null or envelopeId__c != '') and contractDocument__c = false]);
    }
    /***
    * 
    * method reponsible for executing the batch, take the user address not sent to salesrabbit, sends them and update them in salesforce database.
    * 
    * @param BC the  batch context.
    * @param records to process
    */
    global void execute(Database.BatchableContext bc, List<sObject> records){
        List<Home_Services__c> HomeServicesList = (List<Home_Services__c>) records;
        List<Attachment> attachmentsList = new List<Attachment>();
        system.debug('list Size: ' + HomeServicesList.size());
        if(HomeServicesList != null && HomeServicesList.size() > 0){
            //getting Tokens by http request
            diacoDocusignApiRestIntegration ddari =  new diacoDocusignApiRestIntegration();
            //getting tokens as Object
            diacoTokenFromDocusign tokens = ddari.getResponseAsObject(ddari.generatorToken());
            for(Home_Services__c home : HomeServicesList){
                //asking for the envelope status and  getting a response
                HttpResponse response = ddari.gettingEnvelopesStatus(home.envelopeId__c, tokens.access_token);
                //converting the envelope status response to object
                diacoDocusignEnvelopes envelope = ddari.getEnvelopesAsObject(response);
                //comparing if the status of this envelope is completed
                if(envelope.status == 'completed'){
                    //asking for the document to docusign
                    HttpResponse documentResponse = ddari.gettingDocumentAsPDF(home.envelopeId__c, tokens.access_token);
                    //adding the document to a document list to after get all documents add them to the salesforce database and linking to its home service
                    attachmentsList.add(ddari.saveContract(home, documentResponse));
                    home.contractDocument__c = true;
                    if(home.Contract_Status_Product__c == 'Waiting'){
                        home.Contract_Status_Product__c = 'Received';
                        home.Date_Signed_Product_Contract__c = Date.today();
                    }
                    if(home.Contract_Status_Service__c  == 'Waiting'){
                        home.Contract_Status_Service__c  = 'Received';
                        home.Date_Signed_Service_Contract__c = Date.today();
                    }
                }
            }
            
            //updating the refresh token
            ddari.getRefreshToken(tokens.refresh_token); 
            //inserting the attachments
            if(attachmentsList.size() > 0){
                insert attachmentsList;
            }
            update HomeServicesList;
            
        }
        
    }
    
    /***
    *
    * method responsible for ending the batch. 
    * 
    * @param BC the  batch context.
    * 
    */
    global void finish(Database.BatchableContext bc){
        
    }    
}