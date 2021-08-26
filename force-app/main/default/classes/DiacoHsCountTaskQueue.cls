/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			diacoHsCountTask
Description:		Class reponsible to manage queue diacoHsCountTask

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		12/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/

public class DiacoHsCountTaskQueue implements Queueable {
    
    private List<ID> Ids;
    /**
    * 
    * This method is constructor this class.
    * 
    * This method is used in:
    * DiacoHsCountTaskQueue class
    *  
    * 
    * @param List<ID> Ids
    * @return nothing
    **/
    public DiacoHsCountTaskQueue(List<ID> Ids){
        this.Ids = Ids;
    }
    
    /**
    * 
    * This method is responsible to execute the DiacoHsCountTask's method.
    * 
    * This method is used in:
    * DiacoTaskUnified Trigger
    *  
    * 
    * @param QueueableContext context
    * @return nothing
    **/
    public void execute(QueueableContext context) {
        DiacoHsCountTask.execute(Ids);
    }

}