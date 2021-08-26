({
	getDataCustomer : function(component, recordId) {
        
        var action = component.get("c.getDataCustomerOne");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                if(obj != null) {
                    
                    //console.log(JSON.stringify(obj));
                    component.set('v.customer', obj);	
                    
                    component.set('v.id2', obj.Id);	
                    component.set('v.id3', obj.Id);	
                    component.set('v.id4', obj.Id);	
                    component.set('v.id5', obj.Id);	
                    component.set('v.id6', obj.Id);	
                    component.set('v.id7', obj.Id);	
                    
                    component.set('v.recordId', recordId);
                    component.set('v._label', 'Saved');
                    
                    component.set('v.toSynchronize', obj.DiacoAlarm__DiacoPackageId__c != undefined);
                    component.set('v.toPackageService', true);
                }  
            }
        });
        $A.enqueueAction(action);        
    },
    
    getObjectType : function(component, recordId) {
        var action = component.get("c.getObjectType");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    var objectType=response.getReturnValue();
                    if(objectType.search("Home")>-1 && objectType.search("Service")>-1){
                        this.getDataCustomer(component, recordId);
                        this.getRecordTypeFromHS(component, recordId);
                    }else{
                        this.getRecordIdFromEvent(component, recordId)
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
    },

    getRecordIdFromEvent : function(component, recordId) {
        var action = component.get("c.getRecordIdFromEvent");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    var HSId=response.getReturnValue();
                    this.getDataCustomer(component, HSId);
                    this.getRecordTypeFromHS(component, HSId);
                }
                
            }
        });
        $A.enqueueAction(action);
    },

    getRecordTypeFromHS : function(component, recordId) {
        var action = component.get("c.getRecordTypeFromHS");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    var type=response.getReturnValue().RecordType.Name;
                    component.set('v._recordType',type.search('Home Automation')>-1?'Home Automation':type);
                } 
            }
        });
        $A.enqueueAction(action);
    },
})