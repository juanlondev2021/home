/*

Diaco
@author 			John Javier Hernande Araujo href=<johnj.hernandez.araujo@gmail.com>
Project:			Employment App
Description:		class reponsible for sending Vacancies email 

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0			04/04/2020				John Hernandez (JH)	Initial implementation  of the class.
*/
public class DiacoSendVacancyEmails {
        /**
* 
* This method is responsible to send review email.
* 
* This method is used in:
*  the  DiacoSendVacancyEmail.apxt trigger
*  
* 
* @param RecordId is the Event Id controller
* @return nothing
*/ 
    @future(callout=true)
    public static void sendVacancyEmail(String Id,String TemplateName){
        deapp__Applicant__c application = [select Id,
                                           Name,
                                           deapp__Email__c,
                                           deapp__Position_Applied_for__c,
                                           deapp__Vacancy__r.deapp__Title__c,  
                                           deapp__Vacancy__r.deapp__Hiring_Manager__r.name,
                                           deapp__Vacancy__r.Company_Name__c,
                                           deapp__City__c,
                                           deapp__State__c,
                                           deapp__Training_End_Date__c,
                                           deapp__Training_Start_Date__c,
                                           Disc_Emails_Sent__c,
                                           Last_DISC_Date__c
                                           from deapp__Applicant__c where Id=:Id];
        
        if(application.Name != null
           && application.deapp__Email__c != null
          && application.deapp__Vacancy__r.deapp__Title__c != null
           && application.deapp__Position_Applied_for__c != null
          && application.deapp__Vacancy__r.deapp__Hiring_Manager__c != null
          && application.deapp__Vacancy__r.Company_Name__c != null){
               DiacoSendVacancyEmails.sendEmail(application,TemplateName);
               System.debug('Email sent');
           }
    }
    /**
* 
* This method is responsible to send Vacancy email.
* 
* This method is used in:
*  the  DiacoSendVacancyEmail.apxc apex
*  
* 
* @param Event
* @return HttpResponse
*/ 
    public static HttpResponse sendEmail(deapp__Applicant__c application, String templateName){
        System.debug('Reached Send Email Body');
        System.debug('SENDING EMAIL'+templateName);
        Send_Grid__c config = [select Api_Key__c from Send_Grid__c];
        String template = DiacoSendVacancyEmails.getTemplateId(templateName);
        String fromEmail='hiring@keepamericaselling.com';
        
        String endpoint = 'https://api.sendgrid.com/v3/mail/send';
        String body = '{"personalizations": [{'+
            '"to": ['+
            '{'+
            '"email":"' +application.deapp__Email__c+'"'+
            '}'+
            '],'+
            '"dynamic_template_data": {'+
            '"Applicant":"'+application.Name+'"'+
            '"CompanyName":"'+application.deapp__Vacancy__r.Company_Name__c+'"'+
            '"JobTitle":"'+application.deapp__Position_Applied_for__c+'"'+
            '"City":"'+application.deapp__City__c+'"'+
            '"State":"'+application.deapp__State__c+'"'+
            '"landingPageURL":"'+'https://keepamericaselling.com/index.php/video/?id='+application.Id+'"'+
            '"HiringManager":"'+application.deapp__Vacancy__r.deapp__Hiring_Manager__r.name+'"'+
            '"TrainingStartDate":"'+application.deapp__Training_Start_Date__c+'"'+
            '"TrainingEndDate":"'+application.deapp__Training_End_Date__c+'"'+
            '"Title":"'+application.deapp__Vacancy__r.deapp__Title__c+'"'+
            '},'+
            '}],'+
            '"template_id":"'+template+'",'+
            '"from": {'+
            '"email":'+ '"'+fromEmail+'"'+
            '}'+
            '}';
        System.debug(body);
        System.debug(config.Api_Key__c);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', config.Api_Key__c);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        System.debug(request.getHeader('Authorization'));
        HttpResponse response = http.send(request);
        // Parse the JSON response
        System.debug('The status code returned was : ' +
                     response.getStatusCode() + ' ' + response.getStatus());
        

        //Apply History 
        Application_Email_History__c emailHistory = New Application_Email_History__c(
            Applicant_Email__c = application.deapp__Email__c,
            Application__c = application.id,
            Date_Sent__c = System.now(),
            Response_Body__c = body,
            Response_Status__c = response.getStatus(),
            Response_Status_Code__c = String.valueOf(response.getStatusCode()),
            Template_Id__c = template,
            Template_String__c = templateName
        );
        insert emailHistory;
        
        //Manage Disc Assesment fields for re-sending email
        if(templateName=='DISCAssessmentSent'){
            deapp__Applicant__c app= new deapp__Applicant__c(id=application.id);
            Integer counter=0;
            if(application.Disc_Emails_Sent__c==null ||application.Disc_Emails_Sent__c==0){
                counter=1;
            }else{
                counter= application.Disc_Emails_Sent__c.intValue()+1;
            }
            
            app.Disc_Emails_Sent__c=counter;
            app.Last_DISC_Date__c=System.now();
            update app;
            
        }
        //Return
        return response;
    }
    
    
    
    /*FOR BATCH APEX
	This method will not be a future method so it can return an object, for batch operations it will return the history object and the application to update  wrapped in a new class
called DiacoApplicationAndEmailHistory
*/
    public static DiacoApplicationAndEmailHistory sendEmailBatch(deapp__Applicant__c application, String templateName){
        System.debug('Reached Send Email Body');
        System.debug('SENDING EMAIL'+templateName);
        Send_Grid__c config = [select Api_Key__c from Send_Grid__c];
        String template = DiacoSendVacancyEmails.getTemplateId(templateName);
        String fromEmail='hiring@keepamericaselling.com';
        
        String endpoint = 'https://api.sendgrid.com/v3/mail/send';
        String body = '{"personalizations": [{'+
            '"to": ['+
            '{'+
            '"email":"' +application.deapp__Email__c+'"'+
            '}'+
            '],'+
            '"dynamic_template_data": {'+
            '"Applicant":"'+application.Name+'"'+
            '"CompanyName":"'+application.deapp__Vacancy__r.Company_Name__c+'"'+
            '"JobTitle":"'+application.deapp__Position_Applied_for__c+'"'+
            '"City":"'+application.deapp__City__c+'"'+
            '"State":"'+application.deapp__State__c+'"'+
            '"landingPageURL":"'+'https://keepamericaselling.com/index.php/video/?id='+application.Id+'"'+
            '"HiringManager":"'+application.deapp__Vacancy__r.deapp__Hiring_Manager__r.name+'"'+
            '"TrainingStartDate":"'+application.deapp__Training_Start_Date__c+'"'+
            '"TrainingEndDate":"'+application.deapp__Training_End_Date__c+'"'+
            '"Title":"'+application.deapp__Vacancy__r.deapp__Title__c+'"'+
            '},'+
            '}],'+
            '"template_id":"'+template+'",'+
            '"from": {'+
            '"email":'+ '"'+fromEmail+'"'+
            '}'+
            '}';
        System.debug(body);
        System.debug(config.Api_Key__c);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', config.Api_Key__c);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        System.debug(request.getHeader('Authorization'));
        HttpResponse response = http.send(request);
        // Parse the JSON response
            System.debug('The status code returned was : ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
        //Apply History 
        Application_Email_History__c emailHistory = New Application_Email_History__c(
            Applicant_Email__c = application.deapp__Email__c,
            Application__c = application.id,
            Date_Sent__c = System.now(),
            Response_Body__c = body,
            Response_Status__c = response.getStatus(),
            Response_Status_Code__c = String.valueOf(response.getStatusCode()),
            Template_Id__c = template,
            Template_String__c = templateName
        );
      //  insert emailHistory;
        
        //Manage Disc Assesment fields for re-sending email
        
        deapp__Applicant__c app= new deapp__Applicant__c(id=application.id);
        Integer counter=0;
        if(application.Disc_Emails_Sent__c==null ||application.Disc_Emails_Sent__c==0){
            counter=1;
        }else{
            counter= application.Disc_Emails_Sent__c.intValue()+1;
        }
        
        app.Disc_Emails_Sent__c=counter;
        app.Last_DISC_Date__c=System.now();
        //update app;
        DiacoApplicationAndEmailHistory appAndResponse=new DiacoApplicationAndEmailHistory();
        appAndResponse.app=app;
        appAndResponse.history=emailHistory;
        //Return
        return appAndResponse;
    }

    
    
    /**
* 
* This method is responsible to get template Id.
* @param name of the email to be Sent
* @return String
*/ 
    public static String getTemplateId(String name){
        System.debug('Reached getTemplateId');
        
        Send_Grid__c templates = [select employ_invitationInPersonInterview__c,
                                  employ_phoneInterviewRequest__c,
                                  employ_regretToinform__c,
                                  employ_regretToInformInterview__c,
                                  employ_requestForReferences__c,
                                  employ_welcomeAboard__c
                                  from Send_Grid__c];
        String templateId = '';
        if(name.contains('InvitationPersonInterview')){
            templateId=templates.employ_invitationInPersonInterview__c;
        }else if(name.contains('PhoneInterviewRequest')){
            templateId=templates.employ_phoneInterviewRequest__c;
        }else if(name.contains('regretToInform')){
            templateId=templates.employ_regretToinform__c;
        }else if(name.contains('regretInformInterview')){
            templateId=templates.employ_regretToInformInterview__c;
        }else if(name.contains('RequestForReferences')){
            templateId=templates.employ_requestForReferences__c;    
        }else if(name.contains('WelcomeAboard')){
            templateId=templates.employ_welcomeAboard__c;
        }else if(name.contains('WebsiteVideo')){
            //Create SendGridField if decided
            templateId='d-79740f0359944bc5972b4377b5a1da1a';
        }
        else if(name.contains('DISCAssessmentSent')){
            //Create SendGridField if decided
            templateId='d-13e22acbe18148ffaea8555254bf7ff4';
        }else if(name.contains('NotAFitPreDISCAssessment')){
            //Create SendGridField if decided
            templateId='d-681bd6e56b854f5187253a08d68c4491';
        }else if(name.contains('PostDISCNotAFit')){
            //Create SendGridField if decided
            templateId='d-1849db437cd241629586b2a6f0f8e33f';
        }
        else if(name.contains('VideoInterviewInvite')){
            //Create SendGridField if decided
            templateId='d-9bff39f8429c46138d813c41d63439b1';
        }else if(name.contains('NotAFitPostInterview')){
            //Create SendGridField if decided
            templateId='d-beccbde28e5542659cc51b03f5dd0ca1';
        }else if(name.contains('OutboundOrientation')){
            //Create SendGridField if decided
            templateId='d-6dddd322527942af820ad589a1f38170';
        }else if(name.contains('Onboarding')){
            //Create SendGridField if decided
            templateId='d-443415da0b87416f920d0e8795bdb9f6';
        }
        return templateId;
    }
    
}