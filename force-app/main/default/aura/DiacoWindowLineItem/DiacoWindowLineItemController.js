({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        var device = $A.get("$Browser.formFactor");
        // alert("You are using a " + device);
        var fieldSize = '';
        if(device == 'PHONE'){
            fieldSize = 200;
        }
        
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: 'Product Type', fieldName: 'Remodel_Category__c', type: 'text', cellAttributes: { class: { fieldName: 'colorStatus' } }, initialWidth: fieldSize},
            {label: 'Suggested Retail w/Install', fieldName: 'Latch_Suggested_Retail_w_Install__c', type: 'currency', editable: false, cellAttributes: { class: { fieldName: 'colorStatus' } }, initialWidth: fieldSize},
            {label: 'Suggested Retail w/Install & Finance Fees', fieldName: 'Latch_Suggested_Retail_w_Install_Fee__c', type: 'currency', editable: false, cellAttributes: { class: { fieldName: 'colorStatus' } }, initialWidth: fieldSize},
            /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },
            { type: 'action', typeAttributes: { rowActions: actions }},*/
            {fieldName: 'editButton', type: 'button-icon', initialWidth: 20, typeAttributes:
             { variant: 'bare', title: 'Click to add Products and Service',name: 'edit',disabled: {fieldName: 'ToClick'},iconName: {fieldName: 'ToDisabled'}, size:'large' }, cellAttributes: { class: { fieldName: 'colorStatus' } }}
        ]);
        //alert(component.get('v.COtoEdit'));
        
        var recordId;
        
        var pageReference = component.get("v.pageReference");
        if (
            pageReference != null &&
            pageReference.hasOwnProperty("state") &&
            pageReference.state != null &&
            pageReference.state.hasOwnProperty("c__recordId") &&
            pageReference.state.c__recordId != null &&
            pageReference.state.c__recordId.trim().length > 0
        ) {
            recordId = pageReference.state.c__recordId;
            component.set("v.recordId", recordId);
        } else {
            recordId = component.get("v.recordId");
        }
        
        helper.gettingWindowsLineItems(component, recordId);
	},
    
    openModel: function(component, event, helper) {
        component.set("v.COtoEdit",undefined);
        //component.set("v.isLoadCCO",true);
        component.set("v.isOpen",true);
        
        var name = 'Change Order '+component.get('v.lenCO');
        
        //helper.createNew(component,component.get('v.recordId'),name);
        
        //var action = component.get("c.createNew");
        //$A.enqueueAction(action);
	},

    closeModel: function(component, event, helper) {
        component.set("v.isOpen",false);
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
        
	},
    
    savingFields: function(component, event, helper) {
        var dn = component.find("dealerNumber").get("v.value");
        var rm = component.find("retailMultiplier").get("v.value");
        if( dn !== undefined && dn !== '' && rm !== undefined && rm !== ''){
            component.set("v.labelFields","Saving...");
            component.find('buttonToSaveFields').set("v.disabled",true);
            
            var data = component.get('v.data');
            
            for (var i = 0; i < data.length; i++){
                data[i].ToClick = true;
            }
            component.set('v.data',data);
            component.find("editForm").submit();
        }
          
	},
    
    handleChangeFields: function(component, event, helper) {
        component.set('v.labelFields','Not Saved'); 
	},
    
    handleLoad: function(component, event, helper) {
        var recordUi = event.getParam("recordUi");
        //console.log(JSON.stringify(recordUi.record.fields));
        var dN = recordUi.record.fields.Dealer_Number__c.value;
        var rM = recordUi.record.fields.Retail_Multiplier__c.value;
        
        if(dN == null || rM == null){
            // alert("ñe");
            component.find("dealerNumber").set("v.value", dN == null ? 0.0 : dN);
            component.find("retailMultiplier").set("v.value", rM == null ? 1 : rM);
        }
        if(!component.get('v.isChecked') && (dN == null || rM == null)){
            component.set('v.isLoad', true);
            component.set('v.isChecked', true);
            helper.gettingInfoFromHS(component, component.get("v.recordId"));
        }
        
        
        // component.set("v.selectedPriority", recordUi.record.fields.Priority__c.value);
        // component.set("v.selectedCode",recordUi.record.fields.Code__c.value);
        
        // "dealerNumber" "retailMultiplier"
        
        component.set("v.isInitialLoadComplete", true);
	},
    
    handleSuccess: function(component, event, helper) {
        helper.updatingHSLineItem(component);
        if(component.get('v.labelFields') == 'Saving...'){
            component.set("v.labelFields", "Saved");
            window.setInterval(
                $A.getCallback(function() {
                    helper.deleteLabel(component);
                }), 7000
            );
            var action = component.get("c.doInit");
        	$A.enqueueAction(action);
        }
        
        /*var d = component.get('v.dealerNumberField');
        var r = component.get('v.retailMultiplierField');
        
        var nr = component.find("retailMultiplier").get("v.value") != undefined ? component.find("retailMultiplier").get("v.value") : 0;
        nr = nr != '' ? nr : 0;
        var nd = component.find("dealerNumber").get("v.value") != undefined ? component.find("dealerNumber").get("v.value") : 0;
        nd = nd != '' ? nd : 0; 
        
       //alert(nr);
        var data = component.get('v.data');
        for (var i = 0; i < data.length; i++){
            alert(data[i].Latch_Suggested_Retail_w_Install__c +" - "+data[i].Latch_Suggested_Retail_w_Install__c2+" - "+r+" - "+nr);
            data[i].Latch_Suggested_Retail_w_Install__c = (r != 0 ? (data[i].Latch_Suggested_Retail_w_Install__c2 / r) : data[i].Latch_Suggested_Retail_w_Install__c2) * nr;
            // alert(data[i].Latch_Suggested_Retail_w_Install__c);
            // var aux  = 1 + parseFloat(nd);
            // alert(aux);
            data[i].Latch_Suggested_Retail_w_Install_Fee__c = data[i].Latch_Suggested_Retail_w_Install__c * (1 +parseFloat(nd));
            // alert(data[i].Latch_Suggested_Retail_w_Install_Fee__c);
            
        }
        component.set('v.data',data);
        // component.set("v.retailMultiplierField", nr);*/
           
	},
    
    
    handleError: function(component, event, helper) {
        if(component.get('v.labelFields') == 'Saving...'){
            component.set("v.labelFields","Not Saved");
        }
	},
    
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
	},
    
    deletingChangeOrder: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        helper.deleteChangeOrder(component, component.get("v.COtoDelete").Id);
        
	},
    
    selectCategory: function(component, event, helper) {
       	var selectedCategory = component.get("v.selectedCategory");
        if(selectedCategory != ''){
            component.set("v.COtoEdit",{'Remodel_Category__c': selectedCategory});
            component.set("v.isOpen",true);
        } else{
            component.find("selectToCategory").showHelpMessageIfInvalid();
        }
        
	},
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                //component.set('v.isLoadCCO',true);
                //alert('Showing Details: ' + JSON.stringify(row));
                // alert(row.Latch_Category__c);
                component.set("v.COtoEdit",row);
                //helper.thereAre(component);
                component.set("v.isOpen",true);
                break;
        }
    }
})