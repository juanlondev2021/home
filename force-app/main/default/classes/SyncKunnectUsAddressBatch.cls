/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Kunnect Sync renplace jitterbit
 * TestClass:          SyncKunnectUsAddressTest
 * Description:        kunnect Inbound - implements Batchable
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    03/30/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class SyncKunnectUsAddressBatch implements 
    Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
        private KunnectSync inboundUserAdderss = new KunnectSync();
        private Boolean sendEmail = false;
        private string message = null;
        private set<Integer> resConfirmationNumbers = new set<Integer>();

        public Database.QueryLocator start(Database.BatchableContext bc) {
            System.debug('>> start');
            // collect the batches of records or objects to be passed to execute
            return  Database.getQueryLocator(
                [
                    SELECT 
                    Email__c,
                    Recording_Date__c,
                    Sale_Date__c,
                    External_ID__c, 
                    Confirmation_Number__c, 
                    Phone__c, 
                    Sales_Price__c, 
                    fFirstName__c, 
                    fLastName__c,
                    Address__r.Name,
                    Address__r.City__c, 
                    Address__r.State__c, 
                    Address__r.Street__c, 
                    Address__r.Zip_Code__c,
                    Kunnect_Sync__c
                    FROM User_Address__c 
                    WHERE CreatedDate = TODAY AND
                    Kunnect_Sync__c EXCLUDES('contact_metro_inbound')
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
                    
                    // Set miltipicklist
                    list<String> syncValues = new List<String>();
                    if( current.Kunnect_Sync__c != null ) syncValues =  current.Kunnect_Sync__c.split(';');
                    if( !syncValues.contains('contact_metro_inbound') ) syncValues.add('contact_metro_inbound');
                    current.Kunnect_Sync__c = diacoKnifeFunc.formatMultipickList(syncValues);

                    // Confirmation numbers
                    confNumbers.add( integer.valueOf(current.Confirmation_Number__C) );
                    resConfirmationNumbers.add( integer.valueOf(current.Confirmation_Number__C) );
                }
                string endPoint = 'https://salesforcewebsiteapi.herokuapp.com/api/v1.0/inbound/insertUserAddressInKunnect';
                //string endPoint = 'https://fe6767873dd0.ngrok.io/api/v1.0/inbound/insertUserAddressInKunnect';
                requestUserAddress.userAddress = records;
                requestUserAddress.confNumbers = confNumbers;
                requestUserAddress.endPoint    = endPoint;
                inboundUserAdderss.syncUserAddress('contact_metro_inbound', requestUserAddress);

                if( KunnectSync.isUpdate ) Database.update(records, false);
            } catch (Exception e) {
                message = 'Apex Error: line ' + e.getLineNumber() + ' ' + e.getMessage();
            }
        }
        
        public void finish(Database.BatchableContext bc) {
            System.debug('>> finish');
            if( sendEmail ) {
                String body ='Salesforce to Kunnect Daily Import Inbound on ' + System.date.today().format() +
                '\nReport: ' + inboundUserAdderss.emailReport;
                if( !resConfirmationNumbers.isEmpty() ) body += '\nConfirmation Numbers: ' + resConfirmationNumbers.size() + ' '+ KunnectUsAddressDTO.createJson(resConfirmationNumbers);
                
                if( message != null ) body += '\n' + message;
                Messaging.SendEmailResult[] results = diacoKnifeFunc.sendEmail
                (
                    new String[] {'my_home@diaco.us','emorales@diaco.us','cody@diaco.us','cgarrett@myhomeservices.com','jhinson@myhomes.services'},
                    'Sync KunnectDB User Address',
                    body 
                );
            }
        }    
}