global class BatchUpdatingPriceonInv_AC implements Database.Batchable<Aggregateresult>
{

  Public Id invRecordTypeId = Schema.SObjectType.Inventory__C.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
 

   global iterable<Aggregateresult> start(Database.BatchableContext BC)
   { 
         list<AggregateResult> batchAggregationlist = NEW list<AggregateResult>();
         batchAggregationlist =  [SELECT idCPL_Billing_Opportunity__c oppId FROM Inventory__C WHERE UnMatching_Invetnory__c = FALSE AND Product_price__c = Null AND (Survey_Response__c ='Y' OR Survey_Response__c ='M' OR Survey_Response__c ='Blinds' OR Survey_Response__c ='Shutters' OR Survey_Response__c ='Blinds and Shutters') AND  recordtypeid =: invRecordTypeId and  idCPL_Billing_Opportunity__c != NULL  GROUP BY idCPL_Billing_Opportunity__c];
         return batchAggregationlist;
   }
   
   
   
    global void execute(Database.BatchableContext BC, List<AggregateResult> scope) {
    
        Set<id> oppIds = NEW Set<id>();
        
        Set<String> productNamesSet = new Set<String>();
        Map<Id,List<Inventory__c>> oppwithInventoryMap = new Map<Id,List<Inventory__c>>();
        
        Map<Id,String> productNameMap = new Map<Id,String>();
        Set<String> lineItemsSet = new Set<String>();
        Set<String> inventoryIds = new Set<String>();
        
         String Industry;
         
        List<Inventory__c> invList = new List<Inventory__c>();
        
        
        For(AggregateResult INv:scope){
           String oppId = String.valueof(inv.get('oppId'));
           oppIds.add(oppId);
         }
    
    
        Map<String,String> industryCustomSettingMap = new Map<String,String>();
        
        for(Industry_Values__c currIndustry : Industry_Values__c.getAll().Values())
        {
            industryCustomSettingMap.put(currIndustry.Question__c,currIndustry.Label__c);
        }
        
        
       if(oppIds.size() > 0)
       {
          for(Inventory__c currRec : [SELECT Id,Name,Survey_Question__c,Survey_Response__c,idCPL_Billing_Opportunity__c,
                                      Account__r.Branch__c FROM Inventory__c WHERE recordtypeid =: invRecordTypeId AND  
                                      UnMatching_Invetnory__c = FALSE AND  Product_price__c = Null AND
                                      (Survey_Response__c ='Y' OR Survey_Response__c ='M' OR Survey_Response__c ='Blinds' OR Survey_Response__c ='Shutters' 
                                      OR Survey_Response__c ='Blinds and Shutters') AND  
                                      idCPL_Billing_Opportunity__c IN :oppIds])
          {
          
              industry = '';
               
              if(industryCustomSettingMap.containsKey(currRec.Survey_Question__c))
                    Industry = industryCustomSettingMap.get(currRec.Survey_Question__c);
             
             
             if(!oppwithInventoryMap.containsKey(currRec.idCPL_Billing_Opportunity__c))
              {
                   oppwithInventoryMap.put(currRec.idCPL_Billing_Opportunity__c,new List<Inventory__c>{currRec});
                   
                   productNamesSet.add(currRec.Account__r.Branch__c+'-'+Industry);
              }
              else if(oppwithInventoryMap.containsKey(currRec.idCPL_Billing_Opportunity__c))
              {
                   oppwithInventoryMap.get(currRec.idCPL_Billing_Opportunity__c).add(currRec);
                   productNamesSet.add(currRec.Account__r.Branch__c+'-'+Industry);
              }
              
                productNameMap.put(currRec.id,currRec.Account__r.Branch__c+'-'+Industry);
          
          }
       
       }
       
       
        for(OpportunityLineItem lineItem : [SELECT ListPrice,Id,product2.Name,pricebookentry.product2.name,OpportunityId,unitprice,quantity,pricebookentryid FROM OpportunityLineItem WHERE 
                                            OpportunityId IN :oppwithInventoryMap.keySet() AND pricebookentry.product2.name IN :productNamesSet])
        {
        
            for(Inventory__c currInv : oppwithInventoryMap.get(lineItem.OpportunityId))
            {
               if(productNameMap.containsKey(currInv.id))
               {
                  if(productNameMap.get(currInv.id) == lineItem.pricebookentry.product2.name)
                  {
                  
                 
                      
                   if(!lineItemsSet.contains(lineItem.id) && !inventoryIds.contains(currInv.id))
                    {
                       
                       Inventory__c updateInvRec = new Inventory__c();
                       updateInvRec.id = currInv.id;
                        updateInvRec.Product_Name__c = lineItem.product2.name;
                        updateInvRec.Product_Price__c = lineItem.unitprice;
                        updateInvRec.List_Price__c = lineItem.listprice;
                        updateInvRec.Quantity__c = lineItem.Quantity;
                         invList.add(updateInvRec);
                       
                        lineItemsSet.add(lineItem.id);
                        inventoryIds.add(currInv.id);
                    }
                  
                  }
               
               
               }
            
            }   
        }
        
        
        if(invList.size() > 0)
        {
            update invList;
        }
        
    
    }
    
    global void finish(Database.BatchableContext BC) {

      

    }
}