/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			Update Order
 * Class            DiacoUpdateOrderHandler        
 * Test:            DiacoUpdateOrderTest
 * Description:		Update any record.
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		24/07/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/
public with sharing class DiacoUpdateOrderHandler {

    public DiacoUpdateOrderHandler(){
        List<Update_Order__c> uOrders = [SELECT Id, Status__c, List_of_Fields__c, List_of_Values__c, Parent_Id__c, Guest_User__c FROM Update_Order__c WHERE Status__c = 'In Process' AND Createddate = TODAY];
        deleteJob();
        autoSchedule();
        RunUpdateOrder(uOrders,true);


    }
    public static void UpdateOrderData(update_order__c[] uOrders, Boolean schedule) {
        List<SObject> tObject = new List<sobject>();
        List<Update_Order__c> tOrder = new List<Update_Order__c>();

        for(update_order__c uOrder : uOrders){
            if(!uOrder.Guest_User__c && !schedule){
                //Update Update Order Status
                tOrder.add(new Update_Order__c(
                    Status__c = 'Updated',
                    Id        = uOrder.Id
                    ));
                //Split Data From fields/Values
                String[] fields = uOrder.List_of_Fields__c.Split('/,/');
                String[] values = uOrder.List_of_Values__c.Split('/,/');
                Id recordId = uOrder.Parent_Id__c;
                //Getting API Object Name
                SObject actObj = recordId.getSObjectType().newSObject();
                //Preparing record to update.
                system.debug(values +' -,- '+uOrder.List_of_Values__c);
                for(integer i = 0;i < values.size(); i++){
                    
                 	system.debug('lenth values: '+ values.size()+'lenth field: '+fields.size() + 'before: '+i + ',' + fields[i] + ',' + values[i] + ','+ recordId+','+ actObj);	
                    if(values[i] !=''){
                 	system.debug('after: '+i + ',' + fields[i] + ',' + values[i] + ','+ recordId+','+ actObj);	
                        actObj.Id = recordId;
                        actObj.put(fields[i],values[i]);
                    }

                }
                tObject.add(actObj);
            }
        }
   
        map<Id, SObject> accmap = new map<Id, SObject>();
        accmap.putall(tObject);
        if(accmap.size()>0){ update accmap.values(); }

        map<Id, Update_Order__c> accmap1 = new map<Id, Update_Order__c>();
        accmap1.putall(tOrder);
        if(accmap1.size()>0){ update accmap1.values(); }
        
    }
    public static void RunUpdateOrder(update_order__c[] uOrders, Boolean schedule){

        List<SObject> tObject = new List<sobject>();
        List<Update_Order__c> tOrder = new List<Update_Order__c>();

        for(update_order__c uOrder : uOrders){
            if(uOrder.Guest_User__c && schedule){
                //Update Update Order Status
                tOrder.add(new Update_Order__c(
                    Status__c = 'Updated',
                    Id        = uOrder.Id
                    ));
                //Split Data From fields/Values
                String[] fields = uOrder.List_of_Fields__c.Split('/,/');
                String[] values = uOrder.List_of_Values__c.Split('/,/');
                Id recordId = uOrder.Parent_Id__c;
                //Getting API Object Name
//                SObject actObj = recordId.getSObjectType().newSObject();
                //Preparing record to update.
                for(integer i = 0;i < values.size(); i++){
                    if(fields[i] !=''){
                        integer index = 0;
                        
                        for(SObject cObject : tObject){
                            if(recordId == cObject.Id){
                                break;
                            }
                            index++;
                        }
                        if(tObject.size() > 0){
                            if(index < tObject.size() && tObject[index].Id == recordId){
                                tObject[index].put(fields[i],values[i]);
                            }
                            else{
               					SObject actObj = recordId.getSObjectType().newSObject();
                                actObj.Id = recordId;
                                actObj.put(fields[i],values[i]);
                                tObject.add(actObj);
                            }
                        }
                        else{
                            SObject actObj = recordId.getSObjectType().newSObject();
                            actObj.Id = recordId;
                            actObj.put(fields[i],values[i]);
                            tObject.add(actObj);
                        }

                    }

                }
/*                system.debug('actObj: '+actObj.get('Id') == null + ' - ' + actObj.get('Id')+' '+actObj);
                if(actObj != null){
                 tObject.add(actObj);
                }
*/   
            }
        }
        if(tObject.size() > 0){
            system.debug('Parent: '+tObject);
            update tObject;
            update tOrder;
        }
    }
    //method responsible of executing to assign a new job each 15 minutes
    public void autoSchedule(){
        DateTime myDateTime = System.now().addMinutes(1);
        String title = 'Update Order';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ? '+myDateTime.year();
        String jobID = system.schedule(title, sch, new DiacoUpdateOrderScheduleJob());
    }
    //method responsible of deleting the with the name: Docusign job.
    public void deleteJob(){
        String title = 'Update Order';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
}