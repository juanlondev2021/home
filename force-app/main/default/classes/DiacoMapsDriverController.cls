/**
 *
 * Diaco
 * Project: Maps Delivery     
 * Description: Lightning In
 * Apex class: DiacoMapsDriverControllerTest
 * Changes (Version)
 * _________________________________________
 *
 *          No.     Date            Author                  Description
 *          ____    __________      __________________      _____________________________________
 * @version 1.0     25/01/2020      Jull Quintero Daza      Initial implementation  of the class.
 */
public with sharing class DiacoMapsDriverController {
    
    /**
   *@Description
   * This method is responsible to get Picklist value hung Satatus and Delivery Record
   * 
   * This method is used in:
   * DiacoMapsDriverCmp.cmp
   * 
   * @param recordId (Id)
   * @return WrappedResponse
   **/
       @AuraEnabled
       public static WrappedResponse getData(Id recordId, Boolean mode) {
           WrappedResponse response = new WrappedResponse();
           Delivery_Object__c[] deliveries = [SELECT Id, Hung_Status__c, Hung_DateTieme__c FROM Delivery_Object__c WHERE Id = :recordId];
           if( !deliveries.isEmpty() ) {
               maps__Waypoint__c[] waypoints = [Select Id,maps__Route__c,maps__Route__r.maps__Date__c, Hung_Status__c,maps__Route__r.Start__c,maps__Route__r.Stop__c from maps__Waypoint__c where Delivery_Object__c=:deliveries[0].id ORDER BY CreatedDate DESC limit 1];
               if (waypoints.isEmpty()){
                   response.success = false; response.message = 'Could not find Waypoint, Contact your admin.'; return response;
               }else if(waypoints[0].maps__Route__r.maps__Date__c!= Date.today()){
                   response.success = false; response.message = 'This route isn\'t available for today, Contact your admin.'; return response;
               }else if(!String.isEmpty(waypoints[0].Hung_Status__c) && mode){
                   response.success = false; response.message = 'You have already made this delivery, you cannot update again, please contact your administrator.'; return response;
               }
               if(!mode){
                   response.Waypoint = waypoints[0];
                   response.success = true; return response;
               }else if(waypoints[0].maps__Route__r.Start__c==null){
                   response.success = false; response.message = 'This route has not started yet, please start it to update delivery.'; return response;
               }else if(waypoints[0].maps__Route__r.Stop__c!=null){
                   response.success = false; response.message = 'This route was closed, Contact your admin.'; return response;
               }
               response.waypoint = waypoints[0];
               response.waypoint.Checking__c = DateTime.now();
               response.success = true;
               response.delivery = deliveries[0];
               List<Map<String, String>> picklist_values = diacoKnifeFunc.getPicklistValues('Delivery_Object__c', new list<String>{'Hung_Status__c'});
               response.picklist_values = picklist_values;
               return response;
           }
           response.success = false; response.message = 'Could not find delivery'; return response;
       }
       
       /**
   *@Description
   * This method is responsible to Update Delivery
   * 
   * This method is used in:
   * DiacoMapsDriverCmp.cmp
   * 
   * @param Delivery (Delivery_Object__c)
   **/
       //checkout here
       @AuraEnabled
       public static WrappedResponse setDelivery(Delivery_Object__c delivery, maps__Waypoint__c waypoint) {
           WrappedResponse response = new WrappedResponse();
           List<sObject> result = new List<sObject>();
           try {
               waypoint.Hung_Status__c=delivery.Hung_Status__c;
               waypoint.Checkout__c = DateTime.now();
               //delivery.Hung_DateTieme__c = DateTime.now();
               delivery.Delivery_Date__c = DateTime.now();
               result.add(delivery);
               result.add(waypoint);
               List<maps__Route__c> route = new List<maps__Route__c>();
               route.add([Select Start__c,Stop__c from maps__Route__c where Id=:waypoint.maps__Route__c limit 1]);
               if(route[0].Start__c==null){
                   response.success = false; response.message = 'This route has not started yet, please start it to update delivery.'; return response;
               }else if(route[0].Stop__c!=null){
                   response.success = false; response.message = 'This route was closed, Contact your admin.'; return response;
               }
               update result;
               response.delivery = delivery;
               response.success = true;
           }catch(DmlException e) {
               response.success = false; response.message = e.getMessage();
           }       
           return response;        
       }
   
       @AuraEnabled
       public static WrappedResponse updateRoute(Boolean mode, Id recordId){
           WrappedResponse response = new WrappedResponse();
           try{
               maps__Route__c route = new maps__Route__c(Id=recordId);
               if(mode){
                   route.Start__c=DateTime.now();
                   response.message = 'Route started successfully.';
               }else{
                  route.Stop__c=DateTime.now();
                  response.message = 'Route stopped successfully.';
               }
               update route;            
               response.success = true;
           }catch(DmlException e){
               response.success = false; response.message = e.getMessage();
           }
           return response;
       }
       
       
       public class WrappedResponse {
           @AuraEnabled
           public Delivery_Object__c delivery {get;set;}
           @AuraEnabled 
           public maps__Waypoint__c Waypoint {get;set;}
           @AuraEnabled
           public List<Map<String, String>> picklist_values{get;set;}
           @AuraEnabled
           public Boolean success{get;set;}
           @AuraEnabled
           public String message{get;set;}
       }
   }