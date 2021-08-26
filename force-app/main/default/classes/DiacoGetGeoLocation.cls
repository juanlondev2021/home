/** 
* Diaco
* @author 			Jull Quintero D
* Project:			Geo Accurracy - Custom Buttom Delivery and Account Object
* Description:		Create a contract for Data Integration Rule (Geocodes for Account Billing Address) 
* Test class :      DiacoGetGeoLocationTest
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version	1.0		03/02/2021		Jull Quintero D		    Initial implementation of the component.
**/

public with sharing class DiacoGetGeoLocation {

    @AuraEnabled
    public static void contractInit(Id recordId) {

        String objectName = recordId.getSobjectType().getDescribe().getName();
        id currentId;
        if ( objectName == 'Account' ) {
            currentId = recordId;

        }else if ( objectName == 'Delivery_Object__c' ) {
            currentId  = [SELECT Id,Person_Account__c FROM Delivery_Object__c WHERE Id = :recordId ]?.Person_Account__c;
        }
        Id recordTypeId = diacoKnifeFunc.getRecordTypeIdbyName('Account','Person Account');
        List<Account> accounts = [SELECT Id,FirstName,LastName,City__c,State__c,Street__c,Zip__c 
                                FROM Account 
                                WHERE Id = :currentId AND recordTypeId = :recordTypeId];

        if ( !accounts.isEmpty() ) {
            Account account = accounts[0];
            Contact contact = new Contact();
            contact.Person_Account__c = account.Id;
            contact.FirstName = account.FirstName;
            contact.LastName = account.LastName;
            contact.MailingCity = account.City__c;
            contact.MailingState = account.State__c;
            contact.MailingStreet = account.Street__c;
            contact.MailingPostalCode = account.Zip__c;
            contact.Geo_Accuracy__c = true;
            insert contact;

            /*if ( objectName == 'Delivery_Object__c' ) {
                List<Account> accts = [SELECT Id,Latitude__c,Longitude__c FROM Account WHERE Id = :account.Id ];
                if ( !accts.isEmpty() ) { 
                    Account acc = accts[0];
                    Delivery_Object__c delivary = new Delivery_Object__c();
                    delivary.Id = recordId;
                    delivary.Maps_Latitude__c = acc.Latitude__c;
                    delivary.Maps_Longitude__c = acc.Longitude__c;
                    update delivary;
                }
            }*/
        }
    }
}