({    
    setValues : function(cmp, values, fieldNames, miltiPicklist) {
        for (let i = 0; i < values.length; i++) {
            let items = [];
            for (let key in values[i]) {
                items.push({'value':values[i][key], 'key':key});
            }
			cmp.set('v.' + fieldNames[i], items);			
        }

        if( miltiPicklist ) {

            if( cmp.get('v.appoinmType.name') == 'Flooring' ) {

                cmp.set('v.Rooms_to_be_Installed__c', this.setObjectValues(cmp.get('v.Rooms_to_be_Installed__c')) );
            }

            if( cmp.get('v.appoinmType.name') == 'Closet Organization' ) {

                cmp.set('v.Description_of_closet__c', this.setObjectValues(cmp.get('v.Description_of_closet__c')) );

                cmp.set('v.Type_of_System_to_be_installed__c', this.setObjectValues(cmp.get('v.Type_of_System_to_be_installed__c')) );

            }

            if( cmp.get('v.appoinmType.name') == 'Addition(s)' ) {

                cmp.set('v.Rooms_included_in_project__c', this.setObjectValues(cmp.get('v.Rooms_included_in_project__c')) );
            }

            this.setValuesMultiPick(cmp);
        }

        var appointment = cmp.get('v.appointment');
        if( appointment ) {      
            
            if( appointment.Id == null ) {
                // Appintment Create
                appointment.Appointment_Setter__c = cmp.get('v.appointmentSetter');
                appointment.Person_Account__c = cmp.get('v.account.Id');
                
                // leadSource
                if(cmp.get('v.leadSource') == 'Canvas') { 
                    // flow Canvas
                    appointment.Lead_Source__c = 'Canvas';
                }else {
                    // Salesforce Site
                    appointment.Lead_Source__c = cmp.get('v.leadSource');
                }

                // Channer source 
                appointment.Channel_Source__c = 'Canvas';

            }else{
                // Appintment Update
                cmp.set('v.appointmentSetter',appointment.Appointment_Setter__c);
            }
            
            //  Start Time
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
        let objectResult = this.getValuesByRecordType(cmp);
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

    getValuesByRecordType : function(cmp) { 
        let objectResult = [];
        if( cmp.get('v.appoinmType.name') == 'Flooring' ) {
            let typeSerValues = {};
            typeSerValues['Carpet'] = 'Carpet';
            typeSerValues['Stone'] = 'Stone';
            typeSerValues['Tile'] = 'Tile';
            typeSerValues['Waterproof Vinyl'] = 'Waterproof Vinyl';
            typeSerValues['Wood Laminate'] = 'Wood Laminate';

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            objectResult = [typeOfService];
        }
        if( cmp.get('v.appoinmType.name') == 'Pool Maintenance' ) {
            let typeSerValues = {};
            typeSerValues["Pool"] = "Pool";
            typeSerValues["Spa"] = "Spa";
            typeSerValues["Both"] = "Both";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            objectResult = [typeOfService];
        }
        if( cmp.get('v.appoinmType.name') == 'Painting' ) {
            let typeSerValues = {};
            typeSerValues["Interior"] = "Interior";
            typeSerValues["Exterior"] = "Exterior";
            typeSerValues["Both"] = "Both";
            
            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            objectResult = [typeOfService];
        }
        else if( cmp.get('v.appoinmType.name') == 'Blinds & Shutters' ) {
            let typeSerValues = {};
            typeSerValues['Replace/New'] = 'Replace/New';
            typeSerValues['Repair'] = 'Repair';

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            let projtTypValues = {};
            projtTypValues["Blinds/Shades"] = "Blinds/Shades";
            projtTypValues["Wood Shutters"] = "Wood Shutters";
            projtTypValues["Vertical Blinds"] = "Vertical Blinds";
            projtTypValues["Electric Blind/Shade Opener"] = "Electric Blind/Shade Opener";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [typeOfService,projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Addition(s)' ) {
            let typeSerValues = {};
            typeSerValues["Ground level addition"] = "Ground level addition";
            typeSerValues["Second story addition"] = "Second story addition";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            let projtTypValues = {};
            projtTypValues["Design and Build"] = "Design and Build";
            projtTypValues["Build (use existing architectural drawing(s))"] = "Build (use existing architectural drawing(s))";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [typeOfService,projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Windows' ) {
            let projtTypValues = {};
            projtTypValues["Replace Existing Windows"] = "Replace Existing Windows";
            projtTypValues["Repair Existing Window Glass"] = "Repair Existing Window Glass";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Roofing' ) {
            let projtTypValues = {};
            projtTypValues["Repair"] = "Repair";
            projtTypValues["New Install"] = "New Install";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Landscape Design/Installation' ) {
            let projtTypValues = {};
            projtTypValues["Sprinkler System"] = "Sprinkler System";
            projtTypValues["Trees/Shrubs"] = "Trees/Shrubs";
            projtTypValues["Drainage System"] = "Drainage System";
            projtTypValues["Wood Structure(s), Deck(s), Gazebo(s), etc"	] = "Wood Structure(s), Deck(s), Gazebo(s), etc";
            projtTypValues["Concrete Patio/Walkway, etc"] = "Concrete Patio/Walkway, etc";
            projtTypValues["Masonry/Brick/Stone work"] = "Masonry/Brick/Stone work"	;
            projtTypValues["Fencing"] = "Fencing";
            projtTypValues["Retaining wall"] = "Retaining wall";
            projtTypValues["Landscape lighting"] = "Landscape lighting";
            projtTypValues["Pool/Spa"] = "Pool/Spa";
            projtTypValues["Storage Shed"] = "Storage Shed";
            projtTypValues["Built in BBQ"] = "Built in BBQ";
            projtTypValues["Pergola"] = "Pergola";
            projtTypValues["Firepit Gas"] = "Firepit Gas";
            projtTypValues["Firepit Electric"] = "Firepit Electric";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Pool Design/Installation' ) {
            let projtTypValues = {};
            projtTypValues["Refurbish Old"] = "Refurbish Old";
            projtTypValues["Build New"] = "Build New";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Concrete' ) {
            let projtTypValues = {};
            projtTypValues["New"] = "New";
            projtTypValues["Repair"] = "Repair"	;

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Sunroom Patio Enclosure' ) {
            let projtTypValues = {};
            projtTypValues["Enclose existing patio or porch with roof, walls or windows"] = "Enclose existing patio or porch with roof, walls or windows";
            projtTypValues["Build new sunroom or enclosed patio/porch"] = "Build new sunroom or enclosed patio/porch";
            projtTypValues["Screen in existing covered porch/patio"] = "Screen in existing covered porch/patio";
            projtTypValues["Add a metal awning to existing porch/patio"	] = "Add a metal awning to existing porch/patio";
            projtTypValues["Add fabric awning to existing porch/patio"] = "Add fabric awning to existing porch/patio";
            projtTypValues["Repair existing sunroom, porch, patio"] = "Repair existing sunroom, porch, patio";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Landscape Maintenance' ) {
            let typeSerValues = {};
            typeSerValues["Rock"] = "Rock";
            typeSerValues["Grass"] = "Grass";
            typeSerValues["Other"] = "Other";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }
            objectResult = [typeOfService];
        }
        else if( cmp.get('v.appoinmType.name') == 'Landscape Maintenance' ) {
            let typeSerValues = {};
            typeSerValues["Pool"] = "Pool";
            typeSerValues["Spa"] = "Spa";
            typeSerValues["Both"] = "Both";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }
            objectResult = [typeOfService];
        }
        else if( cmp.get('v.appoinmType.name') == 'Electrical' ) {
            let projtTypValues = {};
            projtTypValues["Run new outlets"] = "Run new outlets";
            projtTypValues["Install new lighting"] = "Install new lighting"	;
            projtTypValues["Install electric vehicle charging station"] = "Install electric vehicle charging station";
            projtTypValues["Rewire house"] = "Rewire house";
            projtTypValues["Main panel"] = "Main panel";
            projtTypValues["Service existing electrical"] = "Service existing electrical";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Garage Doors' ) {
            let typeSerValues = {};
            typeSerValues["Other"] = "Other";
            typeSerValues["Roll Up"] = "Roll Up";
            typeSerValues["Vertical"] = "Vertical";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            let projtTypValues = {};
            projtTypValues["New"] = "New";
            projtTypValues["Repair"] = "Repair";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [typeOfService,projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Plumbing' ) {
            let projtTypValues = {};
            projtTypValues["Drains"] = "Drains";
            projtTypValues["Faucets, fixtures, pipes"] = "Faucets, fixtures, pipes";
            projtTypValues["Pumps"] = "Pumps";
            projtTypValues["Septic System, sewers, or water mains"] = "Septic System, sewers, or water mains";
            projtTypValues["Water heater(s)"] = "Water heater(s)";
            projtTypValues["Water Softening and purification"] = "Water Softening and purification";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Solar' ) {
            let projtTypValues = {};
            projtTypValues["Solar"] = "Solar";
            projtTypValues["Energy Efficiencies"] = "Energy Efficiencies";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'HVAC' ) {
            let projtTypValues = {};
            projtTypValues["Service Existing System"] = "Service Existing System";
            projtTypValues["Install new AC System"] = "Install new AC System";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'TV & Internet' ) {
            let typeSerValues = {};
            typeSerValues['Cable'] = 'Cable';
            typeSerValues["Satellite"] = "Satellite";
            typeSerValues["Internet"] = "Internet";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            objectResult = [typeOfService];
        }
        else if( cmp.get('v.appoinmType.name') == 'Locksmith' ) {
            let typeSerValues = {};
            typeSerValues["Other"] = "Other";
            typeSerValues["Deadbolt"] = "Deadbolt";
            typeSerValues["Keyless Entry"] = "Keyless Entry";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }

            let projtTypValues = {};
            projtTypValues["Replace"] = "Replace";
            projtTypValues["Rekey"] = "Rekey";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [typeOfService,projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Pest Control' ) {
            let projtTypValues = {};
            projtTypValues["Pest"] = "Pest";
            projtTypValues["Weed"] = "Weed";
            projtTypValues["Both"] = "Both";

            let projectType = {
                name : 'Project_Type__c',
                result : projtTypValues
            }

            objectResult = [projectType];
        }
        else if( cmp.get('v.appoinmType.name') == 'Carpet/Floor Cleaning' ) {
            let typeSerValues = {};
            typeSerValues["Tile"] = "Tile";
            typeSerValues["Carpet"] = "Carpet";
            typeSerValues["Other"] = "Other";
            typeSerValues["Laminate"] = "Laminate";
            typeSerValues["Wood"] = "Wood";
            typeSerValues["Vinyl"] = "Vinyl";

            let typeOfService = {
                name : 'Type_of_Service__c',
                result : typeSerValues
            }
            
            objectResult = [typeOfService];
        }

        return objectResult;
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
            }
            
            return(validObject);
            
        } 
    }
})