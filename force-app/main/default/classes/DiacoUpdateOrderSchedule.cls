/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			Update Order
 * Class            DiacoUpdateOrderSchedule        
 * Test:            DiacoUpdateOrderTest
 * Description:		Update any record.
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		24/07/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 * @version	1.0		11/09/2020  	Jull Quintero D  	    Initial implementation of the class.
 * 
 **/

public  class DiacoUpdateOrderSchedule {
    private List<Update_Order__c> uOrders = new List<Update_Order__c>();
    public DiacoUpdateOrderSchedule() {
        this.uOrders = [SELECT Id, Status__c,Error_Message__c, List_of_Fields__c, List_of_Values__c,Parent_Id__c, Guest_User__c 
                        FROM Update_Order__c 
                        WHERE Status__c = 'In Process' AND Guest_User__c = true AND Createddate = TODAY];
        //system.debug('>> uOrders ' + uOrders);
        deleteJob();
        autoSchedule();
        RunUpdateOrder(this.uOrders);
    }

    public static void RunUpdateOrder(List<update_order__c> uOrders){
        List<SObject> tObject = new List<SObject>();
        List<Update_Order__c> tOrder = new List<Update_Order__c>();
        List<String> parentIds = new List<String>();

        integer uOrdersLength = uOrders.size();
        for (Integer i = 0; i < uOrdersLength; i++) {
            update_order__c uOrder = uOrders[i];
            
            Id recordId = uOrder.Parent_Id__c;
            if( !String.isEmpty(recordId) ) {
                if (parentIds.contains(recordId)) continue; 

                //Save parentId
                parentIds.add(recordId);
                
                // Instance SObject 
                SObject actObj = recordId.getSObjectType().newSObject();
                actObj.Id = recordId;

                //Update Order Status
                uOrder.Status__c = 'Updated';
                uOrder.Error_Message__c = null;

                //Split Data From fields/Values
                list<String> fields = String.isBlank(uOrder.List_of_Fields__c) ? new list<String>() : uOrder.List_of_Fields__c.Split('/,/');
                list<String> values = String.isBlank(uOrder.List_of_Values__c) ? new list<String>() : uOrder.List_of_Values__c.Split('/,/');                
                
                integer valuesLength = values.size(); integer fieldsLength = fields.size();

                for(integer j = 0;j < fieldsLength; j++){
                    if( !String.isEmpty(fields[j]) ) {

                        try {
                            Schema.DescribeSObjectResult objectDescribe = actObj.getSObjectType().getDescribe();
                            Map<String, Schema.SObjectField> mapFields = objectDescribe.fields.getMap();
                            Schema.SObjectField field = mapFields.get(fields[j]);
                            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                            string value = j < valuesLength ? string.valueOf(values[j]) : null; 
                            if(fieldDescribe.getType() == Schema.DisplayType.BOOLEAN){
                                if(value != null) actObj.put(fields[j],Boolean.valueOf(value));
                            }else{
                                actObj.put(fields[j],value);
                            }
                        } catch (Exception e) {
                            //system.debug('Exception ' + e.getMessage());
                            uOrder.Error_Message__c = e.getMessage();
                            uOrder.Status__c = 'Error';
                            break;
                        }
                    }                    
                }  

                tOrder.add(uOrder);
                tObject.add(actObj);
            }
        }
        if( !tObject.isEmpty() ) {

            //system.debug('Parent: '+tObject);
            Database.update(tObject, false);
            Database.update(tOrder, false);
        }
    }

    //method responsible of executing to assign a new job each 1 minutes
    public void autoSchedule() {
        DateTime myDateTime = System.now().addMinutes(1);
        String title = 'Update Order';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ? '+myDateTime.year();
        String jobID = system.schedule(title, sch, new DiacoUpdateOrderScheduleJob());
    }
    //method responsible of deleting the with the name: Docusign job.
    public void deleteJob() {
        String title = 'Update Order';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
}