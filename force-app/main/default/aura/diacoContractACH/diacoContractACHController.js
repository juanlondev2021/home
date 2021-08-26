({
	editRecord : function(component, event, helper) {
        var isEdit = component.get("v.isEdit");
        component.set("v.isEdit", !isEdit);
        if(!isEdit){
            var allValid = component.find('CustomerInfo').reduce(function (validSoFar, inputCmp) {
                inputCmp.set("v.value", "");
            }, true);
        }else{
            var home = component.get("v.Home_Services");
            home.Routing_Number_ACH__c = undefined;
            home.Account_Number_ACH__c = undefined;
            component.set("v.Home_Services", home);
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
})


/*
<div class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_6-of-12 slds-m-top--medium slds-align_absolute-center">
                        <div class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_11-of-12">
                            <fieldset class="slds-box slds-theme--default height-content">
                                <div class="slds-form slds-grid slds-wrap">
                                    <div class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12">
                                        <lightning:input aura:id="RoutingNumber"
                                                         onchange="{! c.changeStatus }"
                                                         class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_11-of-12"
                                                         name="RoutingNumber" 
                                                         label="Routing Number"/>
                                    </div>
                                    <div class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12">
                                        <lightning:input aura:id="AccountNumber"
                                                         onchange="{! c.changeStatus }"
                                                         class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_11-of-12"
                                                         name="AccountNumber" 
                                                         label="Account Number"/>
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                    </div>*/