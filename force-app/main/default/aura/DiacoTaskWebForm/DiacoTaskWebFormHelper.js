({
	getTask2 : function(component, recordId) {
		 var action = component.get("c.getTasks");
        action.setParams({
            "RecordId": recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("Data2: >-----<");
                console.log(data.length);
                console.log(data);
               
                for(var i = 0; i<data.length; i++){
                    data[i].Url = window.location.hostname+'/lightning/r/Task/'+data[i].Id+'/view';
                    if(data[i].OwnerId != null){
                        data[i].NameOwner = data[i].Owner.Name;
                        data[i].OwnerUrl =  window.location.hostname+'/lightning/r/'+data[i].Owner.Type+'/'+data[i].Owner.Id+'/view';
                    }
                    if(data[i].WhatId != null){
                    data[i].WhatName = data[i].What.Name;
                    data[i].WhatUrl = window.location.hostname+'/lightning/r/'+data[i].What.Type+'/'+data[i].What.Id+'/view';
                    }
                    data[i].buttonEnable = 'false';
                    if(data[i].Status != 'Open'){
                        data[i].buttonEnable = 'true';
                    }
                }
                console.log(data);
                component.set("v.data", data);
            }
        });
        $A.enqueueAction(action);
	}
})