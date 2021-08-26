({
    
	doInit: function(component, event, helper) { 
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
        
        component.set("v.obj",{'isAccount':'No null'});
        var newAccountId = component.get('v.newAccountId');
        if(recordId != 'null'){
            helper.getDataAccount(component, recordId);  
        }else if(newAccountId!=null){
            component.set('v.fn',undefined);
            component.set('v.ln',undefined);
            component.set('v.st',undefined);
            component.set('v.ct',undefined);
            component.set('v.sta',undefined);
            component.set('v.zp',undefined);
            component.set('v.em',undefined);
            component.set("v.obj",{'webFormId':null,'accountId':newAccountId});
        }else{
            component.set("v.obj",{'isAccount':null});
        }
        component.set("v.originalPhoneRep",component.get("v.phoneRep"));
        if(component.get("v.fn")==undefined && component.get("v.ln")==undefined && component.get("v.st")==undefined && component.get("v.ct")==undefined && component.get("v.sta")==undefined && component.get("v.zp")==undefined && component.get("v.em")==undefined){
            component.set("v.thereIsDataToChange",false);
        }
        
    },
    onOldAccount: function(component, event, helper) {
        component.set("v.decision","old")
        component.set("v.toDecision",false)
    },
    onNewAccount: function(component, event, helper) {
        component.set("v.decision","new")
        component.set("v.toDecision",false)
    },
})