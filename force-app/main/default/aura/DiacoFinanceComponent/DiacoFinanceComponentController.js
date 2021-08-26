({
    init : function(component, event, helper) {
        var id = component.get("v.recordId"); 
        helper.getInfoFinanceInHS(component,id);
        helper.getRecordType(component, id);
        helper.thereAreSigned(component, id);
    },
    printParent: function(component, event, helper){
        
        let package_name = component.get("v.att_package_name");              
        let typeOfOrder = component.get("v.att_type_of_order");       
        let selectPackage = component.get("v.item_select");      
        const setStyle = "border: 2px solid #3666BA;";
        console.log( component.get("v.att_package_name"));
        if(package_name === ""){
            
        }else{   
            if(package_name === selectPackage){
                switch(typeOfOrder) {
                    case 'Promotion':
                        component.find(selectPackage).set("v.att_Border_Select_Rent",setStyle);
                        component.find(selectPackage).set("v.att_Border_Select_Buy","");
                       // component.find(package_name).set("v.Checkbox_Deactivate",false);
                        break;
                    case 'Finance':
                        component.find(selectPackage).set("v.att_Border_Select_Rent","");
                        component.find(selectPackage).set("v.att_Border_Select_Buy",setStyle);
                       // component.find(package_name).set("v.Checkbox_Deactivate",true);
                        break;
                    default:
                        alert('Type of order no found');
                        break;                        
                }                       
            }else{
                console.log("HERE IN THIS!");
                component.find(selectPackage).set("v.att_Border_Select_Rent","");
                component.find(selectPackage).set("v.att_Border_Select_Buy","");
                component.find(selectPackage).set("v.Checkbox_Deactivate",true);
                component.find(selectPackage).set("v.Checkbox_value","false");
                component.find(selectPackage).set("v.att_annual",0);
                
            }
        }
    },
    addContent : function(component, event, helper) {
        helper.addContent(component, event);        
    },getRecordType: function(component, event, helper) {
        var Id = component.get("v.recordId");
        helper.getRecordType(component, Id);        
    },ToDocusign: function(component, event, helper) {
        var Id = component.get("v.recordId");
        component.set("v.label",'Sending...'); 
        helper.ToDocusign(component, Id);     
    },closeModel: function(component, event, helper) {
        component.set("v.AlarmEmpty",false); 
    },AlarmToDocusign: function(component, event, helper) {
        var Id = component.get("v.recordId");
        component.set("v.label",'Sending...');
        helper.getAlarmField(component,Id);    
    }
})