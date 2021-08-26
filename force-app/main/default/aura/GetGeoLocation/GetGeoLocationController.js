({
    doInit : function(component, event, helper) {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(success);
            function success(position) {
                var lat = position.coords.latitude;
                component.set("v.latitude",lat);
                var long = position.coords.longitude;
                component.set("v.longitude",long);
            }
        } else {
            error('Geo Location is not supported');
        }
        
    }
})