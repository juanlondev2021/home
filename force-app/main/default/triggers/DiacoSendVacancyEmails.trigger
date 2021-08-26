trigger DiacoSendVacancyEmails on deapp__Applicant__c (after update) {
    	
    Map<Id,deapp__Apply_now__c> VacancyIdMap = new Map<Id,deapp__Apply_now__c>([select Id,
                                                                                name,
                                                                                DISC_Assessment_Sent__c,
                                                                                Not_a_Fit_Pre_DISC_Assessment__c,
                                                                                Onboarding__c,
                                                                                Outbound_Orientation__c,
                                                                                Post_DISC_Not_a_Fit__c,
                                                                                Post_Interview_Not_a_Fit__c,
                                                                                Video_Interview_Invite__c,
                                                                                Website_Video__c
                                                                                from deapp__Apply_now__c]);
    
    if(Trigger.isUpdate){ 
        for(deapp__Applicant__c application : Trigger.New) {
            //System.debug('Accessing vacancy related to current Application');
            //System.debug(vacancy);
            deapp__Applicant__c oldApplication = Trigger.oldMap.get(application.Id);//Getting application before Trigger
            deapp__Apply_now__c vacancy=VacancyIdMap.get(application.deapp__Vacancy__c);//Vacancy related to current application
            
            //Email Four Onboarding
            //Application Status changed to Hired
            if(application.deapp__Status__c=='Hired' && application.deapp__Status__c !=oldApplication.deapp__Status__c
              && vacancy.Onboarding__c==true ) {
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'Onboarding');
               }
            
            //Email Three Option B: Outbound Orientation
            //Application Status changed to Training Scheduled AND Training Start Date and Training End Date are populated.
            if(application.deapp__Training_Start_Date__c != null && application.deapp__Training_End_Date__c != null 
               && application.deapp__Status__c=='Training Scheduled' 
               && application.deapp__Status__c !=oldApplication.deapp__Status__c
              && vacancy.Outbound_Orientation__c==true ) {
                  System.debug('Entro#######################');
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'OutboundOrientation');
                   
               }
            
            //Email Three Option A: Post Interview Not a Fit
            //Application Status changed to Not a Fit AND Interview Date is Populated
            if(application.deapp__Interview_Date__c != null && application.deapp__Status__c=='Not a Fit' && 
               application.deapp__Status__c !=oldApplication.deapp__Status__c && vacancy.Post_Interview_Not_a_Fit__c==true ) {
                    DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'NotAFitPostInterview');
                   
                    
                }
            
            //Email Two Option C:  Video Interview Invite
            //Application Status changed to DISC Sent and DISC Profile Required changed to Yes
            if(application.Meets_DISC_Profile_Required__c == 'Yes' && application.deapp__Status__c=='DISC Sent' && 
               (application.deapp__Status__c !=oldApplication.deapp__Status__c ||
                application.Meets_DISC_Profile_Required__c !=oldApplication.Meets_DISC_Profile_Required__c)
              && vacancy.Video_Interview_Invite__c==true ){
                    DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'VideoInterviewInvite');
                    
                }
            
            //Email Two Option B:  Website Video TODO:Check wheter this email is activate for given Vacancy
            //  Application Status DISC Sent and Meets DISC Profile Required changed to Yes 
            if(application.Meets_DISC_Profile_Required__c == 'Yes' && application.deapp__Status__c=='DISC Sent' && 
               (application.deapp__Status__c !=oldApplication.deapp__Status__c ||application.Meets_DISC_Profile_Required__c !=oldApplication.Meets_DISC_Profile_Required__c)
              && vacancy.Website_Video__c==true){
                    DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'WebsiteVideo');
                    
                }
            
            //Email Two Option A: Post DISC Not a Fit 
            //Application Status changed to Not a Fit and Meets DISC Profile Required equals No 
            if(application.Meets_DISC_Profile_Required__c == 'No' && application.deapp__Status__c=='Not a Fit' && 
               (application.deapp__Status__c !=oldApplication.deapp__Status__c ||
                application.Meets_DISC_Profile_Required__c !=oldApplication.Meets_DISC_Profile_Required__c)
              && vacancy.Post_DISC_Not_a_Fit__c==true){
                    DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'PostDISCNotAFit');
                    
                }
            
            //Email One Option B: Not a Fit Pre DISC Assessment
            //Trigger:  Application Status changed to Not a Fit and Meets DISC Profile Required is Blank 
            if(application.Meets_DISC_Profile_Required__c == null && application.deapp__Status__c=='Not a Fit' && 
               application.deapp__Status__c !=oldApplication.deapp__Status__c
              && vacancy.Not_a_Fit_Pre_DISC_Assessment__c==true){
                    DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'NotAFitPreDISCAssessment');
                    
                }
            
            //Email One Option A. DISC Assessment
            //Trigger:  Application Status changed to DISC Sent
            if(application.deapp__Status__c=='DISC Sent' && 
               application.deapp__Status__c !=oldApplication.deapp__Status__c && vacancy.DISC_Assessment_Sent__c==true){
                    DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'DISCAssessmentSent');
                }
                        
            //------OLD Triggers-------
            //if for for Phone Interview Request Template
            if(application.Phone_Interview_Request__c == true &&
               application.Phone_Interview_Request__c != oldApplication.Phone_Interview_Request__c){
                   //Call method for Phone Interview Request Template
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'PhoneInterviewRequest');
               }
            
            //if for for Regret_to_Inform__c Template
            if(application.Regret_to_Inform__c == true &&
               application.Regret_to_Inform__c !=oldApplication.Regret_to_Inform__c){
                   //Call method for Regret_to_Inform__cTemplate
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'regretToInform');
               }
            
            //if for for Regret_to_Inform_Interviewed__c Template
            if(application.Regret_to_Inform_Interviewed__c == true &&
               application.Regret_to_Inform_Interviewed__c !=oldApplication.Regret_to_Inform_Interviewed__c){
                   //Call method for Regret_to_Inform_Interviewed__c Template
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'regretInformInterview');
               }
            
            //if for for Request_for_References__c Template
            if(application.Request_for_References__c == true &&
               application.Request_for_References__c !=oldApplication.Request_for_References__c){
                   //Call method for Request_for_References__c Template
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'RequestForReferences');
                   
               }
            
            //if for for Invitation_to_In_Person_Interview__c Template
            if(application.Invitation_to_In_Person_Interview__c == true &&
               application.Invitation_to_In_Person_Interview__c !=oldApplication.Invitation_to_In_Person_Interview__c){
                   //Call method for Invitation_to_In_Person_Interview__c Template
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'InvitationPersonInterview');
                   
               }
            
            //if for for Phone_Interview_Request__c Template
            if(application.Welcome_Aboard__c == true &&
               application.Welcome_Aboard__c !=oldApplication.Welcome_Aboard__c){
                   //Call method for Phone_Interview_Request__c Template
                   DiacoSendVacancyEmails.sendVacancyEmail(application.Id,'WelcomeAboard');
               }

        }
  
    }
}