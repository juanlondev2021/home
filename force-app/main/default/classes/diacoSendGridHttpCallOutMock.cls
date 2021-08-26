@isTest
global class diacoSendGridHttpCallOutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        if(req.getEndpoint() =='https://api.neverbounce.com/v4/jobs/create'){
            body = '{'+
                '"new_count": 2,'+
                '"updated_count": 0,'+
                '"error_count": 0,'+
                '"error_indices": [],'+
                '"unmodified_indices": [],'+
                '"persisted_recipients": ['+
                '"ZXNuYXlkZXJtb3JhbGVzMjVAZ21haWwuY29t",'+
                '"ZXNuYXlkZXJtb3JhbGVzMjU1QGdtYWlsLmNvbQ=="'+
                '],'+
                '"errors": []'+
                '}'; 
        }else if(req.getEndpoint() == 'https://api.neverbounce.com/v4/single/check?key=Apikey******&email=test@test.com'){
            
            body = '{'+
                '"status": "success",'+
                '"result": "valid",'+
                '"flags": ['+
                '"has_dns",'+
                '"has_dns_mx"'+
                '],'+
                '"suggested_correction": "",'+
                '"execution_time": 499'+
                '}';
        }
        else{
            body = '{'+
                '"recipient_count": 1992,'+
                '"recipients": ['+
    '{'+
      '"id": "Y3IzMjU1OEBnbWFpbC5jb20=",'+
      '"email": "cr32558@gmail.com",'+
      '"created_at": 1556838796,'+
      '"updated_at": 1556838796,'+
      '"last_emailed": null,'+
      '"last_clicked": null,'+
      '"last_opened": null,'+
      '"first_name": "Catalina",'+
      '"last_name": "Ruiz",'+
      '"custom_fields": ['+
        '{'+
          '"id": 44204523,'+
          '"name": "Id_Account",'+
          '"type": "text",'+
          '"value": "0014100001NT65RAAT"'+
        '},'+
        '{'+
          '"id": 44293703,'+
          '"name": "Id_HS",'+
          '"type": "text",'+
          '"value": null'+
        '}'+
      ']'+
    '},'+
    '{'+
      '"id": "ZGF2aWQubGVnZXJlMUBnbWFpbC5jb20=",'+
      '"email": "david.legere1@gmail.com",'+
      '"created_at": 1556838796,'+
      '"updated_at": 1556838796,'+
      '"last_emailed": null,'+
      '"last_clicked": null,'+
      '"last_opened": null,'+
      '"first_name": "David",'+
      '"last_name": "Legere",'+
      '"custom_fields": ['+
        '{'+
          '"id": 44204523,'+
          '"name": "Id_Account",'+
          '"type": "text",'+
          '"value": "0014100001Nzvp2AAB"'+
        '},'+
        '{'+
          '"id": 44293703,'+
          '"name": "Id_HS",'+
          '"type": "text",'+
          '"value": null'+
        '}'+
      ']'+
    '},'+
    '{'+
      '"id": "c2phbW1lckBtc24uY29t",'+
      '"email": "sjammer@msn.com",'+
      '"created_at": 1556838796,'+
      '"updated_at": 1556838796,'+
      '"last_emailed": null,'+
      '"last_clicked": null,'+
      '"last_opened": null,'+
      '"first_name": "Roger",'+
      '"last_name": "Jammer",'+
      '"custom_fields": ['+
        '{'+
          '"id": 44204523,'+
          '"name": "Id_Account",'+
          '"type": "text",'+
          '"value": "0014100001NzvpLAAR"'+
        '},'+
        '{'+
          '"id": 44293703,'+
          '"name": "Id_HS",'+
          '"type": "text",'+
          '"value": null'+
        '}'+
      ']'+
    '}'+
  ']'+
                '}';
        }
        
        System.debug('endpoint : '+req.getEndpoint());
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        //response.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        response.setStatusCode(200);
        return response;
    }
    
}