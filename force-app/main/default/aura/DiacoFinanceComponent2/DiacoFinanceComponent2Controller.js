({
	 init: function(component, event, helper) {
        var id;
        
        var pageReference = component.get("v.pageReference");
        if (
            pageReference != null &&
            pageReference.hasOwnProperty("state") &&
            pageReference.state != null &&
            pageReference.state.hasOwnProperty("c__recordId") &&
            pageReference.state.c__recordId != null &&
            pageReference.state.c__recordId.trim().length > 0
        ) {
            id = pageReference.state.c__recordId;
            component.set("v.recordId", id);
        } else {
            id = component.get("v.recordId");
        }
         
        if(id){            
            component.set("v.disableInputHS",false);
            component.set("v.existId",true)
        }
         
        helper.getHomeServiceInfo(component,id);
        helper.getRecordType(component, id);
        helper.thereAreSigned(component, id);
    },
       activateSectionToUpdate: function(component, event, helper) {
        component.set("v.disablePrimaryInput",!component.get("v.disablePrimaryInput"));
        const data = component.get('v.data');
           
           component.set('v.backUp', {Purchase:data.Purchase__c,
                                      //MonthlyPaymentPURCHASE:data.Monthly_Payment_PURCHASE__c,
                                      ActivationEmergencyVideoLEASE:data.Activation_Emergency_Video_LEASE__c,
                                      ActivationEmergencyVideoPURCHASE:data.Activation_Emergency_Video_PURCHASE__c});          
       // helper.showInformation(component, c);
                    
    },
    onchangePaymentFactor:function(component, event, helper){
        component.set("v.loaded ",true);
        const id = component.get("v.recordId"); 
        let financeInformation = component.get("v.data");
      	const paymentFactor = financeInformation.Payment_Factor__c;
        if(paymentFactor == '0.01675'){
            component.set("v.data.Payment_Number__c",96);
        }else if(paymentFactor == '0.01487'){
            component.set("v.data.Payment_Number__c",120);
        }
        financeInformation.Name = id;
        financeInformation = helper.calculatePurchase(component,financeInformation);
 		helper.setFinanceType(component,id,financeInformation);        
    },
    closeUpdateSection: function(component,event, helper){
        component.set("v.disablePrimaryInput",true);
        //component.set('v.data.Monthly_Payment_LEASE__c', component.get('v.backUp.MonthlyPaymentLEASE'));
        //component.set('v.data.Monthly_Payment_PURCHASE__c', component.get('v.backUp.MonthlyPaymentPURCHASE'));
        component.set('v.data.Purchase__c', component.get('v.backUp.Purchase'));
        component.set('v.data.Activation_Emergency_Video_LEASE__c', component.get('v.backUp.ActivationEmergencyVideoLEASE')); 
        component.set('v.data.Activation_Emergency_Video_PURCHASE__c', component.get('v.backUp.ActivationEmergencyVideoPURCHASE'));
    },
    saveInfo: function(component,event, helper){
        component.set("v.loaded ",true);
        const id = component.get("v.recordId"); 
        let financeInformation = component.get("v.data");
        financeInformation.Name = id;
        helper.calculatePurchase(component,financeInformation);
        financeInformation.Total_Min_Payments__c = financeInformation.Monthly_Payment_LEASE__c * financeInformation.Monthly_Term_LEASE__c;
        helper.setFinanceType(component,id,financeInformation);
    },   
     onChageUpdateType: function(component, event, helper) {
        const id = component.get("v.recordId"); 
        
        const financeType = component.find("financeType").get("v.value");
        component.set("v.loaded ",true);
        const financeInformation = component.get("v.data");     
         if(financeType){
             financeInformation.type__c = financeType;
             financeInformation.Name = id;
             helper.setFinanceType(component,id,financeInformation);
             helper.getRecordType(component, id);             
         }else{
           component.set("v.loaded ",false);
         }
    },
    onchangeUpdateTax: function(component, event, helper) {
        component.set("v.loaded ",true);
        let financeInformation = component.get("v.data");
        const id = component.get("v.recordId"); 
        financeInformation.Name = id;
        financeInformation = helper.calculatePurchase(component,financeInformation);
        helper.setFinanceType(component,id,financeInformation);
    },
    onChangeInput: function(component,event, helper){
        let financeInformation = component.get("v.data");
       	component.set("v.data.Monthly_Payment_PURCHASE__c",financeInformation.Monthly_Payment_LEASE__c);
        component.set("v.data.Activation_Emergency_Video_PURCHASE__c",financeInformation.Activation_Emergency_Video_LEASE__c);
    }, 
    onchangeUpdateVideo: function(component, event, helper) {
        component.set("v.loaded ",true);
         let financeInformation = component.get("v.data");
         const id = component.get("v.recordId");
        
        if(financeInformation.Video__c == 'true'){
            financeInformation.Monitoring__c = 34.99
        }
        else if(financeInformation.Video__c == 'false'){
            financeInformation.Monitoring__c = 29.99
        }else{
            financeInformation.Monitoring__c = 0
        }
         financeInformation.Name = id;
         financeInformation = helper.calculatePurchase(component,financeInformation);
         helper.setFinanceType(component,id,financeInformation);
    },getRecordType: function(component, event, helper) {
        var Id = component.get("v.recordId");
        helper.getRecordType(component, Id);        
    },ToDocusign: function(component, event, helper) {
        var Id = component.get("v.recordId");
        if(component.get('v.HaveACH')){
            component.set("v.label",'Sending...'); 
            helper.ToDocusign(component, Id);     
        }else{
            component.set('v.withACH',true);
            helper.createPaymentMethod(component);
        }
        
    },closeModel: function(component, event, helper) {
        component.set("v.AlarmEmpty",false); 
    },AlarmToDocusign: function(component, event, helper) {
        var Id = component.get("v.recordId");
        helper.getAlarmField(component,Id);    
    },
    closeModel1 : function(component, event, helper){
        component.set("v.contentModal",false);
        if(component.get("v.withACH")){
            component.set("v.AlarmEmpty",true);
            component.set("v.withACH",false);
        }
        helper.getRecordType(component, component.get("v.recordId"));
    }
})