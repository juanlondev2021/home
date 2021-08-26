/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Kunnect Sync renplace jitterbit
 * TestClass:          OutboundGravelSheduleTest
 * Description:        kunnect Outbound Gravel - implements Batchable
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    05/08/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class OutboundGravelBatch implements 
    Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
        private KunnectSync contact_security = new KunnectSync();
        private KunnectSync contact_water = new KunnectSync();
        private KunnectSync contact_remodel = new KunnectSync();
        private KunnectSync contact_hvac = new KunnectSync();
        private KunnectSync contact_pest_control = new KunnectSync();
        private KunnectSync contact_solar = new KunnectSync();

        List<String> tablesNames = KunnectSync.GRAVELTABLES;
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
                        if ( item == 'gravel_contact_solar' ) {
                            if( current.Address__r != null ) {
                                if( KunnectSync.ZIPCODES.contains(current.Address__r.Zip_Code__c) ) {
                                    if( !syncValues.contains(item) ) syncValues.add(item);
                                }
                            }
                            continue;
                        }
                        if( !syncValues.contains(item) ) syncValues.add(item);
                    }
                    current.Kunnect_Sync__c = diacoKnifeFunc.formatMultipickList(syncValues);

                    // Confirmation numbers
                    confNumbers.add( integer.valueOf(current.Confirmation_Number__c) );
                    resConfirmationNumbers.add( integer.valueOf(current.Confirmation_Number__c) );
                }
                string endPoint = 'https://salesforcewebsiteapi.herokuapp.com/api/v1.0/outbound-gravel';
                //string endPoint = 'https://fe6767873dd0.ngrok.io/api/v1.0/outbound-gravel';
                requestUserAddress.userAddress = records;
                requestUserAddress.confNumbers = confNumbers;
                requestUserAddress.endPoint    = endPoint;
                contact_security.syncUserAddress('contact_security', requestUserAddress);
                contact_water.syncUserAddress('contact_water', requestUserAddress);
                contact_remodel.syncUserAddress('contact_remodel', requestUserAddress);
                contact_hvac.syncUserAddress('contact_hvac', requestUserAddress);
                contact_pest_control.syncUserAddress('contact_pest_control', requestUserAddress);
                contact_solar.syncUserAddress('contact_solar', requestUserAddress);

                if( KunnectSync.isUpdate ) Database.update(records, false);
            } catch (Exception e) {
                message = 'Apex Error: line ' + e.getLineNumber() + ' ' + e.getMessage();
            }
        }

        public void finish(Database.BatchableContext bc) {
            System.debug('>> finish');
            // execute any post-processing operations
            if( sendEmail ) {
                String body ='Salseforce to Kunnect Daily Import Gravel on ' + System.date.today().format() +
                '\nReport: ' + 
                '\n'+contact_security.emailReport +
                '\n'+contact_water.emailReport +
                '\n'+contact_remodel.emailReport +
                '\n'+contact_hvac.emailReport +
                '\n'+contact_pest_control.emailReport +
                '\n'+contact_solar.emailReport;

                if( !resConfirmationNumbers.isEmpty() ) body += '\nConfirmation Numbers: ' + resConfirmationNumbers.size() + ' '+ KunnectUsAddressDTO.createJson(resConfirmationNumbers);
                    
                if( message != null ) body += '\n' + message;
                Messaging.SendEmailResult[] results = diacoKnifeFunc.sendEmail
                (
                    new String[] {'my_home@diaco.us','emorales@diaco.us','cody@diaco.us','cgarrett@myhomeservices.com','jhinson@myhomes.services'},
                    'KunnectDB Outbound Gravel',
                    body 
                );
            }
        }            
    }