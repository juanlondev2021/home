({
    init : function(component, event, helper) {
        var accountId = component.get("v.pageReference").state.c__AccountId;
        var VarConfirmationNumber = component.get("v.pageReference").state.c__ConfirmationNumber;
        var VarPhoneRep = component.get("v.pageReference").state.c__PhoneRep;
        var VarCallerID = component.get("v.pageReference").state.c__CallerId;
        var VarNewFirstName = component.get("v.pageReference").state.c__FirstName;
        var VarNewLastName = component.get("v.pageReference").state.c__LastName;
        var VarNewStreet = component.get("v.pageReference").state.c__Street;
        var VarNewCity = component.get("v.pageReference").state.c__City;
        var VarNewState = component.get("v.pageReference").state.c__State;
        var VarNewZip = component.get("v.pageReference").state.c__Zip;
        var VarNewEmail = component.get("v.pageReference").state.c__Email;
        
        var flow = component.find("flowData");
        var inputVariables = [
            {name : 'VarConfirmationNumber',type : 'String',value : VarConfirmationNumber},
            {name : 'VarPhoneRep',type : 'String',value : VarPhoneRep},
            {name : 'VarCallerID',type : 'String',value : VarCallerID},
            {name : 'VarNewFirstName',type : 'String',value : VarNewFirstName},
            {name : 'VarNewLastName',type : 'String',value : VarNewLastName},
            {name : 'VarNewStreet',type : 'String',value : VarNewStreet},
            {name : 'VarNewCity',type : 'String',value : VarNewCity},
            {name : 'VarNewState',type : 'String',value : VarNewState},
            {name : 'VarNewZip',type : 'String',value : VarNewZip},
            {name : 'VarNewEmail',type : 'String',value : VarNewEmail}
        ];
        flow.startFlow("HomeServiceFlow1", inputVariables);
    }
})