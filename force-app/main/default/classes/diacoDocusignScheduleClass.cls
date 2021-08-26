/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		class responsible together with diacoDocusignClassBridge  class, of getting the documents from docusign api rest.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/01/2018		Jorge Martinez (JM)		Initial implementation of the trigger.
**/
global class diacoDocusignScheduleClass implements Schedulable {
   global void execute(SchedulableContext SC) {
      diacoDocusignClassBridge schedule = new diacoDocusignClassBridge(); 
   }
}