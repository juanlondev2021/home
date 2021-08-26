public class LineItemTriggerHandler extends TriggerHandler{
	public override void afterInsert() {
        //Code Here
        /*List<Line_Item__c> newLine = (List<Line_Item__c>) Trigger.new;
       	Map<Id,Line_Item__c> lineMap = (Map<Id,Line_Item__c>) Trigger.newMap;
        LineItemTriggerHelper.taxFields(newLine, true, lineMap);*/
    }

    public override void beforeUpdate() {
        //Code Here
        List<Line_Item__c> newLine = (List<Line_Item__c>) Trigger.new;
        Map<Id,Line_Item__c> lineMap = (Map<Id,Line_Item__c>) Trigger.newMap;
        LineItemTriggerHelper.taxFields(newLine);
    }
}