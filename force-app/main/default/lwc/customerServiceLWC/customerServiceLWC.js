import { NavigationMixin } from 'lightning/navigation';
import {LightningElement, track, wire, api} from 'lwc';

import TIMEZONE from '@salesforce/i18n/timeZone';

// importing apex class methods
import getCalls from '@salesforce/apex/ClientServiceCallController.getCalls';
import delSelectedCalls from '@salesforce/apex/ClientServiceCallController.deleteCalls';
import saveTaskRecords from '@salesforce/apex/ClientServiceCallController.saveTaskRecords';

// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

// importing to refresh the apex if any record changes the datas
import {refreshApex} from '@salesforce/apex';
import Consent_By_Personnel__c from '@salesforce/schema/Account.Consent_By_Personnel__c';

// Default CSS classes for all call items
const timelineClasses = "slds-timeline__item_expandable slds-timeline__item_call";

// CSS class for expanded call items
const timelineOpenClass = "slds-is-open";

// Default CSS classes for call popup menus
const callMenuClasses = "slds-dropdown-trigger slds-dropdown-trigger_click";

// CSS class for open call menus
const callMenuOpenClass = "slds-is-open";

// get colums name for Status
const taskstatus = [
    {
        label: 'No Answer',
        value: 'No Answer'
    }, {
        label: 'Voicemail',
        value: 'Voicemail'
    }, {
        label: 'Call Back',
        value: 'Call Back'
    }, {
        label: 'Completed',
        value: 'Completed'
    }
];

// get colums name for Type
const taskType = [
    {
        label: 'Quality Control',
        value: 'Quality Control'
    }, {
        label: 'Customer Issues',
        value: 'Customer Issues'
    }, {
        label: 'Project Management',
        value: 'Project Management'
    }, {
        label: 'Service',
        value: 'Service'
    }
];
//yes or no list
const yesNoList = [
    {
        label: 'No',
        value: 'No'
    },
    {
        label: 'Yes',
        value: 'Yes'
    }
];
export default class CustomerServiceLWC extends LightningElement {
      @api recordId;
      
      // reactive variables
      @track timelineData; // A copy of the received data plus state information for the timeline and modals
      @track record = {};
      @track bShowModal = false;
      @track currentRecordId;
      @track isEditForm = false;
      @track isCreateRecord = false;
      @track isUpdateRecord = false;
      @track showLoadingSpinner = false;
      @track showFollowUpDateInUpdateForm = false;
      @track showFollowUpDateInCreateForm = false;
      @track isFollowUp = false;
      // task status
      @track statuses =  taskstatus;
      @track types =  taskType;
      @track yesOrNo = yesNoList;
      @track storeCreatedRecords =  [
        {           
            objName: "Task",           
            comments: "",
            status: "",
            type: "",
            callDateTime: "",
            followUpCallRequired: "No",
            followUpDateTime: "",
            id: ""
        }
    ]; // store created list

    //load vars
    @track callDT;
    @track SltType;
    @track SltStatus;
    @track CommentsVal;
    @track SltFUR;
    @track FUDT;
  
      // non-reactive variables
      data; // Raw, unmodified, read-only data received via wire
      refreshTimeline;
      error;
      currentDateTime;
      timezone = TIMEZONE;
  
      // retrieving the data using wire service
      @wire(getCalls, {recordId: '$recordId'})
      calls(result) {
          this.refreshTimeline = result;
          if (result.data) {
              this.data = result.data;
              this.resetTimelineData(); // Overwrites this.timelineData
              this.error = undefined;
          } else if (result.error) {
              this.error = result.error;
              this.data = undefined;
              this.timelineData = undefined;
          }
      }

      // Resets the timeline's copy of the data and state information. Must be called whenever this.data is updated.
      resetTimelineData() {
        let outputData = [];

        for (let i = 0; i < this.data.length; i++) {
            outputData[i] = Object.assign({
                htmlDetailsId: "call-" + i + "-expanded",
                timelineCSSClasses: timelineClasses,
                expanded: false,
                detailsExpanded: "false",
                detailsHidden: "true",
                menuOpen: false,
                menuClasses: callMenuClasses,
                showFollowUpDate: this.data[i].Follow_Up_Call_Required__c && this.data[i].Follow_Up_Call_Required__c.toUpperCase() == 'YES'
            }, this.data[i]);
        }

        this.timelineData = outputData;
      }

      // Called whenever the edit or create call forms have loaded data.
      handleEditCreateOnLoad(event) {
        if (event.currentTarget.dataset.create == "true") {
            // do nothing; value set in handleCreateCall()
        } else {
            this.showFollowUpDateInUpdateForm = this.template.querySelector('[data-id="callEditFormCallRequired"]').value == "YES";
        }
      }

      // Called whenever the edit or create call forms' Follow_Up_Call_Required__c fields change.
      handleEditCreateOnChange(event) {
        if (event.currentTarget.dataset.create == "true") {
            this.showFollowUpDateInCreateForm = this.template.querySelector('[data-id="callCreateFormCallRequired"]').value == "YES";
        } else {
            this.showFollowUpDateInUpdateForm = this.template.querySelector('[data-id="callEditFormCallRequired"]').value == "YES";
        }
      }

      // Called whenever a call's title is clicked. Displays additional information in a modal.
      handleCallClick(event) {
        this.viewCurrentRecord(this.timelineData[parseInt(event.currentTarget.dataset.index)]);
      }

      // Expands or collapses the clicked call.
      handleExpandCollapseCall(event) {
        event.preventDefault();

        let i = parseInt(event.currentTarget.dataset.index);

        if (this.timelineData[i].expanded) {
            this.timelineData[i].expanded = false;
            this.timelineData[i].detailsExpanded = "false";
            this.timelineData[i].detailsHidden = "true";
            this.timelineData[i].timelineCSSClasses = timelineClasses;
        } else {
            this.timelineData[i].expanded = true;
            this.timelineData[i].detailsExpanded = "true";
            this.timelineData[i].detailsHidden = "false";
            this.timelineData[i].timelineCSSClasses = timelineClasses + " " + timelineOpenClass;
        }
      }

      // Opens or closes a call's menu.
      handleOpenCloseMenu(event) {
        event.preventDefault();

        let i = parseInt(event.currentTarget.dataset.index);

        if (this.timelineData[i].menuOpen) {
            this.closeMenu(i);
        } else {
            this.timelineData[i].menuOpen = true;
            this.timelineData[i].menuClasses = callMenuClasses + " " + callMenuOpenClass;
        }
      }

      // Closes a call's menu by its index in timelineData.
      closeMenu(index) {
        this.timelineData[index].menuOpen = false;
        this.timelineData[index].menuClasses = callMenuClasses;
      }

      // Called whenever a call's edit option is selected in its menu.
      handleEditCall(event) {
        event.preventDefault();
        this.storeCreatedRecords =  [
            {           
                objName: "Task",           
                comments: "",
                status: "",
                type: "",
                callDateTime: "",
                followUpCallRequired: "No",
                followUpDateTime: "",
                id: ""
            }
        ];

        let i = parseInt(event.currentTarget.dataset.index);
        console.log(this.data[i]);
        this.closeMenu(i);

        // open modal box
        this.bShowModal = true;
        this.isEditForm = true;
        this.isCreateRecord = false;
        this.isUpdateRecord = true;
        
        this.editCurrentRecord(this.data[i]);
      }

      // Called whenever a call's delete option is selected in its menu.
      handleDeleteCall(event) {
        event.preventDefault();

        let i = parseInt(event.currentTarget.dataset.index);

        this.closeMenu(i);
        this.deleteCall(this.data[i]);
      }
  
      // view the current record details
      viewCurrentRecord(currentRow) {
          this.record = currentRow;
          this.bShowModal = true;
          this.isEditForm = false;
          this.isCreateRecord = false;
          this.isUpdateRecord = false;
      }
  
      // closing modal box
      closeModal() {
          this.bShowModal = false;

          this.showFollowUpDateInUpdateForm = false;
          this.showFollowUpDateInCreateForm = false;
          this.currentRecordId = undefined;
          this.record = {};
      }

      editCurrentRecord(currentRow) {
          // assign record id to the record edit form
          //this.currentRecordId = currentRow.Id;
          // load record data
          let element = this.storeCreatedRecords.find(ele  => ele.objName === 'Task');
          if(element != 'undefined'){
            element.comments = currentRow.Description;
            element.status =  currentRow.Call_Status__c;
            element.type =  currentRow.Type;
            element.callDateTime = currentRow.Call_Timestamp__c;
            element.id = currentRow.Id;
            element.followUpCallRequired = currentRow.Confirmation__c;
            if(element.followUpCallRequired == "Yes"){
                this.isFollowUp = true;
                element.followUpDateTime = currentRow.Confirmation_DateTime__c;
            }
            else{
                this.isFollowUp = false;
                element.followUpDateTime = "";
            }

          }
          this.callDT = currentRow.Call_Timestamp__c;
          this.SltType = currentRow.Type;
          this.SltStatus = currentRow.Status;
          this.CommentsVal = currentRow.Description;
          this.SltFUR = currentRow.Confirmation__c;
          this.FUDT = element.followUpDateTime; 
          this.storeCreatedRecords = [...this.storeCreatedRecords];
          console.log(JSON.stringify(this.storeCreatedRecords));
      }

      handleCreateCall(){
        this.currentRecordId = undefined;
        this.currentDateTime = new Date().toISOString();
        this.showFollowUpDateInCreateForm = false;

        this.bShowModal = true;
        this.isEditForm = true;

        //new record
        this.isCreateRecord = true;
        this.isUpdateRecord = false;
      }
  
      // handleing record edit form submit
      handleSubmit(event) {
        // prevending default type sumbit of record edit form
        event.preventDefault();

        if (this.validateFollowUpDate(event.detail.fields)) {
            // querying the record edit form and submiting fields to form
            this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
    
            // closing modal
            this.bShowModal = false;
    
            // showing success message
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'Call updated Successfully!',
                variant: 'success'
            }),);
        }
      }

    // handleing record edit form submit
    handleSubmitCreate(event) {
    // prevending default type sumbit of record edit form
            event.preventDefault();

            if (this.validateFollowUpDate(event.detail.fields)) {
                // querying the record edit form and submiting fields to form
                this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
        
                // closing modal
                this.bShowModal = false;
        
                // showing success message
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!',
                    message: 'Call Created Successfully!',
                    variant: 'success'
                }),);
            }
    }

    validateFollowUpDate(fields) {
        if (fields.hasOwnProperty("Follow_Up_Call_Required__c") && fields.Follow_Up_Call_Required__c != undefined && fields.Follow_Up_Call_Required__c != null && fields.Follow_Up_Call_Required__c.toUpperCase() == "YES") {
            if (!fields.hasOwnProperty("Follow_Up_DateTime__c") || fields.Follow_Up_DateTime__c == undefined || fields.Follow_Up_DateTime__c == null || fields.Follow_Up_DateTime__c.trim() == "") {
                // Not valid. The follow-up date can't be left blank if follow-up call required is set to "YES"
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!',
                    message: 'If "Follow Up Call Required" is set to "YES", the "Follow Up DateTime" can\'t be left blank.',
                    variant: 'error'
                }),);

                return false;
            }

            if (fields.Follow_Up_DateTime__c < fields.Call_DateTime__c) {
                // Not valid. The follow-up datetime must be equal or greater than the call date if both are specified.
                
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!',
                    message: 'The Follow-Up Date must occur after the initial Call Date.',
                    variant: 'error'
                }),);

                return false;
            }

            // Still true/valid
        } else {
            // Remove the follow-up date if follow-up call required is not "YES"
            fields.Follow_Up_DateTime__c = null;

            // Still valid
        }

        return true;
    }
  
      // refreshing the timeline after record edit form success
      handleSuccess() {
          return refreshApex(this.refreshTimeline);
      }
  
      deleteCall(currentRow) {
          let currentRecord = [currentRow.Id];
          this.showLoadingSpinner = true;
  
          // calling apex class method to delete the selected contact
          delSelectedCalls({lstCallIds: currentRecord})
          .then(result => {
              //window.console.log('result ====> ' + result);
              this.showLoadingSpinner = false;
  
              // showing success message
              this.dispatchEvent(new ShowToastEvent({
                  title: 'Success!',
                  message: 'Call deleted.',
                  variant: 'success'
              }),);
  
              // refreshing table data using refresh apex
              return refreshApex(this.refreshTimeline);
  
          })
          .catch(error => {
              //window.console.log('Error ====> '+error);
              this.dispatchEvent(new ShowToastEvent({
                  title: 'Error!', 
                  message: error.message, 
                  variant: 'error'
              }),);
          });
      }

    closeCreateModal() {
        // to close modal set isModalOpen tarck value as false
        this.isCreateRecord = false;
    }

    closeUpdateModal() {
        // to close modal set isModalOpen tarck value as false
        this.isUpdateRecord = false;
    }

    genericOnChange(event){
        let element = this.storeCreatedRecords.find(ele  => ele.objName === 'Task');
        if(element != 'undefined'){
            if(event.target.name == 'comments'){
                element.comments = event.target.value;
            }else if(event.target.name == 'status'){
                element.status =  event.target.value;
            }else if(event.target.name == 'type'){
                element.type =  event.target.value;
            }else if(event.target.name == 'callDateTime'){ 
                element.callDateTime = event.target.value;
            }else if(event.target.name == 'followUpDateTime'){
                element.followUpDateTime = event.target.value;
            } 
        }
        this.storeCreatedRecords = [...this.storeCreatedRecords];
        console.log(JSON.stringify(this.storeCreatedRecords));
    }


    submitDetails(event){
        event.preventDefault();
        let errorCount = 0;
        let fixedCount = this.storeCreatedRecords.length;
        if(fixedCount > 0){
            for(let i = 0; i < this.storeCreatedRecords.length; i++) {
                if(this.storeCreatedRecords[i].comments == "" || this.storeCreatedRecords[i].status == null || this.storeCreatedRecords[i].type == "" || this.storeCreatedRecords[i].callDateTime == ""  || this.storeCreatedRecords[i].followUpCallRequired == "" ){
                    errorCount = 1;
                }
            }
        }
        if(errorCount == 0){
            this.cssDisplay = true;
            saveTaskRecords({
                recordId: this.recordId,
                storeCreatedRecords: this.storeCreatedRecords
            })
            .then(result => {
                let oppStr =  this.isCreateRecord ? 'Created' : 'Updated';
                this.isCreateRecord = false;
                this.isUpdateRecord = false;

                this.cssDisplay = false;
                
                // showing success message
                this.dispatchToastEvent("success", 'Call ' + oppStr + ' Successfully!');

                // refreshing table data using refresh apex
                return refreshApex(this.refreshTimeline);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error saving record',
                        message: error.body.message + ' \nStatus: ' + error.statusText,
                        variant: 'error'
                    })
                );
                this.cssDisplay = false;
            });
        }else{
            this.dispatchToastEvent("error", "These required fields must be completed: Comments, Status, Call Type, call Date/Time, followUp Call Required");
        }
    }

    dispatchToastEvent(type, msg) {
        if (type === "success") {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: msg,
              variant: "success"
            })
          );
        } else {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error",
              message: msg,
              variant: "error"
            })
          );
        }
    }

    handleFollowUp(event){
        let element = this.storeCreatedRecords.find(ele  => ele.objName === 'Task');
        if(element != 'undefined'){
            if(event.target.name == 'followUpCallRequired'){
                element.followUpCallRequired = event.target.value;
                if(element.followUpCallRequired == "Yes"){
                    this.isFollowUp = true;
                }
                else{
                    this.isFollowUp = false;
                    element.followUpDateTime = "";
                }
            } 
        }
        this.storeCreatedRecords = [...this.storeCreatedRecords];
        console.log(JSON.stringify(this.storeCreatedRecords));    
    }
}