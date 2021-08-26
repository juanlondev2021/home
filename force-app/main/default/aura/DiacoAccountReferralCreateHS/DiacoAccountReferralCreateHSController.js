({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
		component.set('v.columns', [
            {label: 'Referral', fieldName: 'referralUrl', type: 'url',typeAttributes: { target: '_blank',label: { fieldName: 'referralName' }}},
            {label: 'Home Services Status', fieldName: 'HSStatus', type: 'text', editable: false },
            {label: 'Home Services', fieldName: 'createButton', type: 'button', initialWidth: 150, typeAttributes:
             { label: { fieldName: 'createHS'}, value:{fieldName: 'id'},title: 'Click to create Home Service',onclick:'{! c.openModel }',name: 'edit_status', iconName:{fieldName: 'icon'}, disabled: {fieldName: 'actionDisabled'}, class: 'btn_next'}}
        ]);
        
        helper.getReferrals(component, component.get('v.recordId'));
        helper.getDataRecordType(component);
        
        /*component.set('v.data',[
            {referralName:"Test Ortega",referralUrl:window.location.hostname+'/lightning/r/referral__c/'+'a0k54000008Zl7fAAC'+'/view',actionDisabled:false,createHS:'Create',icon:'utility:edit'},
            {referralName:"Test Alvaro",referralUrl:window.location.hostname+'/lightning/r/referral__c/'+'a0k54000008Zl7fAAC'+'/view',actionDisabled:true,createHS:'Created',icon:'utility:check'},
            {referralName:"Test José",referralUrl:window.location.hostname+'/lightning/r/referral__c/'+'a0k54000008Zl7fAAC'+'/view',actionDisabled:false,createHS:'Create',icon:'utility:edit'},
            {referralName:"Test Vargas",referralUrl:window.location.hostname+'/lightning/r/referral__c/'+'a0k54000008Zl7fAAC'+'/view',actionDisabled:false,createHS:'Create',icon:'utility:edit'}
        ]);*/
        
	},
    openModel: function(component, event, helper) {
        component.set("v.isOpenHS",true);
	},
    newHSId: function(component, event, helper) {
        //alert("Cambio new: "+event.getParam("value"));
        component.set('v.showSpinner', true);
        helper.saveHsOnReferral(component,component.get("v.referralIdToSave"),event.getParam("value"));
	},
    closeModel: function(component, event, helper) {
        component.set("v.isOpenHS",false);
	},
    newHS:function(component, event, helper) {
        var value=component.get("v.recordtypeId");
        if(value!=''){
            var list=component.get('v.recordsType');
            for(var i=0;i<list.length;i++){
                if(list[i].Id==value){
                    component.set('v.recordtypeId', list[i]);
                    component.set("v.isOpenHS",false);
                    component.set('v.isOpen', true);
                    break;
                  }
            }
            
        }
        else{
            component.find("recordTypeSelect").showHelpMessageIfInvalid();
        }
        //alert("Value: "+value+" - "+component.get("v.referralIdToSave"));
        //component.set("v.isOpen",false);
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'edit_status':
                component.set("v.referralIdToSave",row.id);
                component.set("v.recordtypeId",'');
                component.set("v.isOpenHS",true);
                break;
            default:
                break;
        }
    }
})