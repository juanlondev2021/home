public class DocuSignDeleteStatusBridge {
    public static void DeleteStatus(Integer lim, Integer limIn){
        List<ddsign__Envelope__c> envs = new List<ddsign__Envelope__c>();
        envs = [select id from ddsign__Envelope__c where Selected__c=false limit :lim];
        if(!envs.isEmpty()){
            for(ddsign__Envelope__c env : envs){
                env.Selected__c=true;
                database.executeBatch(new DocuSignDeleteStatus(limIn,env.Id), 5000);
            }
            update envs;
        }
    }
    public static void UpdateStatus(){
        List<ddsign__Status__c> status = new List<ddsign__Status__c>();
		status = [select Id from ddsign__Status__c where Selected__c=true];
        for(ddsign__Status__c sta:status){
            sta.Selected__c=false;
        }
        if(!status.isEmpty()) update status;
        List<ddsign__Envelope__c> envs = new List<ddsign__Envelope__c>();
        envs = [select id from ddsign__Envelope__c where Selected__c=true];
        for(ddsign__Envelope__c env : envs){
            env.Selected__c=false;
        }
        if(!status.isEmpty()) update envs;
    }
}