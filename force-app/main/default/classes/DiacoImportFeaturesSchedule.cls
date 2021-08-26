global with sharing class DiacoImportFeaturesSchedule implements Schedulable{
    public Boolean executionType = false;
    public List<Account> accounts; 
    public List<Address__c> address; 
    public List<User_Address__c> uaddress;
    public Boolean options=false;
    global void execute(SchedulableContext SC) {
        Id CronId = SC.getTriggerId();
        CronTrigger job = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name FROM CronTrigger where Id=:CronId];
        if (executionType){
            System.debug('funciono');
            List<DiacoImportFeaturesBatch.importPackage> packages = new List<DiacoImportFeaturesBatch.importPackage>();
            for (Integer i=0;i<accounts.size();i++){
                packages.add(new DiacoImportFeaturesBatch.importPackage(accounts[i],address[i],uaddress[i]));
            }
            DiacoImportFeaturesBatch bat = new DiacoImportFeaturesBatch(packages);
            if(options){
                bat = new DiacoImportFeaturesBatch(packages,options);
            }
            Database.executebatch(bat,50);
            System.abortJob(CronId);
        }else{
            DiacoImportFeatures.ImportRecords(CronId,job.CronJobDetail.Name);
            if(job.CronJobDetail.Name.contains('_child')){
                System.abortJob(CronId);
            }
        }
    }
}