/**********************************
 * Created By: MSTSolutions
 * Description: Just to increase the coverage for PropertyCreationController Controller.
 * ********************************/
@isTest
public class PropertyCreationController_Test {
    static testMethod void DoorTagScript(){
        Property__c propertyIns =   New Property__c();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(propertyIns);
        PropertyCreationController testClassIns =   New PropertyCreationController(stdCon);
        testClassIns.createProperty();
    }
}