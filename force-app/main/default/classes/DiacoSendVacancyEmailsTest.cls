@isTest
public class DiacoSendVacancyEmailsTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    //Setup method, user, Vacancy and application Created.
    @TestSetup static void setup() {
        /*Send grid Custom setting*/
        Send_Grid__c sendGrid= new Send_Grid__c(Api_Key__c='22121', employ_invitationInPersonInterview__c='dedwq21',employ_phoneInterviewRequest__c='dedwq21',
                                                employ_regretToinform__c='dedwq21', employ_regretToInformInterview__c='dedwq21',employ_requestForReferences__c='dedwq21',employ_welcomeAboard__c='dedwq21' );
        insert sendGrid;
        /*Create User*/
        User u2 = new user();
        u2.LastName = 'Test Public Calendar';
        u2.Email = 'test3@test.com';
        u2.Alias = 'PubliCa';
        u2.Username = 'TestEvent3@test.com';
        u2.CommunityNickname = 'tests122';
        u2.LocaleSidKey = 'en_US';
        u2.TimeZoneSidKey = 'GMT';
        u2.ProfileID = '00e41000001hNuFAAU';
        u2.LanguageLocaleKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        insert u2;
        deapp__Apply_now__c vacancy = new deapp__Apply_now__c(Company_Name__c='CompanyName Test',
                                                              deapp__Hiring_Manager__c=u2.Id, 
                                                              Name='Junior Developer',
                                                              deapp__Title__c='Title Test',
                                                              deapp__State__c=true,
                                                              DISC_Assessment_Sent__c=true,
                                                              Not_a_Fit_Pre_DISC_Assessment__c=true,
                                                              Onboarding__c=true,
                                                              Outbound_Orientation__c=true,
                                                              Post_DISC_Not_a_Fit__c=true,
                                                              Post_Interview_Not_a_Fit__c=true,
                                                              Video_Interview_Invite__c=true,
                                                              Website_Video__c=true
                                                             );
        insert vacancy;
        
        deapp__Applicant__c application= new deapp__Applicant__c(
            Name='John',
            deapp__First_Name__c='John',
            deapp__Last_Name__c='Hernandez',
            deapp__Phone__c='312112121',
            deapp__City__c='New York',
            deapp__Email__c='john@hotmail.com',
            deapp__ZIP_Code__c=12313,
            deapp__Street_Address__c='Street test',
            deapp__Vacancy__c=vacancy.Id,
            deapp__Position_Applied_for__c='position test',
            deapp__Status__c='New',
            Regret_to_Inform__c=false,
            Phone_Interview_Request__c=false,
            Invitation_to_In_Person_Interview__c=false,
            Welcome_Aboard__c=false,
            Request_for_References__c=false,
            Regret_to_Inform_Interviewed__c=false
        );
        insert application;
        
        //Setup data for batchjob
        
        //Application with disc sent status a no need to re send email yet 
        deapp__Applicant__c application2= new deapp__Applicant__c(
            Name='John',
            deapp__First_Name__c='John',
            deapp__Last_Name__c='Hernandez',
            deapp__Phone__c='312112121',
            deapp__City__c='New York',
            deapp__Email__c='john@hotmail.com',
            deapp__ZIP_Code__c=12313,
            deapp__Street_Address__c='Street test',
            deapp__Vacancy__c=vacancy.Id,
            deapp__Position_Applied_for__c='position test',
            deapp__Status__c='DISC Sent',
            Disc_Emails_Sent__c=2,
            Last_DISC_Date__c=System.now().addDays(-3)
                    
        );
        insert application2;
        
        //Application with disc sent status, counter 2, last disc date should trigger the re sending email
        deapp__Applicant__c application3= new deapp__Applicant__c(
            Name='John',
            deapp__First_Name__c='John',
            deapp__Last_Name__c='Hernandez',
            deapp__Phone__c='312112121',
            deapp__City__c='New York',
            deapp__Email__c='john@hotmail.com',
            deapp__ZIP_Code__c=12313,
            deapp__Street_Address__c='Street test',
            deapp__Vacancy__c=vacancy.Id,
            deapp__Position_Applied_for__c='position test',
            deapp__Status__c='DISC Sent',
            Disc_Emails_Sent__c=2,
            Last_DISC_Date__c=System.now().addDays(-6)
            
        );
        insert application3;
        
                //Application with disc sent status, counter 3, last disc date should trigger the change status to DISC not returned
        deapp__Applicant__c application4= new deapp__Applicant__c(
            Name='John',
            deapp__First_Name__c='John',
            deapp__Last_Name__c='Hernandez',
            deapp__Phone__c='312112121',
            deapp__City__c='New York',
            deapp__Email__c='john@hotmail.com',
            deapp__ZIP_Code__c=12313,
            deapp__Street_Address__c='Street test',
            deapp__Vacancy__c=vacancy.Id,
            deapp__Position_Applied_for__c='position test',
            deapp__Status__c='DISC Sent',
            Disc_Emails_Sent__c=3,
            Last_DISC_Date__c=System.now().addDays(-6)
            
        );
        insert application4;
        
        //Application with disc sent status, counter null, last disc date should trigger the  new email and emails sent should be change to 1
        deapp__Applicant__c application5= new deapp__Applicant__c(
            Name='John',
            deapp__First_Name__c='John',
            deapp__Last_Name__c='Hernandez',
            deapp__Phone__c='312112121',
            deapp__City__c='New York',
            deapp__Email__c='john@hotmail.com',
            deapp__ZIP_Code__c=12313,
            deapp__Street_Address__c='Street test',
            deapp__Vacancy__c=vacancy.Id,
            deapp__Position_Applied_for__c='position test',
            deapp__Status__c='DISC Sent',
            Last_DISC_Date__c=System.now().addDays(-6)
            
        );
        insert application5;
        
    }
    
    //Test 6 checkbox and send DISC and WebsiteVideo
    @isTest static void testAll(){
        deapp__Applicant__c application= [Select Id From deapp__Applicant__c where Last_DISC_Date__c=null];
        
        Test.startTest();
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        application.Regret_to_Inform__c=true;
        application.Phone_Interview_Request__c=true;
        application.Invitation_to_In_Person_Interview__c=true;
        application.Welcome_Aboard__c=true;
        application.Request_for_References__c=true;
        application.Regret_to_Inform_Interviewed__c=true;
        application.Meets_DISC_Profile_Required__c='Yes';
        application.deapp__Status__c='DISC Sent';
        update application;
        Test.stopTest();
        
    }
    
    //Test DISC send with already sent emails
    @isTest static void testDISCSent2(){
        deapp__Applicant__c application= [Select Id From deapp__Applicant__c where Last_DISC_Date__c=null];
        
        Test.startTest();
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        application.Meets_DISC_Profile_Required__c='Yes';
        application.deapp__Status__c='DISC Sent';
        application.Disc_Emails_Sent__c=2;
        update application;
        Test.stopTest();
        
    }
   
    //Test email when applicant is Hired
    @isTest static void isHired(){
        deapp__Applicant__c application= [Select Id From deapp__Applicant__c where Last_DISC_Date__c=null];
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        Test.startTest();
        application.deapp__Status__c='Hired';
        update application;
        Test.stopTest();
        
    }
    
    //Email One Option B: Not a Fit Pre DISC Assessment TODO:Check{City}, {State}.
    //Trigger:  Application Status changed to Not a Fit and Meets DISC Profile Required is Blank 
    @isTest static void NotAFitPreDISCAssessment(){
        deapp__Applicant__c application= [Select Id From deapp__Applicant__c where Last_DISC_Date__c=null];
     
        Test.startTest();
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        // Test *Email One Option B: Not a Fit Pre DISC Assessment
        
        application.deapp__Status__c='Not a Fit';
        update application;
        
        
        Test.stopTest();
        
    }
    
    //Test  *Email Two Option A: Post DISC Not a Fit 
    @isTest static void PostDISCNotAFit(){
        deapp__Applicant__c application=[Select Id,deapp__Status__c,Meets_DISC_Profile_Required__c From deapp__Applicant__c where Last_DISC_Date__c=null];
        
        Test.startTest();
        //Test  *Email Two Option A: Post DISC Not a Fit 
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        application.deapp__Status__c='Not a Fit';
        application.Meets_DISC_Profile_Required__c='No';
        update application;
        Test.stopTest();
        
    }
    
        //Test  *Email Two Option A: Post Interview Not a Fit 
    @isTest static void PostInterviewNotAFit(){
        deapp__Applicant__c application=[Select Id,deapp__Status__c,Meets_DISC_Profile_Required__c From deapp__Applicant__c where Last_DISC_Date__c=null];
        List<User> u=[Select id From User];
        Test.startTest();
        //Test  *Email Two Option A: Post DISC Not a Fit 
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        application.deapp__Status__c='Not a Fit';
        application.Meets_DISC_Profile_Required__c='Yes';
        application.deapp__Interview_Schedule__c=true;
        application.deapp__Interviewed_With__c=u[0].Id;
        application.deapp__Interview_Date__c=System.today();
        update application;
        Test.stopTest();
        
    }
    
    //Email Three Option B: Outbound Orientation
    //Application Status changed to Training Scheduled AND Training Start Date and Training End Date are populated.
    @isTest static void outboundOrientation(){
        deapp__Applicant__c application=[Select Id From deapp__Applicant__c where Last_DISC_Date__c=null];
        
        Test.startTest();
        //Test  *Email Two Option A: Post DISC Not a Fit 
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        application.deapp__Status__c='Training Scheduled';
        application.deapp__Training_Start_Date__c=System.today();
        application.deapp__Training_End_Date__c=System.today();
        update application;
        Test.stopTest();
        
    }
    
    @isTest static void reSendDISCEmailScheduleTest(){
        
        Test.startTest();
        test.setMock(HttpCalloutMock.class, new DiacoSendVacancyEmailsHttpCallOutMock());
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP,  new DiacoApplicationDISCSchedule());   
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        /*
        // Verify the job has not run with the 4 orientations still active
        list<Orientation__c> ActiveOrientation=[SELECT ID,Name,(SELECT Name,Training_Start_Date__c  FROM Tranings__r) FROM Orientation__c WHERE Current_Orientation__c = true];
        System.debug('Number of actives Orientations before batch executed by schedule apex: '+ActiveOrientation.size());
        System.assertEquals(4, ActiveOrientation.size());
        System.debug(ActiveOrientation);
        // Stopping the test will run the job synchronously
        Test.stopTest();
        // Verify the job has run with 2 orientations Active
        list<Orientation__c> ActiveOrientation2=[SELECT ID,Name,(SELECT Name,Training_Start_Date__c  FROM Tranings__r) FROM Orientation__c WHERE Current_Orientation__c = true];
        System.debug('Number of actives Orientations after batch executed by schedule apex: '+ActiveOrientation2.size());
        System.debug(ActiveOrientation2);*/
    }
    

}