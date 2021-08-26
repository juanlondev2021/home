trigger DriverInteractions on driver__c(After insert,Before Update)
{
    List<Driver_Interaction__c> collDI = new list<Driver_Interaction__c>();
    If(trigger.isinsert && trigger.isAfter)
    {    
        for(Driver__c recDriver : trigger.new)
            if(recDriver.active__c == true)
            collDI.add(new Driver_Interaction__c(Driver__c=recDriver.id,activatedDate__c = Date.today()));
        Insert collDI;
    }
    Set<id> collAscDrivers = new Set<id>();
    Map<Id,Driver_Interaction__c> mapDVInteractions = new Map<Id,Driver_Interaction__c>();

    If(trigger.isBefore && trigger.isUpdate)
    {
        for(driver__c rec : trigger.new)
            collAscDrivers.add(rec.id);
        for(Driver_Interaction__c rec: [select id,driver__c,activatedDate__c,deactivatedDate__c from Driver_Interaction__c where driver__c in :collAscDrivers 
                                        and (activatedDate__c = null OR deactivatedDate__c = null)])
            mapDVInteractions.put(rec.driver__c, rec);
        system.debug(mapDVInteractions );
        for(driver__c tempRec : trigger.new)
        {      
            Driver_Interaction__c testRec = mapDVInteractions.get(tempRec.id);
            System.debug(testRec);
            if(tempRec.active__c == true && trigger.oldmap.get(tempRec.id).active__c==false )
            {           
                if(testRec !=null && testRec.activatedDate__c == null )
                {
                    testRec.activatedDate__c = Date.today();
                    collDI.add(testRec);
                }            
                else IF(testRec == NULL) //new rec
                    collDI.add(new Driver_Interaction__c(driver__c = tempRec.id,activatedDate__c = Date.today()));
            }
            if(tempRec.active__c == false && trigger.oldmap.get(tempRec.id).active__c == true )
            {   
                if( testRec !=null && testRec.deactivatedDate__c == null )
                {
                    testRec.deactivatedDate__c = Date.today();
                    collDI.add(testRec);
                }            
                else IF(testRec == NULL)//new rec 
                    collDI.add(new Driver_Interaction__c(driver__c = tempRec.id,deactivatedDate__c = Date.today()));
            }
        }
    }
    upsert collDI;
}