({
    doInit: function(component, event, helper) {
        var HomeServices = component.get("v.HomeServices");
        
        var name = HomeServices.Account__r.FirstName + ' '+ HomeServices.Account__r.LastName;
        component.find("nameOnCardField").set("v.value", name);
        var home = component.get("v.HomeServices");
        
        var toService = component.get("v.toService");
        if(toService){
        	home.Name_On_Card_Service__c = name;
        }else{
            home.Name_on_Card__c = name;
        }
        component.set("v.HomeServices", home);
        // value="{!v.HomeServices.Account__r.FirstName + ' '+ v.HomeServices.Account__r.LastName}"
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
    
    editRecord : function(component, event, helper) {
        var isEdit = component.get("v.isEdit");
        component.set("v.isEdit", !isEdit);
        if(!isEdit){
            /*component.find("CustomerInfoCardType").set("v.value", "");
            component.find("CustomerInfoCardNumber").set("v.value", "");
            component.find("CustomerInfoCSV").set("v.value", "");
            component.find("CustomerInfoExpirationMonth").set("v.value", "");
            component.find("CustomerInfoExpirationYear").set("v.value", "");*/
            
            var allValid = component.find('CustomerInfo').reduce(function (validSoFar, inputCmp) {
                //inputCmp.showHelpMessageIfInvalid();
                //return validSoFar && !inputCmp.get('v.validity').valueMissing;
                inputCmp.set("v.value", "");
            }, true);
            
        }else{
            var home = component.get("v.HomeServices");
            var toService = component.get("v.toService");
            if(toService){
                home.Card_Type_Service__c = undefined;
                home.Account_Number_Credit_Card_Service__c = undefined;
                home.CSV_Service__c = undefined;
                home.Card_Expiration_Month_Service__c = undefined;
                home.Card_Expiration_Year_Service__c = undefined;
            }else{
                home.Card_Type__c = undefined;
                home.Account_Number__c = undefined;
                home.CSV__c = undefined;
                home.Card_Expiration_Month__c = undefined;
                home.Card_Expiration_Year__c = undefined;
            }
            
            component.set("v.HomeServices", home);
        }
    },
    onRefresh : function(component, event, helper) {
        if(event.getParams().message.search('successfully') >= 0){
            component.set("v.isEdit", false);
            $A.get('e.force:refreshView').fire();
        }
    }
})

/*
<div class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_6-of-12 slds-m-top--medium slds-align_absolute-center">
                    <div class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_11-of-12 slds-align_absolute-center">
                        <fieldset class="slds-box slds-theme--default ">
                            <div class="slds-form slds-grid slds-wrap">
                                <div class="slds-col slds-size_1-of-1 slds-medium-size_6-of-12 slds-large-size_12-of-12 ">
                                    <lightning:select name="Card Type" aura:id="Card_Type1"
                                                      label="Card Type"
                                                      class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_12-of-12"
                                                      onchange="{! c.changeStatus }"
                                                      value="{!v.Card_Type}">
                                        <option value="">choose one...</option>
                                        <aura:iteration items="{!v.options}" var="card">
                                            <option value="{!card}">{!card}</option>
                                        </aura:iteration>
                                    </lightning:select>
                                </div>
                                <!--
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_12-of-12">
                                    <lightning:input aura:id="CustomerInfo"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                                     name="Name on Card"
                                                     onchange="{!c.changeStatus}"
                                                     label="Name on Card"/>
                                </div>-->
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_12-of-12">
                                    <lightning:input aura:id="CustomerInfo1"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_12-of-12"
                                                     name="Card Number" 
                                                     label="Card Number"
                                                     onchange="{!c.changeStatus}"
                                                     maxlength="16"/>
                                </div>
                                
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_12-of-12">
                                    <lightning:input aura:id="CustomerInfo1"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                                     name="CSV" 
                                                     label="CSV"
                                                     onchange="{!c.changeStatus}"
                                                     maxlength="4"/>
                                </div>
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_6-of-12">
                                    <lightning:input aura:id="CustomerInfo1"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_11-of-12"
                                                     name="Expiration Month" 
                                                     label="Expiration Month"
                                                     onchange="{!c.changeStatus}"
                                                     maxlength="2"/>
                                </div>
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_6-of-12 slds-large-size_6-of-12">
                                    <lightning:input aura:id="CustomerInfo1"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                                     name="Expiration Year" 
                                                     label="Expiration Year"
                                                     onchange="{!c.changeStatus}"
                                                     maxlength="4"/>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
*/