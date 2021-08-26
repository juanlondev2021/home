/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Kunnect Sync renplace jitterbit
 * TestClass:          OutboundProSourSheduleTest
 * Description:        kunnect Outbound Portection Source - implements Batchable
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    05/08/2021         Jull Quintero D         Initial implementation of the class.
 **/
public class OutboundProSourBatch implements 
    Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
        private KunnectSync contact_01_security = new KunnectSync();
        private KunnectSync contact_01_water = new KunnectSync();
        private KunnectSync contact_windows_and_blinds = new KunnectSync();
        private KunnectSync contact_pest_control = new KunnectSync();
        private KunnectSync contact_hvac = new KunnectSync();
        private KunnectSync contact_solar = new KunnectSync();
        private KunnectSync contact_srp_solar = new KunnectSync();

        List<String> tablesNames = KunnectSync.SOURCETABLES;
        private Boolean sendEmail = false;
        private string message = null;
        private set<Integer> resConfirmationNumbers = new set<Integer>();

        public Database.QueryLocator start(Database.BatchableContext bc) {
            System.debug('>> start');
            // collect the batches of records or objects to be passed to execute
            return  Database.getQueryLocator(
                [
                    SELECT Id,
                    Kunnect_Sync__c,
                    fFirstName__c, 
                    fLastName__c,
                    Phone__c, 
                    Email__c, 
                    Confirmation_Number__c, 
                    Recording_Date__c, 
                    Respond_Date__c,  
                    Sales_Price__c,
                    Address__r.Street__c,  
                    Address__r.City__c, 
                    Address__r.State__c, 
                    Address__r.Zip_Code__c
                    FROM User_Address__c 
                    WHERE Phone__c != '' AND Respond_Date__c = YESTERDAY AND 
                    ( Verbal_Consent__c='Yes' OR (UserAccount__r.Verbal_Consent__c=null AND UserAccount__r.Canvasser_Disposition__c='Consent Y'))  AND 
                    Kunnect_Sync__c EXCLUDES(:String.join(tablesNames, ';'))
                ]
            );
        }

        public void execute(Database.BatchableContext bc, List<User_Address__c> records) {
            System.debug('>> execute');
            sendEmail = true;
            try {
                // Process each batch of records
                KunnectUsAddressDTO requestUserAddress = new KunnectUsAddressDTO();
                set<Integer> confNumbers = new set<Integer>();
                integer recordSize = records.size();
                for (Integer i = 0; i < recordSize; i++) {
                    User_Address__c current = records[i];

                    // Set miltipicklist Kunnect_Sync__c
                    list<String> syncValues = new List<String>();
                    if( current.Kunnect_Sync__c != null ) syncValues = current.Kunnect_Sync__c.split(';');
                    
                    for (string item : tablesNames) {
                        if ( item == 'source_contact_solar' || item == 'source_contact_srp_solar' ) {
                            if( current.Address__r != null ) {
                                if( KunnectSync.ZIPCODES.contains(current.Address__r.Zip_Code__c) ) {
                                    if( !syncValues.contains('source_contact_solar') ) syncValues.add('source_contact_solar'); 
                                }else{
                                    if( !syncValues.contains('source_contact_srp_solar') ) syncValues.add('source_contact_srp_solar');
                                }
                            }
                        }else {
                            if( !syncValues.contains(item) ) syncValues.add(item);
                        }
                    }
                    current.Kunnect_Sync__c = diacoKnifeFunc.formatMultipickList(syncValues);

                    // Confirmation numbers
                    confNumbers.add( integer.valueOf(current.Confirmation_Number__C) );
                    resConfirmationNumbers.add( integer.valueOf(current.Confirmation_Number__C) );
                }
                string endPoint = 'https://salesforcewebsiteapi.herokuapp.com/api/v1.0/outbound-protection-source';
                //string endPoint = 'https://fe6767873dd0.ngrok.io/api/v1.0/outbound-protection-source';
                requestUserAddress.userAddress = records;
                requestUserAddress.confNumbers = confNumbers;
                requestUserAddress.endPoint    = endPoint;
                contact_01_security.syncUserAddress('contact_01_security', requestUserAddress);
                contact_01_water.syncUserAddress('contact_01_water', requestUserAddress);
                contact_windows_and_blinds.syncUserAddress('contact_windows_and_blinds', requestUserAddress);
                contact_pest_control.syncUserAddress('contact_pest_control', requestUserAddress);
                contact_hvac.syncUserAddress('contact_hvac', requestUserAddress);
                contact_solar.syncUserAddress('contact_solar', requestUserAddress);
                contact_srp_solar.syncUserAddress('contact_srp_solar', requestUserAddress);

                if( KunnectSync.isUpdate ) Database.update(records, false);
            } catch (Exception e) {
                message = 'Apex Error: line ' + e.getLineNumber() + ' ' + e.getMessage();
            }
        }

        public void finish(Database.BatchableContext bc) {
            System.debug('>> finish');
            // execute any post-processing operations
            if( sendEmail ) {
                String body ='Salesforce to Kunnect Daily Import Source on ' + System.date.today().format() +
                '\nReport: ' + 
                '\n'+contact_01_security.emailReport +
                '\n'+contact_01_water.emailReport +
                '\n'+contact_windows_and_blinds.emailReport +
                '\n'+contact_pest_control.emailReport +
                '\n'+contact_hvac.emailReport +
                '\n'+contact_solar.emailReport +
                '\n'+contact_srp_solar.emailReport;

                if( !resConfirmationNumbers.isEmpty() ) body += '\nConfirmation Numbers: ' + resConfirmationNumbers.size() + ' '+ KunnectUsAddressDTO.createJson(resConfirmationNumbers);
                
                if( message != null ) body += '\n' + message;
                Messaging.SendEmailResult[] results = diacoKnifeFunc.sendEmail
                (
                    new String[] {'my_home@diaco.us','emorales@diaco.us','cody@diaco.us','cgarrett@myhomeservices.com','jhinson@myhomes.services'},
                    'KunnectDB Outbound Protection Source',
                    body 
                );
            }
        }            
    }