({
    doInit: function(component, event, helper) {
        //var eventId =component.get('v.EventId');
        //helper.getDataEvent(component, eventId);
        helper.getPersonnel(component);
    },
	openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpenAction", true);
   },
    onChangeDateTime: function(component, event, helper) {
      var date=component.find('AppointmentDate').get('v.value');
      var time=component.find('AppointmentTime').get('v.value');
        
      //2019-08-09T21:01:00.000Z
      if(date!="" && time!=""){
          //alert(date);
          var newDate = new Date(date+"T"+(time<10?("0"+time):time)+":00:00.000Z");
          //alert(newDate.toISOString());
          newDate.setTime(newDate.getTime() + (7*60*60*1000));
          
          //alert(newDate.toISOString());
    
          var newEndDate = new Date(date+"T"+(time<10?("0"+time):time)+":00:00.000Z");
          newEndDate.setTime(newEndDate.getTime() + ((7+2)*60*60*1000));
          
          
          component.find('AppointmentDateField').set('v.value',newDate.toISOString());
          component.find('AppointmentEndDateField').set('v.value',newEndDate.toISOString());
      }
        
      //var dateField=component.find('AppointmentDateField').get('v.value');
      //var endDateField=component.find('AppointmentEndDateField').get('v.value');
      //alert(dateField+" "+endDateField);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpenAction", false);
       component.set("v.showSpinner",true);
   },
 
   submit: function(component, event, helper) {
      component.find("formHomeServices").submit();
   },
   handleLoad: function(component, event, helper) {
       var input=component.find('inputApptSetter').get('v.value');
       component.set("v.apptSetterValue", input);
       var p=component.get("v.personnelRecords");
       //p.push({'Id':'None','Name':'--None--'});
       component.set("v.personnelRecords", p);
       
       var date=component.find('AppointmentDateField').get('v.value');
       //alert(date);
       var newDate = new Date(date);

       newDate.setTime(newDate.getTime() - (7*60*60*1000));
       
       component.find('AppointmentTime').set('v.value',newDate.getUTCHours());
       component.find('AppointmentDate').set('v.value',newDate.toISOString().substr(0,10));
       component.set("v.showSpinner",false);

   },
    handleSubmit: function(component, event, helper) {
 	  component.set("v.showSpinner", true);	
   },
    handleSuccess: function(component, event, helper) {
      var eventFields = event.getParams().response;
      var homeservicesId = eventFields.id;
      component.set("v.showSpinner", false);
      component.set("v.isOpenAction", false);
        
   },
    onChangePersonnel: function (component, evt, helper) {
        var input=component.find('Personnel').get('v.value');
        component.find('inputApptSetter').set('v.value',input);
    }
})