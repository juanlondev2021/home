({ getInfoFinanceInHS : function(component, recordId) {
    
    var action = component.get("c.getInfo_Finance");
    action.setParams({
        'recordId': recordId
    });        
    action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
            
            var data = response.getReturnValue();
            
            this.getInitInfo(component,recordId,data);
            
        }else{
            throw new Error(error);
        }     
    });                          
    $A.enqueueAction(action);
},
  getInitInfo: function(component, recordId, infoFinanceInHs) {
      const action = component.get("c.getInfo_Finance_package");
      //  action.setParams({});        
      action.setCallback(this, function(response){
          const state = response.getState();
          
          component.set("v.loaded ",false);

          if (state === "SUCCESS") {
              const data = response.getReturnValue();
              
              for(let [i,packageDB] of data.entries()){
                  
                  packageDB.NameABC = this.packageNameGeneratorInTab(i);

                  if(packageDB.Name === infoFinanceInHs.Package_Name_FINANCE__c){
                      
                      component.set("v.item_select",infoFinanceInHs.Package_Name_FINANCE__c);
                      this.addTab(component,packageDB,infoFinanceInHs);
                
                  }else{
                     
                      this.addTab(component,packageDB,undefined);
                 
                  }
              }
              
        }else{
            throw new Error(error);
        }
        
    });                          
        $A.enqueueAction(action);
        
    },
  getInfo : function(component, recordId,packageList) {
      
      var action = component.get("c.getInfo_Finance");
      action.setParams({
          'recordId': recordId
      });        
      action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              
              component.set("v.loaded ",false);
              
              var data = response.getReturnValue();
   
              let package_name = data.Package_Name_FINANCE__c;              
              let typeOfOrder = data.Type_of_order_FINANCE__c;
              let InHouse = data.In_house__c;
              if(InHouse === true){InHouse= "true"}else if(InHouse ===false){InHouse="false"}
              const setStyle = "border: 2px solid #3666BA;";
              let inComponent = false;
              
              for(let i of packageList){
                  if(i.Name === package_name){
                      console.log("in component");
                      inComponent = true;
                      
                      break;
                  }
              }
              console.log(package_name);
              if(package_name && inComponent){
                  component.set("v.item_select",package_name);
                  console.log(component.get("v.item_select"));
                  component.find(package_name).set("v.value",typeOfOrder);
                  component.find(package_name).set("v.Checkbox_value",InHouse);
                  
                  switch(typeOfOrder) {
                      case 'Promotion':
                          component.find(package_name).set("v.att_Border_Select_Rent",setStyle);
                          component.find(package_name).set("v.att_Border_Select_Buy","");
                          component.find(package_name).set("v.Checkbox_Deactivate",false);
                          //component.find(package_name).set("v.att_annual",0);
                          break;
                      case 'Finance':
                          component.find(package_name).set("v.att_Border_Select_Rent","");
                          component.find(package_name).set("v.att_Border_Select_Buy",setStyle); 
                          component.find(package_name).set("v.Checkbox_Deactivate",true);
                          // component.find(package_name).set("v.att_annual",component.find(package_name).get("v.att_Yearly_Investment") - component.find(package_name).get("v.att_Yearly_Investment_Two"));
                          break;
                      default:
                          alert('Type of order no found');
                          break;                        
                  }                    
              }
              
          }else{
              throw new Error(error);
          }     
      });                          
      $A.enqueueAction(action);
  },
  
  addTab: function(component,info,infoFinanceInHs) { 
      
      $A.createComponent("lightning:tab", {
          "label": info.NameABC,
          "id": info.Name,
      }, function (newTab, status, error) {
          if (status === "SUCCESS") {
              var tabList = component.get("v.moretabs");
              
              let typeOfOrder="";
              let InHouse = false;
              let border_Select_Rent ="";
              let border_Select_Buy ="";
              let checkbox_Deactivate = true;
              const setStyle = "border: 2px solid #3666BA;";
              
              if(infoFinanceInHs){ // If exist infomation in this Home Service.
                  
                  typeOfOrder = infoFinanceInHs.Type_of_order_FINANCE__c;
                  InHouse = infoFinanceInHs.In_house__c;
                  
                  if(typeOfOrder === 'Promotion'){
                      
                      border_Select_Rent = setStyle;
                      border_Select_Buy = "";
                      checkbox_Deactivate = false; 
                      
                  }else if(typeOfOrder === 'Finance'){
                      
                      border_Select_Rent = "";
                      border_Select_Buy = setStyle;
                      checkbox_Deactivate = true;
                
                  }else {
                      alert('404: Type of order no found');
                      
                  }                      
              }
       
              $A.createComponent("c:DiacoFinancePackageComponent", 
                                 {"aura:id": info.Name,
                                  "recordId":component.get("v.recordId"),
                                  "att_Package_Name":info.Name,
                                  "att_Package":info.NameABC,
                                  "att_child":component.getReference("v.att_package_name"),
                                  "att_TypeOfOrder":component.getReference("v.att_type_of_order"),
                                  "att_Package_Price":info.Package_Price__c, 
                                  "att_Monitoring":info.Monitoring__c,
                                  "att_Promotional_Discount":info.Promotional_Discount__c,
                                  "att_Monthly_Term_Two":info.Monthly_Term_FINANCE__c,				
                                  "att_Monthly_Term":info.Monthly_Term_PROMOTION__c,				
                                  "att_Monthly_Renewal_Two":info.Monthly_Renewal_FINANCE__c,		
                                  "att_Monthly_Renewal":info.Monthly_Renewal_PROMOTION__c,
                                  "value":typeOfOrder,
                                  "Checkbox_value":InHouse.toString(),
                                  'att_Border_Select_Rent':border_Select_Rent,
                                  'att_Border_Select_Buy':border_Select_Buy,
                                  'Checkbox_Deactivate':checkbox_Deactivate
                                 }, 
                                 function (newContent, status, error) {
                                     if (status === "SUCCESS") {
                                         
                                         newTab.set('v.body', newContent);
                                         
                                         tabList.push(newTab);
                                         
                                         component.set("v.moretabs", tabList);
                                         
                                     } else {
                                         throw new Error(error);
                                     }
                                 });
              
          } else {
              throw new Error(error);
          }
      });  
  },
  packageNameGeneratorInTab: function(i) {
      
      const alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');     
      let name = "";
      
      if(i < alphabet.length){
          name = 'Package '+ alphabet[i].toUpperCase();
      }else{
          name = 'Package '+ Number(i+1); 
      }
      
      return name;
  },getRecordType: function (component, recordId) {
      var action = component.get("c.getRecordTypeFromHS");
      action.setParams({
          "RecordId": recordId,
      });
      action.setCallback(this, function (response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              if (response.getReturnValue() != null) {
                  var record = response.getReturnValue();
                  if (record != null) {
                      if (record.RecordType.Name.includes('Home Automation')) {
                          component.set('v.isHomeAuto',true);
                      }
                  } 
              }else{
                  component.set('v.isHomeAuto',false);
              }
          }
      });
      $A.enqueueAction(action);
  },thereAreSigned :function (component, recordId) {
      var action = component.get("c.thereAreSigned");
      action.setParams({
          "RecordId": recordId,
      });
      action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              var res= response.getReturnValue();
              if(res > 0){
                  component.set("v.label", "Re-send to Docusign");
              }else{
                  component.set("v.itWasSigned",false);
              }
          }
      });
      $A.enqueueAction(action);
  },ToDocusign :function (component, recordId) {
      var action = component.get("c.sendToDocusign");
      action.setParams({
          "homeserviceId": recordId,
      });
      action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              var toastEvent = $A.get("e.force:showToast");
              component.set("v.label", "Re-Send to Docusign");
              component.set("v.AlarmEmpty",false);
              toastEvent.setParams({
                  title: "Congrats!",
                  message: "The contract was sent to Docusign successfully!",
                  type: "success"
              });
              toastEvent.fire();
          }
      });
      $A.enqueueAction(action);
  }, getAlarmField :function (component, recordId) {
      var action = component.get("c.getAlarmField");
      action.setParams({
          "RecordId": recordId,
      });
      action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              var res= response.getReturnValue();
              if(res){
                  component.set("v.AlarmEmpty",false);
                  this.ToDocusign(component, recordId);
              }else{
                  component.set("v.AlarmEmpty",true);
              }
          }
      });
      $A.enqueueAction(action);
  }
 })