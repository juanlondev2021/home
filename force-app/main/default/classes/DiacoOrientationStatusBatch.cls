global class DiacoOrientationStatusBatch implements  Database.Batchable<sObject> {
    
    global List<Orientation__c> start(Database.BatchableContext bc) {
        
        // DateTime now=System.now();
        //   'SELECT ID,(SELECT Name,Training_Start_Date__c  FROM Tranings__r WHERE Training_Start_Date__c>'+now+') FROM Orientation__c WHERE Current_Orientation__c = true'
        return [SELECT ID,(SELECT Name,Training_Start_Date__c  FROM Tranings__r)
                FROM Orientation__c 
                WHERE Current_Orientation__c = true Limit 50000];
        

    }
    
    global void execute(Database.BatchableContext bc, List<Orientation__c> scope){
        list<Orientation__c> listToUpdate = new list<Orientation__c>(); 
        
        for (Orientation__c orientation : scope) {
            Boolean needsToBeActive = false; 
            for(Training__c training : orientation.Tranings__r){
                if(training.Training_Start_Date__c > System.now()){ 
                    needsToBeActive = true;
                    break;
                } 
            }
            if(!needsToBeActive)listToUpdate.add(new Orientation__c(id = orientation.id, Current_Orientation__c = false)); 
        }
        System.debug('List to Update: ');
        System.debug(listToUpdate); 
        update listToUpdate;
        
    } 
    
    
    global void finish(Database.BatchableContext bc){
    } 
    
}