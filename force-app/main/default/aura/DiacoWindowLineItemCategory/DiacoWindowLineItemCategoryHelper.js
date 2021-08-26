({
	getLineItems: function(component, recordId, category) {
        component.set('v.isLoad',true);
        var device = $A.get("$Browser.formFactor");
        // alert("You are using a " + device);
        var fieldSize = '';
        if(device == 'PHONE'){
            fieldSize = 150;
        }
		var action = component.get("c.getWindowsLineItemsCategory");
        // alert('= '+category);
        action.setParams({
            'recordId': recordId,
            'category': category
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var ois = response.getReturnValue();
                 var cos = [];
                 // alert('Showing Details: ' + JSON.stringify(ois));
                 for(var i = 0; i < ois.length; i++){
                     // alert(ois[i].Product__r.Unit_Total_Cost__c);
                     // alert(i);
                     ois[i].IdRow = "row-"+i;
                     ois[i].OIUrl = window.location.hostname+'/lightning/r/Line_Item__c/'+ois[i].Id+'/view';
                     ois[i].toEdit = true;
                     
                     /* var aux = false;
                     for(var j = 0; j < cos.length; j++){
                         if(cos[j].Latch_Subcategory__c == ois[i].Latch_Subcategory__c){
                             
                             cos[j].data.push(ois[i]);
                             
                             aux = true;
                             break;
                         }
                     }
                     if(!aux){
                         cos.push({'Latch_Subcategory__c' : ois[i].Latch_Subcategory__c, 'data' : [ois[i]] });
                     } */
                 }
                 
                 var columns = [
                    {label: 'Name', fieldName: 'OIUrl', type: 'url', initialWidth: fieldSize, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                 ];
                 
                columns.push({label: 'UOM', fieldName: 'Latch_UOM__c', type: 'text', initialWidth: fieldSize});
                columns.push({label: 'Unit Price', fieldName: 'Unit_Price__c', type: 'currency',editable: true, initialWidth: fieldSize, typeAttributes: 
                     { required: { fieldName: 'toEdit'}} 
                });
                columns.push({label: 'Quantity', fieldName: 'Quantity__c', type: 'number',editable: true, initialWidth: fieldSize, typeAttributes: 
                     { required: { fieldName: 'toEdit'}} 
                });
                columns.push({label: 'Suggested Retail w/Install', fieldName: 'Latch_Suggested_Retail_w_Install__c', type: 'currency', initialWidth: fieldSize});
                columns.push({label: 'Suggested Retail w/Install & Finance Fees', fieldName: 'Latch_Suggested_Retail_w_Install_Fee__c', type: 'currency', initialWidth: fieldSize});
                columns.push({fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
                     { variant: 'bare', title: 'Click to delete Product',name: 'delete', iconName: 'utility:delete', size:'large' }
                    });
                 
                 component.set('v.columns',columns);
              		
                 // component.set('v.lenCO',cos.length+1);
                 component.set('v.classifiedCategories', cos);
                 
                 component.set('v.data',ois);
                 component.set('v.originalData',JSON.parse(JSON.stringify(ois)));
                 component.set('v.isLoad',false);
                 
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    
    deletingLineItem: function(component, recordId) {
		var action = component.get("c.deleteLineItem");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Product has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Product.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    
    gettingProducts: function(component,recordId, category) {
		var action = component.get("c.getProducts");
        action.setParams({
            'recordId': recordId,
            'category': category
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var ois = response.getReturnValue();
                 var category = component.get('v.category');
                 // alert(category);
                 var cos = [category];
                 var allDataAndCategories = [[]];
                 
                 var firstShow = [];
                 for(var i = 0; i < ois.length; i++){
                     // var toSize = ois[i].Size__c !== undefined && ois[i].Size__c !== '' ? '('+ois[i].Size__c+') ' : '';
                     ois[i].label = ois[i].Name;
                     ois[i].value = ois[i].Id;
                     ois[i].Unit_Total_Price__c = ois[i].Sales_Price__c && ois[i].Sales_Price__c  != 0 ? ois[i].Sales_Price__c : ois[i].Unit_Total_Cost__c;
                     
                     /*var aux = false;
                     // alert(ois[i].Name + " : " + ois[i].Subcategory__c);
                     if(ois[i].Subcategory__c == category || ois[i].Subcategory__c == undefined){
                         ois[i].Subcategory__c = category;
                         firstShow.push(ois[i]);
                     }
                     for(var j = 0; j < cos.length; j++){
                         if(cos[j] == ois[i].Subcategory__c){
                             allDataAndCategories[j].push(ois[i]);
                             aux = true;
                             break;
                         }
                     }
                     if(!aux){
                         if(ois[i].Subcategory__c != undefined){
                             cos.push(ois[i].Subcategory__c);
                             allDataAndCategories.push([ois[i]]);
                         }
                     }*/
                 }
                 // alert(allDataAndCategories.length);
                 // alert(cos.length);
                 
                 component.set('v.originalOptions', JSON.parse(JSON.stringify(ois)));
                 component.set('v.allDataAndCategories', allDataAndCategories);
                 // component.set('v.lenCO',cos.length+1);
                 
                 component.set('v.subcategories', cos);
                 
                 var maxP = 100;
                 
                 var newOptions = JSON.parse(JSON.stringify(ois));
                 component.set('v.allOptionXCategory', JSON.parse(JSON.stringify(newOptions)));
                 component.set("v.totalPagesOfProducts", parseInt(newOptions.length / maxP) + 1);
                 
                 
                 newOptions = newOptions.length > maxP  ? newOptions.slice(0, maxP) : newOptions ;
                 component.set('v.options', newOptions);
                 
                 component.set('v.selectedPageOfProducts', 1);
                 
                 //component.set('v.options', firstShow);
                 //component.set('v.allOptionXCategory', JSON.parse(JSON.stringify(newOptions)));
                 
             }else{
                 
             }
             component.set('v.isLoadP',false);
         })
		 $A.enqueueAction(action);
	},
 
 	gettingInfoFromHS: function(component, recordId) {
		var action = component.get("c.getInfoFromHS");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var cs = response.getReturnValue();
                 // alert(cs[1]+" - "+cs[0]);
                 component.set("v.jobCosting", {'dealerNumber': cs[0] != undefined ? cs[0] : 0.0, 'retailMultiplier': cs[1] != undefined ? cs[1] : 1});
             }else{
             }
         })
		 $A.enqueueAction(action);
	},
    
    handleSaveEdition: function(component, data) {
		var action = component.get("c.updateLineItem");
        action.setParams({
            'recordToUpdate': data
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Line Items were UPDATE successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 
                 var ois = component.get('v.data');
                 component.set('v.originalData',JSON.parse(JSON.stringify(ois)));
                 
                 component.set("v.draftValues",[]);
                 component.set("v.AllDraftValues",[]);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Line Items were NOT UPDATED successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 
             }
             component.set('v.isLoad',false);
         })
		 $A.enqueueAction(action);
	},
    
    addProducts: function(component, iCO, s, category) {
        var rm = component.get('v.jobCosting').retailMultiplier;
		var action = component.get("c.addProductsToHS");
        console.log(iCO);
        action.setParams({
            'recordId': iCO,
            'selectedOptions': s,
            'category': category,
            'multiplier': rm != undefined ? rm : 1,
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 component.set('v.isOpen',false);
                 var action1 = component.get("c.doInit");
                 $A.enqueueAction(action1);
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Line Items Items were added successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 component.set("v.selectedOptions",[]);
                 
             }else{
                 component.set('v.isOpen',false);
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Line Items were NOT added successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 component.set("v.selectedOptions",[]);
             }
         })
		 $A.enqueueAction(action);
	},
})