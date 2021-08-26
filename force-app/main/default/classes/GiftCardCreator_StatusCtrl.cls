public with sharing class GiftCardCreator_StatusCtrl {
	public boolean getStatus{get; private set;}
    public boolean enabled {get; private set;}
    public String JobStatus {get; private set;}
    private Id AsyncDeleteJobId;
    private Id AsyncAddJobId;
    public Integer percentComplete {get; private set;}
    public String gcId;
    public String cId;
    public GiftCardCreator_StatusCtrl(){
    	enabled = true;
    	JobStatus = 'Batch queued';
    	gcId = apexpages.currentPage().getParameters().get('gcId');
    	cId = userInfo.getUserId();
    }
	public PageReference incrementCounter() {
    	String queryString1 ='select id, name from apexclass where name ='+'\'GiftCardCreator_Batch\'';
    	List <ApexClass> batchClass1 = new List <ApexClass>();    
    	batchClass1 = database.query(queryString1);
    	String batchId1 =batchClass1[0].Id;
    	String queryString2='Select id, TotalJobItems, Numberoferrors, JobItemsProcessed from AsyncApexJob where (ApexClassId =\''+batchId1+'\') And (Status = \'Queued\' OR Status = \'Preparing\' OR Status = \'Processing\') And createdById = '+'\''+cId+'\'';
    	system.debug('----------'+queryString2);
    	List<AsyncApexjob> Async_Addjob = new List<AsyncApexjob>();  
    	Async_Addjob = database.query(queryString2); 
       if(Async_Addjob.size()>0){ 
       		Double itemsProcessed ;
  			Double totalItems; 
		   this.JobStatus='Processing batches';
		   itemsProcessed = Async_Addjob[0].JobItemsProcessed;
		   totalItems = Async_Addjob[0].TotalJobItems;
	        if(totalItems == 0){
	                this.percentComplete = 0;
            }else{
                this.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
           }
     	} 
     	if(percentComplete >10 && Async_Addjob.size() == 0){
        	pagereference pg = new pagereference('/'+gcId);
    		pg.setRedirect(true);
    		return pg;
     	}
        return null;
    }
}