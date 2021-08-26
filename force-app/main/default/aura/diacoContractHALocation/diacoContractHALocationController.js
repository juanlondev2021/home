({
	doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        helper.getDataCustomer(component, recordId);
        helper.getDataHomeService(component, recordId); //esta funcion se encarga de llamar del lado del helper el getDataHomeService que se encarga de guardar la info o traer los dato de la fecha 
    },
    saveInformation: function(component, event, helper) {
        var customer = component.get("v.customer");  //aca se le pasa por parametro la funcion customer que es la que se encarga de los datos de la cuenta de los estados 
        var Home_Services = component.get("v.Home_Services"); // se le agg esta variable de home_services para que guarde los dato de la Fecha
        helper.saveInformation(component, Home_Services, customer); // tener encuenta el orden para llamar las funciones (como esta en el helper)
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');  // esta etiqueta se encarga de realizar el cambio visual cuando se van a guardar los datos (save) y cuando ya se guardan que sale (saved)

    },
})