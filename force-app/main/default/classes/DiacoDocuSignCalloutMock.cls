/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Docusign Integration
* Description:		Class responsible for serving to give fake responses
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/01/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
global class DiacoDocuSignCalloutMock implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String body = '';
        if(req.getMethod() == 'POST'){
            body  ='{'+
                '"access_token" : "eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQgAAAABAAUABwAADvZluT7WSAgAAE4ZdPw-1kgCAL15SVJFKo1Ji9BUFTGtZ-4VAAEAAAAYAAEAAAAFAAAADQAkAAAAMjA4NmZiYTUtZDlmNC00NmU5LTgzYzgtMDk3Nzg0ZjA5NzQ0MACAxyUbtD7WSA.kHbqoRTaWLhy2NyUXZI4bzxT_PUhR5SAvaoQB_2s444SAonCrt526xGe5Ijtd3h4G99d2sPBijMAR8-Fmf7FkQx5eFh4rAv--GA-qjn9z15nWQSqCUYgC9ETMsS-NbdgTUWoC6Of-TZlL3w_d3ug3cpZip12etfjx_i_beG9Wgcy24D7fZ6HewGLiHIiEiIDmJh1YFwtfjARjfta24wWDBR3zuMcunLWC_n8aY2rUExplPSD9h_1Fd5UcpNdqDZex5xgrVsBE34RFWuo3-CPWwaxIoX3QY2O0v2DeqxlEKvRQWaWf2RFCtRd16F1v22X0WRROiLL1NHxYf5mC0oJvA",'+
                '"token_type"  : "Bearer",'+
                '"refresh_token": "eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQgAAAABAAgABwAADvZluT7WSAgAAI5aXkxW1kgCAL15SVJFKo1Ji9BUFTGtZ-4VAAEAAAAYAAEAAAAFAAAADQAkAAAAMjA4NmZiYTUtZDlmNC00NmU5LTgzYzgtMDk3Nzg0ZjA5NzQ0MACAxyUbtD7WSA.JRB8ZFsEEnwLm9IhObPecs74ebrb41KMbMYK3ay4Si1snUzqIVo4LrdWrAE413_EAoYVgddzV2KnQG76BH_s-6WS7_ENMTXI9PcDbBGAwVhkHXA5dokp5Y8bJbzTfN3V9BhKBbFld8UvQ9VxHrqjcHVR92aL0rqarS_zmWckzADbQGK_UL2FjqJ0WWLjozZSqGRqABFHrT5qlCFOXkXvyghRbcBTO94N-QocCeWSAKp9obaeShma5_EXROIqfr9cf5HGCmnsqBWj1aeXP6U_velLEs0jS3MNCF9PZjeGOfFbRvlWsVfCehuPaOFHunJpclwrhg4agOIw_M1XqG8amg",'+
                '"expires_in" : 28800'+
                '}';
            
        }else if(req.getMethod() == 'GET'){                                                          
            if(req.getEndpoint() == 'https://na3.docusign.net/restapi/v2/accounts/1234567/envelopes/7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155'){
                body  = '{'+
                            '"status": "completed",'+
                            '"documentsUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/documents",'+
                            '"recipientsUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/recipients",'+
                            '"attachmentsUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/attachments",'+
                            '"envelopeUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db",'+
                            '"emailSubject": "Please Sign this Contract",'+
                            '"emailBlurb": "This is my new eSignature service, it allows me to get your signoff without having to fax, scan, retype, refile and wait forever",'+
                            '"envelopeId": "7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155",'+
                            '"customFieldsUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/custom_fields",'+
                            '"autoNavigation": "true","envelopeIdStamping": "true","notificationUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/notification","enableWetSign": "true",'+
                            '"allowMarkup": "false","allowReassign": "true","createdDateTime": "2018-10-30T03:37:34.7030000Z","lastModifiedDateTime": "2018-10-30T03:37:34.7030000Z",'+
                            '"deliveredDateTime": "2018-10-30T03:37:54.3070000Z","initialSentDateTime": "2018-10-30T03:37:35.6270000Z","sentDateTime": "2018-10-30T03:37:35.6270000Z",'+
                            '"completedDateTime": "2018-10-30T03:38:22.5730000Z","statusChangedDateTime": "2018-10-30T03:38:22.5730000Z","documentsCombinedUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/documents/combined",'+
                            '"certificateUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/documents/certificate","templatesUri": "/envelopes/de3cb7dc-1e51-4d3a-89b8-2770946574db/templates",'+
                            '"purgeState": "unpurged", "is21CFRPart11": "false","signerCanSignOnMobile": "true","isSignatureProviderEnvelope": "false","allowViewHistory": "true"'+
                        '}';
            }else{
                body  = 'PDF BODY';  
            }
        }
        res.setStatusCode(200);
        res.setBody(body);
        System.debug('body : '+res.getBody());
        return res;
    }
    
}