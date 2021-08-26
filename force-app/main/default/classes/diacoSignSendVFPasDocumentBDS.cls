global without sharing class diacoSignSendVFPasDocumentBDS {
    
    @future(callout=true)
    global static void sendToDocusign(String predesignEnvelopeId, String ParentId){
        
        Id RecordType_Id =  [Select Id, Name 
                             From RecordType 
                             where sobjecttype = 'ddsign__Status__c' AND Name = 'HTTP'].Id;
        Id RecordType_Id_DocuSign =  [Select Id, Name 
                                      From RecordType 
                                      where sobjecttype = 'ddsign__Status__c' AND Name = 'DocuSign'].Id;
        
        Map<Id, ddsign__Pre_Designed_Envelope__c> pre_des_enves = diacoSignSendVFPasDocumentBDS.Pre_Designed_Envelope(predesignEnvelopeId);
        
        Map<String, List<ddsign__diacoSign_Signer__c>> MapEnv_signers = diacoSignSendVFPasDocumentBDS.Envelopes(predesignEnvelopeId);
        
        string requestBody = diacoSignSendVFPasDocumentBDS.buildBodyRequest(pre_des_enves, MapEnv_signers, predesignEnvelopeId, ParentId);
        
        ddsign.diacoSignHttpRequests dshr = new ddsign.diacoSignHttpRequests();
        ddsign.diacoSignJsonFunctions dsjf = new ddsign.diacoSignJsonFunctions();
        List<ddsign__Status__c> statuses = new List<ddsign__Status__c>();
        
        HttpResponse sendEnvelopeResponse = new HttpResponse ();
        if(Test.isRunningTest()) {
            string body = '{'+
                '"envelopeId": "c30cbd17-ef51-4548-bc53-ef77bf41f941",'+
                '"uri": "/envelopes/c30cbd17-ef51-4548-bc53-ef77bf41f941",'+
                '"statusDateTime": "2019-12-14T11:28:08.7330000Z",'+
                '"status": "sent"'+
                '}';
            sendEnvelopeResponse.setBody(body);
        }else{
            sendEnvelopeResponse = dshr.sendEnvelope(pre_des_enves.get(predesignEnvelopeId).ddsign__DiacoSign_User__r.ddsign__baseUrl__c, 
                                                     pre_des_enves.get(predesignEnvelopeId).ddsign__DiacoSign_User__r.ddsign__Username__c,
                                                     pre_des_enves.get(predesignEnvelopeId).ddsign__DiacoSign_User__r.ddsign__Password__c,
                                                     pre_des_enves.get(predesignEnvelopeId).ddsign__DiacoSign_User__r.ddsign__IntegratorKey__c,
                                                     requestBody);
        }
        
        
        Map<String, Object> sendEnvelopeResponseJsonify = dsjf.deserializeResponse(sendEnvelopeResponse);
        DateTime Sent_Date;
        try{
            
            Sent_Date = (DateTime) JSON.deserialize('"' + string.valueof(sendEnvelopeResponseJsonify.get('statusDateTime')) + '"', DateTime.class);
            
        }catch(Exception  e){
            
            Sent_Date = DateTime.now();
            
        }
        
        ddsign__Envelope__c envps = new ddsign__Envelope__c(
            ddsign__Pre_Designed_Envelope__c = predesignEnvelopeId,
            ddsign__Parent_Id__c = ParentId, 
            ddsign__status__c = string.valueof(sendEnvelopeResponseJsonify.get('status')),
            ddsign__Envelope_Id__c = string.valueof(sendEnvelopeResponseJsonify.get('envelopeId')),
            ddsign__Sent_Date__c = Sent_Date
        );
        
        upsert envps;
        
        system.debug(envps);
        ddsign__Status__c status =  new ddsign__Status__c(
            RecordTypeId = RecordType_Id,
            ddsign__HTTP_status__c = sendEnvelopeResponse.getStatusCode() + ' : ' + sendEnvelopeResponse.getStatus(),
            ddsign__HTTP_response__c = sendEnvelopeResponse.getBody(),
            ddsign__Envelope_HTTP__c = envps.Id,
            ddsign__Date_Time__c = DateTime.now(),
            ddsign__Name__c = 'Sending Envelope To docusign'
        );
        if(requestBody.length() <= 131072){
            
            status.ddsign__HTTP_request__c = requestBody;
            
        }else if(requestBody.length() > 131072){
            
            Integer startString = requestBody.length() - 131072;
            status.ddsign__HTTP_request__c = requestBody.substring(startString, requestBody.length());
            
        }
        statuses.add(status);
        
        statuses.add(new ddsign__Status__c(
            ddsign__Envelope__c = envps.Id,
            ddsign__Date_Time__c =  DateTime.now(),
            ddsign__status__c = envps.ddsign__status__c,
            RecordTypeId = RecordType_Id_DocuSign,
            ddsign__Name__c = 'Sending Envelope To docusign'
        ));
        for(ddsign__Status__c statu : statuses){
            system.debug(statu);
        }
        //upsert statuses;
        Database.upsert(statuses, false);
    }
    
    global static string buildBodyRequest(Map<Id, ddsign__Pre_Designed_Envelope__c> pre_des_enves, 
                                          Map<String, List<ddsign__diacoSign_Signer__c>> MapEnv_signers,
                                          String predesignEnvelopeId, String ParentId){
                                              
                                              string Documents = '"documents": [';
                                              for(string predId : pre_des_enves.keySet()){
                                                  
                                                  ddsign__Pre_Designed_Envelope__c predesign = pre_des_enves.get(predId);
                                                  List<ddsign__diacoSign_Signer__c> signers = MapEnv_signers.get(predId);
                                                  
                                                  
                                                  
                                                  for(ddsign__Envelope_Document__c document : predesign.ddsign__Envelope_Documents__r){
                                                      
                                                      if('VisualForce' == document.RecordType.Name){
                                                          
                                                          PageReference pageRef = new PageReference('/apex/'+document.ddsign__VisualForce_Name__c);
                                                          
                                                          pageRef.getParameters().put('id', ParentId);
                                                          
                                                          Blob pdfBlob;
                                                          
                                                          if(Test.isRunningTest()) { 
                                                              pdfBlob = blob.valueOf('Unit.Test');
                                                          } else {
                                                              pdfBlob = pageRef.getContentAsPDF();
                                                          }
                                                          
                                                          Documents += '{"documentBase64": "'+EncodingUtil.base64Encode(pdfBlob)+'",'+ 
                                                              '"documentId": "'+document.ddsign__document_Id__c+'",'+
                                                              '"fileExtension": "'+document.ddsign__File_Extension__c+'",'+
                                                              '"name": "'+document.ddsign__Document_Name__c+'"'+
                                                              '},';  
                                                          system.debug('{"documentBase64": "'+EncodingUtil.base64Encode(pdfBlob)+'",'+ 
                                                                       '"documentId": "'+document.ddsign__document_Id__c+'",'+
                                                                       '"fileExtension": "'+document.ddsign__File_Extension__c+'",'+
                                                                       '"name": "'+document.ddsign__Document_Name__c+'"'+
                                                                       '},');
                                                      } 
                                                  }
                                              }
                                              Documents = Documents.removeEnd(',') + '],';
                                              String body_request = ddsign.diacoSignBodyHttpRequests.bodyRequestByDataModelVFP(pre_des_enves.get(predesignEnvelopeId), MapEnv_signers.get(predesignEnvelopeId),
                                                                                                                               ParentId, Documents);
                                              
                                              
                                              return body_request;
                                          }
    
    global static Map<Id, ddsign__Pre_Designed_Envelope__c> Pre_Designed_Envelope(String preDesignEnvelopeId){
        
        Map<Id, ddsign__Pre_Designed_Envelope__c> pre_des_enves = new Map<Id, ddsign__Pre_Designed_Envelope__c>(
            [select Id, Name, ddsign__SObject_Assigned__c, ddsign__subject__c, ddsign__Document_Types__c, 
             ddsign__DiacoSign_User__r.ddsign__baseUrl__c, ddsign__DiacoSign_User__r.ddsign__IntegratorKey__c,
             ddsign__DiacoSign_User__r.ddsign__Username__c, ddsign__DiacoSign_User__r.ddsign__Password__c,
             (select Id, Name, RecordType.Name, ddsign__Template_Id__c, ddsign__File_Extension__c,
              ddsign__VisualForce_Name__c,
              ddsign__Document_Name__c, ddsign__document_Id__c
              from ddsign__Envelope_Documents__r ORDER BY ddsign__document_Id__c ASC)
             From ddsign__Pre_Designed_Envelope__c 
             where Id = :preDesignEnvelopeId]
        );
        
        
        return pre_des_enves;
    }
    
    global static Map<String, List<ddsign__diacoSign_Signer__c>> Envelopes(String preDesignEnvelopeId){
        
        Map<String, List<ddsign__diacoSign_Signer__c>> MapEnv_signers = new Map<String, List<ddsign__diacoSign_Signer__c>>();
        
        List<ddsign__diacoSign_Signer__c> env_signers = [select Id, Name, ddsign__email__c, ddsign__Recipient_Id__c,
                                                         ddsign__Role_Name__c, ddsign__routing_Order__c, ddsign__Sobject__c,
                                                         ddsign__Signer_Selection__c, ddsign__Pre_Designed_Envelope__c,
                                                         ddsign__Recipient_Type__c,
                                                         (Select Id, ddsign__Recipient_Id__c, ddsign__Sobject__c,  ddsign__ValueOf__c,
                                                          ddsign__Type__c, ddsign__value__c, ddsign__anchorString__c
                                                          From ddsign__Tabs__r)
                                                         From ddsign__diacoSign_Signer__c 
                                                         where ddsign__Pre_Designed_Envelope__c = :preDesignEnvelopeId];
        
        
        
        List<ddsign__diacoSign_Signer__c> signers = new List<ddsign__diacoSign_Signer__c>();
        if(!env_signers.isEmpty()){
            signers.addAll(env_signers);
        }
        
        
        MapEnv_signers.put(preDesignEnvelopeId, signers);
        
        return MapEnv_signers;
    }
    
}