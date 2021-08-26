import { LightningElement, track } from 'lwc';
import searchUserByParameters from '@salesforce/apex/Diaco_ManageChannelUsersLWCController.searchUserByParameters';
import updateUser from '@salesforce/apex/Diaco_ManageChannelUsersLWCController.updateUser';

const actions = [
    { label: 'Edit Channel slack', name: 'editChannels' },
];

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'FirstName', fieldName: 'FirstName' },
    { label: 'LastName', fieldName: 'LastName' },
    { label: 'Username', fieldName: 'Username' },
    { label: 'Installation Slack Channel', fieldName: 'Installation_Slack_Channel__c'},
    { label: 'Sales Slack Channel', fieldName: 'Slack_Channel__c' },
    { label: 'Service Slack Channel', fieldName: 'Service_Slack_Channel__c' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
export default class ManageChannelUsers extends LightningElement {

channelUsersInput = {};
@track showEditRow = false;
tooMuchResults = true;
maxResults = 'The Results are limited to 100 records, for mor precision try reduce amount of results using the filters ';

@track data = [];
columns = columns;
@track record = {};

valueChannel1;
valueChannel2;
valueChannel3;

optionsChannels=[];

messageNotFound;

rowOffset = 100;

connectedCallback() {
this.channelUsersInput.user = {
    "Name" : "",
    "FirstName" : "",
    "LastName" : "",
    "Username" : "",
    "Username" : "",
}
}

handleChannelChange1(event) {
this.record.Installation_Slack_Channel__c = event.detail.value;
}

handleChannelChange2(event) {
this.record.Slack_Channel__c = event.detail.value;
}

handleChannelChange3(event) {
this.record.Service_Slack_Channel__c = event.detail.value;
}


handleCompleteNameValueChanged (event) {
 this.channelUsersInput.user.Name = event.detail.value;
}

handleFirstNameValueChanged (event) {
this.channelUsersInput.user.FirstName = event.detail.value;
}

handleLastNameValueChanged (event) {
this.channelUsersInput.user.LastName = event.detail.value;
}

handleUsernameValueChanged (event) {
this.channelUsersInput.user.Username = event.detail.value;
}

handleSearchUser () {

searchUserByParameters({
                inputJson: JSON.stringify(this.channelUsersInput)
            })
            .then(result => {
                console.log('ResponseService-->' + JSON.stringify(result));
                this.data = result.records;
                //this.optionsChannels = result.channels;
                console.log('length canales-->' + result.channels.length);
                let optionsAction = [];
                for (let j = 0; j < result.channels.length; j++) {
                    let valueIt = result.channels[j];
                    console.log('Metiendo canales-->' + valueIt.Name);
                    console.log('Metiendo canales COmplete-->' + valueIt);
                    optionsAction.push({label: valueIt.Name, value: valueIt.Name});
                }
                this.optionsChannels = optionsAction;
                /*if (this.data.length >= 100) {
                    console.log('MAXLENGTHExceded-->' + this.data.length);
                    this.tooMuchResults = true;
                    this.data = [];
                } else {
                    console.log('MAXLENGTHOk-->' + this.data.length);
                    this.tooMuchResults = false;
                }*/
                console.log('this.data.length-->' + this.data.length);
            })
            .catch(error => {
                this.error = error;
            });
}

handleCancelClick () {
    this.showEditRow = false;
    this.record =  {};
}

handleSaveClick () {
    this.channelUsersInput.userToSave=this.record;
updateUser({
                inputJson: JSON.stringify(this.channelUsersInput)
            })
            .then(result => {
                console.log('ResponseService AfterSave-->' + JSON.stringify(result));
                this.data = result.records;
                this.showEditRow = false;
                this.record =  {};
                //this.optionsChannels = result.channels;
                console.log('length canales AfterSave-->' + result.channels.length);

                console.log('this.data.length AfterSave-->' + this.data.length);
            })
            .catch(error => {
                this.error = error;
            });
}


handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'editChannels':
                this.showEditChannels(row);
                break;
            default:
        }
    }

showEditChannels (row) {

    this.showEditRow = true;
    this.record =  row;
}
}