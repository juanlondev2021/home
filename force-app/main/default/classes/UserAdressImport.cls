/**
 * @description       : Class responsible to assign address to useraddress
 * @author            : Esnayder Morales
 * @group             : 
 * @last modified on  : 10-11-2020
 * @last modified by  : Esnayder Morales
 * @TestClass 		  : UserAdressImportTest
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-24-2020   Esnayder Morales   Initial Version
**/

public class UserAdressImport {
    
    public static void execute(List<User_Address__c> users, Boolean isInsert){
        if(isInsert){
            Address adds = getZip(users);
            System.debug('Zip');
            System.debug(adds);
            if(adds.uniqueKey.size()>0){
                   Map<String, String> addressAccount = getAdress(adds);
                   System.debug(addressAccount);
                   for(User_Address__c user : users){
                       if(user.UserAccount__c != null){
                           	System.debug(addressAccount.get(user.UserAccount__c));
                              user.Address__c = addressAccount.get(user.UserAccount__c);
                          }
                   }
                   
               }
        }
    }
    
    
    public static Map<String, String> getAdress(address request){
        Map<String, Address__c> adresss_map = new Map<String, Address__c>();
        Map<String, String> AccountsMap = new Map<String,String>();
        List<Address__c> address = [select Id, Zip_Code__c, Street__c 
                                    from Address__c where Unique_Key__c in:request.uniqueKey];
        for(Address__c ad : address){
            adresss_map.put(ad.Zip_Code__c+'-'+ad.Street__c, ad);
        }
        System.debug(adresss_map);
        for(Account acc : request.accounts){
            
            if(acc.Street__c != null && acc.Zip__c !=null){
                System.debug(adresss_map.get(acc.Zip__c+'-'+acc.Street__c));
                if(adresss_map.get(acc.Zip__c+'-'+acc.Street__c)!=null){
                    AccountsMap.put(acc.Id, adresss_map.get(acc.Zip__c+'-'+acc.Street__c).Id);
                }
            	
            }
        }
        return AccountsMap;
    }
    
    public static List<String> getAccountAddress(List<User_Address__c> users){
        List<String> result = new List<String>();
        for(User_Address__c user : users){
            if(user.UserAccount__c != null){
                result.add(user.UserAccount__c);
            }
        }
        return result;
    }
    
    public static Address getZip(List<User_Address__c> users){
        Address adds = new Address();
        adds.uniqueKey = new List<String>();
        adds.accounts = new List<Account>();
        List<String> IDs = getAccountAddress(users);
        if(!IDs.isEmpty()){
           	List<Account> accounts = [select Zip__c, Street__c from Account where Id in :IDs];
            adds.accounts = accounts;
            for(Account acc : accounts){
                System.debug(acc);
                if(acc.Street__c != null
                   && acc.Zip__c !=null){
                       adds.uniqueKey.add(acc.Street__c+':'+acc.Zip__c);
                   }
            } 
        }
        return adds;
    }
    
    private class Address {
        public List<String> uniqueKey {get;set;}
        public List<Account> accounts {get; set;} 
    }
}