/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Unique webform 
* Description:		class responsible to assign webform to account.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		10/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
global class DiacoAssignRouteZip {
    
    @InvocableMethod(label='Account to Route' description='Account relationship to Route.')
    public static void ConnectWebformAccount(List<param> params) {	
        System.debug('Account to Route');
        System.debug('===========::::::::>>>>');
        //System.debug(params);
        for (param p: params){
            if(String.isEmpty(p.Route)){
                p.Route=null;
            }        
        }
        //List<Account> acct = [select Id,Zip__c,Route__c from Account where Id IN : Ids];
		updateRoute(params);
        return;
    }
  
    global class param {
        @InvocableVariable
        global String Id ;
        @InvocableVariable
        global String Zip;
        @InvocableVariable
        global String Route;
    }
    
    public static String updateRoute(List<param> records){
        List<Account> accounts = new List<Account>();
        List<ZipCode__c> routeId = [select Route__c from ZipCode__c where Name = 'unknown']; 
     	List<ZipCode__c> zipCode = [select Name, Route__c from ZipCode__c];
        System.debug('Activate process Builder #1');
        //System.debug(records[0].Route__c);
        for(param acc : records){
            for(ZipCode__c zip : zipCode){
                if(acc.Zip == zip.Name){
                	acc.Route = zip.Route__c;
                    break;
                }else{
                   acc.Route = null;
                }
            }
            System.debug(acc.Route);
            //System.debug(routeId[0].Route__c +'  |||-------------->>>s');
            if(acc.Route == null &&
              routeId.size()>0){
                acc.Route = routeId[0].Route__c;
            }
            Account ac = new Account(Id = acc.Id);
            if(acc.Route!=null){
                ac.Route__c=acc.Route;
            }            
            accounts.add(ac);
        }
        for(Account ac : accounts){
            System.debug(ac.Id+ ' ------------  ' +ac.Route__c);
        }
        update accounts;
        return 'Good';
    }

}