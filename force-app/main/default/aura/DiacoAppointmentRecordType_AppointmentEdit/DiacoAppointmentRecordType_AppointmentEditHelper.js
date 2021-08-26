({
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