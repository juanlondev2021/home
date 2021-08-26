public class DiacoDelete {
	@AuraEnabled
    public static void deleteRecord(String recordId, String customObject){
        try{
           sObject obj = Schema.getGlobalDescribe().get(customObject).newSObject();
            obj.put('Id', recordId);
            delete obj; 
        }catch(Exception e){
            System.debug('Error');
            System.debug(e.getMessage());
        }
        
    }
}