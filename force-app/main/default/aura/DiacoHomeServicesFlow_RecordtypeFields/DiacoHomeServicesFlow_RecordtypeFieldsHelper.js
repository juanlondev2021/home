({    
    setValues : function(cmp, values, fieldNames, miltiPicklist) {
        console.log(values);
        console.log(fieldNames);
        for (let i = 0; i < values.length; i++) {
            let items = [];
            for (let key in values[i]) {
                items.push({'value':values[i][key], 'key':key});
            }
            cmp.set('v.' + fieldNames[i], items);
            
            //console.log(fieldNames[i]+ ' - ' + JSON.stringify(items));
        }
        
        if( miltiPicklist ) {
            
            if( cmp.get('v.appoinmType.name') == 'Flooring' ) {
                
                cmp.set('v.Rooms_to_be_Installed__c', this.setObjectValues(cmp.get('v.Rooms_to_be_Installed__c')) );
                console.log('Rooms_to_be_Installed__c ' + JSON.stringify(cmp.get('v.Rooms_to_be_Installed__c')));
            }
            
            if( cmp.get('v.appoinmType.name') == 'Closet Organization' ) {
                
                cmp.set('v.Description_of_closet__c', this.setObjectValues(cmp.get('v.Description_of_closet__c')) );
                console.log('Description_of_closet__c ' + JSON.stringify(cmp.get('v.Description_of_closet__c')));
                
                cmp.set('v.Type_of_System_to_be_installed__c', this.setObjectValues(cmp.get('v.Type_of_System_to_be_installed__c')) );
                console.log('Type_of_System_to_be_installed__c ' + JSON.stringify(cmp.get('v.Type_of_System_to_be_installed__c')));
                
            }
            
            if( cmp.get('v.appoinmType.name') == 'Addition(s)' ) {
                
                cmp.set('v.Rooms_included_in_project__c', this.setObjectValues(cmp.get('v.Rooms_included_in_project__c')) );
                console.log('Rooms_included_in_project__c ' + JSON.stringify(cmp.get('v.Rooms_included_in_project__c')));
            }
            
            //cmp.set('v.Project_Type__c', this.setObjectValues(cmp.get('v.Project_Type__c')) );
            
            this.setValuesMultiPick(cmp);
        }
        
        var appointment = cmp.get('v.appointment');
        if( appointment ) {
            
            if( appointment.Id == null ) {
                
                appointment.Appointment_Setter__c = cmp.get('v.appointmentSetter');
                appointment.Person_Account__c = cmp.get('v.account.Id');
                
                //Channel Source
                appointment.Channel_Source__c = 'Canvas';
            }else{
                cmp.set('v.appointmentSetter',appointment.Appointment_Setter__c)
            }
            
            if( appointment.Appointment_Start_Time__c ) {
                let arizonaTime = this.changeTimezone(new Date(appointment.Appointment_Start_Time__c), "America/Phoenix");
                let appointmentTime = $A.localizationService.formatTime(new Date(arizonaTime),"HH:mm");
                let appointmentDate = $A.localizationService.formatDate(new Date(arizonaTime),"yyyy-MM-dd");                
                cmp.set('v.appointmentTime', appointmentTime);
                cmp.set('v.appointmentDate', appointmentDate);
                
            }
            cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));
        }

        // values start dateTime list
        const startDateValues = [
            {
                value: '8 - 10 AM',
                time: '08:00',
                endHour: 2,
            },
            {
                value: '9 - 11 AM',
                time: '09:00',
                endHour: 2,
            },
            {
                value: '12 - 2 PM',
                time : '12:00',
                endHour : 2,
            },
            {
                value: '3 - 5 PM',
                time: '15:00',
                endHour: 2,
            },
            {
                value: '6 - 8 PM',
                time: '18:00',
                endHour: 2,
            },
        ]; 
        cmp.set('v.appointmentTimeValues', startDateValues);
        
    },
    
    
    setValuesByRecordType : function(cmp) {
        
        let appoinmType = cmp.get('v.appoinmType');
        let byRecordType = cmp.get('v.picklistValuesByRecordType');
        
        let objectResult = byRecordType.filter(item => item.recordTypeId === appoinmType.id);
        
        for (let i = 0; i < objectResult.length; i++) {
            // Type__c is Picklist
            var values = objectResult[i].result;
            var items = [];
            for (let key in values) {
                items.push({'value':values[key], 'key':key});
            }
            
            if( objectResult[i].name === 'Type_of_Service__c') {
                
                cmp.set('v.Type_of_Service__c', items);
                // Project_Type__c is multiplicklist
            }else if ( objectResult[i].name === 'Project_Type__c' ) {
                
                cmp.set('v.Project_Type__c', this.setObjectValues(items));
            }
        }
    },
    
    setObjectValues: function(values) {
        values = values.map(e => {
            let obj = {};
                            obj['value'] = e.key;
                            obj['label'] = e.value;
                            return obj;
                            });
        return values;
    },
    
    setValuesMultiPick : function(cmp) {
        
        var appointment = cmp.get('v.appointment');
        
        cmp.set('v.Project_Type_Values', appointment.Project_Type__c != null ? appointment.Project_Type__c.split(';') : []);
        
        if( cmp.get('v.appoinmType.name') == 'Flooring' ) {
            
            cmp.set('v.Rooms_to_be_Installed_Values', appointment.Rooms_to_be_Installed__c != null ? appointment.Rooms_to_be_Installed__c.split(';') : []);
            //console.log(JSON.stringify(cmp.get('v.Rooms_to_be_Installed_Values'))); 
            let Rooms_to_be_Installed_Values = cmp.get('v.Rooms_to_be_Installed_Values');
            cmp.set('v.isBathrooms',Rooms_to_be_Installed_Values.filter(item => item === 'Bathroom(s)').length > 0 ? true : false);
            cmp.set('v.isBedrooms',Rooms_to_be_Installed_Values.filter(item => item === 'Bedroom(s)').length > 0 ? true : false);
            
        }
        
        if( cmp.get('v.appoinmType.name') == 'Closet Organization' ) {
            
            cmp.set('v.Description_of_closet_values', appointment.Description_of_closet__c != null ? appointment.Description_of_closet__c.split(';') : []);
            cmp.set('v.Type_of_System_to_be_installed_values', appointment.Type_of_System_to_be_installed__c != null ? appointment.Type_of_System_to_be_installed__c.split(';') : []);
        }
        
        
        if( cmp.get('v.appoinmType.name') == 'Closet Organization' ) {
            
            cmp.set('v.Rooms_included_in_project_values', appointment.Rooms_included_in_project__c != null ? appointment.Rooms_included_in_project__c.split(';') : []);
        }
    },
    
    changeTimezone :function (date, ianatz) { 
        let invdate = new Date(date.toLocaleString('en-US', {
            timeZone: ianatz
        }));        
        return invdate;
    },

    isBlank : function(str) {
        return (!str || /^\s*$/.test(str));
    },

    validateFieldsForm: function(cmp, object) {
    
        var validObject = true;
        // Show error messages if required fields are blank
        var allValid = cmp.find('fieldId').reduce(function (validFields, inputCmp) {
    
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        if ( allValid ) {
            
            if( $A.util.isEmpty(object) ) {
                
                validObject = false;
                console.log("Quick action context doesn't have a valid objecet.");
            }
            
            return(validObject);
            
        } 
    }
})