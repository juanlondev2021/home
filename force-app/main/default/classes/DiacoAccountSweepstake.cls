public class DiacoAccountSweepstake {
    /*Receive a list of accounts and the sweepstake Status is updated to Completed*/
    
    @future
    public static void completedSweepstake(String[] accounts){
        List<Account> accounts2 = new List<Account>();
        for(String acc : accounts){
            accounts2.add(new Account(
            	Id = acc,
                Sweepstake_Status__c = 'Completed'
            ));
        }
        /*Account acc = new Account();
        acc.Id = AccountId;
        acc.Sweepstake_Status__c = 'Completed';*/
        System.debug('actualizando cuenta');
        System.debug(accounts2);
        update accounts2;
    }

}