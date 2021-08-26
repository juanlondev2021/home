({
  getHomeServiceInfo: function (component, recordId) {
    const action = component.get("c.getInfo_HS");
    action.setParams({
      recordId: recordId
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const data = response.getReturnValue();
        const financeId = data.FinanceId__c;
        console.log(financeId);
        component.set("v.hsId", data.Id);
        component.set("v.financeId", financeId);
        this.getInitInfo(component, financeId);
      } else {
        alert("Error!");
        component.set("v.loaded", false);
      }
    });
    $A.enqueueAction(action);
  },

  getInitInfo: function (component, recordId) {
    const action = component.get("c.getInfo_Finance_HS_With_Tax");
    action.setParams({
      recordId: recordId,
      hsId: component.get("v.hsId")
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const data = response.getReturnValue();
        console.log(data);
        this.formatingInformation(component, data);
        component.set("v.loaded ", false);
      } else {
        alert("Error!");
      }
    });
    $A.enqueueAction(action);
  },
  setFinanceType: function (component, recordId, financeObject) {
    console.log("test", financeObject);
    var action = component.get("c.create_update_Finance_HS");
    console.log("DEBUG");
    console.log(financeObject);
    financeObject.Id = component.get("v.financeId");
    console.log(financeObject);
    action.setParams({
      recordId: component.get("v.hsId"),
      financeInfo: financeObject
    });

    action.setCallback(this, function (response) {
      var state = response.getState();
      var toastEvent = $A.get("e.force:showToast");

      if (state === "SUCCESS") {
        const data = response.getReturnValue();
        this.formatingInformation(component, data);
        component.set("v.financeId", data.Id);
        component.set("v.loaded ", false);
        component.set("v.disablePrimaryInput", true);
        toastEvent.setParams({
          title: "Success!",
          message: "The Finance has been updated successfully.",
          type: "Success"
        });
        toastEvent.fire();
      } else {
        component.set("v.loaded ", false);
        alert("Error in set Type!");
      }
    });
    $A.enqueueAction(action);
  },
  formatingInformation: function (component, data) {
    data.Tax__c = data.Tax__c ? "true" : "false";
    //data.Video__c = (data.Video__c)? "true" : "false";
    data.Purchase__c = data.Purchase__c
      ? parseFloat(data.Purchase__c).toFixed(2)
      : data.Purchase__c;
    data.Customer_Owned_LEASE__c = data.Customer_Owned_LEASE__c
      ? "true"
      : "false";
    data.Customer_Owned_PURCHASE__c = data.Customer_Owned_PURCHASE__c
      ? "true"
      : "false";
    data.X12_Months_Same_As_Cash__c = data.X12_Months_Same_As_Cash__c
      ? "true"
      : "false";
    //data.Monthly_Payment_LEASE__c = data.Monitoring__c + data.Equipment_Min_Payment__c;
	//data.Monthly_Payment_PURCHASE__c = data.Monthly_Payment_LEASE__c;
      
    component.set("v.data", data);
    this.activateBorder(component, data.type__c);
    const YearlyOne = data.Monthly_Payment_LEASE__c * 12;
    component.set("v.att_Yearly ", YearlyOne);
    const YearlyTwo = data.Monthly_Term_PURCHASE__c * data.Monitoring__c;
    component.set("v.annualSavings", YearlyOne - YearlyTwo);
  },
  calculatePurchase: function (component, financeInformation) {
    const paymentFactor = financeInformation.Payment_Factor__c;
    const PURCHASE = financeInformation.Purchase__c;
    const monitoring = financeInformation.Monitoring__c; //(financeInformation.Video__c)? 29.99 : 24.99;
    const EquipmentMinPayment = PURCHASE*paymentFactor;

    financeInformation.Equipment_Min_Payment__c = EquipmentMinPayment;
    financeInformation.Monthly_Payment_LEASE__c = financeInformation.Monitoring__c + financeInformation.Equipment_Min_Payment__c;
    financeInformation.Monthly_Payment_PURCHASE__c = financeInformation.Monthly_Payment_LEASE__c;
    financeInformation.Tax__c = "false";
    /*
        if(financeInformation.Tax__c == 'true'){
            financeInformation.Purchase__c = (EquipmentMinPayment/paymentFactor)*1.083
        }
        
    if (financeInformation.Tax__c == "false") {
      console.log("HERE" + paymentFactor);
      financeInformation.Purchase__c = EquipmentMinPayment / paymentFactor;
    }
    */
    return financeInformation;
  },

  activateBorder: function (component, financeType) {
    const setStyle = "border: 2px solid #3666BA;";

    if (financeType === "lease") {
      component.set("v.att_Border_Select_lease", setStyle);
      component.set("v.att_Border_Select_purchase", "");
    } else if (financeType === "purchase") {
      component.set("v.att_Border_Select_purchase", setStyle);
      component.set("v.att_Border_Select_lease", "");
    }
  },
  //send to docusign helpers
  getRecordType: function (component, recordId) {
    var action = component.get("c.getRecordTypeFromHS");
    action.setParams({
      RecordId: recordId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      console.log("data: " + component.get("v.data"));
      if (state === "SUCCESS") {
        console.log("sss");
        if (response.getReturnValue() != null) {
          var record = response.getReturnValue();
          console.log("info " + record);
          if (record != null) {
            if (record[0].includes("Home Automation")) {
              component.set("v.isHomeAuto", true);
              if (record[1] == "OK") {
                component.set("v.HaveACH", true);
              } else {
                component.set("v.HaveACH", false);
              }
            }
          }
        } else {
          component.set("v.isHomeAuto", false);
        }
      }
    });
    $A.enqueueAction(action);
  },
  thereAreSigned: function (component, recordId) {
    var action = component.get("c.thereAreSigned");
    action.setParams({
      RecordId: recordId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        if (res > 0) {
          component.set("v.label", "Re-send to Docusign");
        } else {
          component.set("v.itWasSigned", false);
        }
      }
    });
    $A.enqueueAction(action);
  },
  ToDocusign: function (component, recordId) {
    var action = component.get("c.sendToDocusign");
    action.setParams({
      homeserviceId: recordId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var data = response.getReturnValue();
      if (state === "SUCCESS") {
        if (data[0] == "Created") {
          var toastEvent = $A.get("e.force:showToast");
          component.set("v.label", "Re-Send to Docusign");
          component.set("v.AlarmEmpty", false);
          toastEvent.setParams({
            title: "Congrats!",
            message: "The contract was sent to Docusign successfully!",
            type: "success"
          });
          toastEvent.fire();
        } else if (
          data[0] == "Bad Request" ||
          data[0] == "Unauthorized" ||
          data[0] == "Error"
        ) {
          var toastEvent = $A.get("e.force:showToast");
          component.set("v.label", "Send to Docusign");
          component.set("v.AlarmEmpty", false);
          toastEvent.setParams({
            title: "Error!",
            message: data[1],
            type: "Error"
          });
          toastEvent.fire();
        } else {
          var toastEvent = $A.get("e.force:showToast");
          component.set("v.label", "Send to Docusign");
          component.set("v.AlarmEmpty", false);
          toastEvent.setParams({
            title: "Error!",
            message: data[1],
            type: "Error"
          });
          toastEvent.fire();
        }
      }
    });
    $A.enqueueAction(action);
  },
  getAlarmField: function (component, recordId) {
    var action = component.get("c.getAlarmField");
    action.setParams({
      RecordId: recordId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        if (res) {
          if (component.get("v.HaveACH")) {
            component.set("v.AlarmEmpty", false);
            component.set("v.label", "Sending...");
            this.ToDocusign(component, recordId);
          } else {
            this.createPaymentMethod(component);
          }
        } else {
          component.set("v.AlarmEmpty", true);
        }
      }
    });
    $A.enqueueAction(action);
  },
  createPaymentMethod: function (component) {
    try {
      var modalBody;
      var recordId = component.get("v.recordId");
      $A.createComponent(
        "c:diacoFinancePayMethodCreate",
        {
          AccId: recordId
        },
        function (content, status) {
          if (status === "SUCCESS") {
            modalBody = content;
            component.set("v.header", "ACH Payment Method");
            component.set("v.body", modalBody);
            component.set("v.contentModal", true);
            component.set("v.AlarmEmpty", false);
          }
        }
      );
    } catch (error) {
      console.log(error);
    }
  }
});