/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			City on Account
 * Test:            DiacoAccountCityTest
 * Description:		Relate a City record with the Account.
 *
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		24/06/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/
global class DiacoAccountCity {
    @InvocableMethod(label='Account City' description='Relate Account with City')
    public static void paramList(List<param> requests) {

        List<Account> Acc = new List<Account>();
        for(param nAcc : requests){

                Acc.add(new Account(
                City__c = nAcc.city,
                Id        = nAcc.accountId
                ));
            
        }
      
        List <String> city = new List <String>();
   
        for(Account account: Acc){
            if(account.City__c != null){
                city.add(account.City__c);
            }
        }

        city.add('Unknown');
        List <City__c> c = [SELECT id, Name FROM City__c WHERE Name IN: city];

        for(City__c Unknowns:c){
            if(Unknowns.Name == 'Unknown'){
            currentAccount(Acc, c, Unknowns.Id);
            break; 
            }
        }

        }

    global class param {

        @InvocableVariable
        global String city;

        @InvocableVariable(required = true)
        global ID accountId;
    }

    public static String currentAccount( List <Account> accounts , List <City__c> cities, String Unknown ){
       List <Account> acc = new List<Account>();

       for (Account ac:accounts){
           Account a = new Account();
           a.id = ac.Id;
           

           for (City__c c:cities){
               
               if(ac.City__c == c.Name){
                 a.City_lookup__c = c.id;
                 break;

               }
               else {
                a.City_lookup__c = Unknown;
            

               }


           }

          acc.add(a);
       }
       
        update acc;
        return 'Account updated';
    }


}