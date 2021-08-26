/****************************************************************
 * Created By : MSTSolutions
 * Description: To update status post field in ob campaign member records 
 * when the appoinment is set for the particular industries
 * 
 * **************************************************************/
public class InventoryTriggerHandler {
    public static void updateOBCMembers(List<Inventory__c> inventoryList){
        Id inventoryOBCRecordtypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId();
        List<OB_Campaign_Member__c> toUpdateOBC = New List<OB_Campaign_Member__c>();
        Map<Id,Set<String>> inventoryIndustryMap = New Map<Id,Set<String>>();
        for(Inventory__c currInv:inventoryList){
            //Checking the record type and collecting matching inventory records.
            if(inventoryOBCRecordtypeId == currInv.RecordtypeId){
                if((currInv.User_Address__c != Null) && (currInv.Industry__c != '') && (currInv.Call_Disposition__c == 'Appointment Set')){
                    if(inventoryIndustryMap.containsKey(currInv.User_Address__c))
                        inventoryIndustryMap.get(currInv.User_Address__c).add(currInv.Industry__c);
                    else{
                        Set<String> industrySet = New Set<String>();
                        industrySet.add(currInv.Industry__c);
                        inventoryIndustryMap.put(currInv.User_Address__c,industrySet);
                    }
                }
            }
        }
        system.debug('inventoryIndustryMap values '+inventoryIndustryMap);
        if(!inventoryIndustryMap.isEmpty()){
            //Getting all obcampaign member record for the user addresses.
            Map<Id,List<OB_Campaign_Member__c>> userAddressOBCMem = New Map<Id,List<OB_Campaign_Member__c>>();
            for(OB_Campaign_Member__c OBCMem:[SELECT Id,User_Address__c,Industry__r.Name FROM OB_Campaign_Member__c WHERE User_Address__c IN :inventoryIndustryMap.keySet()]){
                if(userAddressOBCMem.containsKey(OBCMem.User_Address__c))
                    userAddressOBCMem.get(OBCMem.User_Address__c).add(OBCMem);
                else{
                    List<OB_Campaign_Member__c> OBCMemList = New List<OB_Campaign_Member__c>();
                    OBCMemList.add(OBCMem);
                    userAddressOBCMem.put(OBCMem.User_Address__c, OBCMemList);
                }
            }
            system.debug('userAddressOBCMem values '+userAddressOBCMem);
            if(!userAddressOBCMem.isEmpty()){
                //Looping through inventory and create update 
                for(Id id:inventoryIndustryMap.keySet()){
                    for(String industry:inventoryIndustryMap.get(id)){
                        if(userAddressOBCMem.containsKey(id)){
                            for(OB_Campaign_Member__c OBCMEMIns:userAddressOBCMem.get(id)){
                                if(OBCMEMIns.Industry__r.Name == industry){
                                    OB_Campaign_Member__c toUpdateOBCMem = New OB_Campaign_Member__c();
                                    toUpdateOBCMem.Id = OBCMEMIns.Id;
                                    toUpdateOBCMem.Status_Post__c = 'Appointment Set';
                                    toUpdateOBC.add(toUpdateOBCMem);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if(!toUpdateOBC.isEmpty())
            Update toUpdateOBC;
        system.debug('toUpdateOBC values '+toUpdateOBC);
    }
}