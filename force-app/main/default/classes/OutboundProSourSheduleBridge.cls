/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            kunnect Protection Source 
 * TestClass:          OutboundProSourSheduleTest
 * Description:        Job to POST Home Service Server, Insert User Address Kunnect DB
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    09/04/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class OutboundProSourSheduleBridge {

    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible for getting and setting user Address Records 
    * @param setting(KunnectScheduleSetting) 
    **/
    public static void Actions(KunnectScheduleSetting setting) {        
        List<User_Address__c>  userAddress = setting.getOutboundSourceUserAddress();
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
            List<String> tablesNames = KunnectScheduleSetting.SOURCETABLES;
            for (Integer i = setting.start; i < setting.currentUserAddreSize; i++) {
                User_Address__c current = userAddress[i];

                // Save miltipicklist
                list<String> KunnectSync = new List<String>();
                if( current.Kunnect_Sync__c != null ) KunnectSync = current.Kunnect_Sync__c.split(';');
                
                for (string item : tablesNames) {
                    if (item == 'source_contact_solar' ) {
                        if( current.Address__r != null ) {
                            if( KunnectScheduleSetting.ZIPCODES.contains(current.Address__r.Zip_Code__c) ) {
                                if( !KunnectSync.contains('source_contact_solar') ) KunnectSync.add('source_contact_solar');
                            }else {
                                if( !KunnectSync.contains('source_contact_srp_solar') ) KunnectSync.add('source_contact_srp_solar');
                            }
                        }
                        continue;
                    }
                    if( !KunnectSync.contains(item) ) KunnectSync.add(item);
                }
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
            
            OutboundProSourSheduleBridge.outbound(settingStr, request, startLog);
        }else {
            //Executing to assign a new job
            integer year  = System.Date.today().year();
            integer month = System.Date.today().month();
            integer day  = System.Date.today().day() + 1;
            //10:00:00 Phoenix
            setting.nextRun = DateTime.newInstance(year, month, day, 2, 20, 0);
            OutboundProSourSheduleBridge.Assignjob(setting);
        }
    }

    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible for server callout 
    * @param setting(KunnectScheduleSetting) 
    **/
    @future(callout=true)
    private static void outbound(String settingStr, String request, integer startLog) {
        KunnectScheduleSetting setting = KunnectScheduleSetting.parse(settingStr);
        KunnectUsAddressDTO UsAddress = KunnectUsAddressDTO.parse(request);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://salesforcewebsiteapi.herokuapp.com/api/v1.0/outbound-protection-source/');
        //req.setEndpoint('https://fc250a298972.ngrok.io/api/v1.0/outbound-protection-source/');
        req.setMethod('POST');
        req.setHeader( 'origin' , 'https://myhomeservices.com/');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(request);
        integer statusCode = 0;
        String message = 'Not Connect';
        String emailReport = 'Not Report';
        Boolean sendEmail = false;

        try{
            HttpResponse res = http.send(req);
            statusCode = res.getStatuscode();
            if( statusCode == 200 ) {
                message = 'Success';
                emailReport = '';
                List<String> tablesFails = new List<String>();
                List<object> body = (List<object>)JSON.deserializeUntyped(res.getBody());                
                for (Object item : body) {
                    String json = KunnectResponseDTO.createJson(item);
                    KunnectResponseDTO response = KunnectResponseDTO.parse(json);

                    // Email Report
                    string tableName = response.tableName;
                    if( setting.emailReport.get(tableName) == null ) setting.emailReport.put(tableName, '0'); // total Inserts
                    if( setting.emailReport.get(tableName+'TotalRows') == null ) setting.emailReport.put(tableName+'TotalRows', '0');
                    if( setting.emailReport.get(tableName+'SqlMessage') == null ) setting.emailReport.put(tableName+'SqlMessage', 'Success');

                    // Count Total Inserts;
                    integer totalInserts = integer.valueOf( setting.emailReport.get(tableName) ) + response.affectedRows;
                    setting.emailReport.put(tableName, string.valueOf(totalInserts) );
                    
                    // Count Total Rows;
                    integer totalRows = integer.valueOf( setting.emailReport.get(tableName+'TotalRows') ) + response.totalRows;
                    setting.emailReport.put(tableName+'TotalRows',string.valueOf(totalRows) );  
                    
                    if ( !response.ok ) {             
                        tablesFails.add(tableName);
                        setting.emailReport.put(tableName+'SqlMessage', response.message);
                    }
                    emailReport += '\n'+ tableName + ' - ' + totalInserts + '/' + totalRows+
                    ' - SqlMessage: ' + setting.emailReport.get(tableName+'SqlMessage');
                }


                // update userAddress
                List<User_Address__c> updateUserAddress = UsAddress.userAddress;
                if ( !tablesFails.isEmpty() ) {
                    message = 'Error in some tables';
                    integer userAddreSize = updateUserAddress.size();
                    for (Integer i = 0; i < userAddreSize; i++) {
                        User_Address__c current = updateUserAddress[i];
                        set<String> KunnectSync = new Set<String>(current.Kunnect_Sync__c.split(';'));
                        KunnectSync.removeAll(tablesFails);
                        current.Kunnect_Sync__c = diacoKnifeFunc.formatMultipickList(new list<String>(KunnectSync));
                    }                    
                }
                update updateUserAddress;
            
                // Reset Next Run
                sendEmail = setting.sendEmail(startLog);

                /*System.debug('>> Setting Next Job ');
                System.debug('>> start: ' + setting.start);
                System.debug('>> get new User Address?: ' + setting.newUserAddress);
                System.debug('>> currentUserAddreSize: ' + setting.currentUserAddreSize);
                System.debug('>> map report email ' + setting.emailReport);*/
            }
        }catch (Exception e) {
            message = e.getMessage();
            sendEmail = true;
            emailReport = 'Error';
        }

        //Executing to assign a new job
        OutboundProSourSheduleBridge.Assignjob(setting);

        // Send Sms
        String body ='Salesforce to Kunnect Daily Import Source on ' + System.date.today().format() +
                    '\nReport: ' + emailReport;                    
        if( sendEmail || statusCode != 200 ) {
            Messaging.SendEmailResult[] results = diacoKnifeFunc.sendEmail
            (
                new String[] {'jullsforce@gmail.com','emorales@diaco.us'}, 
                'KunnetDB Outbound Protection Source',
                body  +='\nMessage: ' + message+
                '\nConfirmation Numbers: ' + KunnectUsAddressDTO.createJson(UsAddress.confNumbers)
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
        OutboundProSourShedule nextRequest = new OutboundProSourShedule(setting);
        String title = 'Outbound Protection Source';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        String jobID = system.schedule(title, sch, nextRequest);
    }

    /**
    * @author Jull Quintero | 10/04/2021 
    * @description: Method responsible of deleting the with the name: Outbound Protection Source.
    **/
    public static void deleteJob() {
        String title = 'Outbound Protection Source';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE CronJobDetail.Name = :title]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
}