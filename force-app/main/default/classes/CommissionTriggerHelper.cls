/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Commission Trigger
 * TestClass:          CommissionTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    06/10/2020         Jull Quintero D         Initial implementation of the class.
 **/

public class CommissionTriggerHelper {

/**
 * @Author Álvaro Ortega (AO) | 17/10/2019  
 * @Author Jull Quintero | 07/10/2020  
 * @Description:
 * Assign Commission Name
 * Assign Commission owner when personnel user is not null and is activate
 * This method is after Insert
 * 
 * This method is used in:
 * CommissionTrigger
 * 
 * @param Set<Id> commissionIds
 **/
public static void assignCommissionNameAndUser(Set<Id> commissionIds) {
    List<Commission__c> commissions = new List<Commission__c>(); 
    Map<Id,Commission__c> commissionMap = new Map<Id,Commission__c> 
                                    ([SELECT Id,CreatedDate,LastModifiedDate,Home_Service__c,
                                        Home_Service__r.RecordType.Name,Home_Service__r.Closed_Won_Date__c,
                                        Personnel__c,Personnel__r.First_Name__c,Personnel__r.Last_Name__c,
                                        Personnel__r.SF_User__c,Personnel__r.SF_User__r.IsActive
                                    FROM Commission__c 
                                    WHERE Id IN :commissionIds ORDER BY Home_Service__c]);

    Map<Id,Id> HScommissions=new Map<Id,Id>();
    for (Id commissionId : commissionMap.keySet()) {
        Commission__c commission = commissionMap.get(commissionId);
        HScommissions.put(commission.Id,commission.Home_Service__c);
    }
    Map<Id,Home_Services__c> homeServicesMap = new Map<Id,Home_Services__c>
                                            ([SELECT Id, (SELECT Id, Name FROM Commissions__r) 
                                            FROM Home_Services__c 
                                            WHERE Id IN :HScommissions.values()]); 
    integer countCommissions;
    Integer auxCount=0;
    Id oldHsId;
    for (Id commissionId : HScommissions.keySet()) {
        Id hsId = HScommissions.get(commissionId);
        Commission__c commission = commissionMap.get(commissionId);
        Home_Services__c homeService = homeServicesMap.get(hsId);

        //Assign Name
        //auxCount = hsId == oldHsId ?  auxCount+=1 : 0; 
        if ( hsId != oldHsId ) {
            countCommissions = homeService.Commissions__r.size();
            auxCount=0;
        }else{
            auxCount+=1;
        }
        integer nummber = countCommissions - auxCount;
        string name = '';
        if( commission.Personnel__c != null ) {
            name = commission.Personnel__r.First_Name__c + ' ' + commission.Personnel__r.Last_Name__c;
        }
        commission.Name=name + ' - M' + nummber + ' ' + commission.Home_Service__r.RecordType.Name;

        // Assign User
        if( commission.Personnel__r.SF_User__c != null && commission.Personnel__r.SF_User__r.IsActive ){
            commission.OwnerId=commission.Personnel__r.SF_User__c;
        }
        commissions.add(commission);
        oldHsId = hsId;
    }

    TriggerHandler.bypass('CommissionTrigger');
        if(!commissions.isEmpty()) update commissions;       
    TriggerHandler.clearBypass('CommissionTrigger');
}

/**
 * @Author * | * 
 * @Author Jull Quintero | 06/10/2020  
 * @Description:
 * If the new commission was created with the paid status
 * If the commission was deleted with the paid status
 * If the commission was updated with change to Commission Status  or Commission Amount
 * This method is after Insert, after Update, after Delete
 * 
 * This method is used in:
 * CommissionTrigger
 * 
 * @param Boolean isUpdate
 * @param Commission__c newCommissions
 * @param Map<Id,Commission__c> oldCommission
 **/
    public static void homeServiceCommissionPaid(Boolean isUpdate,List<Commission__c> newCommissions,Map<Id,Commission__c> oldCommssMap) {
        //set representing the HomeServices whose total paid commissions field will be update, a Set to avoid duplicated operations
        Set<String> hsToUpdate = new Set<String>();

        integer commssonsLength = newCommissions.size();
        for (Integer i = 0; i < commssonsLength; i++) {
            Commission__c commission = newCommissions[i];
            if( isUpdate ){
                if((commission.Commission_Status__c != oldCommssMap.get(commission.Id).Commission_Status__c) ||
                    commission.Commission_Amount__c != oldCommssMap.get(commission.Id).Commission_Amount__c){
                    hsToUpdate.add(commission.Home_Service__c);
                }
            }else{
                if( commission.Commission_Status__c=='Paid' ) hsToUpdate.add(commission.Home_Service__c);
            }
        }
        
        if( !hsToUpdate.isEmpty() ) {
            if( !System.isFuture() && !System.isBatch() ) {
                updateTotalCommissionPaidField(hsToUpdate);
                updateCommissionRecordAmountField(hsToUpdate);
            }
        } 
    }

        /**
     * @Author 
     * @Description:
     * Update  Field Homeservice Sale Commission Paid with Total Commission Amount when Commission Status is paid 
     * 
     * This method is used in:
     * homeServiceCommissionPaid
     * 
     * @param Set<Id> HomeService Id
     **/
    @future
    private static void updateTotalCommissionPaidField(set<String> homeServicesToUpdate) {
        list<Home_Services__c> homeServices=new list<Home_Services__c>();
        list<AggregateResult> commissionsAggregated=[SELECT SUM(Commission_Amount__c) sums,Home_Service__c 
                                                    FROM Commission__c 
                                                    WHERE (Home_Service__c IN :homeServicesToUpdate and Commission_Status__c='Paid') GROUP BY Home_Service__c];
        
        for(AggregateResult result : commissionsAggregated){
            Home_Services__c hs= new Home_Services__c(Id=(String)result.get('Home_Service__c'),Sale_Commission_Paid__c=(Decimal)result.get('sums'));
            homeServices.add(hs); 
        }
        
        if(commissionsAggregated.size()<1){
            for(String hsId:homeServicesToUpdate){
                Home_Services__c hs= new Home_Services__c(Id=hsId,Sale_Commission_Paid__c=null);
                homeServices.add(hs); 
            }
        }

        update homeServices;
    }

    /**
    * @Author 
    * @Description:
    * Update  field Homeservice Commissions Record Amount with Total Commission Amount when Commission Status is changes or is paid 
    * or is changes  Commission Amount
    * 
    * This method is used in:
    * homeServiceCommissionPaid
    * 
    * @param Set<Id> HomeService Id
    **/
    @future
    private static void updateCommissionRecordAmountField(set<String> homeServicesToUpdate) {
        list<Home_Services__c> homeServices=new list<Home_Services__c>();
        list<AggregateResult> commissionsAggregated=
            [SELECT SUM(Commission_Amount__c) sums,Home_Service__c 
            FROM Commission__c 
            WHERE Home_Service__c IN :homeServicesToUpdate GROUP BY Home_Service__c];

        for(AggregateResult result : commissionsAggregated){
            Home_Services__c hs= new Home_Services__c(Id=(String)result.get('Home_Service__c'),Commissions_Record_Amount__c=(Decimal)result.get('sums'));
            homeServices.add(hs); 
        }

        if(commissionsAggregated.size()<1){
            for(String hsId:homeServicesToUpdate){
                Home_Services__c hs= new Home_Services__c(Id=hsId,Commissions_Record_Amount__c=null);
                homeServices.add(hs); 
            }
        }
        
        update homeServices;
    }
}