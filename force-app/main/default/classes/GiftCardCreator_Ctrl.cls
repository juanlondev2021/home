public with sharing class GiftCardCreator_Ctrl {
    public list<selectOption> branchOptions {get;set;}
    public String selectedBranch {get;set;}
    public boolean showOptions {get;set;}
    public String batchNumber {get;set;}
    public String location {get;set;}
    public Integer qnty {get;set;}
    public list<Opportunity> oppList {get;set;}
    public map<String,String> csMap;
    public Boolean showButton {get;set;}
    
    //
    public boolean getStatus{get; private set;}
    public boolean enabled {get; private set;}
    public String JobStatus {get; private set;}
    private Id AsyncDeleteJobId;
    private Id AsyncAddJobId;
    public Integer percentComplete {get; private set;}
    //
    
    public GiftCardCreator_Ctrl(){
        branchOptions = new list<Selectoption>();
        selectedBranch = '';
        enabled = false;
        location = '';
        batchNumber = '0300';
        JobStatus = 'Job Started';
        qnty = 0;
        showOptions = false;
        showButton = true;
        csMap = new map<String,String>();
        for(BranchLocation_Mapper__c each : BranchLocation_Mapper__c.getAll().values()){
            csMap.put(each.Branch_Name__c,each.Location_Name__c);
        }
        Schema.DescribeFieldResult dfr = Opportunity.Branch__c.getDescribe();
        List<Schema.PicklistEntry> P = dfr.getPicklistValues();
        branchOptions.add(new selectOption('--Select--','--Select--'));
        for(Schema.PicklistEntry each : p){
            branchOptions.add(new selectOption(each.getValue(),each.getLabel()));
        }
    }
    public void processSelection(){
        showOptions = true;
        showButton = true;
        oppList = new list<Opportunity>();
        String selBranch = apexpages.currentpage().getParameters().get('selBranch');
        if(csMap.containsKey(selBranch)){
            location = csMap.get(selBranch);
            oppList = [Select id,name,account.name,Prime_Front__c,Operational_Stages__c from opportunity 
                            where Branch__c=:selBranch and Operational_Stages__c in ('Gift Card Proof Approved','Gift Card Ordered','Gift Card Received & in Fulfillment','Gift Card Active Customer') 
                             order by Prime_Front__c desc, closedate asc];
             if(oppList.size()==0)showButton = false;
            Integer c = [Select count() from Gift_Card_Orders__c where Parent_Gift_Card_Order__c = null and Branch_Location__c=:selBranch limit 1000];
            if(c != 0){
                batchNumber = String.valueOf(0300+integer.valueOf(c));
                if(batchNumber.length()==3)
                batchNumber = '0'+batchNumber;
            }
            else
            batchNumber = '0300';
        }
        else
        location = 'Location can\'t be found, please contact your admin';
        
    }
    public pagereference saveOrder(){
        if(qnty == 0){
             Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,'required field missing: Quantity'));
             return null;
        }
        String oppIds = apexpages.currentpage().getParameters().get('oppIds');
        list<String> oppList = oppIds.split(',');
        /*if(qnty*oppList.size()>9500){
           Integer newQnty = 9500/oppList.size();
             Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,'Transaction size exceeded 9999,please reduce your quanity to '+String.valueOf(newQnty)+' orders or less'));
             return null;
        }*/
        list<Gift_Card_Orders__c> gcoList = new list<Gift_Card_Orders__c>();
        Gift_Card_Orders__c gco = new Gift_Card_Orders__c();
        gco.Date_Ordered__c = date.today();
        gco.Branch_Location__c = selectedBranch;
        gco.Quantity_Ordered__c = qnty;
        gco.name = csMap.get(selectedBranch)+' '+batchNumber+' '+'0000'+' '+'0000';
        try{
            insert gco;
        }
        catch(exception e){
             Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getmessage()));
             return null;
        }
        for(integer i=1;i<=qnty;i++){
            Gift_Card_Orders__c gc = new Gift_Card_Orders__c();
            String nth = String.valueOf(i);
            if(nth.length() == 1)nth='000'+nth;
             if(nth.length() == 2)nth='00'+nth;
              if(nth.length() == 3)nth='0'+nth;
            gc.name =  csMap.get(selectedBranch)+' '+batchNumber+' '+'0000'+' '+nth;
            gc.Date_Ordered__c = date.today();
            gc.Parent_Gift_Card_Order__c = gco.Id;
            gc.Branch_Location__c = selectedBranch;
           /*gc.Quantity_Ordered__c = qnty;*/
            gcoList.add(gc);
        }
        try{
            insert gcoList;
            if((gcoList.size()*oppList.size())<=9500){
                list<Gift_Card__c> giftCardList = new list<Gift_Card__c>();
                integer i=1;
                for(Gift_Card_Orders__c each :  gcoList){
                     for(String eachOpp : oppList){
                        String nnth = String.valueOf(i);
                        if(nnth.length() == 1)nnth='000'+nnth;
                         if(nnth.length() == 2)nnth='00'+nnth;
                          if(nnth.length() == 3)nnth='0'+nnth;
                        Gift_Card__c giftCard = new Gift_Card__c();
                        giftCard.Opportunity__c = eachOpp;
                        giftCard.Gift_Card_Order__c = each.Id;
                        system.debug('@@@@'+each.name);
                        giftCard.name = csMap.get(selectedBranch)+' '+batchNumber+' '+nnth+' '+each.name.substring(each.name.length()-4,each.name.length());
                        giftCardList.add(giftCard);
                        i++;
                        if(i>oppList.size())i=1;
                     }
                }
                insert giftCardList;
                pagereference pg = new pagereference('/'+gco.Id);
              pg.setRedirect(true);
              return pg;
            }
            else{
              list<String> gcoIds = new list<String>();
              for(Gift_Card_Orders__c each :  gcoList){
                 gcoIds.add(each.Id);
              }
              system.debug('-----------selectedBranch'+selectedBranch);
              system.debug('----------batchNumber'+batchNumber);
              system.debug('-----------gcoIds'+gcoIds);
              system.debug('----------csMap'+csMap);
              system.debug('----------oppList'+oppList);
              GiftCardCreator_Batch obj = new GiftCardCreator_Batch(selectedBranch,batchNumber,gcoIds,csMap,oppList);
              database.executeBatch(obj,30);
              pagereference pg = new pagereference('/apex/GiftCardCreator_Status?gcId='+gco.Id);
              pg.setRedirect(true);
              return pg;
            }
           return null;
        }
       catch(exception e){
             Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getmessage()));
             return null;
        }
        return null;
    }
    public Integer count = 0;
      
   public PageReference incrementCounter() {
      /*String queryString1 ='select id, name from apexclass where name ='+'\'GiftCardCreator_Batch\'';
      List <ApexClass> batchClass1 = new List <ApexClass>();    
      batchClass1 = database.query(queryString1);
      String batchId1 =batchClass1[0].Id;
      String queryString2='Select id, TotalJobItems, Numberoferrors, JobItemsProcessed from AsyncApexJob where (ApexClassId =\''+batchId1+'\') And (Status = \'Queued\' OR Status = \'Preparing\' OR Status = \'Processing\')';
      List<AsyncApexjob> Async_Addjob = new List<AsyncApexjob>();  
      Async_Addjob = database.query(queryString2); 
       if(Async_Addjob.size()>0){ 
           Double itemsProcessed ;
        Double totalItems; 
       this.JobStatus='Adding Entities';
       itemsProcessed = Async_Addjob[0].JobItemsProcessed;
       totalItems = Async_Addjob[0].TotalJobItems;
          if(totalItems == 0){
                  this.percentComplete = 0;
            }else{
                this.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
           }
       } */
        return null;
    }
  public void incrementCounter1(){
    enabled = true;
  }  
    public Integer getCount() {
        return count;
    }
}