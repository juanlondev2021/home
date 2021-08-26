({
	delete : function(component, event, helper) {
    try{
    helper.deleteRecord(component, component.get('v.recordId'),component.get('v.CustomObject'))
}catch(error){
    console.log(error)
}

},
    closeModel : function(component, event, helper) {
        component.find("overlayLib").notifyClose();
    }
})