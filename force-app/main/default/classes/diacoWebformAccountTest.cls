/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Unique webform 
* Description:		TestClass to diacoWebformAccountTest.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		10/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
@isTest
public class diacoWebformAccountTest {
    @isTest static void testAll(){
        /*Account acc = new Account(
        	FirstName = 'Test acc',
            LastName = 'last test'  
        );
        insert acc;*/
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        List<String> paramList = new List<String>();
        webForm__c webForm = new webForm__c();
        webForm.Name = 'Test';
        insert webForm;
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA'));
        }
        accounts.add(new Account(name='Account 11', 
                billingcity='New York', billingcountry='USA', Web_Form__c=webForm.Id));
        insert accounts;
        test.startTest();
        //paramList.add(acc.Id+',');
        for(Account acc : accounts){
            paramList.add(acc.Id);
        }
        diacoWebformAccount.ConnectWebformAccount(paramList);
        test.stopTest();
    }    
}