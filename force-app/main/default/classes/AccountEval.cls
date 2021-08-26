/** 
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Account eval
 * TestClass:          AccountTriggerTest
 * Description:        
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08-07-2021         Jull Quintero D         Initial implementation of the class.
 **/

public with sharing class AccountEval {
    public static Boolean addressNoNull(Account acct) {
        return  acct.Street__c != null  || 
                acct.City__c != null    ||
                acct.State__c != null   || 
                acct.Zip__c != null     || 
                acct.County__c != null;
    }

    public static Boolean addressChange(Account acct, Account oldAcct) { 
        return  acct.Street__c != oldAcct.Street__c ||
                acct.City__c != oldAcct.City__c     ||
                acct.State__c != oldAcct.State__c   ||
                acct.Zip__c != oldAcct.Zip__c       || 
                acct.County__c != oldAcct.County__c;
    }

    public static Boolean locationNoNull(Account acct) {
        return  acct.BillingLatitude != null && 
                acct.BillingLongitude != null;
    }

    public static Boolean locationChange(Account acct, Account oldAcct) {
        return  acct.BillingLatitude != oldAcct.BillingLatitude || 
                acct.BillingLongitude != oldAcct.BillingLongitude;
    }

    public static Boolean geoCodeChange(Account acct, Account oldAcct) {
        return  diacoKnifeFunc.getRecordTypeNameById('Account', acct.RecordTypeId) == 'Person Account' &&
                AccountEval.locationNoNull(acct) &&
                AccountEval.addressNoNull(acct) && 
                (AccountEval.addressChange(acct, oldAcct) || 
                AccountEval.locationChange(acct, oldAcct));
    }

    public static Boolean mapLayerChangeLocation(Account acct, Account oldAcct) {
        return  AccountEval.locationChange(acct, oldAcct) && 
                !AccountEval.addressChange(acct, oldAcct) &&
                UserInfo.getUserId() != label.Data_com_Clean_User_Id;
    }
}