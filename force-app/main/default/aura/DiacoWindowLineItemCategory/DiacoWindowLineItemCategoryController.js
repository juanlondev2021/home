({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        
        component.set('v.columns2', [
            {label: 'Name', fieldName: 'label', type: 'text'},
            {label: 'Unit Total Price', fieldName: 'Unit_Total_Price__c', type: 'currency'},
            {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 10, typeAttributes:
             { variant: 'bare', title: 'Click to delete Product',name: 'delete', iconName: 'utility:delete', size:'large' }
            }
        ]);
        //alert(component.get('v.COtoEdit'));
   		//alert(+component.get('v.category'));
   		helper.gettingInfoFromHS(component, component.get('v.recordId'));
        helper.getLineItems(component,component.get('v.recordId'),component.get('v.category'));
        
	},
    
    handleSaveEdition: function (component, event, helper) {
        component.set('v.isLoad',true);
        var ois = component.get('v.data');
        
        var draf = event.getParam('draftValues');
        
        //alert(JSON.stringify(draf));
        
        var recordsToSave = [];
        for(var j = 0; j < draf.length; j++){
            // alert(draf[j].Quantity__c+" : "+  draf[j].Latch_Color_Option_C2__c);
            for(var i = 0; i < ois.length; i++){
                //alert(ois[i].IdRow + " " + draf[0].id);
                if(ois[i].IdRow == draf[j].id){
                    ois[i].Quantity__c = draf[j].Quantity__c != undefined ? draf[j].Quantity__c : ois[i].Quantity__c;
                    
                    // ois[i].Price__c = draf[j].Price__c != undefined ? draf[j].Price__c : ois[i].Price__c;
                    
                    recordsToSave.push({
                        'Id':ois[i].Id,
                        'Quantity__c':ois[i].Quantity__c,
                        'Unit_Price__c':ois[i].Unit_Price__c,
                        'Total_Sales_Price_p__c': ois[i].Latch_Suggested_Retail_w_Install__c,
                    })
                    break;
                }
            }
        }
        helper.handleSaveEdition(component,recordsToSave);
    },
    
    handleCancelEdition: function (component, event, helper) {
        var ois = component.get('v.originalData');
        component.set('v.data',JSON.parse(JSON.stringify(ois)));
        component.set("v.draftValues",[]);
        component.set("v.AllDraftValues",[]);
    },
    
    handleCellEdition: function (component, event, helper) {
        // alert("Holi 1");
        var draf = event.getParam('draftValues');
        var ois = component.get('v.data');
        // alert('Showing Details: ' + JSON.stringify(draf));
        for(var i = 0; i < ois.length; i++){
            //alert(ois[i].IdRow + " " + draf[0].id);
            if(ois[i].IdRow == draf[0].id){
                draf[0].Quantity__c = draf[0].Quantity__c < 0 ? 0 : (draf[0].Quantity__c != undefined ? parseFloat(draf[0].Quantity__c).toFixed(0) : undefined);
                draf[0].Unit_Price__c= draf[0].Unit_Price__c < ois[i].Product__r.Unit_Total_Cost__c ? ois[0].Product__r.Unit_Total_Cost__c : draf[0].Unit_Price__c;
                
                ois[i].Quantity__c = draf[0].Quantity__c != undefined ? draf[0].Quantity__c : ois[i].Quantity__c;
                ois[i].Unit_Price__c = draf[0].Unit_Price__c != undefined ? draf[0].Unit_Price__c : ois[i].Unit_Price__c;
                
                var tc = ois[i].Quantity__c * (ois[i].Unit_Price__c);
                // alert(tc);
                var jc = component.get('v.jobCosting');
                
                draf[0].Latch_Suggested_Retail_w_Install__c = tc * jc.retailMultiplier;
                draf[0].Latch_Suggested_Retail_w_Install_Fee__c = draf[0].Latch_Suggested_Retail_w_Install__c  * (1 + jc.dealerNumber);
            	
                ois[i].Latch_Suggested_Retail_w_Install__c = draf[0].Latch_Suggested_Retail_w_Install__c
                ois[i].Latch_Suggested_Retail_w_Install_Fee__c = draf[0].Latch_Suggested_Retail_w_Install_Fee__c
                break;
            }
        }
        
        
       var allDraf = component.get("v.AllDraftValues");
        
       //alert('Showing Details: ' + JSON.stringify(allDraf));
       
       var found = false;
       for(var i = 0; i < allDraf.length; i++){
           if(allDraf[i].id === draf[0].id){
               //alert('Comparacion: '+JSON.stringify(allDraf[i])+'|'+JSON.stringify(draf[0]));
               
               
               var aux = Object.assign(JSON.parse(JSON.stringify(allDraf[i])), JSON.parse(JSON.stringify(draf[0])));
               
               allDraf[i] = aux;
               //alert('Resultado: '+JSON.stringify(aux));
           
               found = true;
               break;
           }
        }
        if(!found){
            allDraf.push(draf[0]);
        }
        
       //alert('Showing Details: ' + JSON.stringify(allDraf));
       component.set("v.draftValues",draf);
       component.set("v.AllDraftValues",allDraf);
       //event.setParam('draftValues',draf);
       component.set('v.data',ois);
    },
    
    addProducts: function(component, event, helper) {
        component.set('v.isLoadP',true);
        var iCO =component.get('v.recordId')
        var s = component.get("v.data2");
        if(s.length > 0){
            helper.addProducts(component, iCO, s, component.get('v.category'));
            component.set("v.data2",[]);
        }else{
            component.set('v.isLoadP',false);
        }
        // var data = component.get("v.options");
        
    },
    
    actionDualListBox: function(component, event, helper) {
        var values = event.getParam("value");
        var labels = component.get("v.options")
                 	.filter(option => values.indexOf(option.value) > -1)
        			.map(option => option);
       // alert(JSON.stringify(labels));
       // 
       var se = component.get("v.persistentsSelectedSubcategories");
        
       component.set("v.data2", JSON.parse(JSON.stringify(labels)).concat(se));
       
    },	
    
    openModel: function(component, event, helper) {
        component.set('v.isLoadP',true);
        component.set("v.isOpen",true);
        helper.gettingProducts(component,component.get('v.recordId'),component.get('v.category'));
	},
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen",false);
        component.set("v.selectedSubcategories",'');
        component.set("v.selectedOptions",[]);
        component.set("v.data2",[]);
        component.set("v.persistentsSelectedSubcategories",[]);
	},
    
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set("v.COtoDelete",{});
        //alert(JSON.stringify(component.get("v.draftValues")));
        //alert(component.get("v.draftValues").length);
	},
    
    deletingLineItem: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set('v.isLoad',true);
        helper.deletingLineItem(component,component.get('v.COtoDelete').Id);
	},
    
    nextProduct: function(component, event, helper) {
        var actual = component.get('v.selectedPageOfProducts');
        var all = component.get("v.totalPagesOfProducts");
        var maxP = 100;
        
        if(actual < all){
            actual +=1;
            component.set('v.selectedPageOfProducts', actual);
            
         	var newOptions = component.get('v.allOptionXCategory');
            
            var init = maxP * (actual - 1);
            var end = (init + maxP) > newOptions.length ? newOptions.length : (init + maxP);
            
            newOptions = newOptions.slice(init, end);
        	component.set('v.options', newOptions);
            
            component.set('v.selectedOptions', []);
       		component.set("v.persistentsSelectedSubcategories", component.get("v.data2"));
        }
 	},
    
    backProduct: function(component, event, helper) {
        var actual = component.get('v.selectedPageOfProducts');
        var all = component.get("v.totalPagesOfProducts");
        var maxP = 100;
        
        if(actual > 1){
            actual -=1;
            component.set('v.selectedPageOfProducts', actual);
            
         	var newOptions = component.get('v.allOptionXCategory');
            
            var init = maxP * (actual - 1);
            var end = (init + maxP) > newOptions.length ? newOptions.length : (init + maxP);
            
            newOptions = newOptions.slice(init, end);
        	component.set('v.options', newOptions);
        }
 	},
    
    onchange: function(component, event, helper) {
        var maxP = 100;
        // component.set('v.isLoadP',true);
        var subcategory = component.find('selectToSubcategory').get('v.value');

        var allDataAndCategories = component.get('v.allDataAndCategories');
        // alert(JSON.stringify(allDataAndCategories[subcategory]));
        var newOptions = JSON.parse(JSON.stringify(allDataAndCategories[subcategory]));
        component.set('v.allOptionXCategory', JSON.parse(JSON.stringify(newOptions)));
        component.set("v.totalPagesOfProducts", parseInt(newOptions.length / maxP) + 1);
                      
        newOptions = newOptions.length > maxP  ? newOptions.slice(0, maxP) : newOptions ;
        component.set('v.options', newOptions);
        
        component.set('v.selectedPageOfProducts',1);
        component.set('v.selectedOptions', []);
       	component.set("v.persistentsSelectedSubcategories", component.get("v.data2"));
        
        
        /*alert(labels)
        component.set("v.options",component.get("v.options").concat(JSON.parse(JSON.stringify(labels))));*/
	},
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        /*alert(action);
        alert(action.label);
        alert(action.name);
		alert(action.category);    */
        
        if(action.category != undefined){
            if(action.category == 'KITCHEN CABINETS'){
                if(action.option == 'Color Option'){
                    var allDraf = component.get("v.AllDraftValues");
                    var o = action.name == 'None' ? '' : action.name;
                    
                    var found = false;
                    for(var i = 0; i < allDraf.length; i++){
                        if(allDraf[i].id === row.IdRow){
                            allDraf[i].Latch_Color_Option_C1__c = o;
                            allDraf[i].colorOptionKITCHENCABINETS = 'Ñe';
                            
                            found = true;
                            break;
                        }
                    }
                    if(!found){
                        allDraf.push({'id': row.IdRow, 'colorOptionKITCHENCABINETS':'Ñe', 'Latch_Color_Option_C1__c': o});
                    }
                    
                    component.set("v.AllDraftValues",allDraf);
                    component.set("v.draftValues",[{}]);
                }
           	} else if(action.category == 'WINDOW COVERINGS'){
                if(action.option == 'Color Option'){
                    var allDraf = component.get("v.AllDraftValues");
                    var o = action.name == 'None' ? '' : action.name;
                    
                    var found = false;
                    for(var i = 0; i < allDraf.length; i++){
                        if(allDraf[i].id === row.IdRow){
                            allDraf[i].Latch_Color_Option_C2__c = o;
                            allDraf[i].colorOptionWINDOWCOVERINGS = 'Ñe';
                            
                            found = true;
                            break;
                        }
                    }
                    if(!found){
                        allDraf.push({'id': row.IdRow, 'colorOptionWINDOWCOVERINGS':'Ñe', 'Latch_Color_Option_C2__c': o});
                    }
                    
                    component.set("v.AllDraftValues",allDraf);
                    component.set("v.draftValues",[{}]);
                }
            }  
        }else{
            switch (action.name) {
                case 'delete':
                    //alert(JSON.stringify(component.get("v.draftValues")));
                    //alert(component.get("v.draftValues").length);
                    component.set("v.isOpenDelete",true);
                    component.set("v.COtoDelete",row);
                    break;
            }
            
        }
        
        
    },
    
    handleRowAction2: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var data = component.get("v.data2");
        var selected = component.get("v.selectedOptions");
        selected = JSON.parse(JSON.stringify(selected));
        var se = component.get("v.persistentsSelectedSubcategories");
        
        //alert(action.name);
        
        switch (action.name) {
                case 'delete':
                 	for(var i = 0; i <  data.length; i++){ 
                        if(data[i].Id == row.Id){
                            data.splice(i, 1 );
                            break;
                        }
                    }
                	var aux = false;
                    for(var i = 0; i <  selected.length; i++){ 
                        // alert(selected[i] +' - '+row.Id);
                        if(selected[i] == row.Id){
                            selected.splice(i, 1 );
                            aux = true;
                            break;
                        }
                    }
                    if(!aux){
                        for(var i = 0; i <  se.length; i++){ 
                            if(se[i].Id == row.Id){
                                se.splice(i, 1 );
                                break;
                            }
                        }
                        component.set("v.persistentsSelectedSubcategories", se);
                    }
                	
                    component.set("v.selectedOptions", selected);
                	component.set("v.data2", data);
                    break;
            }
    }
})