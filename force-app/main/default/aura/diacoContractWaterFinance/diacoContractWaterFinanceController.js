({
    editRecord : function(component, event, helper) {
        var isEdit = component.get("v.isEdit");
        component.set("v.isEdit", !isEdit);
        if(!isEdit){
            /*component.find("CustomerInfoFinanceCompany").set("v.value", "");
            component.find("CustomerInfoFinanceAmount").set("v.value", "");*/
            var allValid = component.find('CustomerInfo').reduce(function (validSoFar, inputCmp) {
                inputCmp.set("v.value", "");
            }, true);
        }else{
            var home = component.get("v.HomeServices");
            home.Finance_Company__c = undefined;
            home.Financed_Amount__c = undefined;
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
})

/*
 <div class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_6-of-12 slds-m-top--medium">
                    <div class="slds-col slds-size_1-of-1 slds-medium-size_11-of-12 slds-large-size_11-of-12 slds-align_absolute-center">
                        <fieldset class="slds-box slds-theme--default ">
                            <div class="slds-form slds-grid slds-wrap">
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_12-of-12 slds-large-size_12-of-12">
                                    <lightning:input aura:id="CustomerInfo"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                                     name="Finance Company"
                                                     onchange="{!c.changeStatus}"
                                                     label="Finance Company"/>
                                </div>
                                <div class="slds-col slds-size_2-of-2 slds-medium-size_12-of-12 slds-large-size_12-of-12">
                                    <lightning:input aura:id="CustomerInfo"
                                                     class="slds-col slds-size_1-of-1 slds-medium-size_12-of-12 slds-large-size_12-of-12"
                                                     name="Financed Amount"
                                                     onchange="{!c.changeStatus}"
                                                     label="Financed Amount"
                                                     type="number"
                                                     formatter="currency"/>
                                </div>
                                
                            </div>
                        </fieldset>
                    </div>
                </div>
*/