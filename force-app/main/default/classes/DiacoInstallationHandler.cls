/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			Install Item Process
 * Class            HomeServiceSaleApprovedHandler        
 * Test:            DiacoInstallationTriggerTest
 * Description:		Install Item Process.
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		13/08/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/
public with sharing class DiacoInstallationHandler {
    public static void DiacoInstallationHandler(Installation__c[] Installations, map<Id, Installation__c> oldIns, TriggerOperation op) {
    
        switch on op {
            when AFTER_INSERT {
                installItems(Installations, oldIns);
            }
        }

    }

    public static void installItems(Installation__c[] Installations, map<Id, Installation__c> oldIns){
        List<Install_Item__c> insItemTask = new List<Install_Item__c>();

        for(Installation__c inst : Installations){
            IF(inst.Home_Service__c != null){
                for(Line_Item__c lItem : [SELECT Id, Name, Cost__c, Active__c, Cost_of_Goods__c  FROM Line_Item__c WHERE Home_Service__c =: inst.Home_Service__c]){
                    if(lItem.Active__c){
                        insItemTask.add(new Install_Item__c(
                            Name            = lItem.Name,
                            Installation__c = inst.Id,
                            Bid_Amount__c   = lItem.Cost__c + lItem.Cost_of_Goods__c,
                            Line_Item__c    = lItem.Id
                        ));
                    }
                }
                insert insItemTask;
            }

        }

    }
}