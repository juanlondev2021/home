/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoThread
 Description:		class reponsible of wait the response sendgrid
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		04/05/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/

public class diacoThread {
    public void thread(Integer second){
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < second) {
            //sleep for 9s
            finishTime = DateTime.now().getTime();
        }
    }
}