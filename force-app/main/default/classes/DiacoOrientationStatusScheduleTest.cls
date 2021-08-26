@isTest
private class DiacoOrientationStatusScheduleTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @testSetup 
    static void setup() {
        //Create User
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
        //Create Vacancy
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

        //Creamos 4 Orientations con estado activo
        Orientation__c o1=new Orientation__c(Name='O1',Vacancy__c=vacancy.Id,Current_Orientation__c=true); 
        Orientation__c o2=new Orientation__c(Name='O2',Vacancy__c=vacancy.Id,Current_Orientation__c=true); 
        Orientation__c o3=new Orientation__c(Name='O3',Vacancy__c=vacancy.Id,Current_Orientation__c=true); 
        Orientation__c o4=new Orientation__c(Name='O4',Vacancy__c=vacancy.Id,Current_Orientation__c=true); 
        insert o1;
        insert o2;
        insert o3;
        insert o4;
        System.now().addHours(4);
            
        //We create the trainnings
         //orientation 1 will have 2 training days with start date previous to current Date(Should be Inactive)
        Training__c t1= new Training__c(Name='t1',Orientation__c=o1.Id,Training_Start_Date__c=System.now().addHours(-4),Training_End_Date__c=System.now().addHours(+8));
        Training__c t2= new Training__c(Name='t2',Orientation__c=o1.Id,Training_Start_Date__c=System.now().addHours(-4),Training_End_Date__c=System.now().addHours(+8));
         //orientation 2 will have 2 training days with start date after to current Date(Should stay active)
        Training__c t3= new Training__c(Name='t3',Orientation__c=o2.Id,Training_Start_Date__c=System.now().addHours(4),Training_End_Date__c=System.now().addHours(+8));
        Training__c t4= new Training__c(Name='t4',Orientation__c=o2.Id,Training_Start_Date__c=System.now().addHours(4),Training_End_Date__c=System.now().addHours(+8));
        //orientation 3 will have 1 training date with start date after to current Date and one previous(Should be active)
        Training__c t5= new Training__c(Name='t5',Orientation__c=o3.Id,Training_Start_Date__c=System.now().addHours(4),Training_End_Date__c=System.now().addHours(+8));
        Training__c t6= new Training__c(Name='t6',Orientation__c=o3.Id,Training_Start_Date__c=System.now().addHours(-4),Training_End_Date__c=System.now().addHours(+8));
        //orientation 4 will have 2 training days with start date previous to current Date(Should be Inactive)
        Training__c t7= new Training__c(Name='t7',Orientation__c=o4.Id,Training_Start_Date__c=System.now().addYears(-4),Training_End_Date__c=System.now().addHours(+8));
        Training__c t8= new Training__c(Name='t8',Orientation__c=o4.Id,Training_Start_Date__c=System.now().addYears(-4),Training_End_Date__c=System.now().addHours(+8));
        insert t1;
        insert t2;
        insert t3;
        insert t4;
        insert t5;
        insert t6;
        insert t7;
        insert t8;
        
    }
    
    @isTest static void testAll(){
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP,  new DiacoOrientationStatusSchedule());   
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
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
        System.debug(ActiveOrientation2);
    }

}