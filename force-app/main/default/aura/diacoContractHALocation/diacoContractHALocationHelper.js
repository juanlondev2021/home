({
	 getDataCustomer : function(component, recordId) {
         // la variable action toma una funcion del controlador del lado del servidor y la almacena para si.
         // 
        var action = component.get("c.getDataLocationAndPayments");
         //esa funcionsn tomada se comprta como una variable. por ende tiene parametros o atributos.
         //estos deben ser colocados  en el mismo orden y con el mismo nombre con el que se colocaron en la funcion 
         //// en el servidor.
        action.setParams({
            //parametros en la funcion del lado del servidor.
            "RecordId": recordId,
        });
         //setCallBack ejecuta esa funcion y retorna una repsuesta, la cual puede ser vacioa o retornar algun valor dependiendo de
         //como la definamos en el controlador del lado del servidor.
        action.setCallback(this, function(response){
            //esta retorna un estado luego de ser ejecutada
            var state = response.getState();
            //y si su estado es success(exitoso) entonces procedemos a  asignar los valores que necesitamos
            ////en las variables pertinentes.a
             if (state === "SUCCESS") {
                 //por ejemplo el atributo v.customerse le esta asignando el valor de la respuesta recibida de 
                 //nuestra peticion hecha al servidor
                 //
                 //response.getReturnValue() = a la respuesta recibida de nuestra peticion.
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
            }
            
        });
        $A.enqueueAction(action);
    },
    saveInformation: function(component,HomeService, customer){ //tener en cuenta el orden de como se llaman las funciones
        //saveHomeOwner(Home_Services__c HomeService, Account account) // esta funcion se busca en el apxc(base) porque tiene la funcion
        // de guardar los datos de la cuenta y de la fecha(Home_Services)
        var action = component.get("c.saveHomeOwner"); //aca se llama  esa misma funcion saveHomeOwner para pasarla por parametro
        action.setParams({
            "HomeService":HomeService,  //aca se agg la variable de HomeServices y tener en cuenta el orden en que se llaman
            "account": customer
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Home_Services",response.getReturnValue()); //aca se coloca Home_services esta guarda los datos de la fecha y de la cuenta
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This records was saved successfully", //msj en pantalla 
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    getDataHomeService : function(component, recordId) {      //esta funcion fue reutilizada de la funcion que InstallationDate 
        													  //Solo se copia la funcion donde se esta llamando el componente de la vista este caso seria  getInstallationDate
        													  //solo que le cambie el nombre( getDataHomeService )porque no puede tener los mismos nombres las funciones
        var action = component.get("c.getInstallationDate");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Home_Services",response.getReturnValue());
                component.set('v._label', 'Saved');
                var homeService = component.get("v.Home_Services");
                
            }
        });
        $A.enqueueAction(action);
    },
})