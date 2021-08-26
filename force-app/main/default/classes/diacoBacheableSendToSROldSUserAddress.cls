/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		method responsible for getting all user address with the necessary features and sends them to salesrabbit.  
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		19/09/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
global class diacoBacheableSendToSROldSUserAddress implements Database.Batchable<sObject>, /*Schedulable, */Database.AllowsCallouts, Database.Stateful {
    
    public List<salesRabbitSchedule__c> settingList{get;set;}
    public salesRabbitSchedule__c salesRabbitSchedule{get;set;}
    
    
    //constructor
    public diacoBacheableSendToSROldSUserAddress(){
        settingList =  new List<salesRabbitSchedule__c>();
        salesRabbitSchedule = new salesRabbitSchedule__c();
        settingList = [select Id, deleteAfter__c, minSalePrice__c,
                       maxSalePrice__c,
                       token__c from  salesRabbitSchedule__c];
        salesRabbitSchedule = settingList[0];
    }
    /***
     * 
     * method responsible for starting the batch
     * 
     * @param BC the  batch context.
     * 
     * @return a list with user address not sent to salesrabbit.
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
          
        Date today = Date.today();
        Date before = today.addDays(-Integer.valueOf(settingList[0].deleteAfter__c));
        
        
        return Database.getQueryLocator([select Id, name, status__c, UserAccount__c, sales_rabbit_leadId__c, Sales_Price__c, CreatedDate, knock_counter__c, CreatedById,
                                         fFirstName__c, fLastName__c, Phone__c, PersonMobilePhone__c, fAddress__c, fCity__c, fState__c, fzipCode__c, fEmail__c, Confirmation_Number__c,
                                         creationDate__c, deletionDate__c
                                from User_Address__c 
                                where sales_rabbit_leadId__c = null and CreatedDate >= :before and CreatedDate <= :today 
                                and (knock_counter__c = null or knock_counter__c = 0) 
                                and Sales_Price__c >= :salesRabbitSchedule.minSalePrice__c and Sales_Price__c <= :salesRabbitSchedule.maxSalePrice__c]);
    }
    
    /***
     * 
     * method reponsible for executing the batch, take the user address not sent to salesrabbit, sends them and update them in salesforce database.
     * 
     * @param BC the  batch context.
     * @param records to process
	 */
    global void execute(Database.BatchableContext bc, List<sObject> records){
        List<User_Address__c> userList = (List<User_Address__c>) records;
        system.debug('list Size: ' + userList.size());
        if(userList != null && userList.size() > 0){
            system.debug('list Size: ' + userList.size());
            for(User_Address__c use : userList){
                if(use.status__C == null || use.status__C == ''){
                    use.status__C = 'New Lead';  
                }
                system.debug('use : '+ use);
                String [] sObjectFields = new String[]{'fFirstName__c','fLastName__c','Phone__c','PersonMobilePhone__c','fAddress__c','fCity__c','fState__c','fzipCode__c','status__c','fEmail__c'};
                String [] apiFields = new String[]{'firstName','lastName','phonePrimary','phoneAlternate','street1','city','state','zip','status','email' };
                Personnel__c per =[select Id,salesRabbitUserId__c, SF_User__c from Personnel__c where SF_User__c = :use.CreatedById limit 1];
                Integer i = 0;
                Map<String, String> mapFields = new Map<String, String>();
                
                for(String field : sObjectFields){
                    if(String.valueOf(use.get(field)) != null){
                        mapFields.put(apiFields[i], String.valueOf(use.get(field)));
                    }
                    i++;
                }
                String json = '{"data": {"userId":'+per.salesRabbitUserId__c+',';
                for(String key : mapFields.keySet()){
                    json += '"'+key+'":"' +mapFields.get(key)+'",';
                }
                json +='"customFields": {'+'"salesForceId": "'+use.Id+'",'+'"confirmationNumber": "'+use.Confirmation_Number__c+'"'+'}'+'}'+'}';
                system.debug(use.Sales_Price__c + '>='+salesRabbitSchedule.minSalePrice__c +'&&'+use.Sales_Price__c +'<'+ salesRabbitSchedule.maxSalePrice__c);
                if(use.Sales_Price__c >= salesRabbitSchedule.minSalePrice__c && use.Sales_Price__c < salesRabbitSchedule.maxSalePrice__c){
                    system.debug('token__c : '+ salesRabbitSchedule.token__c);
                    system.debug('json : '+ json);
                    
                    HttpResponse responseFsR =  DiacoSalesRabbitIntegration.createLeads(salesRabbitSchedule.token__c, json);
                    responsesFromSalesRabbit newLead = DiacoSalesRabbitIntegration.newLeadData(responseFsR);
                    use.sales_rabbit_leadId__c = String.valueOf(newLead.data.id);
                    use.creationDate__c = Date.today();
                    use.deletionDate__c = Date.today().addDays(Integer.valueOf(salesRabbitSchedule.deleteAfter__c));
                    
                }
                
                json = '';
            }
            update userList;
        }
        
    }    
    
    /***
     *
     * method responsible for ending the batch. 
     * 
     * @param BC the  batch context.
     * 
     */
    global void finish(Database.BatchableContext bc){
        
    }    
    
    /*
     *method responsible for  executing the schedule interface
     * 
     * @param SC scheduler context
     * 
     *
    global void execute(SchedulableContext SC)
	{
		database.executebatch(new diacoBacheableSendToSROldSUserAddress(),100);
	}*/
}