/************************************************************************************************************
Created By : MST Solutions
Created Date : 
Description : This controller helps to select multiple zip codes in each products.  It is the simulation of multiselect standard picklist
functionality which is used to select multiple zip codes and then further stored to 2 long text fields.  One field is to store the selected 
zip codes and another field is to store the excluded zip codes.
**********************************************************************************************************************/

public class nuHome_Multiple_ZipCodes_AC {
     // variable declaration.
    public Product2 prod{get;set;}
    public Boolean edit{get;set;}
    public Boolean view{get;set;}
    Public List<string> leftSelected{get;set;}
    Public List<string> rightSelected{get;set;}
    Set<string> leftValues = new Set<string>();
    Set<string> rightValues = new Set<string>();
    
    public nuHome_Multiple_ZipCodes_AC(ApexPages.StandardController stdController){
        leftSelected = new List<String>();
        rightSelected = new List<String>();
         if(!test.isRunningTest())
        stdController.addFields(new List<String>{'Zip_Codes__c','Available_ZipCodes__c','Exclude_Zip_Codes__c','Branch__c'});
        this.prod = (Product2)stdController.getRecord();
        //Fetch the existing exclude zip codes from the field and display it in left section of the multiselect window.
        system.debug('this.prod value'+this.prod);
        if(this.prod.Exclude_Zip_Codes__c != Null)
        for(String s : this.prod.Exclude_Zip_Codes__c.split(';')){
            leftValues.add(s);
        }
        ////Fetch the existing Available zip codes from the field and display it in right section of the multiselect window.
        if(this.prod.Available_ZipCodes__c != Null)
        for(String s : this.prod.Available_ZipCodes__c.split(';')){
            rightValues.add(s);
        }        
        view = True;
        edit = False;
    }
    public void saveZip(){
        view = True;
        edit = False;
        Boolean Start = true;
        Boolean Start2 = true;
        String codes = '';
        String exCodes = '';
        //fetch the selected available zip codes and form it as long text.
        if(!rightValues.isEmpty()) {           
            for(String Str : rightValues) {
                if(Start) {
                    codes = Str;
                    Start = false;
                } else {               
                    codes = codes + ';' + Str;
                }
            }
        }
        //fetch the selected exclude zip codes and form it as long text.
        if(!leftValues.isEmpty()) {           
            for(String Str : leftValues) {
                if(Start2) {
                    exCodes = Str;
                    Start2 = false;
                } else {               
                    exCodes = exCodes + ';' + Str;
                }
            }
        }
        //Updating both the available and exclude zip code long text to the product record.
        this.prod.Available_ZipCodes__c = codes;
        this.prod.Exclude_Zip_Codes__c = exCodes;
        //DML update product.
        update this.prod;
    }
    public void editZip(){
		//Making edit boolean as true to render edit section.
        view = False;
        edit = True;
    }
    
    public PageReference selectClick(){
        //Action method for select button, cleared right selected array and adding values from leftvalues to rightvalues.
        rightSelected.clear();
        for(String s : leftSelected){
            leftValues.remove(s);
            rightValues.add(s);
        }
        return null;
    }
    
    public PageReference unSelectClick(){
        //Action method for unnselect button, cleared left selected array and adding values from rightvalues to leftvalues.
        leftSelected.clear();
        for(String s : rightSelected){
            rightValues.remove(s);
            leftValues.add(s);
        }
        return null;
    }
    
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftValues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
    
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightValues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
}