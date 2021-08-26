({
    doInit: function(component, event, helper) {
        /*var recordId = component.get("v.TaskId");
        //var customer = component.get("v.customer");
        helper.getDataTask(component, recordId);*/
        //helper.getDataHS(component);
    },
	openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
 
   UpdateTask: function(component, event, helper) {
       var description = component.find("Description").get("v.value");
       var status = component.find("Status").get("v.value");
       var services = component.find("Services").get("v.value");
       var task = {
           Status: status,
           Description: description,
           Id: component.get('v.TaskId'),
       }
       console.log(typeof(services)); 
       var taskId = component.get('v.TaskId');
       helper.saveInformation(component, task, services);
   },
})