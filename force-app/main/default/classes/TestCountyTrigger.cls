@isTest
public class TestCountyTrigger {

     @testSetup static void setup() {
        TestClassUtil.createCounty(4);
     }
    static testMethod void countyAndStateCombination(){  
    Integer i = 1;  
        List<County__c> countyList = new List<County__c>();
        for(County__c county : [SELECT Id,County_Name__c,State__c,county_state__c FROM County__c]){
            if(i == 1){
               county.State__c = 'A'+i;
            }
            else {    
                county.County_Name__c = 'Jefferson County'+i;
                countyList.add(county);
            }
            i++;
        }
        if(countyList.size() > 0){
            update countyList;
        }
        System.assertEquals(Limits.getDmlStatements(),2);
    }
}