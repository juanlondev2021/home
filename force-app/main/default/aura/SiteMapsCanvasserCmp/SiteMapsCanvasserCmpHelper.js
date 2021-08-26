({

    
   	getGeoLocation : function(cmp) {
            console.log('>> recordId ' + cmp.get('v.recordId'));

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition((position)=>{
                var lat = position.coords.latitude;
                cmp.set("v.latitude",lat);
                var long = position.coords.longitude;
                cmp.set("v.longitude",long);
                console.log('latitude ' + cmp.get("v.latitude") + ',' + ' latitude' + cmp.get("v.latitude") );
            },(error)=>{
                /*if(error.code == 1) {
                    alert("Error: Access is denied!");
                } else if( error.code == 2) {
                    alert("Error: Position is unavailable!");
                }*/
                this.sendNotification();
            });
        }else {
            console.error('Geo Location is not supported');
            cmp.set('v.ErrorModal',true);
        }
    },
    
    sendNotification : function() {
        try{
            // Comprobamos si el navegador soporta las notificaciones
            if (!("Notification" in window)) {
                //alert("Este navegador no soporta las notificaciones del sistema");
                return;
            }
            
            // Comprobamos si ya nos habían dado permiso
            else if (Notification.permission === "granted") {
                // Si esta correcto lanzamos la notificación
                let notification = new Notification('Request location permissions', {
                    //icon: 'http://cdn.sstatic.net/stackexchange/img/logos/so/so-icon.png',
                    body: 'This website need permission to get location',
                });        
            } // Si no, tendremos que pedir permiso al usuario
                else if (Notification.permission !== 'denied') {
                    Notification.requestPermission(function (permission) {
                        // Si el usuario acepta, lanzamos la notificación
                        if (permission === "granted") {
                            let notification = new Notification('Request location permissions', {
                                //icon: 'http://cdn.sstatic.net/stackexchange/img/logos/so/so-icon.png',
                                body: 'This website need permission to get location',
                            });            
                        }
                    });
                }   
        }catch(error){
            
        }
    },
})