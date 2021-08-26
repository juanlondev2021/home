/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			DiacoFtpJob
Description:		class reponsible to sincronize call record with useraddress schedule

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		09/05/2020		Esnayder Morales (ES)	Initial implementation  of the class.
*/
global class DiacoAWSJob implements Schedulable{

    /**
* 
* This method is responsible to call future method to sincronize
* 
* This method is used in:
*  the  Account Send Grid process builder
*  
* 
* @param List<String> param (id's accounts)
* @return nothing
**/
    global void execute(SchedulableContext ctx) {
        DiacoFtp.saveAllFilesAWS();
        System.debug('Good');
    }
}