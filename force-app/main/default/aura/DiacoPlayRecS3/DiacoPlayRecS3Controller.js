({
    init : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var actions = [
            { label: 'Rec Date', name: 'Rec_Date__c', fieldName: 'Rec_Date__c' },
            { label: 'Rec', name: 'Rec_WAV__c', fieldName: 'Rec_WAV__c', },
            {label: 'Action', type: 'button-icon', initialWidth: 100, typeAttributes:
             { label: { fieldName: 'actionLabel'}, title: 'Download', name: 'download_rec', 
              iconName: 'action:download', class: '', variant:'border-filled'}},
            {label: '', type: 'button-icon', initialWidth: 50, typeAttributes:
             { label: { fieldName: 'actionLabel'}, title: 'Play', name: 'play_rec', 
              iconName: 'action:preview', class: '', variant:'border-filled'}}
            
        ];	
        component.set('v.columns', actions);
        helper.getRecords(component, recordId);
    },
    handleRowAction: function(component, event, helper) {
        try{
            var action = event.getParam('action');
            var row = event.getParam('row');
            if (action.name == 'download_rec') {
                window.open(row.Rec_WAV__c, '_blank');
                
            }else if(action.name == 'play_rec'){
                component.set('v.recWAV', row.Rec_WAV__c);
                /*var audio = component.find('rec').getElement();
                console.log(audio)
                audio.play();*/
                var audio= document.getElementById("rec");
                console.log(audio)
                audio.play();
                var audio2 = new Audio(row.Rec_WAV__c);
                audio2.type = 'audio/wav';
				audio2.play();
              /*try {
                await audio2.play();
                console.log('Playing...');
              } catch (err) {
                console.log('Failed to play...' + err);
              }*/
            }
        }catch(error){
            console.log(error)
        }
    }
})