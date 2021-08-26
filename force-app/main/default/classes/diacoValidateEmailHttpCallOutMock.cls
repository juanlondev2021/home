@isTest
global class diacoValidateEmailHttpCallOutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        
        if(req.getEndpoint() =='https://api.neverbounce.com/v4/jobs/status?key=Apikey******&job_id=277461'){
            body = '{'+
                '"status": "success",'+
                '"id": 277461,'+
                '"filename": "Created from Array.csv",'+
                '"created_at": "2017-07-25 14:52:27",'+
                '"started_at": "2017-07-25 14:52:40",'+
                '"finished_at": "2017-07-25 14:53:06",'+
                '"total": {'+
                '"records": 2,'+
                '"billable": 2,'+
                '"processed": 2,'+
                '"valid": 0,'+
                '"invalid": 2,'+
                '"catchall": 0,'+
                '"disposable": 0,'+
                '"unknown": 0,'+
                '"duplicates": 0,'+
                '"bad_syntax": 0'+
                '},'+
                ' "bounce_estimate": 0,'+
                ' "percent_complete": 100,'+
                '"job_status": "complete",'+
                '"execution_time": 322'+
                '}'; 
        }
        else if(req.getEndpoint() == 'https://api.neverbounce.com/v4/jobs/results?key=Apikey******&job_id=277461'){
            body = '{'+
                '"status": "success",'+
                '"total_results": 3,'+
                '"total_pages": 1,'+
                '"query": {'+
                '"job_id": 2728676,'+
                '"valids": 1,'+
                '"invalids": 1,'+
                '"disposables": 1,'+
                '"catchalls": 1,'+
                '"unknowns": 1,'+
                '"page": 0,'+
                '"items_per_page": 10'+
                '},'+
                '"results": ['+
                '{'+
                '"data": {'+
                '"email": "rdemarbiex1@msn.com",'+
                '"id": "0014100001yH9ugAAC"'+
                '},'+
                '"verification": {'+
                '"result": "valid",'+
                '"flags": ['+
                '"free_email_host",'+
                '"has_dns",'+
                '"has_dns_mx",'+
                '"smtp_connectable"'+
                '],'+
                '"suggested_correction": "",'+
                '"address_info": {'+
                '"original_email": "rdemarbiex1@msn.com",'+
                '"normalized_email": "rdemarbiex1@msn.com",'+
                '"addr": "rdemarbiex1",'+
                '"alias": "",'+
                '"host": "msn.com",'+
                '"fqdn": "msn.com",'+
                '"domain": "msn",'+
                '"subdomain": "",'+
                '"tld": "com"'+
                '}'+
                '}'+
                '},'+
                '{'+
                '"data": {'+
                '"email": "email@email.com",'+
                '"id": "0014100001zC4iFAAS"'+
                '},'+
                '"verification": {'+
                '"result": "invalid",'+
                '"flags": ['+
                '"free_email_host",'+
                '"role_account",'+
                '"has_dns",'+
                '"has_dns_mx",'+
                '"smtp_connectable"'+
                '],'+
                '"suggested_correction": "",'+
                '"address_info": {'+
                '"original_email": "email@email.com",'+
                '"normalized_email": "email@email.com",'+
                '"addr": "email",'+
                '"alias": "",'+
                '"host": "email.com",'+
                '"fqdn": "email.com",'+
                '"domain": "email",'+
                '"subdomain": "",'+
                '"tld": "com"'+
                '}'+
                '}'+
                '},'+
                '{'+
                '"data": {'+
                '"email": "alucero@protectionsource.com",'+
                '"id": "0014100001zCVslAAG"'+
                '},'+
                '"verification": {'+
                '"result": "valid",'+
                '"flags": ['+
                '"has_dns",'+
                '"has_dns_mx",'+
                '"smtp_connectable"'+
                '],'+
                '"suggested_correction": "",'+
                '"address_info": {'+
                '"original_email": "alucero@protectionsource.com",'+
                '"normalized_email": "alucero@protectionsource.com",'+
                '"addr": "alucero",'+
                '"alias": "",'+
                '"host": "protectionsource.com",'+
                '"fqdn": "protectionsource.com",'+
                '"domain": "protectionsource",'+
                '"subdomain": "",'+
                '"tld": "com"'+
                '}'+
                '}'+
                '}'+
                '],'+
                '"execution_time": 20'+
                '}';
        }
        else if(req.getEndpoint() == 'https://api.neverbounce.com/v4/jobs/results?key=Apikey******&job_id=277461&page=1&items_per_page=10'){
            body = '{'+
                '"status": "success",'+
                '"total_results": 3,'+
                '"total_pages": 1,'+
                '"query": {'+
                '"job_id": 2728676,'+
                '"valids": 1,'+
                '"invalids": 1,'+
                '"disposables": 1,'+
                '"catchalls": 1,'+
                '"unknowns": 1,'+
                '"page": 0,'+
                '"items_per_page": 10'+
                '},'+
                '"results": ['+
                '{'+
                '"data": {'+
                '"email": "rdemarbiex1@msn.com",'+
                '"id": "0014100001yH9ugAAC"'+
                '},'+
                '"verification": {'+
                '"result": "valid",'+
                '"flags": ['+
                '"free_email_host",'+
                '"has_dns",'+
                '"has_dns_mx",'+
                '"smtp_connectable"'+
                '],'+
                '"suggested_correction": "",'+
                '"address_info": {'+
                '"original_email": "rdemarbiex1@msn.com",'+
                '"normalized_email": "rdemarbiex1@msn.com",'+
                '"addr": "rdemarbiex1",'+
                '"alias": "",'+
                '"host": "msn.com",'+
                '"fqdn": "msn.com",'+
                '"domain": "msn",'+
                '"subdomain": "",'+
                '"tld": "com"'+
                '}'+
                '}'+
                '},'+
                '{'+
                '"data": {'+
                '"email": "email@email.com",'+
                '"id": "0014100001zC4iFAAS"'+
                '},'+
                '"verification": {'+
                '"result": "invalid",'+
                '"flags": ['+
                '"free_email_host",'+
                '"role_account",'+
                '"has_dns",'+
                '"has_dns_mx",'+
                '"smtp_connectable"'+
                '],'+
                '"suggested_correction": "",'+
                '"address_info": {'+
                '"original_email": "email@email.com",'+
                '"normalized_email": "email@email.com",'+
                '"addr": "email",'+
                '"alias": "",'+
                '"host": "email.com",'+
                '"fqdn": "email.com",'+
                '"domain": "email",'+
                '"subdomain": "",'+
                '"tld": "com"'+
                '}'+
                '}'+
                '},'+
                '{'+
                '"data": {'+
                '"email": "alucero@protectionsource.com",'+
                '"id": "0014100001zCVslAAG"'+
                '},'+
                '"verification": {'+
                '"result": "valid",'+
                '"flags": ['+
                '"has_dns",'+
                '"has_dns_mx",'+
                '"smtp_connectable"'+
                '],'+
                '"suggested_correction": "",'+
                '"address_info": {'+
                '"original_email": "alucero@protectionsource.com",'+
                '"normalized_email": "alucero@protectionsource.com",'+
                '"addr": "alucero",'+
                '"alias": "",'+
                '"host": "protectionsource.com",'+
                '"fqdn": "protectionsource.com",'+
                '"domain": "protectionsource",'+
                '"subdomain": "",'+
                '"tld": "com"'+
                '}'+
                '}'+
                '}'+
                '],'+
                '"execution_time": 20'+
                '}';
        }
        else if(req.getEndpoint() == 'https://api.neverbounce.com/v4/single/check?key=Apikey******&email=test@test.com'){
            
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
		else if(req.getEndpoint() == 'https://api.neverbounce.com/v4/jobs/create'){
            body = '{"status": "success","job_id": 277461,"execution_time": 712}';
        }        
        System.debug('endpoint : '+req.getEndpoint());
        system.debug(body);
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }
}