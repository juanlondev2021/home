public class PropertyCreationController {

public PropertyCreationController(ApexPages.StandardController controller) {}

    public pageReference createProperty(){
        PageReference pg = new PageReference('/'+Property__c.sObjectType.getdescribe().getkeyprefix()+'/e?Name=PR-0001&retURL=%2Fa4m%2Fo&nooverride=1');
        pg.setRedirect(true);
        return pg;
    }
    
}