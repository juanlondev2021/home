/********************************************************************************************
* Class Name : DeliveryParameterUI
* Created By : Sankar Marappan
* Created Date : 2/5/2016
* Author : MST
* Description: 
**********************************************************************************************/
public with sharing class DeliveryParameterUI {
    //Used to hold current branch info
    private final Branch__c branch;
    private final integer NEXT_ATTEMPT_DAYS;
    private boolean isInitial = false;
    public String branchName {get;set;}
    public boolean isError {get;set;} 
    public boolean isSaved {get;set;}
    public boolean isChanged {get;set;}
    public boolean isConfirm {get;set;}
    //Used to display active delivery param fields in UI.
    public Delivery_Parameter__c delivery {get;set;} 
    //Used to display included & excluded zipcode as selectList in UI
    private SelectOption[] allZipCodes;
    public SelectOption[] includedZipCodes { get; set; }
    public SelectOption[] excludedZipCodes { get; set; }
    //Used to display included & excluded products as selectList in UI
    public SelectOption[] allProducts { get; set; }
    public SelectOption[] selectedProducts { get; set; }
    //Used to validate include & exclude zipcode form UI
    public Set<String> includedZipCodeSet = new Set<String>();
    public Set<String> excludedZipCodeSet = new Set<String>();    
    private Set<String> inComingIncludeZipCodeSet = new Set<String>();  
    private Set<String> inComingExcludeZipCodeSet = new Set<String>();
    //Used to validate include & exclude products form UI
    public Set<String> selectedProductSet = new Set<String>(); 
    private Set<String> inComingProductSet = new Set<String>(); 
    //Used to hold existing next attempt value for this delivery Param
    private Integer oldDaysNextAttempt;
    
    public DeliveryParameterUI(ApexPages.StandardController controller) {
        isError = false;
        isInitial = false;
        isSaved = false;
        isConfirm = false;
        // Get the threshold value from the custom setting
        NEXT_ATTEMPT_DAYS = (Integer)Hung_Status_Setting__c.getInstance('Hung').Days_Until_Next_Delivery__c;
        excludedZipCodes = new List<SelectOption>();
        includedZipCodes = new List<SelectOption>();
        allProducts = new List<SelectOption>();
        selectedProducts = new List<SelectOption>();        
        //Used to get the current record info
        this.delivery = (Delivery_Parameter__c)controller.getRecord();
        //Get the delivery parameter record, when users clicks edit button on the delivery Parameter.
        if(this.delivery.id != null){            
            Delivery_Parameter__c activeDeliveryParam = [SELECT Id,Min_Sales_Price__c,Allow_Multiple_Attempts__c,Max_Sales_Price__c,Close_Date__c,Branch__r.Name,Days_Until_Next_Delivery__c,
                                                         Selected_Products__c,Delivery_Number__c,Create_Date_in_SFDC__c,Branch__c,Active__c,Included_ZipCodes__c,Excluded_ZipCodes__c
                                                         FROM Delivery_Parameter__c WHERE id =: this.delivery.id];
            if(activeDeliveryParam != null){
                this.delivery = activeDeliveryParam;
                if(this.delivery.Active__c){                
                    branchName = this.delivery.Branch__r.Name;
                }
                else{//if the users edit the inactive delivery parameter then show error msg
                    isError = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can\'t edit inactive delivery parameter record.'));
                }
            }
        }
        else{//Get the delivery parameter record, when users clicks new button on the delivery Parameter.
            branch = [SELECT id,name from Branch__c where id =: this.delivery.Branch__c];
            branchName = branch.Name;
            List<Delivery_Parameter__c> deliveryParamList = [SELECT Id,Min_Sales_Price__c,Max_Sales_Price__c,Close_Date__c,Branch__r.Name,Days_Until_Next_Delivery__c,
                                                             Selected_Products__c,Delivery_Number__c,Create_Date_in_SFDC__c,Branch__c,Active__c,Included_ZipCodes__c,Excluded_ZipCodes__c,Allow_Multiple_Attempts__c
                                                             FROM Delivery_Parameter__c WHERE Active__c = true and Branch__c =: branch.id order by Delivery_Number__c ASC];
            if(!deliveryParamList.isEmpty()){
                this.delivery = deliveryParamList.get(0);
            }
            if(this.delivery.id == null){//if no active delivery parameter record exists for this branch, then create as new record
                this.delivery = new Delivery_Parameter__c(Branch__c=branch.id,Active__c = true);
                isInitial = true;
            }            
        }
        if(!isError){
            if(this.delivery.Included_ZipCodes__c != null){
                String includedZipCodeStr = this.delivery.Included_ZipCodes__c;
                includedZipCodeSet.addAll(includedZipCodeStr.split(','));
            }
            if(includedZipCodeSet.size() > 0){
                for(String includeZip : includedZipCodeSet){
                    includedZipCodes.add(new SelectOption(includeZip,includeZip)); 
                }
            }
            if(this.delivery.Excluded_ZipCodes__c != null){
                String excludedZipCodeStr = this.delivery.Excluded_ZipCodes__c;
                excludedZipCodeSet.addAll(excludedZipCodeStr.split(','));
            }
            if(excludedZipCodeSet.size() > 0){
                for(String excludeZip : excludedZipCodeSet){
                    excludedZipCodes.add(new SelectOption(excludeZip,excludeZip)); 
                }
            }
            if(this.delivery.Selected_Products__c != null){
                String productStr = this.delivery.Selected_Products__c;
                selectedProductSet.addAll(productStr.split(','));
            }
            if(selectedProductSet.size() > 0){
                for(String prod : selectedProductSet){
                    selectedProducts.add(new SelectOption(prod,prod)); 
                }
            }
            //if the branch don't have any active delivery parameter record,then create a new deliveryParameter record by including all Zipcodes.
            if(isInitial){
                allZipCodes = new List<SelectOption>();
                for (ZipCodeMatch__c zip : ZipCodeMatch__c.getAll().values()){
                    if(zip.Carrier_Code__c == branchName){ 
                        allZipCodes.add(new SelectOption(zip.Zip_Code__c,zip.Zip_Code__c));
                    }
                } 
                includedZipCodes = allZipCodes;
            }
        }
        //set value to days until next attempt for corresponding branch.
        if(this.delivery.Days_Until_Next_Delivery__c == null){
            // Get the day value from the custom setting 'HungStatus__c' to create the delivery two record
            this.delivery.Days_Until_Next_Delivery__c = NEXT_ATTEMPT_DAYS;
        }
        else{
            oldDaysNextAttempt = (Integer)this.delivery.Days_Until_Next_Delivery__c;
        }
        List<Delivery_Product__c> productList = [SELECT id,name FROM Delivery_Product__c];
        for(Delivery_Product__c prod : productList){
            if(!selectedProductSet.contains(prod.name)){
                allProducts.add(new SelectOption(prod.Name,prod.Name));
            }
        }
    }
    public void save() {  
        isSaved = false; 
        isConfirm = false;        
        if(includedZipCodes.size() > 0){
            delivery.Included_ZipCodes__c = UtilClass.getValuesFromSelectList(includedZipCodes); 
            for ( SelectOption so : includedZipCodes ) {
                inComingIncludeZipCodeSet.add(so.getlabel());
            }
        }
        else{
            delivery.Included_ZipCodes__c = '';  
        }  
        
        if(excludedZipCodes.size() > 0){
            delivery.Excluded_ZipCodes__c = UtilClass.getValuesFromSelectList(excludedZipCodes); 
            for ( SelectOption so : excludedZipCodes ) {
                inComingExcludeZipCodeSet.add(so.getlabel());
            }
        }
        else{
            delivery.Excluded_ZipCodes__c = '';  
        }  
        
        if(selectedProducts.size() > 0){
            delivery.Selected_Products__c = UtilClass.getValuesFromSelectList(selectedProducts);
            for ( SelectOption so : selectedProducts ) {
                inComingProductSet.add(so.getlabel());
            }
        }
        else{
            delivery.Selected_Products__c = '';  
        }  
        //if the users didn't change any values on the current active record from UI, then need to prevent new record creation, 
        if(!isInitial){
            List<Delivery_Parameter__c> dupParamList = [SELECT Id,Included_ZipCodes__c,Excluded_ZipCodes__c FROM Delivery_Parameter__c WHERE id =: delivery.id AND Min_Sales_Price__c =: delivery.Min_Sales_Price__c
                                                        AND Max_Sales_Price__c =: delivery.Max_Sales_Price__c AND Close_Date__c =: delivery.Close_Date__c AND Allow_Multiple_Attempts__c =: delivery.Allow_Multiple_Attempts__c AND Days_Until_Next_Delivery__c =: delivery.Days_Until_Next_Delivery__c AND
                                                        Delivery_Number__c =: delivery.Delivery_Number__c AND Create_Date_in_SFDC__c =: delivery.Create_Date_in_SFDC__c];
            //Change made found on the UI, then we need to create as new record. So we make delivery.id to null
            if(dupParamList.size() == 0){
                this.delivery.id = null;
            }
            //Change made found on the UI, then we need to create as new record. So we make delivery.id to null  
            else if(!includedZipCodeSet.containsAll(inComingIncludeZipCodeSet) || !excludedZipCodeSet.containsAll(inComingExcludeZipCodeSet)){
                this.delivery.id = null;
            }
            else if(!selectedProductSet.containsAll(inComingProductSet) || inComingProductSet.size() == 0){
                this.delivery.id = null;
            }
        }
        try{
            if(delivery.Id == null){
                isSaved = true;
            }
            else if(delivery.active__c == false){
                isSaved = true;
            }
            upsert delivery;
            if(isSaved){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Your Delivery Parameter saved successfully.'));             
            }
            else{
                isSaved = true; // For navigation
                isConfirm = true;
                ApexPages.addmessage(new ApexPages.message(Apexpages.severity.INFO,'Must update delivery parameter for new record to be saved.'));
            }
        }
        catch(DMLException e){
            System.debug('@Caught Exception: '+e.getMessage());
            ApexPages.addMessages(e);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum sales price not less than Minimum Price'));
        }
    }
    public void updateBranchNextAttemptDays(){  
        if(isChanged){
            delivery.Active__c = true;
        }
        else{
            if(oldDaysNextAttempt != null){
                delivery.Days_Until_Next_Delivery__c = oldDaysNextAttempt;
            }
            else{
                delivery.Days_Until_Next_Delivery__c = NEXT_ATTEMPT_DAYS;
            }
        }
    }
    //Used to redirect to the parent page once the users click on the confirmation page    
    public PageReference redirect(){
        pageReference pageRef = new pageReference('/'+delivery.Branch__c);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference refresh(){
        isSaved = false;
        return null;
    }
}