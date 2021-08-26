({
    doInit: function(component, event, helper) {
        helper.getPersonnel(component);
        
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.showSpinner",true);
    },
    
    submit: function(component, event, helper) {
        component.find("formHomeServices").submit();
    },
    
    handleLoad: function(component, event, helper) {
        if(component.get("v.phoneRep")!='' && component.get("v.phoneRep")!=undefined){
            helper.getPersonnelOne(component,component.get("v.phoneRep"));
        }
        if(component.get("v.recordtypeId.Name").search("Flooring")>-1){
            component.set("v.recordtypeId.Name","Flooring Sales");
            //alert("Floring");
        }else if(component.get("v.recordtypeId.Name").search("Kitchen")>-1){
            //alert("Kitechen");
            component.set("v.recordtypeId.Name","Kitchen and Bath Sales");
        }
        component.set("v.showSpinner",false);
    },
    
    handleSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);	
    },
    
    handleSuccess: function(component, event, helper) {
        var eventFields = event.getParams().response;
        var homeservicesId = eventFields.id;
        component.set("v.newHSId", homeservicesId);
        helper.saveDataEvent(component, homeservicesId);
    },
    
    onChangeDateTime: function(component, event, helper) {
        var date=component.find('AppointmentDate').get('v.value');
        var time=component.find('AppointmentTime').get('v.value');
        
        //2019-08-09T21:01:00.000Z
        if(date!="" && time!=""){
            var newDate = new Date(date+"T"+(time<10?("0"+time):time)+":00:00.000Z");
            newDate.setTime(newDate.getTime() + (7*60*60*1000));
            
            var newEndDate = new Date(date+"T"+(time<10?("0"+time):time)+":00:00.000Z");
            newEndDate.setTime(newEndDate.getTime() + ((7+2)*60*60*1000));
            
            component.find('AppointmentDateField').set('v.value',newDate.toISOString());
            component.find('AppointmentEndDateField').set('v.value',newEndDate.toISOString());
        }
        
        //var dateField=component.find('AppointmentDateField').get('v.value');
        //var endDateField=component.find('AppointmentEndDateField').get('v.value');
        //alert(dateField+" "+endDateField);
    },
    
    onChangePersonnelInputApptSetter: function (component, evt, helper) {
        var input=component.find('Personnel').get('v.value');
        component.find('inputApptSetter').set('v.value',input);
    },
    
    onChangePersonnelInputLeadReview: function (component, evt, helper) {
        var input=component.find('Lead_Review').get('v.value');
        component.find('inputLeadReview').set('v.value',input);
    }
})