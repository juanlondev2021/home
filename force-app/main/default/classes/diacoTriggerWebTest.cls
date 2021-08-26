/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Web sites integration
* Description:		Class responsible to test diacoCreateAccountAFWeb and diacoCreateHSByWebSite
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/17/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
public class diacoTriggerWebTest {
   /*@isTest static void testToDiacoCreateAccountAFWebClass(){
        Test.startTest();
        webForm__c web = new webForm__c(
            email__c = 'test@test.com',
            firstName__c = 'test',
            lastName__c = 'test',
            phone__c = '1234567',
            Address__c = 'AZ,Glendale,Cll 89,12351',
            date__c = '11/19/2018',
            hour__c = '12:00 PM - 02:00 PM',
            type__c =  'aqua'
        );
        insert web;
        Test.stopTest();
        
    }
    
   
    @isTest static void testTodiacoDiacoCreateHSByWebSiteClass(){
        
         webForm__c web = new webForm__c(
             email__c = 'test@test.com',
             firstName__c = 'test',
             lastName__c = 'test',
             phone__c = '1234567',
             Address__c = 'AZ,Glendale,Cll 89,12351',
             date__c = '11/19/2018',
             hour__c = '12:00 PM - 02:00 PM',
             type__c =  'aqua'
         );
         insert web;
         List<String> address = web.address__c.split(',');
         Account account = new Account(
             FirstName = web.firstName__c,
             LastName = web.lastName__c,
             Phone = web.phone__c,
             PersonEmail = web.email__c,
             State__c = address[0],
             City__c = address[1],
             Street__c = address[2],
             Zip__c = address[3],
             RecordTypeId = '012410000012NOKAA2'
         );
         insert account;
         web.Account__c = account.Id;
         update web;
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new diacoHttpCalloutMock2());
          Home_Services__c home = new Home_Services__c(
             ApptSetter__c = 'a131K000006V5d8QAC',//a1329000001M9weAAC  a131K000006V5d8QAC 
             Account__c = account.Id,
             RecordTypeId = '012410000013G9OAAU',
             WebSite__c = true,
             Already_have_a_system__c = true,
             Pre_Plumb__c = true,
             People_in_the_home_water__c = 5,
             Bottled_Water__c = 500
         );
         insert home;
         Test.stopTest();
         
    } */
   
    
}