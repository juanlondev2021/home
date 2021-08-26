({
    editRecord : function(component, event, helper) {
        var isEdit = component.get("v.isEdit");
        component.set("v.isEdit", !isEdit);
        if(!isEdit){
            /*component.find("CustomerInfoBankName").set("v.value", "");
            component.find("CustomerInfoBankAccountType").set("v.value", "");
            component.find("CustomerInfoBankAccountName").set("v.value", "");
            component.find("CustomerInfoBankAccountNumber").set("v.value", "");
            component.find("CustomerInfoRoutingNumber").set("v.value", "");
            component.find("CustomerInfoNumberChecking").set("v.value", "");*/
            
            var allValid = component.find('CustomerInfo').reduce(function (validSoFar, inputCmp) {
                inputCmp.set("v.value", "");
            }, true);
        }else{
            var home = component.get("v.HomeServices");
            var toService = component.get("v.toService");
            if(toService){
                home.Bank_Name_Service__c = undefined;
                home.Bank_Account_Type_Service__c = undefined;
                home.Bank_Account_Name_Service__c = undefined;
                home.Bank_Account_Number_Service__c = undefined;
                home.Routing_Number_New__c = undefined;
                home.Account_Number_Checking_Service__c = undefined;
            }else{
                home.Bank_Name__c = undefined;
                home.Bank_Account_Type__c = undefined;
                home.Bank_Account_Name__c = undefined;
                home.Bank_Account_Number_Encrypted__c = undefined;
                home.Routing_Number__c = undefined;
                home.Account_Number_Checking__c = undefined;
            }
            
            component.set("v.HomeServices", home);
        }
    },
    
    validityCheck : function(component, event){
        var items = component.find('CustomerInfo');
        if(items){
            var allValid = items.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            return allValid;
        }else{
            return true;
        } 
    },
    onRefresh : function(component, event, helper) {
        if(event.getParams().message.search('successfully') >= 0){
            component.set("v.isEdit", false);
            $A.get('e.force:refreshView').fire();
        } 
    }
    /*
     changeStatus : function(component, event, helper) {
        var home =  component.get("v.HomeServices");
		var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
        
        if(fieldName === 'Bank Name'){
            
           home.Bank_Name_System__c = newValue;
            
        }else if(fieldName === 'Bank Account Name'){
            
           home.Bank_Account_Name_System__c = newValue;
            
        }else if(fieldName === 'Bank Account Number'){
            
           home.Bank_Account_Number__c = newValue;
            
        }else if(fieldName === 'Routing Number'){
            
           home.Bank_Routing_Number__c = newValue;
            
        }else if(fieldName === 'Check Number'){
            
           home.Check_Number__c = newValue;
            
        }else if(fieldName === 'Bank Account Type'){
            
            home.Bank_Account_Type_System__c = component.get("v.Bank_Account_Type");
            
        }
        component.set("v.HomeServices", home);
	},
     */
})

/*
 <div class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_6-of-12 slds-m-top--medium slds-align_absolute-center">
            <div class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_11-of-12 slds-align_absolute-center">
                <fieldset class="slds-box slds-theme--default ">
                    <div class="slds-form slds-grid slds-wrap">
                        <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_6-of-12">
                            <lightning:input aura:id="CustomerInfo"
                                             class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_11-of-12"
                                             name="Bank Name"
                                             onchange="{!c.changeStatus}"
                                             label="Bank Name"
                                             value="{!v.Bank_Name}"/>
                        </div>
                        <div class="slds-col slds-size_1-of-1 slds-medium-size_6-of-12 slds-large-size_6-of-12">
                            <lightning:select name="Bank Account Type" aura:id="Bank_Account_Type"
                                              label="Bank Account Type"
                                              class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                              onchange="{! c.changeStatus }"
                                              value="{!v.Bank_Account_Type}">
                                <option value="">choose one...</option>
                                <aura:iteration items="{!v.options}" var="Account">
                                    <option value="{!Account}">{!Account}</option>
                                </aura:iteration>
                            </lightning:select>
                        </div>
                        <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_12-of-12">
                            <lightning:input aura:id="Bank_Account_Name"
                                             class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_12-of-12"
                                             name="Bank Account Name" 
                                             label="Bank Account Name"
                                             onchange="{!c.changeStatus}"
                                             value="{!v.Bank_Account_Name}"/>
                        </div>
                        <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_12-of-12">
                            <lightning:input aura:id="Bank_Account_Number"
                                             class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                             name="Bank Account Number" 
                                             label="Bank Account Number"
                                             onchange="{!c.changeStatus}"
                                             value="{!v.Bank_Account_Number_Encrypted}"/>
                        </div>
                        <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_6-of-12">
                            <lightning:input aura:id="CustomerInfo"
                                             class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_11-of-12"
                                             name="Routing Number" 
                                             label="Routing Number"
                                             onchange="{!c.changeStatus}"
                                             value="{!v.Routing_Number}"/>
                        </div>
                        <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_6-of-12">
                            <lightning:input aura:id="CustomerInfo"
                                             class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                             name="Check Number" 
                                             label="Check Number"
                                             onchange="{!c.changeStatus}"
                                             value="{!v.Account_Number_Checking}"/>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
*/