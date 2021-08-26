/*****************************************************************************
createdby : MST
Description : Its add/update a pricebook on opportunity and also updating opportunity 
              recordtype based on the Pricebook choosen.
             
******************************************************************************/


public class ChoosepricebookController{
    
    public Opportunity theOpp;
    public String selectedPriceBookId{get;set;}
    public List<SelectOption> priceBookOptions{get;set;}
    
    public ChoosepricebookController(ApexPages.StandardController controller) {
        priceBookOptions = new List<SelectOption>();
        theOpp = [select Id, RecordTypeId, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
            
            // Querying all the active pricebooks.
            List<Pricebook2> priceBookList = [SELECT Name FROM PriceBook2 WHERE IsActive = true];
            if(theOpp.Pricebook2Id != Null){
              priceBookOptions.add(new SelectOption('0', '--None--'));
              selectedPriceBookId = theOpp.Pricebook2Id;
              for(integer i = 0, j = priceBookList.size(); i < j; i++)
                priceBookOptions.add(new SelectOption(priceBookList[i].Id, priceBookList[i].Name));
            }
            else{
            priceBookOptions.add(new SelectOption('0', '--None--'));
            for(integer i = 0, j = priceBookList.size(); i < j; i++){
                priceBookOptions.add(new SelectOption(priceBookList[i].Id, priceBookList[i].Name));
        }
        }
    }
    public pageReference savePriceBookName(){
    
    Boolean flag = false;
    
    if(selectedPriceBookId != '0'){
            PriceBook2 selectedPricebook = [SELECT id, Name FROM PriceBook2 WHERE Id =: selectedPriceBookId LIMIT 1];
            String currPricebookName = selectedPricebook.Name;
            if(currPricebookName == 'nuHome Hot Leads - Tier 1' || currPricebookName == 'nuHome Hot Leads - Tier 2' || currPricebookName == 'nuHome Hot Leads - Tier 3')
            {
                currPricebookName = 'nuHome Hot Lead';
            }
            Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(currPricebookName).getRecordTypeId();
           
            if(theOpp.Pricebook2Id != selectedPriceBookId)
            {
                theOpp.Pricebook2Id = selectedPriceBookId; // updating pricebook id.
                theOpp.RecordTypeId = oppRecordTypeId; // updating opportunity record type id.
                flag = true;
            }
            
    }  
    else
    {
        theOpp.Pricebook2Id = Null;
        flag = true;
    }
   
   try
   {
   
   if(flag == true)
   {
       // if pricebook is updating, it would delete all the existing line items from an opportunity.
        delete [select ID from OpportunityLineItem where opportunityID =:theOpp.ID];
        update theOpp;
   }
           
            pageReference pgRef = new pageReference('/'+theOpp.id);
            pgRef.setRedirect(True);
            return pgRef;
   }
   
   Catch(DMLException e)
   {
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getmessage() );
      ApexPages.addMessage(myMsg);
   }
    return null;
}
}