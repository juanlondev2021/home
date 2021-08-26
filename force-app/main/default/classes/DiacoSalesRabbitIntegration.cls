/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible to do the requests to salesrabbit web service.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		07/08/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/

public class DiacoSalesRabbitIntegration {
    
    /**
*
* Method responsible of call createLeads function in the trigger to do the request to Salesrabbit web service.
*
* @param info, info contain all information needed to send to SR.
*
*/
    
    @future(callout=true)
    public static void createLeadSR(String token, String body, String uaddId){
        try{
            //making a request to salesrabbit web service
            HttpResponse responseFsR =  DiacoSalesRabbitIntegration.createLeads(token, body);
            //we convert the response to responsesFromSalesRabbit class to understand it better
            responsesFromSalesRabbit newLead = DiacoSalesRabbitIntegration.newLeadData(responseFsR);
            //we  looking for the user address to update
            User_Address__c User_Add = [select Id, name from User_Address__c where Id =:uaddId];
            salesRabbitSchedule__c salesRabbitSchedule = new salesRabbitSchedule__c();
            //we looking for the setting
            List<salesRabbitSchedule__c> settingList = new List<salesRabbitSchedule__c>();
            settingList = [select Id, deleteAfter__c from salesRabbitSchedule__c];
            salesRabbitSchedule = settingList[0];
            //we put the changes in the user address to update
            User_Add.sales_rabbit_leadId__c = String.valueOf(newLead.data.id);
            User_Add.creationDate__c = Date.today();
            User_Add.deletionDate__c = Date.today().addDays(Integer.valueOf(salesRabbitSchedule.deleteAfter__c));
            TriggerHandler.bypass('');
            update User_Add;
            TriggerHandler.clearBypass('');
        }catch(exception e){
            system.debug(e);
        }
    }
    
    /**
*
* this function is executed time to time by the schedule class, 
* is responsible for making salesrabbit requests to obtain each 
* lead with the modified  status to create a Task for each lead 
* with the modified  status.
*
* @param token, is the token of the org in salesrabbit
* @param ifModifiedSince, is the date of today
*
*/
    
    @future(callout=true)
    public static void allLeadsSR(String token, date ifModifiedSince){
        try{
            List<User_Address__c> ListToUpdate = new List<User_Address__c>();
            List<Task> Tasks = new List<Task>();
            HttpResponse allLeads = DiacoSalesRabbitIntegration.allLeads(token, ifModifiedSince);
            responseToUpdates rtu = DiacoSalesRabbitIntegration.leadsToUpdate(allLeads);
            List<salesRabbitSchedule__c> settingList = [select Id, 
                                                        quantityDayOrHour__c, 
                                                        options__c, 
                                                        last_update__c,
                                                        knockCounter__c
                                                        from salesRabbitSchedule__c];
            salesRabbitSchedule__c salesRabbitSchedule = settingList[0]; 
            
            
            if(rtu.data != null){
                try{
                    List<User_Address__c> User_Add = [select Id, name, status__c, UserAccount__c, sales_rabbit_leadId__c, 
                                                      CreatedById, knock_counter__c 
                                                      from User_Address__c 
                                                      where knock_counter__c < :salesRabbitSchedule.knockCounter__c AND sales_rabbit_leadId__c != null ];
                    for(User_Address__c  userAddrs : User_Add){
                        system.debug('userAddrs : '+userAddrs);
                        for(datas  userAdrs : rtu.data){
                            if(userAddrs.sales_rabbit_leadId__c == String.valueOf(userAdrs.id) && userAddrs.status__c != userAdrs.status){
                                userAddrs.status__c = userAdrs.status;
                                userAddrs.knock_counter__c += 1;
                                if(userAddrs.knock_counter__c < salesRabbitSchedule.knockCounter__c){
                                    Tasks.add(DiacoSalesRabbitIntegration.Tasks(userAdrs, userAddrs));
                                }else{
                                    DiacoSalesRabbitIntegration.deleteLead(token, userAdrs.id); 
                                }
                                ListToUpdate.add(userAddrs);
                            }
                        } 
                    }
                    update ListToUpdate;
                    insert Tasks;
                }catch(System.LimitException e){
                    system.debug('System.LimitException : '+ e);
                }
                
            }
        }catch(exception ex){
            
        }
        
    }
    
    
    /**
*
* Method responsible to return a task.
*
* @param dtAttributes, task Attributes.
* @param useMap, task Attributes
*
* @return a task.
*/
    public static Task Tasks(datas user, User_Address__c useMap ){
        Personnel__c per = [select Id,salesRabbitUserId__c from Personnel__c where salesRabbitUserId__c = :user.userId limit 1];
        return new Task(
            Status = 'Completed',
            Subject ='Door Knock (SalesRabbit)',
            Priority = 'Low',
            SalesRabbit_Status__c = ''+user.status,
            Call_Notes__c = 'Status: '+user.status+'\n\n'+
            'Client: '+user.firstName +' '+ user.lastName +'\n'+
            user.street1+'\n'+user.city +', '+user.state+', '+user.zip +'\n\n'+
            'Notes: '+ user.notes+'\n'+
            'User: '+user.userName+'\n'+
            'SalesRabbitID: '+user.userId,
            WhatId = useMap.UserAccount__c,
            OwnerId = useMap.CreatedById,
            Date_Time__c = dateStmap(user.dateModified),
            assignedPersonnel__c = per.Id
        );
    }
    /**
*
* Method responsible to create a lead in salesrabbit web service.
*
* @param info, info contain all information needed to send to SR.
*
* @return a response from salesrabbit web service.
*/
    public static HttpResponse createLeads(String token, String body) {
        String endpoint = 'https://api.salesrabbit.com/leads';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
        }
        return response;
    }
    
    
    
    /**
*
* Method responsible to get all salesrabbit leads.
*
* @param token, token required to do request to salesrabbit web service.
* @param ifModifiedSince, token required to do request to salesrabbit web service.
*
* @return a response from salesrabbit web service with all leads in salesrabbit.
*/
    public static HttpResponse allLeads(String token, date ifModifiedSince){
        String endpoint = 'https://api.salesrabbit.com/leads?sortBy=dateCreated&order=asc';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json');
        if(ifModifiedSince != null){
            request.setHeader('if-modified-since', ifModifiedSince.year()+'-'+ifModifiedSince.month()+'-'+ifModifiedSince.day() );
        }
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
        }
        return response;
    }
    
    
    /**
*
* Method responsible to delete a lead from salesrabbit by id.
*
* @param token, token required to do request to salesrabbit web service.
* @param leadId, id required to get the lead and delete it.
*
* @return a response from salesrabbit web service to confirm the lead has been deleted.
*/
    public static HttpResponse deleteLead(String token, Integer leadId){
        String endpoint = 'https://api.salesrabbit.com/leads/'+leadId;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('DELETE');
        request.setHeader('Authorization', 'Bearer ' + token);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 204) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
        }
        return response;
    }
    
    /**
*
* Method responsible to convert a string in a object date.
*
* @param datet, date received in the json.
*
* @return a date.
*/
    public static DateTime dateStmap(String datet){
        
        String[] datesplt = datet.split('T');
        String[] datecomplete = datesplt[0].split('-');
        String[] datesplit = datesplt[1].split('\\+');
        String[] hourComplete = datesplit[0].split(':');
        DateTime myDateTime = DateTime.newInstance(
            Integer.valueOf(datecomplete[0]), 
            Integer.valueOf(datecomplete[1]), 
            Integer.valueOf(datecomplete[2]), 
            Integer.valueOf(hourComplete[0]), 
            Integer.valueOf(hourComplete[1]),
            Integer.valueOf(hourComplete[2])
        );
        return myDateTime;
    }
    
    /**
*
* Method responsible for returning the values required from the json response from a new lead.
*
* @param responseFsR, json response from salesrabbit after creating a new lead 
*
* @return a object of type response with  the values required from a json received.
*/
    public static responsesFromSalesRabbit newLeadData(HttpResponse responseFsR){
        responsesFromSalesRabbit newLeadData = (responsesFromSalesRabbit)JSON.deserialize(responseFsR.getBody(), responsesFromSalesRabbit.class);
        return newLeadData;
    }
    /**
*
* Method responsible for returning all lead updates to update user address status in salesforce.
*
* @param responseFsR, json response from salesrabbit with all updated leads  
*
* @return a object of type response with  the values required from a json received.
*/
    public static responseToUpdates leadsToUpdate(HttpResponse responseFsR){
        
        responseToUpdates newLeadsData = (responseToUpdates)JSON.deserialize(responseFsR.getBody(), responseToUpdates.class);
        return newLeadsData;
        
    }
}