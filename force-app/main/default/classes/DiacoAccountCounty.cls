/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			County on Account
 * Test:            DiacoAccountCountyTest
 * Description:		Relate a County record with the Account.
 *
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		24/06/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/

global class DiacoAccountCounty {
    @InvocableMethod(label='Account County' description='Relate Account with County')



    public static void  paramList(List<param> requests) {



     
        List<Account> Acc = new List<Account>();
        for(param nAcc : requests){

                Acc.add(new Account(
                County__c = nAcc.countyId,
                Id        = nAcc.accountId
                ));
            
        }

        System.debug(requests[0] + ' ' + requests[0].countyId);
      
        List <String> county = new List <String>();
   
        for(Account account: Acc){
            if(account.County__c != null){
                county.add(account.County__c);
            }
        }

        county.add('Unknown');
        List <County__c> c = [SELECT id, County_Name__c FROM County__c WHERE County_Name__c IN: county];

        for(County__c Unknowns:c){
            if(Unknowns.County_Name__c == 'Unknown'){
            currentAccount(Acc, c, Unknowns.Id);
            break; 
            }
        }



        }

    global class param {
        @InvocableVariable
        global String countyId;
        @InvocableVariable(required=true)
        global ID accountId;
    }

    public static String currentAccount( List <Account> accounts , List <County__c> counties, String Unknown ){
       List <Account> acc = new List<Account>();

       for (Account ac:accounts){
           Account a = new Account();
           a.id = ac.Id;
           

           for (County__c c:counties){
               
               if(ac.County__c == c.County_Name__c){
                 a.County_Lookup__c = c.Id;
                 break;

               }
   
               else {
                System.debug('####ERROR###');
                System.debug(Unknown);
                a.County_Lookup__c = Unknown;
            

               }


           }

          acc.add(a);
       }
       
        update acc;
        return 'Account updated';
    }


}