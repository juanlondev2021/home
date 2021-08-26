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
public class DiacoSendgridSincronizeQueue implements Queueable{
     private List<Account> accounts;
     private List<String> acc;
    public DiacoSendgridSincronizeQueue(List<Account> accounts_2, List<String> acc){
        this.accounts = accounts_2;
        this.acc = acc;
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
        DiacoSendgridSincronize.sincronize(DiacoSendgridSincronize.accounts(accounts), acc);
    }

}