({
    doInit: function(component,event,helper) {
        //SETUP COLUMNS
        component.set('v.ObjectsListS',[]);
        var actions = [
            { label: 'Select Record', name: 'select_record' } 
        ]
        var actions2 = [
            { label: 'Unselect Record', name: 'unselect_record' } 
        ]
        component.set('v.ObjectsColumnsR', [
            {label: 'First name', fieldName: 'Firstname', type: 'text'},
            {label: 'Last name', fieldName: 'Lastname', type: 'text'},
            {label: 'Street', fieldName: 'address', type: 'text'},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'State', fieldName: 'state', type: 'text'},
            {label: 'Zip', fieldName: 'zip', type: 'text'},
            {label: 'County', fieldName: 'County', type: 'text'},
            {label: 'Sale Price', fieldName: 'SalePrice', type: 'text'},
            {label: 'Down', fieldName: 'Down', type: 'text'},
            { label: '',type: 'action', fixedWidth: 60, typeAttributes: { rowActions: actions } }
        ]);
        component.set('v.ObjectsColumnsS', [
            {label: 'First name', fieldName: 'Firstname', type: 'text'},
            {label: 'Last name', fieldName: 'Lastname', type: 'text'},
            {label: 'Street', fieldName: 'address', type: 'text'},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'State', fieldName: 'state', type: 'text'},
            {label: 'Zip', fieldName: 'zip', type: 'text'},
            {label: 'County', fieldName: 'County', type: 'text'},
            {label: 'Sale Price', fieldName: 'SalePrice', type: 'text'},
            {label: 'Down', fieldName: 'Down', type: 'text'},
            { label: '',type: 'action', fixedWidth: 60, typeAttributes: { rowActions: actions2 } }
        ]);
        component.set('v.ObjectsColumns', [
            {label: 'First name', fieldName: 'Firstname', type: 'text'},
            {label: 'Last name', fieldName: 'Lastname', type: 'text'},
            {label: 'Street', fieldName: 'address', type: 'text'},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'State', fieldName: 'state', type: 'text'},
            {label: 'Zip', fieldName: 'zip', type: 'text'},
            {label: 'County', fieldName: 'County', type: 'text'},
            {label: 'Sale Price', fieldName: 'SalePrice', type: 'text'},
            {label: 'Down', fieldName: 'Down', type: 'text'},
        ]);
            //helper.GetRecords(component,'0692a0000012ZtnAAE');
	},
    handleUploadFinished: function (cmp, event,helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log(uploadedFiles);
        //alert("Files uploaded : " + uploadedFiles.length);
        //cmp.set('v.disabled',true);
        cmp.set("v.loaded",false);
        // Get the file name
        uploadedFiles.forEach(file => {
                cmp.set('v.filesContractId',file.documentId);
                helper.GetRecords(cmp,file.documentId);
            }
        );
    },
    handleClick1: function (cmp, event,helper){
    	helper.GetRecords(cmp,cmp.get('v.filesContractId'));
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var rowObject=JSON.parse(JSON.stringify(event.getParam('row')));
        var listR = [];
        var listS = [];
        switch (action.name) {
            case 'select_record':
                listR = component.get('v.ObjectsListR');
                listS = component.get('v.ObjectsListS');
                listR.splice(listR.findIndex(elem => elem.index == rowObject.index),1);
                listS.push(rowObject);
                component.set('v.ObjectsListR',listR);
                component.set('v.ObjectsListS',listS);
                break;
            case 'unselect_record':
                listR = component.get('v.ObjectsListR');
                listS = component.get('v.ObjectsListS');
                listR.push(rowObject);
                listS.splice(listS.findIndex(elem => elem.index == rowObject.index),1);
                component.set('v.ObjectsListR',listR);
                component.set('v.ObjectsListS',listS);
                break;
        }
    },
    handleClick: function (component, event, helper){
        component.set("v.ConfirmModal",true);
    },
    handleDeliveries: function (component, event, helper){
        let status = component.get('v.ConfirmModal2');
        if(status){
            helper.createDeliveries(component);
            component.set("v.ConfirmModal2",false);
        }else{
            component.set("v.ConfirmModal2",true);
        } 
    },
    handleInsert1: function (component, event, helper){
        helper.handleInsert(component,true);
    },
    handleInsert2: function (component, event, helper){
        helper.handleInsert(component,false);
    },
    closeModel: function (component, event, helper){
        component.set("v.ConfirmModal",false);
        component.set("v.ConfirmModal2",false);
    }
})