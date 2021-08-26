/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiacoContract Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		22/02/2019		Jorge Martinez (JM)		Initial implementation of the class.
* @version	1.0		22/03/2020		Álvaro Ortega (AO)		Changes.
**/
public class DiacoSolarContractController {
    @AuraEnabled
    public static Home_Services__c getDataHomeOwner(String RecordId){
        Home_Services__c home =  [select Account__c, Account__r.LastName, Account__r.Phone,
                                  hoaPhoneNumber__c, Account__r.Street__c, Account__r.City__c, 
                                  Account__r.State__c, Account__r.Zip__c,
                                  Account__r.PersonEmail, Utility_Company__c, hoaName__c,
                                  Account__r.FirstName, Account__r.Homeowner_2_First_Name__c,
                                  Account__r.Homeowner_2_Last_Name__c
                                  from Home_Services__c where id = :RecordId];
        return home;
    }
    
    @AuraEnabled
    public static Home_Services__c getPaymentMethods(String RecordId){
        Home_Services__c home =  [select Id, 
                                  /*Payment solar*/
                                  Balance_Due__c, FirstPayment__c, SecondPayment__c, ThirdPayment__c,
                                  /*products pay methods*/
                                  Method_Of_Payment__c,
                                  /*credit card field to fill*/
                                  Credit_Card_Type_System__c,Name_On_Card_System__c,Card_Number__c,last4numbers__c, Credit_Card_CSV__c,Expiration_Month__c, Expiration_Year__c,
                                  /*credit card field to show*/
                                  Card_Type__c, Name_on_Card__c, Account_Number__c, Card_Last_4__c, CSV__c, Card_Expiration_Month__c, Card_Expiration_Year__c,
                                  /*checking field to fill*/
                                  Bank_Account_Type_System__c, Bank_Account_Number__c, Bank_Account_Name_System__c, Bank_Name_System__c, Bank_Routing_Number__c, Check_Number__c,
                                  /*checking field to show*/
                                  Bank_Account_Type__c, Bank_Account_Number_Encrypted__c, Bank_Account_Name__c, Bank_Name__c, Routing_Number__c, Account_Number_Checking__c,
                                  /*finance field to fill and show*/
                                  Finance_Company__c, Financed_Amount__c,
                                  /*services pay methods*/
                                  Method_Of_Payment_Service_System__c,
                                  /*credit card field to fill*/
                                  Account_Number_Credit_Card_Service_Syste__c, Card_Expiration_Month_Service_System__c, Card_Expiration_Year_Service_System__c, Card_Last_4_Service_System__c,
                                  Card_Type_Service_System__c, Name_On_Card_Service_System__c, CSV_Service_System__c,
                                  /*checking field to fill*/
                                  Account_Number_Checking_Servicio_System__c, Bank_Account_Name_Service_System__c, Bank_Account_Type_Service_System__c, Bank_Account_Number_Servicio_System__c,
                                  Bank_Name_Service_System__c, Routing_Number_Service_System__c,
                                  /*credit card field to show*/
                                  Account_Number_Credit_Card_Service__c, Card_Expiration_Month_Service__c, Card_Expiration_Year_Service__c, Card_Last_4_Service__c, Card_Type_Service__c,
                                  Name_On_Card_Service__c, CSV_Service__c,
                                  /*checking field to show*/
                                  Account_Number_Checking_Service__c, Bank_Account_Name_Service__c, Bank_Account_Type_Service__c, Bank_Account_Number_Service__c, Bank_Name_Service__c, 
                                  Routing_Number_New__c,
                                  envelopeId__c, EnvelopeAgreeId__c,
                                  Account__r.FirstName, Account__r.LastName
                                  from Home_Services__c where id = :RecordId];
        return home;
    }
    
    @AuraEnabled
    public static Home_Services__c saveHomeService(Home_Services__c Home_Services){
        upsert Home_Services;
        return Home_Services;
    }

}