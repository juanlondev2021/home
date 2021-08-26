/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoSendGridSincronize
 Description:		class reponsible mannage to queue
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		05/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class DiacoSendgridSincronizeBatchQueue implements Queueable{
    private List<Account> accounts;
    public DiacoSendgridSincronizeBatchQueue(List<Account> accounts_2){
        this.accounts = accounts_2;
    }
    /**
    * 
    * This method is responsible to create queue.
    * 
    * This method is used in:
    *  the  DiacoSendgridSincronize class
    *  
    * 
    * @param QueueableContext context
    * @return nothing
    **/ 
    public void execute(QueueableContext context) {
        String  accBody = DiacoSendgridSincronize.accountsBody(accounts);
        System.debug('##ACCBODY##');
        System.debug(accBody);
		DiacoSendgridSincronize.sincronizeAccounts(accBody);
    }
}