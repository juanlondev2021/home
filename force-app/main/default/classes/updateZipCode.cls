global class updateZipCode implements Database.Batchable<sObject>, Schedulable {
    
    String query;
    
    global updateZipCode() {
      
            query = 'SELECT Id, Name, zip_codes__c,Branch__c from Product2 WHERE createdDate = Today'; 
   }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new updateZipCode(), 25);
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
       
        Map<Id,String> productsBranchMap = new Map<Id, String>();
        Map<String,Set<String>> zipforBranchMap = new Map<String, Set<String>>();
      
        for(Product2 currProd: (List<Product2>)scope) {
           
            productsBranchMap.put(currProd.id,currProd.Branch__c);
        }
       
       
        for(ZipCode__c zipCode : [SELECT Id,Name,Branch__c FROM ZipCode__c WHERE Branch__c =: productsBranchMap.values()])
        {
           if(zipforBranchMap.containskey(zipCode.Branch__c))
           {
               zipforBranchMap.get(zipCode.Branch__c).add(zipCode.name);
        
           }
           else
           {
               zipforBranchMap.put(zipCode.Branch__c, new Set<String>{zipCode.name});
           
           }
        } 
        
        
        List<Product2> updateProducts = new List<Product2>();
        
        for(Product2 currProd: (List<Product2>)scope)
        {
          if(zipforBranchMap.containsKey(currProd.Branch__c))
          {
             Product2 updateProd = new Product2();
             updateProd.id = currProd.id;
             String zipVal='';
             for(String zip : zipforBranchMap.get(currProd.Branch__c))
             {
               zipVal += zip + ';';
             }
             zipVal = zipVal.removeEnd(';');
             
             updateProd.Available_ZipCodes__c = zipVal;
             updateProducts.add(updateProd);
          }
        
        }
        
        if(updateProducts.size() > 0)
                update updateProducts;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
  }