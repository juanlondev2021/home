@isTest 
public class UpdateDeliveryTest 
{
    static testMethod void testMethod1() 
    {
        Address__c currAddress = new Address__c();
        currAddress.Name	= 'Test';
        Account currAccount = new Account();
        currAccount.name = 'Test';
        try{
        	insert currAddress;  
            Insert currAccount;
        }Catch(Exception ex){
            
        }
        List<User_Address__c> userAddressList = new List<User_Address__c>();
        for(Integer i=0 ;i <200;i++)
        {
            User_Address__c userAddress = new User_Address__c();
            userAddress.Address__c =currAddress.id;
            userAddress.UserAccount__c =currAccount.id;            
            userAddressList.add(userAddress);
        }
        try{
            insert userAddressList;
        }catch(exception ex){
        	    
        }
        
        
        Test.startTest();

            UpdateDelivery obj = new UpdateDelivery();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}