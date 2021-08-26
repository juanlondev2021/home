/*********************************************************************************************
Createdby : MST
Description : This class overwrites the standard [Add Product] button functionalities. It would display 
              Products based on the State,City, Industry selected on the page. 
              If user selects products and hit [Save] button, it will create lineitems under Opportunity.
**********************************************************************************************/

Public with sharing class ProductOverrideController {
    
    public Opportunity theOpp {get;set;}
    public Pricebook2 theBook {get;set;}
    public String selectedState{get;set;}
    public String selectedCity{get;set;}
    public String selectedIndustry{get;set;}
    public String selectedPriceBookId{get;set;}
    public boolean isPriceBook{get;set;}
    public Set<Id> productIdSet;
    public List<Wrap> prodList{get;set;}
    public List<opportunityLineItem> cartlist{get;set;}
    public List<SelectOption> priceBookOptions{get;set;}
    //pagination
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    public integer total_size{get;set;} //used to show user the total size of the list
    //selection hold
    public string toselect{get;set;}
     public String toUnselect {get; set;}
    public Set<String> selectedSet = new Set<String>();
    Map<String,String > selectedProdMap = new Map<String,String >();
    public List<opportunityLineItem> shoppingCart {get;set;}
    
    public ProductOverrideController(ApexPages.StandardController controller) {
        priceBookOptions = new List<SelectOption>();
        shoppingCart = new List<opportunityLineItem>();
        productIdSet = new Set<Id>();
        theOpp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
         if(theOpp.Pricebook2Id != null){
             theBook = theOpp.Pricebook2;
         } else {
             List<Pricebook2> priceBookList = [SELECT Name FROM Pricebook2 WHERE IsActive = true];
             priceBookOptions.add(new SelectOption('0', '--None--'));
             for(integer i = 0, j = priceBookList.size(); i < j; i++){
                priceBookOptions.add(new SelectOption(priceBookList[i].Id, priceBookList[i].Name));
           } 
         }
         selectedState = '--NONE--';
         selectedCity = '--NONE--';
    }
    // Fetching all the states of products based on the opportunity's pricebook.
    public List<SelectOption> getStates() {
        List<SelectOption> opt = new List<SelectOption>();
        Set<String> deDUpSet = new Set<String>();
        opt.add(new SelectOption('--NONE--','--NONE--')) ;
        for(PriceBookEntry pbe : [SELECT Product2.Id,Product2.Name,Product2.product_state__c,Product2.product_city__c FROM PriceBookEntry WHERE Product2.product_state__c != null AND Pricebook2Id =: theBook.Id]) {
            if(!deDUpSet.contains(pbe.Product2.product_state__c)){
                 opt.add(new SelectOption(pbe.Product2.product_state__c, pbe.Product2.product_state__c)) ;
                 deDUpSet.add(pbe.Product2.product_state__c);
             }
        }
        if(opt.size() > 0)
          opt.sort();
        return opt;
    } 
    
    // Fetching all the industries of products based on the opportunity's pricebook.
   /* public List<SelectOption> getIndustries() {
        List<SelectOption> opt = new List<SelectOption>();
        Set<String> deDUpSet = new Set<String>();
        opt.add(new SelectOption('--NONE--','--NONE--')) ;
        for(PriceBookEntry pbe: [SELECT Product2.Id,Product2.Name,UnitPrice,Product2.product_industry__c FROM PriceBookEntry WHERE Product2.product_Industry__c != null AND Pricebook2Id =: theBook.Id]) {
            if(!deDUpSet.contains(pbe.Product2.product_industry__c )){
                 opt.add(new SelectOption(pbe.Product2.product_industry__c , pbe.Product2.product_industry__c )) ;
                 deDUpSet.add(pbe.Product2.product_industry__c );
             }
        }
        if(opt.size() > 0)
          opt.sort();
        return opt;
    } */
    
    
    // Fetching all the industries of products based on the opportunity's pricebook.
    public List<SelectOption> getIndustries() {
    
        Pricebook2 pbName;
        String pname;
        
        if(theBook.Id != Null)
        {
            pbName = [SELECT Name FROM Pricebook2 WHERE Id = :theBook.Id limit 1];
            pname = pbName.Name;
        }
        
        
        List<SelectOption> opt = new List<SelectOption>();
        Set<String> deDUpSet = new Set<String>();
        opt.add(new SelectOption('--NONE--','--NONE--')) ;
        for(Industry__c currName: [SELECT Name FROM Industry__c WHERE name != null AND Pricebook_To_Display__c includes (:pname)]) {
            if(!deDUpSet.contains(currName.name)){
                 opt.add(new SelectOption(currName.name,currName.name )) ;
                 deDUpSet.add(currName.Name);
             }
        }
        if(opt.size() > 0)
          opt.sort();
        return opt;
    } 
    
    
     // Fetching all the cities of products based on the opportunity's pricebook.
    public List<SelectOption> getCities() {
        List<SelectOption> opt = new List<SelectOption>();
        Set<String> deDUpSet = new Set<String>();
        opt.add(new SelectOption('--NONE--','--NONE--')) ;
        String query = '';
        string idVal = '';
        idVal = theBook.Id;
        
        if(selectedState == '--NONE--'){
            query = 'SELECT Product2.Id,UnitPrice,Product2.Name,Product2.product_state__c,Product2.product_city__c FROM PriceBookEntry WHERE Product2.product_city__c != null AND Pricebook2Id =: idVal';
        }else {
            query = 'SELECT Product2.Id,UnitPrice,Product2.Name,Product2.product_state__c,Product2.product_city__c FROM PriceBookEntry WHERE Product2.product_city__c != null AND Product2.product_state__c =: selectedState AND Pricebook2Id =: idVal';
        }
        
        for(PriceBookEntry pbe: database.query(query)) {
            if(!deDUpSet.contains(pbe.Product2.product_city__c)){
                 opt.add(new SelectOption(pbe.Product2.product_city__c, pbe.Product2.product_city__c)) ;
                 deDUpSet.add(pbe.Product2.product_city__c);
             }
        }
        if(opt.size() > 0)
          opt.sort();
        return opt;
    }   
    
    // It will search the products based on the city,state and industry selected on the page.
    public void Search() {
        prodList = new list<Wrap>();
        String query,cond='';
        Set<String> conditions = new Set<String>();
        
        if(selectedCity  != '--NONE--'){
            conditions.add(' Product2.product_city__c =: selectedcity ');
        }
        if(selectedState  != '--NONE--'){
            conditions.add(' Product2.product_state__c =: selectedState ');
        }
        if(selectedIndustry != '--NONE--'){
            conditions.add(' Product2.Industry__r.name =: selectedindustry ');
        }
        
        Conditions.add(' Product2.isActive = True ');
        for(String s : conditions){
            cond+=s+'AND';
        }
        
        cond = cond.removeEnd('AND');
        
        if(conditions.size() > 0) {
            string idVal = theBook.Id;
            cond += 'AND Pricebook2Id =: idVal';
            cond = '('+cond+')';
            cond = cond+ ' OR ' + '(Pricebook2Id =: idVal AND ' + ' ' +'Product2.Name = \'1 Required CPL Premier Partner Fee\'' +')';
            query = 'SELECT Product2.Id,UnitPrice,Product2.Name,Product2.ProductCode,Product2.Description,Product2.Family FROM PriceBookEntry WHERE '+cond+' ORDER BY Name limit :list_size offset :counter ';
            System.debug('QUERY :::::: '+query);
            
            for(PriceBookEntry pbe : Database.query(query))
            {    
                wrap wp = new wrap();
                wp.prod = pbe;
                if(selectedProdMap.containsKey(pbe.Product2.Id)){
                    wp.sel = true;
                    wp.Quantity = Integer.valueOf(selectedProdMap.get(pbe.Product2.Id));
                }else {
                    wp.sel = false;
                    wp.Quantity = 0;
                }
                prodList.add(wp);    
            }
        System.debug('TEST1::::: '+cond);
        List<AggregateResult> countAgg = Database.Query('select count(Id) from PriceBookEntry WHERE '+cond);
        total_size = (countAgg != null && countAgg.size() > 0) ? (Integer) countAgg[0].get('expr0') : 0;
        }
    }
   
   // Its adding pricebook to opportunity.
    public PageReference savePriceBook(){
    
        If(selectedPricebookId != '0'){
            PriceBook2 selectedPricebook = [SELECT id, Name FROM PriceBook2 WHERE Id =: selectedPriceBookId LIMIT 1];
            String currPricebookName = selectedPricebook.Name;
            if(currPricebookName == 'nuHome Hot Leads - Tier 1' || currPricebookName == 'nuHome Hot Leads - Tier 2' || currPricebookName == 'nuHome Hot Leads - Tier 3')
            {
                currPricebookName = 'nuHome Hot Lead';
            }
            Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(currPricebookName).getRecordTypeId();
            theOpp.Pricebook2Id = selectedPriceBookId;
            theOpp.RecordTypeId = oppRecordTypeId;
            update theOpp;
        }
         PageReference pgRef= new PageReference('/apex/ProductOverride?id='+theOpp.Id);
         pgRef.setRedirect(true);
         return pgRef;
    }
    
    // This function used to clear the filter.
    public void clear(){
        selectedState = '--NONE--';
        selectedCity =  '--NONE--';
        selectedIndustry = '--NONE--';
       try
       {
        if(prodList.size() > 0)
            prodList.clear();
       }
       Catch(Exception e)
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getmessage() );
           ApexPages.addMessage(myMsg);
       
       }
        
    }
    
    public with sharing class wrap {
        public boolean sel{get;set;}
        public PriceBookEntry prod{get;set;}
        public integer quantity{get;set;}
        
       
    }
    
      //Pagination
       public PageReference Beginning() { //user clicked beginning
          counter = 0;
          Search();
          return null;
       }
    
       public PageReference Previous() { //user clicked previous button
          counter -= list_size;
          Search();
          return null;
       }
    
       public PageReference Next() { //user clicked next button
          counter += list_size;
          Search();
          return null;
       }
    
       public PageReference End() { //user clicked end
          counter = total_size - math.mod(total_size, list_size);
          Search();
          return null;
       }
    
       public Boolean getDisablePrevious() { 
          //this will disable the previous and beginning buttons
          if (counter>0) return false; else return true;
       }
    
       public Boolean getDisableNext() { //this will disable the next and end buttons
          if (counter + list_size < total_size) return false; else return true;
       }
       
        public Integer getPageNumber() {
          return counter/list_size + 1;
       }
    
       public Integer getTotalPages() {
          try{
          if (math.mod(total_size, list_size) > 0) {
             return total_size/list_size + 1;
          } else {
             return (total_size/list_size);
          }
          }catch(Exception e){
              return 0;
          }
       }
   
      // its add to cart. 
       public void addToShoppingCart() {
        selectedSet.add(toSelect);  
        for(wrap d : prodList){
            if((String)d.prod.Id == toSelect){
                shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d.prod, PriceBookEntryId=d.prod.Id, UnitPrice=d.prod.unitprice,Quantity = 1));
                break;
            }
        }
       }
       
       //Its removing selected product from the list.
        public void removeFromShoppingCart(){
        Integer count = 0;
        for(opportunityLineItem d : shoppingCart){
            if((String)d.PriceBookEntryId==toUnselect){
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
    }
       
    // Its creating opportunity product.    
    public PageReference onSave(){
        if(shoppingCart.size()>0)
        {
            System.debug('shoppingCart+++++++++++++++++++++++++++++++ ' + shoppingCart);
            upsert(shoppingCart);
        }
        PageReference pgRef= new PageReference('/'+theOpp.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    // Back to opportunity page.
     public PageReference onCancel(){
 
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
   
}