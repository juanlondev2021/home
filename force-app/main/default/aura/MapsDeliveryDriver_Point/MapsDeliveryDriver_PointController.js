({
    doInit : function(cmp, event, helper) {
        //alert('>> Point ' + JSON.stringify(cmp.get('v.point')));
        cmp.set('v.open',true);
        let point = cmp.get('v.point');
        cmp.set('v.isSaved',false);
        if(!$A.util.isEmpty(point.Checking__c)){
            cmp.set('v.lastHungStatus',point.Hung_Status__c);
        }else{
            cmp.set('v.lastHungStatus',null);
        }
        helper.getGeoLocation(cmp);
    },

    handleRecordUpdated: function(cmp, event, helper) {

        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            
        } else if(eventParams.changeType === "LOADED") {
            // record is loaded in the cache
            let point = cmp.get('v.dataPoint');
            //alert('>> Record Data ' + JSON.stringify(point));
            if ( !$A.util.isEmpty(point.Checking__c) ) {
                cmp.set('v.isCheckOut',true);
            }else {
                cmp.set('v.isCheckOut',false);
            }
            cmp.set('v.currentHungStatus',point.Hung_Status__c);

        } else if(eventParams.changeType === "REMOVED") {            
            // record is deleted and removed from the cache

        } else if(eventParams.changeType === "ERROR") {
            helper.showMessage(cmp.get("v.pointError"), 'error'); 
            console.error('error: ' + cmp.get("v.pointError"));
        }

        cmp.set('v.loaded', false);
    },

    checkInAndOut : function(cmp, event, helper) {
        let point = cmp.get('v.dataPoint');
        point.Maps_Delivery_Driver__c = true;
        let isLocation = false;

        if (!cmp.get('v.isCheckOut') && cmp.get('v.latitude') != null && cmp.get('v.longitude') != null ) {
            isLocation = true;
            point.Checking__c = $A.localizationService.formatDateTime(new Date(), "yyyy-MM-ddTHH:mm:ssZ");
            point.Delivery_Driver_Latitude__c = cmp.get('v.latitude');
            point.Delivery_Driver_Longitude__c = cmp.get('v.longitude');
        }
 
        if( isLocation ) {
            cmp.set('v.loaded', true);
            cmp.set('v.dataPoint',point);
            helper.updatePoint(cmp);
        }else {
            let device = $A.get("$Browser.formFactor");
            if ( device == 'DESKTOP' ) {
                helper.showMessage('This website need permission to get location.','Error');
            }else{
                helper.showMessage('Please activate the GPS','Error');
            }
            helper.getGeoLocation(cmp);
        }
    },

    setHungStatus : function(cmp,event,helper) {
        let point = cmp.get('v.dataPoint');
        if(helper.validateFieldsForm(cmp,point)){
            cmp.set('v.loaded', true);
            point.Maps_Delivery_Driver__c = true;
            point.Hung_Date_Time__c = $A.localizationService.formatDateTime(new Date(), "yyyy-MM-ddTHH:mm:ssZ");
            //console.log('>> point ' + JSON.stringify(point));
            cmp.set('v.isSaved',true);
            helper.updatePoint(cmp);
        }
    },
    
    mapTakeMeThere : function(cmp,event,helper) {
        let point = cmp.get('v.point');
        window.open("https://www.google.com/maps/dir/?api=1&travelmode=driving&layer=traffic&destination="+point.maps__Latitude__c + ',' + point.maps__Longitude__c);
    },

    changeHungStatus : function(cmp,event, helper){
        cmp.set('v.notValit',false);
    },

    closeModel : function(cmp, event, helper) {
        cmp.set('v.open', false);
        let dataPoint = cmp.get('v.dataPoint');
        dataPoint.Maps_Delivery_Driver__c = true;
        let isLocation = false;
        if ( !$A.util.isEmpty(dataPoint.Checking__c) && dataPoint.Hung_Status__c!= cmp.get('v.lastHungStatus') && cmp.get('v.isSaved')) {
            isLocation = true;
            dataPoint.Checkout__c = $A.localizationService.formatDateTime(new Date(), "yyyy-MM-ddTHH:mm:ssZ");
        }
        if( isLocation ) {
            cmp.set('v.loaded', true);
            cmp.set('v.dataPoint',dataPoint);
            helper.updatePoint(cmp);
        }
    },locationUpdate : function (component, event, helper) {
        // Get the new hash from the event
        //var loc = event.getParam("token");
        var action = component.get('c.closeModel');
        $A.enqueueAction(action);
        // Do something else
    },
    closeModelP: function(cmp,event,helper){
        cmp.set('v.ConfirmModal',false);
        cmp.set('v.open', true);
    },
    handleUploadFinished: function (cmp, event,helper) {
        // Get the list of uploaded files
        let record = cmp.get('v.point');
        let recordId = record.Delivery_Object__c;
        record.Delivery_Object__r.Aws_Url__c='text';
        cmp.set('v.ConfirmModal',false);
        cmp.set('v.point',record);
        cmp.set('v.open', true);
        var uploadedFiles = event.getParam("files");
        // Get the file name
        uploadedFiles.forEach(file => {
            helper.UploadPhoto(cmp,file.documentId,recordId);
        }
        );
        helper.showMessage('Photo uploaded successfully.','success');
            
    },
    UpModel: function(cmp,event,helper){
        cmp.set('v.ConfirmModal',true);
        cmp.set('v.open', false);
    }
})