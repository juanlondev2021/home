/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            kunnect Inbound
 * TestClass:          SyncKunnectUsAddressTest
 * Description:        JOB to POST Homse Service Server, Inser User Address Kunnect DB
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    30/03/2021         Jull Quintero D         Initial implementation of the class.
 **/


public class SyncKunnectUsAddressBridge {
    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible for getting and setting user Address Records 
    * @param setting(KunnectScheduleSetting) 
    **/
    public static void Actions(KunnectScheduleSetting setting) {        
        List<User_Address__c>  userAddress = setting.getInboundUserAddress();
        
        if ( !userAddress.isEmpty() ) {
            /*System.debug('>> Setting Current Job ');
            System.debug('>> start: ' + setting.start);
            System.debug('>> get new User Address?: ' + setting.newUserAddress);
            System.debug('>> currentUserAddreSize: ' + setting.currentUserAddreSize);*/
            
            List<User_Address__c> updateUserAddress = new List<User_Address__c>();
            KunnectUsAddressDTO requestUserAddress = new KunnectUsAddressDTO();

            set<Integer> confNumbers = new set<Integer>();
            integer startLog;
            integer cont = 0;
            // Setting User Address and create Recuest
            for (Integer i = setting.start; i < setting.currentUserAddreSize; i++) {
                User_Address__c current = userAddress[i];

                // Save miltipicklist
                list<String> KunnectSync = new List<String>();
                if( current.Kunnect_Sync__c != null ) KunnectSync =  current.Kunnect_Sync__c.split(';');
                if( !KunnectSync.contains('contact_metro_inbound') ) KunnectSync.add('contact_metro_inbound');
                current.Kunnect_Sync__c = diacoKnifeFunc.formatMultipickList(KunnectSync);

                // Confirmation number and Users Address Record
                confNumbers.add( integer.valueOf(current.Confirmation_Number__C) );
                updateUserAddress.add(current);
                // Split Records
                startLog = i + 1;
                if( cont == setting.recordSize - 1 ) break;
                cont +=1; 
            }
    
            requestUserAddress.userAddress = updateUserAddress;
            requestUserAddress.confNumbers = confNumbers;
            String request = KunnectUsAddressDTO.createJson(requestUserAddress);

            setting.newUserAddress = false;
            setting.nextRun = System.now().addMinutes(1);
            String settingStr = KunnectScheduleSetting.createJson(setting); 
            
            SyncKunnectUsAddressBridge.inbound(settingStr, request, startLog);
        }else {
            //Executing to assign a new job
            setting.nextRun = System.now().addMinutes(35);
            SyncKunnectUsAddressBridge.Assignjob(setting);
        }
    }

    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible for server callout 
    * @param setting(KunnectScheduleSetting) 
    **/
    @future(callout=true)
    private static void inbound(String settingStr, String request, integer startLog) {
        KunnectScheduleSetting setting = KunnectScheduleSetting.parse(settingStr);
        KunnectUsAddressDTO UsAddress = KunnectUsAddressDTO.parse(request);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://salesforcewebsiteapi.herokuapp.com/api/v1.0/inbound/insertUserAddressInKunnect');
        //req.setEndpoint('https://fc250a298972.ngrok.io/api/v1.0/inbound/insertUserAddressInKunnect');
        req.setMethod('POST');
        req.setHeader( 'origin' , 'https://myhomeservices.com/');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(request);
        integer statusCode = 0;
        String message = 'Not Connect';
        String emailReport = 'Not Report';
        Boolean sendRequest = false;
        Boolean sendEmail = false;
        try {
            HttpResponse res = http.send(req);
            statusCode = res.getStatuscode();
            if( statusCode == 200 ) {
                message = 'Success';
                Object body = (Object)JSON.deserializeUntyped(res.getBody());
                String json = KunnectResponseDTO.createJson(body);
                KunnectResponseDTO response = KunnectResponseDTO.parse(json);
                // Set Email Report
                if( setting.emailReport.get('contact_metro_inbound') == null ) setting.emailReport.put('contact_metro_inbound', '0');
                if( setting.emailReport.get('totalRows') == null ) setting.emailReport.put('totalRows', '0');
                if( setting.emailReport.get('SqlMessage') == null ) setting.emailReport.put('SqlMessage', 'Success');

                // count rows
                integer totalInserts = Integer.valueOf(setting.emailReport.get('contact_metro_inbound'))  + response.affectedRows;
                setting.emailReport.put('contact_metro_inbound', String.valueOf(totalInserts));

                integer totalRows = Integer.valueOf(setting.emailReport.get('totalRows')) + response.totalRows;
                setting.emailReport.put('totalRows', String.valueOf(totalRows));
                
                if( response.ok ) {
                    // update user Address
                    List<User_Address__c> updateUserAddress = UsAddress.userAddress;
                    update updateUserAddress;

                }else {
                    sendRequest = true;
                    setting.emailReport.put('SqlMessage', response.message);
                }

                emailReport = 'contact_metro_inbound - ' + totalInserts + '/' + totalRows + 
                ' - SqlMessage: ' + setting.emailReport.get('SqlMessage');

                // Reset Next Run
                sendEmail = setting.sendEmail(startLog);

                /*System.debug('>> Setting Next Job ');
                System.debug('>> start: ' + setting.start);
                System.debug('>> get new User Address?: ' + setting.newUserAddress);
                System.debug('>> currentUserAddreSize: ' + setting.currentUserAddreSize);
                System.debug('>> map report email ' + setting.emailReport);*/
            }
        } catch (Exception e) {
            message = e.getMessage();
            sendEmail = true;
        }

        //Executing to assign a new job
        SyncKunnectUsAddressBridge.Assignjob(setting);

        // Send Sms
        String body ='Salesforce to Kunnect Daily Import Inbound on ' + System.date.today().format() +
                    '\nReport: ' + emailReport + 
                    '\nMessage: ' + message;
        if ( sendRequest ) {
            body +='\nConfirmation Numbers: ' + KunnectUsAddressDTO.createJson(UsAddress.confNumbers);
        }
        if( sendEmail || statusCode != 200 ) {
            Messaging.SendEmailResult[] results = diacoKnifeFunc.sendEmail
            (
                new String[] {'jullsforce@gmail.com','emorales@diaco.us'}, 
                'Sync KunnectDB User Address',
                body
            );
        }

    }

    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible of executing to assign a new job
    * @param setting(KunnectScheduleSetting) 
    **/
    private static void Assignjob(KunnectScheduleSetting setting) {
        DateTime myDateTime = setting.nextRun;
        SyncKunnectUsAddressShedule nextRequest = new SyncKunnectUsAddressShedule(setting);
        String title = 'Sync KunnectDB User Address';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        String jobID = system.schedule(title, sch, nextRequest);
    }

    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible of deleting the with the name: Sync KunnectDB User Address.
    **/
    public static void deleteJob() {
        String title = 'Sync KunnectDB User Address';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE CronJobDetail.Name = :title]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
    
}