({
    doInit: function(component, event, helper) {

        var accountId = component.get("v.pageReference").state.c__AccountId;
        if(accountId !== undefined && accountId !== ''){
            component.set("v.recordId", accountId);
        }else{
            var cn=component.get("v.pageReference").state.c__ConfirmationNumber;
            var pr=component.get("v.pageReference").state.c__PhoneRep;
            var ci=component.get("v.pageReference").state.c__CallerId;
            var fn=component.get("v.pageReference").state.c__FirstName;
            var ln=component.get("v.pageReference").state.c__LastName;
            var st=component.get("v.pageReference").state.c__Street;
            var ct=component.get("v.pageReference").state.c__City;
            var sta=component.get("v.pageReference").state.c__State;
            var zp=component.get("v.pageReference").state.c__Zip;
            var em=component.get("v.pageReference").state.c__Email;
            component.set("v.fn",fn);
            component.set("v.ln",ln);
            component.set("v.st",st);
            component.set("v.ct",ct);
            component.set("v.sta",sta);
            component.set("v.zp",zp);
            component.set("v.em",em);
            if(cn != null && cn != undefined && cn != ''){
                component.set("v.phoneRep",pr);
                component.set("v.callerId",ci);
                component.find("confirmationNumber").set("v.value",cn);
                var a = component.get('c.handleClick');
                $A.enqueueAction(a);
            }
        }  
    },

	handleClick : function(component, event, helper) {
        var cN = component.find("confirmationNumber").get("v.value");	
        if(cN !== "11111111"){
            component.set("v.loading",true);
            helper.getUserAddress(component,cN);
        }else{
            component.set("v.userAddress",'');
        }
    },

    closeModel: function(component, event, helper) {
        component.set("v.isOpen",false);
    },
    
    newAccount: function(component, event, helper) {
        component.find("confirmationNumber").set("v.value","11111111");
        var action = component.get("c.handleClick");
        $A.enqueueAction(action);
        component.set("v.isOpen",false);
    },
    
    formPress : function(component, event, helper) {
        if (event.keyCode === 13) {
            var a = component.get('c.handleClick');
            $A.enqueueAction(a);
        }
    },
    
    handleClickBack : function(component, event, helper) {
        component.set("v.loading",false);
        component.set("v.userAddress",null);
	}
})